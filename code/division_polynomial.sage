
def division_polynomial(K,a,b,l):
    """ return a dictionnary with all the polynomial division between 1 and l"""
    R.<x,y> = PolynomialRing(GF(K))
    E = EllipticCurve(GF(K), [a,b])
    dict = {}
    dict[0], dict[1], dict[2] = 0,1,1
    dict[3] = 3*x**4 + 6*a*x**2 + 12*b*x - a**2
    dict[4] = 2*x**6 + 10*a*(x**4) + 40*b*(x**3) - 10*(a**2)*(x**2) -  8*a*b*x - 2*(a**3 + 8*b**2)
    dict[-1] = 4*x**3 + 4*a*x + 4*b
    n = 5
    while n < l:
        dict = reccurence_poly(n, dict)
        n += 1
    return dict

def reccurence_poly(n, dict):
    """ reccurence formulae used to compute the l-th division polynomial"""
    if n%2 != 0:
        m = floor(n/2)
        if m%2 == 0:
            dict[n] = (dict.get(m+2)*(dict.get(m)**3))*dict.get(-1)**2 - dict.get(m-1)*(dict.get(m+1)**3)
        else:
            dict[n] = (dict.get(m+2)*(dict.get(m)**3)) - dict.get(m-1)*(dict.get(m+1)**3)*dict.get(-1)**2
    else:
        m = n/2
        dict[n] = dict.get(m)*(dict.get(m+2)*(dict.get(m-1)**2) - dict.get(m-2)*(dict.get(m+1)**2))
    return dict



### THE FOLLOWING ALGO IS CURRENTLY NOT WORKING NEED TO CHANGE IT ###
### USE nP_double_and_add() is EC_basic_computation.sage instead  ###
#compute nP using division polynomial,  args : n, param = carac, [a,b] to construct E, l the division polynomial used in the modulus of the ring
#                                               dict with divsion polynomial
#compute nP using division polynomial,  args : n, param = carac, [a,b] to construct E, l the division polynomial used in the modulus of the ring
#                                               dict with divsion polynomial, P = (x,y)
def nP(n, param_E, dict, P):
    print "entering nP computation", P
    n = RR(n)
    K, a, b, l = param_E
    P_x, P_y = P
    S.<x1, y1> = PolynomialRing(GF(K))
    R.<x> = PolynomialRing(GF(K))
    poly_divi_l = R(dict.get(l))
    if not  poly_divi_l.is_irreducible():
        for poly, deg in list(reversed(factor(poly_divi_l))):
            if poly.degree() > 1:
                poly_divi_l  = poly
                break

    f = x**3 + a*x + b
    B.<x2> = R.quotient(poly_divi_l)
    C.<y> = PolynomialRing(B)
    W = C.quotient(y**2 - f)

    if n == 1:
        return W(x),W(y)
    if 2*n not in dict or (n + 1) not in dict or (n-1) not in dict:
        dict = division_polynomial(K,a,b, 2*n + 1)

    inter_n = S(dict.get(n))
    inter_n_minus_1 =S(dict.get(n-1))
    inter_n_plus_1 = S(dict.get(n+1))
    inter_2n = S(dict.get(2*n))
    print inter_n.parent(),inter_n_minus_1.parent(),inter_n_plus_1.parent(),inter_2n.parent(), inter_n,inter_n_minus_1,inter_n_plus_1,inter_2n, type(inter_n)

    if n % 2 == 0:
        print "n = ",n
   #      print "n",inter_n, type(inter_n), type(5), type(inter_n) != type(5)
        if type(inter_n) != type(5):
            psi_n = (2*y1*inter_n)(x1=P_x,y1=P_y)
            psi_n = W(psi_n)
        if type(inter_n_minus_1) != type(5):
            psi_n_minus_1 = inter_n_minus_1(x1=P_x,y1=P_y)
            psi_n_minus_1 = W(psi_n_minus_1)
        if type(inter_n_plus_1) != type(5):
            psi_n_plus_1 = inter_n_plus_1(x1=P_x,y1=P_y)
            psi_n_plus_1 = W(psi_n_plus_1)
        # if type(inter_n) == type(5):
#             print "ok"
#             psi_n = (2*y1*inter_n)(x1=P_x,y1=P_y)
#             ps__n = W(psi_n)
#         if type(inter_n_minus_1) == type(5):
#             psi_n_minus_1 = W(inter_n_minus_1)
#         if type(inter_n_plus_1) != type(5):
#             psi_n_plus_1 = W(inter_n_plus_1)

    else:
        if type(inter_n) != type(5):
            psi_n = inter_n(x1=P_x,y1=P_y)
            psi_n = W(psi_n)
        if type(inter_n_minus_1) != type(5):
            psi_n_minus_1 = (2*y1*inter_n_minus_1)(x1=P_x, y1=P_y)
            psi_n_minus_1 = W(psi_n_minus_1)
        if type(inter_n_plus_1) != type(5):
            psi_n_plus_1 = (2*y1*inter_n_plus_1)(x1=P_x, y1=P_y)
            print "->", psi_n_plus_1, psi_n_plus_1.parent()
            psi_n_plus_1 = W(psi_n_plus_1)
        # if type(inter_n) == type(5):
#             psi_n = W(inter)
#         if type(inter_n_minus_1) == type(5):
#             psi_n_minus_1 = (2*y1*inter_n_minus_1)(x1=P_x, y1=P_y)
#             psi_n_minus_1 = W(psi_n_minus_1)
#         if type(inter_n_plus_1) == type(5):
#             psi_n_plus_1 = (2*y1*inter_n_plus_1)(x1=P_x, y1=P_y)
#             psi_n_plus_1 = W(psi_n_plus_1)
    if type(inter_2n) != type(5):
        psi_2n = inter_2n(x1=P_x, y1=P_y)
        psi_2n = W(psi_2n)
    # else:
#         psi_2n = W(inter_2n)

    print(" psi n : ",type(psi_n), psi_n)
    print(" psi_2n :", type(psi_2n), psi_2n )
    print(" psi_n_plus_1: ",type(psi_n_plus_1), psi_n_plus_1)
    print(" psi_n_minus_1 ", type(psi_n_minus_1), psi_n_minus_1)

    # divisor = (psi_n**2)
#     poly_divi = dict.get(l)
#     print l
#     for elt in list(factor(poly_divi)):
#          print elt
#     print ("psi n carre : ",divisor)
#     print ("l eme pol div : ", dict.get(l))
#     print("is irreducible ? : ", R(poly_divi).is_irreducible())
#     inter = psi_n_minus_1*psi_n_plus_1 / psi_n**2
#     print inter
    x1 = W(P_x) - W( psi_n_minus_1*psi_n_plus_1 / psi_n**2)
    y1 = W(psi_2n / psi_n**4)
    return W(x1), W(y1)
