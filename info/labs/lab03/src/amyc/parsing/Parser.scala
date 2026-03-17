package amyc
package parsing

import scala.language.implicitConversions

import amyc.ast.NominalTreeModule._
import amyc.utils._
import Tokens._
import TokenKinds._

import scallion._

// The parser for Amy
object Parser extends Pipeline[Iterator[Token], Program]
                 with Parsers {

  type Token = amyc.parsing.Token
  type Kind = amyc.parsing.TokenKind

  import Implicits._

  override def getKind(token: Token): TokenKind = TokenKind.of(token)

  val eof: Syntax[Token] = elem(EOFKind)
  def op(string: String): Syntax[Token] = elem(OperatorKind(string))
  def kw(string: String): Syntax[Token] = elem(KeywordKind(string))

  implicit def delimiter(string: String): Syntax[Token] = elem(DelimiterKind(string))

  // An entire program (the starting rule for any Amy file).
  lazy val program: Syntax[Program] = many1(many1(module) ~<~ eof).map(ms => Program(ms.flatten.toList).setPos(ms.head.head))

  // A module (i.e., a collection of definitions and an initializer expression)
  lazy val module: Syntax[ModuleDef] = (kw("object") ~ identifier ~ many(definition) ~ opt(expr) ~ kw("end") ~ identifier).map {
    case obj ~ id ~ defs ~ body ~ _ ~ id1 => 
      if id == id1 then 
        ModuleDef(id, defs.toList, body).setPos(obj)
      else 
        throw new AmycFatalError("Begin and end module names do not match: " + id + " and " + id1)
  }

  // An identifier.
  val identifier: Syntax[String] = accept(IdentifierKind) {
    case IdentifierToken(name) => name
  }

  // An identifier along with its position.
  val identifierPos: Syntax[(String, Position)] = accept(IdentifierKind) {
    case id@IdentifierToken(name) => (name, id.position)
  }

  // A definition within a module.
  lazy val definition: Syntax[ClassOrFunDef] = 
    (kw("abstract") ~ kw("class") ~ identifier).map {
      case abs ~ _ ~ id => AbstractClassDef(id).setPos(abs)
    } |
    (kw("case") ~ kw("class") ~ identifier ~ "(" ~ parameters ~ ")" ~ kw("extends") ~ identifier).map {
      case c ~ _ ~ id ~ _ ~ params ~ _ ~ _ ~ parent => CaseClassDef(id, params.map(_.tt), parent).setPos(c)
    } |
    (kw("def") ~ identifier ~ "(" ~ parameters ~ ")" ~ ":" ~ typeTree ~ ":=" ~ expr ~ kw("end") ~ identifier).map {
      case d ~ id ~ _ ~ params ~ _ ~ _ ~ tpe ~ _ ~ body ~ _ ~ id1 => 
        if id == id1 then 
          FunDef(id, params, tpe, body).setPos(d)
        else 
          throw new AmycFatalError("Begin and end function names do not match: " + id + " and " + id1)
    }
  

  // A list of parameter definitions.
  lazy val parameters: Syntax[List[ParamDef]] = repsep(parameter, ",").map(_.toList)

  // A parameter definition, i.e., an identifier along with the expected type.
  lazy val parameter: Syntax[ParamDef] = 
    (identifierPos ~ ":" ~ typeTree).map {
      case (name, pos) ~ _ ~ tpe => ParamDef(name, tpe).setPos(pos)
    }

  // A type expression.
  lazy val typeTree: Syntax[TypeTree] = primitiveType | identifierType

  // A built-in type (such as `Int`).
  val primitiveType: Syntax[TypeTree] = (accept(PrimTypeKind) {
    case tk@PrimTypeToken(name) => TypeTree(name match {
      case "Unit" => UnitType
      case "Boolean" => BooleanType
      case "Int" => IntType
      case "String" => StringType
      case _ => throw new AmycFatalError("Unexpected primitive type name: " + name)
    }).setPos(tk)
  } ~ opt("(" ~ literal ~ ")")).map { 
    case (prim@TypeTree(IntType)) ~ Some(_ ~ IntLiteral(32) ~ _) => prim
    case TypeTree(IntType) ~ Some(_ ~ IntLiteral(width) ~ _) => 
      throw new AmycFatalError("Int type can only be used with a width of 32 bits, found : " + width)
    case TypeTree(IntType) ~ Some(_ ~ lit ~ _) =>
      throw new AmycFatalError("Int type should have an integer width (only 32 bits is supported)")
    case TypeTree(IntType) ~ None => 
      throw new AmycFatalError("Int type should have a specific width (only 32 bits is supported)")
    case prim ~ Some(_) => 
      throw new AmycFatalError("Only Int type can have a specific width")
    case prim ~ None => prim
  }

  // A user-defined type (such as `List`).
  lazy val identifierType: Syntax[TypeTree] = 
    (identifierPos ~ opt("." ~>~ identifier)).map {
      case (name, pos) ~ None => TypeTree(ClassType(QualifiedName(None, name))).setPos(pos)
      case (module, pos) ~ Some(name) => TypeTree(ClassType(QualifiedName(Some(module), name))).setPos(pos)
    }

  // An expression.
  // HINT: You can use `operators` to take care of associativity and precedence
  lazy val expr: Syntax[Expr] = recursive { 

    lazy val unaryExpr: Syntax[Expr] = 
      (op("-") ~ unaryExpr).map { case start ~ e => Neg(e).setPos(start) } |
      (op("!") ~ unaryExpr).map { case start ~ e => Not(e).setPos(start) } |
      simpleExpr

    lazy val binOpExpr: Syntax[Expr] = operators(unaryExpr)(
      op("*") | op("/") | op("%") is LeftAssociative,
      op("+") | op("-") | op("++") is LeftAssociative,
      op("<") | op("<=") is LeftAssociative,
      op("==") is LeftAssociative,
      op("&&") is LeftAssociative,
      op("||") is LeftAssociative
    ) {
      case (lhs, OperatorToken(opString), rhs) => opString match {
        case "*" => Times(lhs, rhs).setPos(lhs)
        case "/" => Div(lhs, rhs).setPos(lhs)
        case "%" => Mod(lhs, rhs).setPos(lhs)
        case "+" => Plus(lhs, rhs).setPos(lhs)
        case "-" => Minus(lhs, rhs).setPos(lhs)
        case "++" => Concat(lhs, rhs).setPos(lhs)
        case "<" => LessThan(lhs, rhs).setPos(lhs)
        case "<=" => LessEquals(lhs, rhs).setPos(lhs)
        case "==" => Equals(lhs, rhs).setPos(lhs)
        case "&&" => And(lhs, rhs).setPos(lhs)
        case "||" => Or(lhs, rhs).setPos(lhs)
      }
    }

    val matchExpr: Syntax[Expr] = 
      (binOpExpr ~ opt(kw("match") ~ "{" ~ many1(matchCase) ~ "}")).map {
        case e ~ None => e
        case e ~ Some(_ ~ _ ~ cases ~ _) => Match(e, cases.toList).setPos(e)
      }

    val matchIfErrorExpr: Syntax[Expr] = 
      (kw("if") ~ "(" ~ expr ~ ")" ~ kw("then") ~ expr ~ kw("else") ~ expr ~ kw("end") ~ kw("if")).map {
        case i ~ _ ~ cond ~ _ ~ _ ~ thenn ~ _ ~ elze ~ _ ~ _ => Ite(cond, thenn, elze).setPos(i)
      } |
      (kw("error") ~ "(" ~ expr ~ ")").map {
        case err ~ _ ~ msg ~ _ => Error(msg).setPos(err)
      } |
      matchExpr

    (kw("val") ~ parameter ~ "=" ~ matchIfErrorExpr ~ ";" ~ expr).map { 
      case v ~ param ~ _ ~ value ~ _ ~ body => Let(param, value, body).setPos(v)
    } |
    (matchIfErrorExpr ~ opt(";" ~ expr)).map {
      case e ~ None => e
      case e ~ Some(_ ~ seq) => Sequence(e, seq).setPos(e)
    }
  }

  lazy val matchCase: Syntax[MatchCase] = 
    (kw("case") ~ pattern ~ "=>" ~ expr).map {
      case c ~ pat ~ _ ~ e => MatchCase(pat, e).setPos(c)
    }


  // starting here, this is mine
  // A literal expression.
  lazy val literal: Syntax[Literal[?]] = accept(LiteralKind){
    case IntLitToken(value) => IntLiteral(value)
    case StringLitToken(value) => StringLiteral(value)
    case BoolLitToken(value) => BooleanLiteral(value)
    // WARNING I might need to get a unit litteral from somewhere
  }

  // A pattern as part of a mach case.
  lazy val pattern: Syntax[Pattern] = recursive { 
    literalPattern | wildPattern
  }


  lazy val literalPattern: Syntax[Pattern] = accept(LiteralKind){
    case IntLitToken(value) => LiteralPattern((IntLiteral(value)))
    case StringLitToken(value) => LiteralPattern(StringLiteral(value))
    case BoolLitToken(value) => LiteralPattern(BooleanLiteral(value))
  }

  lazy val wildPattern: Syntax[Pattern] = accept(KeywordKind("_")){
    case KeywordToken("_") => WildcardPattern()
  }
  // ending here, this was mine



  // HINT: It is useful to have a restricted set of expressions that don't include any more operators on the outer level.
  lazy val simpleExpr: Syntax[Expr] = 
    literal.up[Expr] | variableOrCall |  ("(" ~>~ expr ~<~ ")")

  lazy val arguments: Syntax[List[Expr]] =
      ("(" ~>~ repsep(expr, ",").map(_.toList) ~<~ ")")
    
  lazy val variableOrCall: Syntax[Expr] =
    (identifierPos ~ opt("." ~>~ identifier) ~ opt(arguments)).map {
      case (name, pos) ~ None ~ None => Variable(name).setPos(pos)
      case (name, pos) ~ None ~ Some(args) => Call(QualifiedName(None, name), args).setPos(pos)
      case (module, pos) ~ Some(name) ~ Some(args) => Call(QualifiedName(Some(module), name), args).setPos(pos)
      case _ => throw new AmycFatalError("Invalid variable or call")
    }


  // TODO: Other definitions.
  //       Feel free to decompose the rules in whatever way convenient.


  // Ensures the grammar is in LL(1)
  lazy val checkLL1: Boolean = {
    if (program.isLL1) {
      true
    } else {
      // Set `showTrails` to true to make Scallion generate some counterexamples for you.
      // Depending on your grammar, this may be very slow.
      val showTrails = false
      debug(program, showTrails)
      false
    }
  }

  override def run(ctx: Context)(tokens: Iterator[Token]): Program = {
    import ctx.reporter._
    if (!checkLL1) {
      ctx.reporter.fatal("Program grammar is not LL1!")
    }

    val parser = Parser(program)

    try {
      parser(tokens) match {
        case Parsed(result, rest) => result
        case UnexpectedEnd(rest) => fatal("Unexpected end of input.")
        case UnexpectedToken(token, rest) => fatal("Unexpected token: " + token + ", possible kinds: " + rest.first.map(_.toString).mkString(", "))
      }
    } catch {
      case e: AmycFatalError =>
        ctx.reporter.fatal(e.msg)
        sys.exit(1)
    }
  }
}