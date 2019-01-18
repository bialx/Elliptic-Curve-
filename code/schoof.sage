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
        div = E.division_polynomial(l, two_torsion_multiplicity = 0)
        print(div)
        #Create the quotient ring in which we are going to do all of our compution
        # W = F_p[X,Y]/(f_l(X), Y² - X¨3 - aX - b)
        #
        B = R.quotient(div, 'x2')
        C = PolynomialRing(B, 'y')
        x = C.gen()
        W = C.quotient(y**2 - x**3 - x - 3)

        p_l = K(p)
        psi_2m = E.division_polynomial(2*p_l, two_torsion_multiplicity = 0))
        if p_l % 2 == 0:
            psi_m = W(2*y*(E.division_polynomial(p_l, two_torsion_multiplicity = 0)))
            psi_mbef = W(E.division_polynomial(p_l - 1, two_torsion_multiplicity = 0))
            psi_mbaft = W(E.division_polynomial(p_l + 1, two_torsion_multiplicity = 0))
        else:
            psi_m = W((E.division_polynomial(p_l, two_torsion_multiplicity = 0)))
            psi_mbef = W(2*y*(E.division_polynomial(p_l - 1, two_torsion_multiplicity = 0)))
            psi_mbaft = W(2*y*(E.division_polynomial(p_l + 1, two_torsion_multiplicity = 0)))

        x1 = x - (psi_aft*psi_bef)/psi_m**2
        y1 = psi_2m / psi_m**4
