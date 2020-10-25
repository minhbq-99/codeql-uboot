import cpp

class NetworkByteswap extends Expr {
  NetworkByteswap() {
    exists(MacroInvocation m |
      m.getMacro().getName().regexpMatch("ntoh.+") and
      this = m.getExpr()
    )
  }
}

from NetworkByteswap n
select n
