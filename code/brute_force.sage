def brute_force(p, a,b):
    R.<x> = PolynomialRing(GF(p))
    f = x**3 + a*x + b
    return 1+p+sum([kronecker(f(i),p) for i in range(p)])
