divpoly_factor = 0    # global variable for factor of the division polynomial when ZeroDivisionError's occur

def add(P,Q,a):
    """add P and Q"""
    global divpoly_factor
    if not P:
      return Q
    if not Q:
      return P
    x1, y1, x2, y2 = P[0], P[1], Q[0], Q[1]
    if x1 == x2:
        if y1 == y2:
          return double(P,a)
        else:
          return ()
    try:
        lambd = (y2-y1) / (x2-x1)
    except ZeroDivisionError:
        ### raise an error so that we can restart the algorithm working in a smaller quotient ring
        divpoly_factor = x2 - x1
        raise
    x3 = lambd**2 -x1 - x2
    y3 = lambd*(x1-x3) - y1
    return (x3,y3)

def double(P,a):
    """double P : P+P """
    global divpoly_factor
    if not P:
      return P
    x1, y1 = P[0], P[1]
    try:
        lambd = (3*x1^2+a) / (2*y1)
    except ZeroDivisionError:
        divpoly_factor = 2*y1
        raise
    x3 = lambd^2 - 2*x1
    y3 = lambd*(x1-x3) - y1
    return (x3,y3)

def neg(P):
    """ negate P : -P """
    if not P:
      return P
    return (P[0], -P[1])

def nP_double_and_add(n,P,a):
    """ compute the scalar multiplicatione nP using double and add"""
    if not n:
      return ()
    nbits = n.digits(2)
    i = len(nbits)-2
    Q = P
    while i >= 0:
        Q = double(Q,a)
        if nbits[i]:
          Q = add(P,Q,a)
        i -= 1
    return Q
