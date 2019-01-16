#
# R.<u> = GF(p)[]
# S.<v> = R[]
# T = S.fraction_field()
# E = EllipticCurve(T, [a, b])


#source https://hal-univ-rennes1.archives-ouvertes.fr/tel-01101949/document
#http://www-users.math.umn.edu/~musiker/schoof.pdf


def schoof(a,b,p):
    N = 1
    prime = 1
    list_l = []
    list_t = []
    try:
        K = GF(p)
        R.<x> = PolynomialRing(K)
    except:
        raise NameError('wrong p ,cant construct the Ring R.<x> = PolynomialRing(K)')


#Compute a set of small prime whose product is > 4* sqrt(p)
    while N <= 4*sqrt(p):
        if prime == p:
            pass
        prime = next_prime(prime)
        N = N*prime
        list_l.append(prime)

    E = EllipticCurve(K, [a, b])
    if gcd(x**p - x, x**3 + a*x + b) != 1:
        list_t.append(0)
    else:
        list_t.append(1)

#Create the extension in which we are going to do all of our compution

    for l in list_l:
        div = E.division_polynomial(l, two_torsion_multiplicity = 0)
        print(div)
        #Create the quotient ring in which we are going to do all of our compution
        # F_p[X,Y]/(f_l(X), Y² - X¨3 - aX - b)
        #
        # S.<x2> = R.quotient(R,div)
        # Quotient_X_Y.<e,f> = QuotientRing(Y,y**2 - a*x**3 - b)
        # p_l = GF(l)(p)
