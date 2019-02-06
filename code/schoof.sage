load("division_polynomial.sage")
load("EC_basic_computation.sage")

# The elliptic curve E is in Weierstrass form y^2=f(x)=x^3+ax+b


#source comprehesnion polynome de division + algo schoof :
#https://hal-univ-rennes1.archives-ouvertes.fr/tel-01101949/document
#http://www-users.math.umn.edu/~musiker/schoof.pdf

def schoof2(E):
    K = E.base_ring()
    p = K.cardinality()
    a, b = E.a4(), E.a6()
    N = 1
    prime = 1
    answer = 0
    list_l = []
    list_t = []
    R.<x> = PolynomialRing(K)
    S.<x1, y1> = PolynomialRing(K)
    f = x**3 + a*x + b

    """ Compute a set of small prime whose product is > 4* sqrt(p) """
    while N <= 4*sqrt(p):
        if prime == p:
            pass
        prime = next_prime(prime)
        N = N*prime
        list_l.append(prime)

    """ Pre computation of division polynomial """
    dict = division_polynomial(p, a, b, 2*max(list_l)+1)

    for l in list_l:
        if l == 2:
            if gcd(x**p - x, x**3 + a*x + b) != 1:
                list_t.append(0)
                continue
            else:
                list_t.append(1)
                continue

        """ Create the ring where our computation w'll take place"""
        poly_divi_l = R(dict.get(l))
        if not  poly_divi_l.is_irreducible():                         #to ensure the ring is a field, f_l might not be irreducible
            for poly, deg in list(reversed(factor(poly_divi_l))):
                if poly.degree() > 1:
                    poly_divi_l  = poly
                    break
        B.<x2> = R.quotient(ideal(poly_divi_l))
        C.<y> = PolynomialRing(B)
        W = C.quotient(y**2 - f)

        phi = (W(x**p), W(y**p))           #(x^p, y^p)
        phi2 = (W(x**(p**2)), W(y**(p**2)))  #(x^(p^2), y^(p^2))
        phi2_x, phi2_y = phi2
        prod = nP_double_and_add(p%l,(W(x),W(y)),a)    #[p mod l]*(x,y)
        prod_x, prod_y = prod

        if phi2_x != prod_x:
            sum_x, sum_y = add(phi2, prod, a)      #(x^(p^2), y^(p^2)) + [p mod l]*(x,y)
            S = (sum_x, sum_y)
            for tau in range(1, l):
                tau_prod = nP_double_and_add(ZZ(tau),phi,a)
                tau_prod_x, tau_prod_y = tau_prod
                if sum_x == tau_prod_x:
                    if sum_y == tau_prod_y:
                        list_t.append(tau)
                        answer = 1
                        break
                    else:
                        list_t.append(-tau)
                        answer = 1
                        break

        else:
            if kronecker(p, l) == 1:      # check if p is a square modulus l and p = w^2 mod l
                w = Mod(p,l).sqrt()
                w_times_phi_x, w_times_phi_y = nP_double_and_add(w,phi,a)    #[w](x^p, y^p)
                w_times_phi = (w_times_phi_x, w_times_phi_y)
                if w_times_phi == phi_2:               #  if [w](x^p, y^p) =  (x^(p^2), y^(p^2))
                    list_t.append(2*w)
                    anwser = 1
                elif w_times_phi_x == phi2_x and w_times_phi_y == -phi2_y:      #  if [w](x^p, y^p) =  (x^(p^2), -y^(p^2))
                    list_t.append(-2*w)
                    anwser = 1
            else:
                list_t.append(0)
                anwser = 1

        """ In case we found no value to satisfy the equation"""
        if answer == 0:
            list_t.append(0)

    """ return t using chinese remainder theorem"""
    print (list_t, list_l)
    t = crt(list_t, list_l)
    if t > (N-1)/2:
        return t-N
    else:
        return t



p = 97
l = 3
K = GF(p)
E = EllipticCurve(K,[2,1])
a,b = E.a4(), E.a6()
schoof2(E)
print (E.trace_of_frobenius())
