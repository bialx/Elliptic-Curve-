A.<y> = PolynomialRing(GF(2))
B = A.quotient(y**2 + y + 1, 'y2')
C = PolynomialRing(B, 'x')

print(C)
#http://www.math.sciences.univ-nantes.fr/~sorger/chow/html/en/reference/polynomial_rings/sage/rings/polynomial/polynomial_quotient_ring.html
