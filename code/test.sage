load("division_polynomial.sage")
load("schoof.sage")
load("brute_force.sage")
load("EC_basic_computation.sage")

nbr_test = 500

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
        return ("succes")
    else:
        return("failure")


#We compare our fonction with the buil in sage function E.division_polynomial to check if our induction relation for polynomial division is correct
def test_right_polynomial(nbr_test):
    i = 0
    error = 0
    l = 50
    while i < nbr_test:
        i += 1
        param = (random_prime(5,500), randint(4,10), randint(4,10))
        p, a, b = param
        try :
            E = EllipticCurve(GF(p), [a,b])
        except ArithmeticError as e:
            print(e)
            continue
        polynome = division_polynomial(p, a, b, l)

        for cle, valeur in polynome.items():
            if cle == -1 or cle == 0:
                continue
            else:
                error = valeur - E.division_polynomial(cle, two_torsion_multiplicity = 0)
                i += 1
    if error == 0:
        print("test is correct, we construct the same division polynomial as sage !")



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
            print(e)
            continue
        R.<x> = PolynomialRing(GF(p))
        for point in E:
            if list(point) == [0, 1, 0]:
                continue
            if list(point)[1] == 0:
                continue
            P = list(point)[:-1]
            n = randint(2, p)
            if list(ZZ(n)*point)[:-1] != list(nP_double_and_add(ZZ(n),P,a)):
                error = 1
                break
        if error == 0:
            return ("succes")
        else:
            return ("failure")
