package amyc
package analyzer

import amyc.ast.NominalTreeModule._
import amyc.utils._

/**
 * Replaces tuple temporary nodes into case classes/calls/types.
 */
object TupleDesugarer extends Pipeline[Program, Program] {

  def run(ctx: Context)(p: Program): Program = {
    import ctx.reporter._

    def transformExpr(expr: Expr): Expr = {
      val res = expr match {
        case TupleLiteral(exprs) =>
          val transformedExprs = exprs.map(transformExpr)
          val args = transformedExprs.map(e => (None, e))
          Call(QualifiedName(Some("T"), "Tuple" + exprs.length), args)

        case Let(df, value, body) =>
          Let(transformParamDef(df), transformExpr(value), transformExpr(body))

        case Sequence(e1, e2) =>
          Sequence(transformExpr(e1), transformExpr(e2))

        case Ite(cond, thenn, elze) =>
          Ite(transformExpr(cond), transformExpr(thenn), transformExpr(elze))

        case Match(scrut, cases) =>
          Match(transformExpr(scrut), cases.map(transformCase))

        case Call(qname, args) =>
          Call(qname, args.map { case (name, e) => (name, transformExpr(e)) })

        case Plus(lhs, rhs)        => Plus(transformExpr(lhs), transformExpr(rhs))
        case Minus(lhs, rhs)       => Minus(transformExpr(lhs), transformExpr(rhs))
        case Times(lhs, rhs)       => Times(transformExpr(lhs), transformExpr(rhs))
        case Div(lhs, rhs)         => Div(transformExpr(lhs), transformExpr(rhs))
        case Mod(lhs, rhs)         => Mod(transformExpr(lhs), transformExpr(rhs))
        case LessThan(lhs, rhs)    => LessThan(transformExpr(lhs), transformExpr(rhs))
        case LessEquals(lhs, rhs)  => LessEquals(transformExpr(lhs), transformExpr(rhs))
        case And(lhs, rhs)         => And(transformExpr(lhs), transformExpr(rhs))
        case Or(lhs, rhs)          => Or(transformExpr(lhs), transformExpr(rhs))
        case Equals(lhs, rhs)      => Equals(transformExpr(lhs), transformExpr(rhs))
        case Concat(lhs, rhs)      => Concat(transformExpr(lhs), transformExpr(rhs))

        case Not(e) => Not(transformExpr(e))
        case Neg(e) => Neg(transformExpr(e))

        case Error(msg) => Error(transformExpr(msg))

        case _ => expr
      }
      res.setPos(expr)
    }

    def transformPattern(pat: Pattern): Pattern = {
      val res = pat match {
        case TuplePattern(patterns) =>
          CaseClassPattern(QualifiedName(Some("T"), "Tuple" + patterns.length), patterns.map(transformPattern))
        
        case CaseClassPattern(constr, args) =>
          CaseClassPattern(constr, args.map(transformPattern))

        case _ => pat
      }
      res.setPos(pat)
    }

    def transformType(tt: TypeTree): TypeTree = {
      val res = tt.tpe match {
        case TupleType(tpes) =>
          TypeTree(ClassType(QualifiedName(Some("T"), "Tuple")))
        case _ => tt
      }
      res.setPos(tt)
    }

    def transformParamDef(df: ParamDef): ParamDef = {
      val defaultTr = df.default.map(transformExpr)
      ParamDef(df.name, transformType(df.tt), defaultTr).setPos(df)
    }

    def transformCase(mc: MatchCase): MatchCase = {
      MatchCase(transformPattern(mc.pat), transformExpr(mc.expr)).setPos(mc)
    }

    def transformDef(df: ClassOrFunDef): ClassOrFunDef = {
      val res = df match {
        case FunDef(name, params, retType, body) =>
          FunDef(name, params.map(transformParamDef), transformType(retType), transformExpr(body))
        case CaseClassDef(name, fields, parent) =>
          CaseClassDef(name, fields.map(transformParamDef), parent)
        case _ => df
      }
      res.setPos(df)
    }

    Program(
      p.modules.map { m =>
        ModuleDef(
          m.name,
          m.defs.map(transformDef),
          m.optExpr.map(transformExpr)
        ).setPos(m)
      }
    ).setPos(p)
  }
}
