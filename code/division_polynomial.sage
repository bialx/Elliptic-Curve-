
def division_polynomial(K,a,b,l):
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


#compute nP using division polynomial,  args : n, param = carac, [a,b] to construct E, l the division polynomial used in the modulus of the ring
#                                               dict with divsion polynomial
def nP(n, param_E, dict):
    K, a, b, l = param_E
    R.<x> = PolynomialRing(GF(K))
    B.<x2> = R.quotient(dict.get(l))
    C.<y> = PolynomialRing(B)
    W = C.quotient(y**2 - x**3 - a*x - b)

    if 2*n not in dict or (n + 1) not in dict or (n-1) not in dict:
        dict = division_polynomial(K,a,b, 2*n + 1)
    if n % 2 == 0:
        psi_n = 2*y*(dict.get(n))
        psi_n_minus_1 = dict.get(n-1)
        psi_n_plus_1 = dict.get(n+1)
    else:
        psi_n = dict.get(n)
        psi_n_minus_1 = 2*y*dict.get(n-1)
        psi_n_plus_1 = 2*y*dict.get(n+1)
    psi_2n = dict.get(2*n)
    # print(f"psi n : {type(psi_n)}\npsi_2n :{type(psi_2n)}\npsi_n_plus_1: {type(psi_n_plus_1)}\npsi_n_minus_1 {type(psi_n_minus_1)}")
    x1 = x - ( psi_n_minus_1*psi_n_plus_1 / psi_n**2)

    y1 = psi_2n / psi_n**4
    return x1,y1
