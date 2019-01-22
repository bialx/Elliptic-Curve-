laod("division_polynomial.sage")

# R.<u> = GF(p)[]
# S.<v> = R[]
# T = S.fraction_field()
# E = EllipticCurve(T, [a, b])


#source comprehesnion polynome de division + algo schoof :
#https://hal-univ-rennes1.archives-ouvertes.fr/tel-01101949/document
#http://www-users.math.umn.edu/~musiker/schoof.pdf





def schoof(a,b,p):
    N = 1
    prime = 1
    list_l = []
    list_t = []
    try:
        K = GF(p)
        R.<x> = PolynomialRing(K)
        E = EllipticCurve(K, [a,b])
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
        #Create the quotient ring in which we are going to do all of our compution
        # W = F_p[X,Y]/(f_l(X), Y² - X¨3 - aX - b)
        #
        B = R.quotient(div, 'x2')
        C = PolynomialRing(B, 'y')
        x = C.gen()
        W = C.quotient(y**2 - x**3 - a*x - b)
        dict = division_polynomial(p, a, b, l)
        E2 = E.base_extend(W)
        p_l = K(p)
        phi_2 = E2[x**(p**2), y**(p**2)]
        pl_times_P_x, pl_times_P_y  = np(p_l, (p, a, b, l), dict)
        pl_times_P = E2[pl_times_P_x, pl_times_P_y]


        #sum_to_check = phi_2 + pl_times_P

        for i in range(l):
            if np(i, (p, a, b, l), dict) == sum_to_check:
