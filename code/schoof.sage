load("division_polynomial.sage")


# The elliptic curve E is in Weierstrass form y^2=f(x)=x^3+ax+b

# R.<u> = GF(p)[]
# S.<v> = R[]
# T = S.fraction_field()
# E = EllipticCurve(T, [a, b])


#source comprehesnion polynome de division + algo schoof :
#https://hal-univ-rennes1.archives-ouvertes.fr/tel-01101949/document
#http://www-users.math.umn.edu/~musiker/schoof.pdf



def add(P,Q,E):
    # Cas P != Q
    # a = E.a4()
    # b = E.a6()
    x1, y1 = P
    x2, y2 = Q
    lambd = (y2 - y1)/(x2- x1)
    x3 = lambd**2 - x1 - x2
    y3 = lambd*(x1 - x3 ) - y1
    return (x3, y3)


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



#Pre comuptation of division polynomial so we can store them in a dictionary structure and acces its element in constant time
    dict = division_polynomial(p, a, b, 2*max(list_l)+1)

    for l in list_l:
        anwser = 0
        #Create the quotient ring in which we are going to do all of our compution
        # W = F_p[X,Y]/(f_l(X), Y² - X¨3 - aX - b)
        #
        B = R.quotient(dict.get(l), 'x2')
        C = PolynomialRing(B, 'y')
        x = C.gen()
        W = C.quotient(y**2 - x**3 - a*x - b)
        E2 = E.base_extend(W)
        p_l = K(p)
        phi_2 = E2[x**(p**2), y**(p**2)]
        pl_times_P_x, pl_times_P_y  = np(p_l, (p, a, b, l), dict)
        pl_times_P = E2[pl_times_P_x, pl_times_P_y]
        x3, y3 = add(phi_2, pl_times_P, E2)

        for i in range(l):
            x_t, y_t = np(i, (p, a, b, l), dict)
            if x_t == x3:
                if y_t == y3:
                    list_t.append(i)
                    anwser = 1
                    break
                else:
                    list_t.append(-i)
                    answer = 1
                    break

#Case we dont find any solution to statisfie the caracteristic equation
#so we have the wrong assumption with our addition formulae
        if anwser == 0:
            return 0

#we use the chinese remainder theorem to return the trace of the frobenius endomorphism
    return ctr(izip(list_t, list_l))
