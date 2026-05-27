package amyc
package analyzer

import amyc.utils._
import amyc.ast.{Identifier, NominalTreeModule => N, SymbolicTreeModule => S}
import amyc.parsing.Tokens.IntLitToken
import amyc.parsing.Tokens.BoolLitToken
import amyc.parsing.Tokens.StringLitToken

// Name analyzer for Amy
// Takes a nominal program (names are plain string, qualified names are string pairs)
// and returns a symbolic program, where all names have been resolved to unique Identifiers.
// Rejects programs that violate the Amy naming rules.
// Also populates symbol table.
object NameAnalyzer extends Pipeline[N.Program, (S.Program, SymbolTable)] {
  def run(ctx: Context)(p: N.Program): (S.Program, SymbolTable) = {
    import ctx.reporter._

    // Step 0: Initialize symbol table
    val table = new SymbolTable

    // Step 1: Add modules
    val modNames = p.modules.groupBy(_.name)
    modNames.foreach{ case (name, modules) =>
      if (modules.size > 1) {
        fatal(s"Two modules named $name in program", modules.head.position)
      }
    }

    modNames.keys.toList foreach table.addModule

    // Step 2: Check name uniqueness in modules
    p.modules.foreach { m =>
      val names = m.defs.groupBy(_.name)
      names.foreach{ case (name, defs) =>
        if (defs.size > 1) {
          fatal(s"Two definitions named $name in module ${m.name}", defs.head)
        }
      }
    }

    // Step 3: Discover types
    for {
      m <- p.modules
      case N.AbstractClassDef(name) <- m.defs
    } table.addType(m.name, name)

    def transformType(tt: N.TypeTree, inModule: String): S.Type = {
      tt.tpe match {
        case N.IntType => S.IntType
        case N.BooleanType => S.BooleanType
        case N.StringType => S.StringType
        case N.UnitType => S.UnitType
        case N.ClassType(qn@N.QualifiedName(module, name)) =>
          table.getType(module getOrElse inModule, name) match {
            case Some(symbol) =>
              S.ClassType(symbol)
            case None =>
              fatal(s"Could not find type $qn", tt)
          }
      }
    }

    // Step 4: Discover type constructors
    for {
      m <- p.modules
      case cc@N.CaseClassDef(name, fields, parent) <- m.defs
    } {
      val argTypes = fields map (pd => transformType(pd.tt, m.name))
      val retType = table.getType(m.name, parent).getOrElse(fatal(s"Parent class $parent not found", cc))
      val defaultValueOptions = fields.map(
        param => (param.default, param.name)
      )

      if (defaultValueOptions.dropWhile(!_._1.isDefined).exists(!_._1.isDefined)){
        for (x <- defaultValueOptions)
        {
          x._1 match
            case Some(value) => println(x._1.get match
              case N.IntLiteral(v) => S.IntLiteral(v)        
              case N.BooleanLiteral(v) => S.BooleanLiteral(v)
              case N.StringLiteral(v) => S.StringLiteral(v))
            case None => println("no default value was found for this one")
        }
        fatal("argument has no default value")
      }
      val defaultValues = defaultValueOptions.flatMap(value =>
        value match
          case (Some(v), s) => 
            v match
              case N.IntLiteral(v) => List((S.IntLiteral(v), s))        
              case N.BooleanLiteral(v) => List((S.BooleanLiteral(v), s))
              case N.StringLiteral(v) => List((S.StringLiteral(v), s))
          case (None, _) => Nil
        )
      table.addDefaultConstructor(m.name, name, argTypes, retType, defaultValues)
    }

    // Step 5: Discover functions signatures.
    for {
      m <- p.modules
      case N.FunDef(name, params, retType1, _) <- m.defs
    } {
      val argTypes = params map (p => transformType(p.tt, m.name))
      val retType2 = transformType(retType1, m.name)
      val defaultValueOptions = params.map(
        param => (param.default, param.name)
      )

      if (defaultValueOptions.dropWhile(!_._1.isDefined).exists(!_._1.isDefined)){
        for (x <- defaultValueOptions)
        {
          x._1 match
            case Some(value) => println(x._1.get match
              case N.IntLiteral(v) => S.IntLiteral(v)        
              case N.BooleanLiteral(v) => S.BooleanLiteral(v)
              case N.StringLiteral(v) => S.StringLiteral(v))
            case None => println("no default value was found for this one")
        }
        fatal("argument has no default value")
      }
      val defaultValues = defaultValueOptions.flatMap(value =>
        value match
          case (Some(v), s) => 
            v match
              case N.IntLiteral(v) => List((S.IntLiteral(v), s))        
              case N.BooleanLiteral(v) => List((S.BooleanLiteral(v), s))
              case N.StringLiteral(v) => List((S.StringLiteral(v), s))
          case (None, _) => Nil
        )

      table.addDefaultFunction(m.name, name, argTypes, retType2, defaultValues)
    }

    // Step 6: We now know all definitions in the program.
    //         Reconstruct modules and analyse function bodies/ expressions

    def transformDef(df: N.ClassOrFunDef, module: String): S.ClassOrFunDef = { df match {
      case N.AbstractClassDef(name) =>
        S.AbstractClassDef(table.getType(module, name).get)
      case N.CaseClassDef(name, nomFields, _) =>
        val Some((sym, sig)): Option[(Identifier, DefaultConstrSig)] = table.getDefaultConstructor(module, name) : @unchecked
        val symFields = nomFields.zip(sig.argTypes).map { case (nf, tpe) =>
          S.ParamDef(Identifier.fresh(nf.name), S.TypeTree(tpe).setPos(nf.tt)).setPos(nf)
        }
        S.CaseClassDef(sym, symFields, sig.parent)
      case fd: N.FunDef =>
        transformFunDef(fd, module)
    }}.setPos(df)

    def transformFunDef(fd: N.FunDef, module: String): S.FunDef = {
      val N.FunDef(name, params, retType, body) = fd
      val Some((sym, sig)) = table.getDefaultFunction(module, name) : @unchecked

      params.groupBy(_.name).foreach { case (name, ps) =>
        if (ps.size > 1) {
          fatal(s"Two parameters named $name in function ${fd.name}", fd)
        }
      }

      val paramNames = params.map(_.name)
      // TODO should add here something where I actually use the default parameters. (Kepp this line intact. Just remove the comment)
      val newParams = params zip sig.argTypes map { case (pd@N.ParamDef(name, tt, _), tpe) =>
        val s = Identifier.fresh(name)
        S.ParamDef(s, S.TypeTree(tpe).setPos(tt)).setPos(pd)
      }

      val paramsMap = paramNames.zip(newParams.map(_.name)).toMap

      S.FunDef(
        sym,
        newParams,
        S.TypeTree(sig.retType).setPos(retType),
        transformExpr(body)(module, (paramsMap, Map()))
      ).setPos(fd)
    }

    def transformExpr(expr: N.Expr)
                     (implicit module: String, names: (Map[String, Identifier], Map[String, Identifier])): S.Expr = {
      val (params, locals) = names
      val res = expr match {
        case N.Variable(name) =>
          S.Variable(
            locals.getOrElse(name, // Local variables shadow parameters!
              params.getOrElse(name,
                fatal(s"Variable $name not found", expr))))
        case N.IntLiteral(value) =>
          S.IntLiteral(value)
        case N.BooleanLiteral(value) =>
          S.BooleanLiteral(value)
        case N.StringLiteral(value) =>
          S.StringLiteral(value)
        case N.UnitLiteral() =>
          S.UnitLiteral()
        case N.Plus(lhs, rhs) =>
          S.Plus(transformExpr(lhs), transformExpr(rhs))
        case N.Minus(lhs, rhs) =>
          S.Minus(transformExpr(lhs), transformExpr(rhs))
        case N.Times(lhs, rhs) =>
          S.Times(transformExpr(lhs), transformExpr(rhs))
        case N.Div(lhs, rhs) =>
          S.Div(transformExpr(lhs), transformExpr(rhs))
        case N.Mod(lhs, rhs) =>
          S.Mod(transformExpr(lhs), transformExpr(rhs))
        case N.LessThan(lhs, rhs) =>
          S.LessThan(transformExpr(lhs), transformExpr(rhs))
        case N.LessEquals(lhs, rhs) =>
          S.LessEquals(transformExpr(lhs), transformExpr(rhs))
        case N.And(lhs, rhs) =>
          S.And(transformExpr(lhs), transformExpr(rhs))
        case N.Or(lhs, rhs) =>
          S.Or(transformExpr(lhs), transformExpr(rhs))
        case N.Equals(lhs, rhs) =>
          S.Equals(transformExpr(lhs), transformExpr(rhs))
        case N.Concat(lhs, rhs) =>
          S.Concat(transformExpr(lhs), transformExpr(rhs))
        case N.Not(e) =>
          S.Not(transformExpr(e))
        case N.Neg(e) =>
          S.Neg(transformExpr(e))
        case N.Call(qname, args) =>
          val owner = qname.module.getOrElse(module)
          val name  = qname.name
          val entry = table.getDefaultConstructor(owner, name).orElse(table.getDefaultFunction(owner, name))
          entry match {
            case None =>
              fatal(s"Function or constructor $qname not found", expr)
            case Some((sym, sig)) =>
              sig match 
                case DefaultConstrSig(argTypes, parent, index, defaultValues) => 
                  if (argTypes.size - defaultValues.size > args.size){
                    fatal(s"Wrong number of arguments for function/constructor $qname", expr)
                  }
                case DefaultFunSig(argTypes, retType, owner, defaultValues) =>
                  if (argTypes.size - defaultValues.size > args.size){
                    fatal(s"Wrong number of arguments for function/constructor $qname", expr)
                  }
              /*if (sig.argTypes.size != args.size) {
                fatal(s"Wrong number of arguments for function/constructor $qname", expr)
              }*/
              S.Call(sym, args map { case (name, e) => (name, transformExpr(e)) })
          }
        case N.Sequence(e1, e2) =>
          S.Sequence(transformExpr(e1), transformExpr(e2))
        case N.Let(vd, value, body) =>
          if (locals.contains(vd.name)) {
            fatal(s"Variable redefinition: ${vd.name}", vd)
          }
          if (params.contains(vd.name)) {
            warning(s"Local variable ${vd.name} shadows function parameter", vd)
          }
          val sym = Identifier.fresh(vd.name)
          val tpe = transformType(vd.tt, module)
          S.Let(
            S.ParamDef(sym, S.TypeTree(tpe)).setPos(vd),
            transformExpr(value),
            transformExpr(body)(module, (params, locals + (vd.name -> sym)))
          )
        case N.Ite(cond, thenn, elze) =>
          S.Ite(transformExpr(cond), transformExpr(thenn), transformExpr(elze))
        case N.Match(scrut, cases) =>
          def transformCase(cse: N.MatchCase) = {
            val N.MatchCase(pat, rhs) = cse
            val (newPat, moreLocals) = transformPattern(pat)
            S.MatchCase(newPat, transformExpr(rhs)(module, (params, locals ++ moreLocals)).setPos(rhs)).setPos(cse)
          }

          def transformPattern(pat: N.Pattern): (S.Pattern, List[(String, Identifier)]) = {
            val (newPat, newNames): (S.Pattern, List[(String, Identifier)]) = pat match {
              case N.WildcardPattern() =>
                (S.WildcardPattern(), List())
              case N.IdPattern(name) =>
                if (locals.contains(name)) {
                  fatal(s"Pattern identifier $name already defined", pat)
                }
                if (params.contains(name)) {
                  warning("Suspicious shadowing by an Id Pattern", pat)
                }
                table.getDefaultConstructor(module, name) match {
                  case Some((_, DefaultConstrSig(Nil, _, _, _))) =>
                    warning(s"There is a nullary constructor in this module called '$name'. Did you mean '$name()'?", pat)
                  case _ =>
                }
                val sym = Identifier.fresh(name)
                (S.IdPattern(sym), List(name -> sym))
              case N.LiteralPattern(lit) =>
                (S.LiteralPattern(transformExpr(lit).asInstanceOf[S.Literal[Any]]), List())
              case N.CaseClassPattern(constr, args) =>
                val (sym, sig) = table
                  .getDefaultConstructor(constr.module.getOrElse(module), constr.name)
                  .getOrElse(fatal(s"Constructor $constr not found", pat))
                if (sig.argTypes.size != args.size) {
                  fatal(s"Wrong number of args for constructor $constr", pat)
                }
                val (newPatts, moreLocals0) = (args map transformPattern).unzip
                val moreLocals = moreLocals0.flatten
                moreLocals.groupBy(_._1).foreach { case (name, pairs) =>
                  if (pairs.size > 1) {
                    fatal(s"Multiple definitions of $name in pattern", pat)
                  }
                }
                (S.CaseClassPattern(sym, newPatts), moreLocals)
            }
            (newPat.setPos(pat), newNames)
          }

          S.Match(transformExpr(scrut), cases map transformCase)

        case N.Error(msg) =>
          S.Error(transformExpr(msg))
      }
      res.setPos(expr)
    }

    val newProgram = S.Program(
      p.modules map { case mod@N.ModuleDef(name, defs, optExpr) =>
        S.ModuleDef(
          table.getModule(name).get,
          defs map (transformDef(_, name)),
          optExpr map (transformExpr(_)(name, (Map(), Map())))
        ).setPos(mod)
      }
    ).setPos(p)

    (newProgram, table)

  }
}
