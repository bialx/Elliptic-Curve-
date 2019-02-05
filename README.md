# Elliptic-Curve-

TER master 2 sur le sujet suivant : compter les points sur une courbe elliptique.

Rapport -> Le rapport pour le projet 

Code -> l'ensemble des codes, fonctions utilisés lors de notre étude

Partie Code : 

    schoof.sage -> contient le code de l'algorithme de schoof (currently using basing operation to compute scalar multiplication, not using division polynomial yet)
    
    division_polynomial.sage -> contient un ensemble de fonctions permettant de calculer les polynomes de division
                                d'une courbe ellitpique et de calculer les coordonnées de nP en focntion de ces polynomes
    
    EC_basic_computation -> function to add, multiply, negate point on elliptic curve
    
    brute_force.sage -> brute force to count points on an elliptic curve
    
    test.sage -> contient un ensemble de test permettant de vérifier la validité des fonctions écrites
    
    graphic.sage -> graphics used to illustrate how efficient our method are (or how unefficient)


Warning : if you are using python 3.X when running Sage you may end up facing error because some sage method arent fully implemented in python3. Better to switch to python 2.7 to avoid any error
