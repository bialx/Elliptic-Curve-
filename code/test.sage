load("division_polynomial.sage")
load("schoof.sage")
load("brute_force.sage")
load("EC_basic_computation.sage")
#http://www.math.sciences.univ-nantes.fr/~sorger/chow/html/en/reference/polynomial_rings/sage/rings/polynomial/polynomial_quotient_ring.html
#
# E = EllipticCurve(GF(97), [1,3])
# p = E.division_polynomial(3, two_torsion_multiplicity = 0)
#
# A.<y> = PolynomialRing(GF(97))
# B = A.quotient(p, 'y2')
# C = PolynomialRing(B, 'x')
# x=C.gen()
# R = C.quotient(y**2 - x**3 - x - 3)



def test_brute_force(nbr_test):
    error = O
    i = 0
    while i < nbr_test:
        i += 1
        p = random_prime(5000, False, 11)
        a,b = randint(3, p-1), randint(3,p-1)
        try :
            E = EllipticCurve(GF(p), [a,b])
        except ArithmeticError as e:
            print(e, f"with parameters : a,b,p = {a}, {b}, {p}")
            continue
        error = E.cardinality() - brute_force(p,a,b)
    if error == 0:
        return (f"succes over {nbr_test} tests")
    else:
        return(f"error over {nbr_test} tests")


#We compare our fonction with the buil in sage function E.division_polynomial to check if our induction relation for polynomial division is correct
def test_right_polynomial():
    nbr_test = 0
    error = 0
    l = 50
    while nbr_test < 100:
        param = (random_prime(5,500), randint(4,10), randint(4,10))
        p, a, b = param
        try :
            E = EllipticCurve(GF(p), [a,b])
        except ArithmeticError as e:
            print(e, f"with parameters : a,b,p = {a}, {b}, {p}")
            continue
        polynome = division_polynomial(p, a, b, l)

        for cle, valeur in polynome.items():
            if cle == -1 or cle == 0:
                continue
            else:
                error = valeur - E.division_polynomial(cle, two_torsion_multiplicity = 0)
            nbr_test += 1
    if error == 0:
        print(f"test is correct, we construct the same {l} first division polynomial as sage !")

def nP_classical(nbr_test):
    error = 0
    i = 0
    while i < nbr_test:
        i += 1
        param = (random_prime(5,500), randint(4,10), randint(4,10))
        p, a, b = param
        try :
            E = EllipticCurve(GF(p), [a,b])
        except ArithmeticError as e:
            print(e, f"with parameters : a,b,p = {a}, {b}, {p}")
            continue
        R.<x> = PolynomialRing(GF(p))
        for point in E:
            if list(point) == [0, 1, 0]:
                pass
            P = list(point)[:-1]
            n = randint(2, p)
            error = error + list(n*point)[:-1] - nP_double_and_add(n,P,a)
        if error == 0:
            return "succes"
        else:
            return "failure"
