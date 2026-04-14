package amyc
package analyzer

import amyc.utils._
import amyc.ast.SymbolicTreeModule._
import amyc.ast.Identifier
import amyc.parsing.Parser.typeTree

// The type checker for Amy
// Takes a symbolic program and rejects it if it does not follow the Amy typing rules.
object TypeChecker extends Pipeline[(Program, SymbolTable), (Program, SymbolTable)] {

  def run(ctx: Context)(v: (Program, SymbolTable)): (Program, SymbolTable) = {
    import ctx.reporter._

    val (program, table) = v

    case class Constraint(expected: Type, found: Type, pos: Position)

    // Represents a type variable.
    // It extends Type, but it is meant only for internal type checker use,
    //  since no Amy value can have such type.
    case class TypeVariable private (id: Int) extends Type
    object TypeVariable {
      private val c = new UniqueCounter[Unit]
      def fresh(): TypeVariable = TypeVariable(c.next(()))
    }

    // Generates typing constraints for an expression `e` with a given expected type.
    // The environment `env` contains all currently available bindings (you will have to
    //  extend these, e.g., to account for local variables).
    // Returns a list of constraints among types. These will later be solved via unification.
    def genConstraints(e: Expr, expected: Type)(implicit env: Map[Identifier, Type]): List[Constraint] = {
      
      // This helper returns a list of a single constraint recording the type
      //  that we found (or generated) for the current expression `e`
      def topLevelConstraint(found: Type): List[Constraint] =
        List(Constraint(expected, found, e.position))
      
      e match {
        case IntLiteral(_) =>
          topLevelConstraint(IntType)
        case Equals(lhs, rhs) =>
          // HINT: Take care to implement the specified Amy semantics
          val tv = TypeVariable.fresh()
          topLevelConstraint(BooleanType) ++ genConstraints(lhs, tv) ++ genConstraints(rhs, tv)
        case Match(scrut, cases) =>
          // Returns additional constraints from within the pattern with all bindings
          // from identifiers to types for names bound in the pattern.
          // (This is analogous to `transformPattern` in NameAnalyzer.)
          def patternBindings(pat: Pattern, expected: Type): (List[Constraint], Map[Identifier, Type]) = {
            pat match {
              case WildcardPattern() =>
                (Nil, Map.empty)
              case IdPattern(name) =>
                (Nil, Map(name -> expected))
              case LiteralPattern(lit) =>
                (genConstraints(lit, expected), Map.empty)
              case CaseClassPattern(constr, args) =>
                val sig = table.getConstructor(constr).get
                val constrConstraint = Constraint(expected, ClassType(sig.parent), pat.position)
                val pairs = (args zip sig.argTypes).map { case (argPat, argType) =>
                  patternBindings(argPat, argType)
                }
                var constraints = List(constrConstraint)
                var bindings = Map[Identifier, Type]()
                
                for ((argConstraints, argBindings) <- pairs) {
                  constraints = constraints ++ argConstraints
                  bindings = bindings ++ argBindings
                }
                
                (constraints, bindings)
            }
          }

          def handleCase(cse: MatchCase, scrutExpected: Type): List[Constraint] = {
            val (patConstraints, moreEnv) = patternBindings(cse.pat, scrutExpected)
            patConstraints ++ genConstraints(cse.expr, expected)(env ++ moreEnv)
          }

          val st = TypeVariable.fresh()
          genConstraints(scrut, st) ++
          cases.flatMap(cse => handleCase(cse, st))

        case BooleanLiteral(_) =>
          topLevelConstraint(BooleanType)
        case StringLiteral(_) =>
          topLevelConstraint(StringType)
        case UnitLiteral() =>
          topLevelConstraint(UnitType)
        case Variable(name) =>
          topLevelConstraint(env(name))
        case Plus(lhs, rhs) =>
          topLevelConstraint(IntType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case Minus(lhs, rhs) =>
          topLevelConstraint(IntType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case Times(lhs, rhs) =>
          topLevelConstraint(IntType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case Div(lhs, rhs) =>
          topLevelConstraint(IntType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case Mod(lhs, rhs) =>
          topLevelConstraint(IntType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case LessThan(lhs, rhs) =>
          topLevelConstraint(BooleanType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case LessEquals(lhs, rhs) =>
          topLevelConstraint(BooleanType) ++ genConstraints(lhs, IntType) ++ genConstraints(rhs, IntType)
        case And(lhs, rhs) =>
          topLevelConstraint(BooleanType) ++ genConstraints(lhs, BooleanType) ++ genConstraints(rhs, BooleanType)
        case Or(lhs, rhs) =>
          topLevelConstraint(BooleanType) ++ genConstraints(lhs, BooleanType) ++ genConstraints(rhs, BooleanType)
        case Concat(lhs, rhs) =>
          topLevelConstraint(StringType) ++ genConstraints(lhs, StringType) ++ genConstraints(rhs, StringType)
        case Not(e) =>
          topLevelConstraint(BooleanType) ++ genConstraints(e, BooleanType)
        case Neg(e) =>
          topLevelConstraint(IntType) ++ genConstraints(e, IntType)
        case Call(qname, args) =>
          val (argTypes, retType) = table.getFunction(qname) match {
            case Some(sig) => (sig.argTypes, sig.retType)
            case None =>
              val sig = table.getConstructor(qname).get
              (sig.argTypes, sig.retType)
          }
          topLevelConstraint(retType) ++
            (args zip argTypes).flatMap { case (arg, argType) => genConstraints(arg, argType) }
        case Sequence(e1, e2) =>
          val tv = TypeVariable.fresh()
          genConstraints(e1, tv) ++ genConstraints(e2, expected)
        case Let(df, value, body) =>
          genConstraints(value, df.tt.tpe) ++
          genConstraints(body, expected)(env + (df.name -> df.tt.tpe))
        case Ite(cond, thenn, elze) =>
          genConstraints(cond, BooleanType) ++
          genConstraints(thenn, expected) ++
          genConstraints(elze, expected)
        case Error(msg) =>
          genConstraints(msg, StringType)
      }
    }

    // Given a list of constraints `constraints`, replace every occurence of type variable
    //  with id `from` by type `to`.
    def subst_*(constraints: List[Constraint], from: Int, to: Type): List[Constraint] = {
      constraints map { case Constraint(expected, found, pos) =>
        Constraint(subst(expected, from, to), subst(found, from, to), pos)
      }
    }

    // Do a single substitution.
    def subst(tpe: Type, from: Int, to: Type): Type = {
      tpe match {
        case TypeVariable(`from`) => to
        case other => other
      }
    }

    // Solve the given set of typing constraints and report errors
    //  using `ctx.reporter.error` if they are not satisfiable.
    // We consider a set of constraints to be satisfiable exactly if they unify.
    def solveConstraints(constraints: List[Constraint]): Unit = {
      constraints match {
        case Nil => ()
        case Constraint(expected, found, pos) :: more =>
          /*println(constraints)
          println(expected)
          println(found)
          println("===============================")*/

          (expected, found) match
            case Tuple2(tv: TypeVariable, t) => solveConstraints(subst_*(more, tv.id, t))
            case Tuple2(t, tv: TypeVariable) => solveConstraints(subst_*(more, tv.id, t))
            case Tuple2(_, _) => 
              if (expected != found){
                ctx.reporter.error(f"expcted type $expected found $found", pos)
              }
              else{
                solveConstraints(more)
              }
            
          
          

          // HINT: You can use the `subst_*` helper above to replace a type variable
          //       by another type in your current set of constraints.
          // TODO
      }
    }

    // Putting it all together to type-check each module's functions and main expression.
    program.modules.foreach { mod =>
      mod.defs.collect { case FunDef(_, params, retType, body) =>
        val env = params.map{ case ParamDef(name, tt) => name -> tt.tpe }.toMap
        solveConstraints(genConstraints(body, retType.tpe)(env))
      }

      val tv = TypeVariable.fresh()
      mod.optExpr.foreach(e => solveConstraints(genConstraints(e, tv)(Map())))
    }

    v

  }
}
