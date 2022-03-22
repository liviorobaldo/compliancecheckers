package org.example

import it.unibo.tuprolog.argumentation.core.Arg2pSolver
import it.unibo.tuprolog.argumentation.core.dsl.arg2pScope
import it.unibo.tuprolog.argumentation.core.libs.basic.FlagsBuilder
import it.unibo.tuprolog.core.Struct
import it.unibo.tuprolog.core.parsing.parse
import it.unibo.tuprolog.solve.channel.OutputChannel
import it.unibo.tuprolog.solve.classic.ClassicSolverFactory
import it.unibo.tuprolog.theory.Theory
import it.unibo.tuprolog.theory.parsing.parse
import it.unibo.tuprolog.argumentation.core.mining.graph
import it.unibo.tuprolog.argumentation.core.model.Graph


fun solve(theory: String) : Graph =
    arg2pScope {
        Arg2pSolver.default().let { arg2pSolver ->
            ClassicSolverFactory.mutableSolverWithDefaultBuiltins(
                otherLibraries = arg2pSolver.to2pLibraries().plus(FlagsBuilder().create().content()),
                staticKb = Theory.parse(theory, arg2pSolver.operators()),
                stdOut = OutputChannel.of {}
            ).let { solver ->
                solver.solve(Struct.parse("buildLabelSets") and "context_active"(X))
                    .map { it.substitution[X]!!.asNumeric()!!.intValue.toInt() }
                    .first()
                    .let { solver.graph(it) }
            }
        }
    }


fun solve(theory: String, consumer : (String) -> Unit) =
    Arg2pSolver.default().let { arg2pSolver ->
            ClassicSolverFactory.mutableSolverWithDefaultBuiltins(
            otherLibraries = arg2pSolver.to2pLibraries().plus(FlagsBuilder().create().content()),
            staticKb = Theory.parse(theory, arg2pSolver.operators()),
            stdOut = OutputChannel.of(consumer)
        ).solve(Struct.parse("buildLabelSets")).first()
    }

fun solve(query: String, theory: String) : Boolean =
    arg2pScope {
        Arg2pSolver.default().let { arg2pSolver ->
            ClassicSolverFactory.mutableSolverWithDefaultBuiltins(
                otherLibraries = arg2pSolver.to2pLibraries().plus(FlagsBuilder().create().content()),
                staticKb = Theory.parse(theory, arg2pSolver.operators())
            ).solve("answerQuery"(Struct.parse(query, arg2pSolver.operators()), X, Y, Z)).first().let {
                it.isYes && ! it.substitution[X]!!.toTerm().isEmptyList
            }
        }
    }


fun solve(queryList: List<String>, theory: String) : List<String> =
    arg2pScope {
        Arg2pSolver.default().let { arg2pSolver ->
            ClassicSolverFactory.mutableSolverWithDefaultBuiltins(
                otherLibraries = arg2pSolver.to2pLibraries().plus(FlagsBuilder().create().content()),
                staticKb = Theory.parse(theory, arg2pSolver.operators())
            ).let { solver ->
                solver.solve("parser" call "convertAllRules"(`_`)).first()
                queryList.filter { query ->
                    solver.solve("structured" call "computeStatementAcceptance"(
                        Struct.parse(query, arg2pSolver.operators()), X, Y, Z)).first().let {
                            it.isYes && ! it.substitution[X]!!.toTerm().isEmptyList }
                }
            }
        }
    }