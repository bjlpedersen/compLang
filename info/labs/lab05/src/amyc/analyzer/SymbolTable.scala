package amyc.analyzer

import amyc.ast.Identifier
import amyc.ast.SymbolicTreeModule._
import amyc.utils.UniqueCounter

import scala.collection.mutable.HashMap

trait Signature[RT <: Type]{
  val argTypes: List[Type]
  val retType: RT
}

/**
  * The signature of a function in the symbol table
  *
  * @param argTypes Types of the args of the function, in order
  * @param retType Return type of the function
  * @param owner Name of the module in which the function is defined
  */
case class FunSig(argTypes: List[Type], retType: Type, owner: Identifier) extends Signature[Type]


case class DefaultFunSig(argTypes: List[Type], retType: Type, owner: Identifier, defaultValues: List[(Expr, String)]) extends Signature[Type]

/**
  * The signature of a constructor in the symbol table
  *
  * @param argTypes Types of the args of the constructor, in order
  * @param parent Identifier of the abstract class that the constructor extends
  * @param index Constructors extending a parent are numbered, starting at 0 for each parent.
  *              This is useful for code generation, where we need a runtime representation of which
  *              instance of the parent type a value represents.
  */
case class ConstrSig(argTypes: List[Type], parent: Identifier, index: Int) extends Signature[ClassType] {
  val retType = ClassType(parent)
}

case class DefaultConstrSig(argTypes: List[Type], parent: Identifier, index: Int, defaultValues: List[(Expr, String)])
  extends Signature[ClassType] {
  val retType = ClassType(parent)
}

// A class that represents a dictionary of symbols for an Amy program
class SymbolTable {
  private val defsByName = HashMap[(String, String), Identifier]()
  private val modules = HashMap[String, Identifier]()

  private val types = HashMap[Identifier, Identifier]()
  private val functions = HashMap[Identifier, FunSig]()
  private val constructors = HashMap[Identifier, ConstrSig]()
  private val defaultFunctions = HashMap[Identifier, DefaultFunSig]()
  private val defaultConstructors = HashMap[Identifier, DefaultConstrSig]()

  private val typesToConstructors = HashMap[Identifier, List[Identifier]]()

  private val constrIndexes = new UniqueCounter[Identifier]

  def addModule(name: String) = {
    val s = Identifier.fresh(name)
    modules += name -> s
    s
  }
  def getModule(name: String) = modules.get(name)

  def addType(owner: String, name: String) = {
    val s = Identifier.fresh(name)
    defsByName += (owner, name) -> s
    types += (s -> modules.getOrElse(owner, sys.error(s"Module $name not found!")))
    s
  }
  def getType(owner: String, name: String) =
    defsByName.get(owner,name) filter types.contains
  def getType(symbol: Identifier) = types.get(symbol)

  def addDefaultConstructor(owner: String, name: String, argTypes: List[Type], parent: Identifier, 
  defaultArgs: List[(Literal[Any], String)]) = {
    val s = Identifier.fresh(name)
    defsByName += (owner, name) -> s
    defaultConstructors += s -> DefaultConstrSig(
      argTypes,
      parent,
      constrIndexes.next(parent),
      defaultArgs
    )
    typesToConstructors += parent -> (typesToConstructors.getOrElse(parent, Nil) :+ s)
    s
  }
  def getDefaultConstructor(owner: String, name: String): Option[(Identifier, DefaultConstrSig)] = {
    for {
      sym <- defsByName.get(owner, name)
      sig <- defaultConstructors.get(sym)
    } yield (sym, sig)
  }
  def getDefaultConstructor(symbol: Identifier) = defaultConstructors.get(symbol)
  /*def addConstructor(owner: String, name: String, argTypes: List[Type], parent: Identifier) = {
    val s = Identifier.fresh(name)
    defsByName += (owner, name) -> s
    constructors += s -> ConstrSig(
      argTypes,
      parent,
      constrIndexes.next(parent)
    )
    typesToConstructors += parent -> (typesToConstructors.getOrElse(parent, Nil) :+ s)
    s
  }
  def getConstructor(owner: String, name: String): Option[(Identifier, ConstrSig)] = {
    for {
      sym <- defsByName.get(owner, name)
      sig <- constructors.get(sym)
    } yield (sym, sig)
  }
  def getConstructor(symbol: Identifier) = constructors.get(symbol)*/

  def getConstructorsForType(t: Identifier) = typesToConstructors.get(t)
/*
  def addFunction(owner: String, name: String, argTypes: List[Type], retType: Type) = {
    val s = Identifier.fresh(name)
    defsByName += (owner, name) -> s
    functions += s -> FunSig(argTypes, retType, getModule(owner).getOrElse(sys.error(s"Module $owner not found!")))
    s
  }*/
  def addDefaultFunction(owner: String, name: String, argTypes: List[Type], retType: Type, defaultArgs: List[(Literal[Any], String)]) =  {
    val s = Identifier.fresh(name)
    defsByName += (owner, name) -> s
    defaultFunctions += s -> DefaultFunSig(argTypes, retType, 
      getModule(owner).getOrElse(sys.error(s"Module $owner not found!")), defaultArgs)
    s
  }
  def getDefaultFunction(owner: String, name: String): Option[(Identifier, DefaultFunSig)] = {
    for {
      sym <- defsByName.get(owner, name)
      sig <- defaultFunctions.get(sym)
    } yield (sym, sig)
  }
  def getDefaultFunction(symbol: Identifier) = defaultFunctions.get(symbol)
  /*def getFunction(owner: String, name: String): Option[(Identifier, FunSig)] = {
    for {
      sym <- defsByName.get(owner, name)
      sig <- functions.get(sym)
    } yield (sym, sig)
  }
  def getFunction(symbol: Identifier) = functions.get(symbol)
*/
}
