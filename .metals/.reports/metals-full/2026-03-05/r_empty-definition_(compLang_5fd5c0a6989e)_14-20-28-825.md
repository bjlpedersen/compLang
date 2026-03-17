file://<WORKSPACE>/info/labs/lab01/src/amyc/interpreter/Interpreter.scala
empty definition using pc, found symbol in pc: 
semanticdb not found
empty definition using fallback
non-local guesses:
	 -utils/Identifier#
	 -ast/SymbolicTreeModule.Identifier#
	 -ast/Identifier#
	 -Identifier#
	 -scala/Predef.Identifier#
offset: 6699
uri: file://<WORKSPACE>/info/labs/lab01/src/amyc/interpreter/Interpreter.scala
text:
```scala
package amyc
package interpreter

import utils._
import ast.SymbolicTreeModule._
import ast.Identifier
import analyzer.SymbolTable

// An interpreter for Amy programs, implemented in Scala
object Interpreter extends Pipeline[(Program, SymbolTable), Unit] {

  // A class that represents a value computed by interpreting an expression
  abstract class Value {
    def asInt: Int = this.asInstanceOf[IntValue].i
    def asBoolean: Boolean = this.asInstanceOf[BooleanValue].b
    def asString: String = this.asInstanceOf[StringValue].s

    override def toString: String = this match {
      case IntValue(i) => i.toString
      case BooleanValue(b) => b.toString
      case StringValue(s) => s
      case UnitValue => "()"
      case CaseClassValue(constructor, args) =>
        constructor.name + "(" + args.map(_.toString).mkString(", ") + ")"
    }
  }
  case class IntValue(i: Int) extends Value
  case class BooleanValue(b: Boolean) extends Value
  case class StringValue(s: String) extends Value
  case object UnitValue extends Value
  case class CaseClassValue(constructor: Identifier, args: List[Value]) extends Value

  def run(ctx: Context)(v: (Program, SymbolTable)): Unit = {
    val (program, table) = v

    // These built-in functions do not have an Amy implementation in the program,
    // instead their implementation is encoded in this map
    val builtIns: Map[(String, String), (List[Value]) => Value] = Map(
      ("Std", "printInt")    -> { args => println(args.head.asInt); UnitValue },
      ("Std", "printString") -> { args => println(args.head.asString); UnitValue },
      ("Std", "readString")  -> { args => StringValue(scala.io.StdIn.readLine()) },
      ("Std", "readInt")     -> { args =>
        val input = scala.io.StdIn.readLine()
        try {
          IntValue(input.toInt)
        } catch {
          case ne: NumberFormatException =>
            ctx.reporter.fatal(s"""Could not parse "$input" to Int""")
        }
      },
      ("Std", "intToString")   -> { args => StringValue(args.head.asInt.toString) },
      ("Std", "digitToString") -> { args => StringValue(args.head.asInt.toString) }
    )

    // Utility functions to interface with the symbol table.
    def isConstructor(name: Identifier) = table.getConstructor(name).isDefined
    def findFunctionOwner(functionName: Identifier) = table.getFunction(functionName).get.owner.name
    def findFunction(owner: String, name: String) = {
      program.modules.find(_.name.name == owner).get.defs.collectFirst {
        case fd@FunDef(fn, _, _, _) if fn.name == name => fd
      }.get
    }

    // Interprets a function, using evaluations for local variables contained in 'locals'
    // TODO: Complete all missing cases. Look at the given ones for guidance. 
    def interpret(expr: Expr)(implicit locals: Map[Identifier, Value]): Value = {
      expr match {
        case Variable(name) =>
            locals.get(name) match {
              case Some(value) => value
              case None => ctx.reporter.fatal(s"Undefined variable: ${name.name}@${expr.position}")
            }
        case IntLiteral(i) =>
            IntValue(i)
        case BooleanLiteral(b) =>
            BooleanValue(b)
        case StringLiteral(s) =>
            StringValue(s)
        case UnitLiteral() =>
            UnitValue
        case Plus(lhs, rhs) =>
          IntValue(interpret(lhs).asInt + interpret(rhs).asInt)
        case Minus(lhs, rhs) =>
            IntValue(interpret(lhs).asInt - interpret(rhs).asInt)
        case Times(lhs, rhs) =>
            IntValue(interpret(lhs).asInt * interpret(rhs).asInt)
        case Div(lhs, rhs) =>
            val l = interpret(lhs).asInt
            val r = interpret(rhs).asInt
            if (r == 0) ctx.reporter.fatal("Division by zero", expr)
            else IntValue(l / r)
        case Mod(lhs, rhs) =>
            IntValue(interpret(lhs).asInt % interpret(rhs).asInt)
        case LessThan(lhs, rhs) =>
            BooleanValue(interpret(lhs).asInt < interpret(rhs).asInt)
        case LessEquals(lhs, rhs) =>
            BooleanValue(interpret(lhs).asInt <= interpret(rhs).asInt)
        case And(lhs, rhs) =>
            BooleanValue(interpret(lhs).asBoolean && interpret(rhs).asBoolean)
        case Or(lhs, rhs) =>
            BooleanValue(interpret(lhs).asBoolean || interpret(rhs).asBoolean)
        case Equals(lhs, rhs) =>
          val leftValue = interpret(lhs)
          val rightValue = interpret(rhs)
          (leftValue, rightValue) match {
            case (IntValue(i1), IntValue(i2)) => BooleanValue(i1 == i2)
            case (BooleanValue(b1), BooleanValue(b2)) => BooleanValue(b1 == b2)
            case (UnitValue, UnitValue) => BooleanValue(true)
            case _ => BooleanValue(leftValue eq rightValue)
          }
        case Concat(lhs, rhs) =>
            StringValue(interpret(lhs).asString + interpret(rhs).asString)
        case Not(e) =>
            BooleanValue(!interpret(e).asBoolean)
        case Neg(e) =>
            IntValue(-interpret(e).asInt)
        case Call(qname, args) =>
          val evaluatedArgs = args.map(interpret)
          if (isConstructor(qname)) {
            CaseClassValue(qname, evaluatedArgs)
          } else {
            val owner = findFunctionOwner(qname)
            if (builtIns.contains((owner, qname.name))) {
              builtIns((owner, qname.name))(evaluatedArgs)
            } else {
              val funDef = findFunction(owner, qname.name)
              val params = funDef.params
              val body = funDef.body
              val newLocals = Map() ++ params.map(_.name).zip(evaluatedArgs)
              interpret(body)(newLocals)
            }
          }
        case Sequence(e1, e2) =>
            interpret(e1)
            interpret(e2)
        case Let(df, value, body) =>
            val evalueatedVal = interpret(value)
            val newLocals = locals + (df.name -> evalueatedVal)
            interpret(body)(newLocals)
        case Ite(cond, thenn, elze) =>
            if (interpret(cond).asBoolean) interpret(thenn) 
            else interpret(elze)
        case Match(scrut, cases) =>
            // Hint: We give you a skeleton to implement pattern matching
            //       and the main body of the implementation
          val evS = interpret(scrut)

          // None = pattern does not match
            // Returns a list of pairs id -> value,
            // where id has been bound to value within the pattern.
            // Returns None when the pattern fails to match.
            // Note: Only works on well typed patterns (which have been ensured by the type checker).
          def matchesPattern(v: Value, pat: Pattern): Option[List[(Iden@@tifier, Value)]] = {
            ((v, pat): @unchecked) match {
              case (_, WildcardPattern()) => 
                  Some(List())
              case (_, IdPattern(name)) => 
                  Some(List((name, v)))
              case (IntValue(i1), LiteralPattern(IntLiteral(i2))) =>
                if (i1 == i2) Some(List()) 
                else
                  None
              case (BooleanValue(b1), LiteralPattern(BooleanLiteral(b2))) =>
                  if (b1 == b2) Some(List()) 
                  else
                    None
              case (StringValue(s1), LiteralPattern(StringLiteral(s2))) =>
                  None
              case (UnitValue, LiteralPattern(UnitLiteral())) =>
                  Some(List())
              case (CaseClassValue(con1, realArgs), CaseClassPattern(con2, formalArgs)) =>
                  if (con1 == con2) {
                    val argsMatch = realArgs.zip(formalArgs).map { case (a, p) => matchesPattern(a, p) }
                    if (argsMatch.forall(_.isDefined)) {
                      Some(argsMatch.flatMap(_.get))
                    } else {
                      None
                    }
                  } else {
                    None
                  }
            }
          }
          // Main "loop" of the implementation: Go through every case,
          // check if the pattern matches, and if so return the evaluation of the case expression
          cases.to(LazyList).map(matchCase => 
            val MatchCase(pat, rhs) = matchCase
            (rhs, matchesPattern(evS, pat))
          ).find(_._2.isDefined) match {
            case Some((rhs, Some(moreLocals))) =>
              interpret(rhs)(locals ++ moreLocals)
            case _ =>
              // No case matched
              ctx.reporter.fatal(s"Match error: ${evS.toString}@${scrut.position}")
          }

        case Error(msg) =>
          ctx.reporter.fatal(interpret(msg).asString, expr)
      }
    }

    for {
      m <- program.modules
      e <- m.optExpr
    } {
      interpret(e)(Map())
    }
  }
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 