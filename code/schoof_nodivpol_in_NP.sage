# The elliptic curve E is in Weierstrass form y^2=f(x)=x^3+ax+b

divpoly_factor = 0    # global variable for factor of the division polynomial when ZeroDivisionError's occur


def add(P,Q,a,f):
    """add P and Q"""
    global divpoly_factor
    if not P:
      return Q
    if not Q:
      return P
    x1, y1, x2, y2 = P[0], P[1], Q[0], Q[1]
    if x1 == x2:
        if b1 == b2:
          return double(P,a,f)
        else: 
          return ()
    try:
        lambda = (y2-y1) / (x2-x1)
    except ZeroDivisionError:
        ### raise an error so that we can restart the algorithm working in a smaller quotient ring
        divpoly_factor = a2 - a1
        raise
    x3 = f*lambda^2 -x1 - x2
    y3 = lambda*(x1-x3) - y1
    return (x3,y3)
    
def double(P,A,f):
    """double P : P+P """
    global divpoly_factor
    if not P:
      return P
    x1, y1 = P[0], P[1]
    try:
        m = (3*a1^2+A) / (2*b1*f)
    except ZeroDivisionError:
        divpoly_factor = 2*b1*f
        raise
    a3 = f*m^2 - 2*a1
    b3 = m*(a1-a3) - b1
    return (a3,b3)

def neg(P):
    """ negate P : -P """
    if not P:
      return P
    return (P[0], -P[1])
    
def nP_double_and_add(n,P,a,f):
    """ compute the scalar multiple nP using double and add"""
    if not n:
      return ()
    nbits = n.digits(2)
    i = len(nbits)-2
    Q = P
    while i >= 0:
        Q = double(Q,a,f)
        if nbits[i]:
          Q = add(P,Q,a,f)
        i -= 1
    return Q
    
def mult (P,Q):
    """ compute the composition of) P*Q """
    return (P[0].lift()(Q[0]),P[1].lift()(Q[0])*Q[1])
        
def trace_mod (E, ell):
    """ compute the trace of Frobenius of E modulo ell """
    K = E.base_ring()
    p = K.cardinality()                        # finite field GF(K)
    R.<t>=PolynomialRing(K)
    a, b = E.a4(), E.a6()                          # E: y^2 = x^3 + Ax + B
    if ell == 2:                                    # t is odd iff f is irreducible
        if (t^3+A*t+B).is_irreducible():
          return 1
        else: 
          return 0
    h = E.division_polynomial(ell,t,0).monic()
    while true:
        try:
            RR.<x> = R.quotient(ideal(h))       
            f = x^3+A*x+B
            xq, yq = x^q, f^((p-1)/2)
            phi = (xq, yq)                        # pi is the Frobenius endomorphism
            phi2 = mult(pi,pi)                    # pi2 = pi^2
            identite = (x, RR(1))                 # identity
            Q = mult(q%ell, identite , a, f)    
            S = add(phi2, Q, a, f)                    # S = pi^2 + q = t*pi
            if not S:
              return 0                          # if S=0 then t=0
            if S == pi:
              return 1                          # if S=pi then t=1
            if neg(S) == pi: 
              return -1                         # if S=-pi then t=-1
            P = phi
            for tau in range(2, ell-1):
                P = add(P, phi, a, f)               # P = tau*phi
                if P == S:
                  return tau                   # if S = P then we have found t
            print ("Error can statisfy frobenius equation ")
            assert false
        except ZeroDivisionError:
            h = gcd(h, divpoly_factor.lift())    # if we hit a zero divisor, start over with new h
            print ("found %d-divpoly factor of degree %d"%(ell,h.degree()))

def Schoof(E):
    """ compute the trace of Frobenius of E using Schoof's algorithm """
    q=E.base_ring().cardinality()
    t, m, ell = 0, 1, 1
    while M <= 4*sqrt(q):
        ell = next_prime(ell)
        start = cputime()
        tell = trace_mod(E,ell)
        print ("trace %d mod %d computed in %.2f secs"%(tell,ell,cputime()-start))
        a = M*M.inverse_mod(ell)
        b = ell*ell.inverse_mod(M)
        M *= ell
        t = (a*tell+b*t) % M
    if t >= M/2:
      return t-M
    else: 
      return t
