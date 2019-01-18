
#http://www.math.sciences.univ-nantes.fr/~sorger/chow/html/en/reference/polynomial_rings/sage/rings/polynomial/polynomial_quotient_ring.html

E = EllipticCurve(GF(97), [1,3])
p = E.division_polynomial(3, two_torsion_multiplicity = 0)

A.<y> = PolynomialRing(GF(97))
B = A.quotient(p, 'y2')
C = PolynomialRing(B, 'x')
x=C.gen()
R = C.quotient(y**2 - x**3 - x - 3)
