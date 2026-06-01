# Lab 5 — Improved Parameters & Tuples Extension

## Team

- Bjork Pedersen (bjork.pedersentomas@epfl.ch)
- Sanem Sarioglu (sanem.sarioglu@epfl.ch)
- Fedor Katanaev (fedor.katanaev@epfl.ch)

## Overview

This extension adds three new features to the Amy compiler:
1. **Default parameter values** — function parameters can have default values
2. **Named arguments at call sites** — callers can pass arguments by name
3. **Tuples** — native tuple types, literals, and pattern matching

## Files Modified

### AST
- `src/amyc/ast/TreeModule.scala` — added `default: Option[Expr]` to `ParamDef`, changed `Call.args` to `List[(Option[String], Expr)]`, added `NamedArg`, `TupleLiteral`, `TupleType`, `TuplePattern`
- `src/amyc/ast/Printer.scala` — compatibility fixes for new AST shapes

### Parser
- `src/amyc/parsing/Parser.scala` — added `paramWithDefault`, `namedOrExpr`, updated `arguments` and `variableOrCall`, added `tupleType`, `parenOrTupleOrUnitExpr`, `parenOrTuplePattern`, wrapped `typeTree` in `recursive {}`

### Analyzer
- `src/amyc/analyzer/SymbolTable.scala` — new signatures `DefaultFunSig` and `DefaultConstrSig` storing default values
- `src/amyc/analyzer/NameAnalyzer.scala` — handles default values, validates ordering, allows fewer arguments when defaults cover the rest
- `src/amyc/analyzer/TupleDesugarer.scala` — new phase that desugars `TupleLiteral`, `TupleType`, `TuplePattern` into standard case class calls before name analysis
- `src/amyc/analyzer/TypeChecker.scala` — compatibility fixes, tuple type variable bypass

### Code Generation
- `src/amyc/codegen/CodeGen.scala` — handles named and default arguments at code generation level

### Library
- `library/Tuple.Amy` — defines `Tuple2` through `Tuple10` as case classes extending abstract class `Tuple`

## Files Added

### Tests
- `test/resources/parser/passing/DefaultParams.amy` — parser test for default parameters
- `test/resources/parser/passing/NamedArgs.amy` — parser test for named arguments
- `test/resources/execution/passing/TupleTest.amy` — basic tuple execution test
- `test/resources/execution/passing/LargerTupleTest.amy` — tuples with arity > 2
- `test/resources/execution/passing/MixedTupleTest.amy` — tuples mixing Int and Boolean
- `test/resources/execution/passing/NestedTupleTest.amy` — nested tuples
- `test/resources/execution/outputs/TupleTest.txt` — expected output
- `test/resources/execution/outputs/LargerTupleTest.txt` — expected output
- `test/resources/execution/outputs/MixedTupleTest.txt` — expected output
- `test/resources/execution/outputs/NestedTupleTest.txt` — expected output

### Report
- `CLP_report.md` — full project report

## How to Run

Compile and run an Amy source file:
```
sbt "runMain amyc.Main yourfile.amy"
```

Example with default parameters and named arguments:
```
sbt "runMain amyc.Main test/resources/parser/passing/NamedArgs.amy"
```

Example with tuples:
```
sbt "runMain amyc.Main library/Tuple.Amy test/resources/execution/passing/TupleTest.amy"
```

## How to Test

Run the full test suite:
```
sbt test
```

Run only parser tests:
```
sbt "testOnly amyc.test.ParserTests"
```

Run only execution tests:
```
sbt "testOnly amyc.test.ExecutionTests"
```
