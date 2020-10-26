import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteswap extends Expr {
  NetworkByteswap() {
    exists(MacroInvocation macro | macro.getMacro().getName().regexpMatch("ntoh.+") |
      this = macro.getExpr()
    )
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemcpyFuncLen" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof NetworkByteswap }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call | sink.asExpr() = call.getArgument(2) |
      call.getTarget().getName() = "memcpy"
    )
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink
