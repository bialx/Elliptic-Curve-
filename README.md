# Elliptic-Curve-

TER master 2 sur le sujet suivant : compter les points sur une courbe elliptique.

Rapport -> Le rapport pour le projet 

Code -> l'ensemble des codes, fonctions utilisés lors de notre étude

Partie Code : 

    schoof.sage -> schoof's algoritmh (currently using basing operation to compute scalar multiplication, not using division polynomial yet)
    
    division_polynomial.sage -> function to compute division polynomial of an elliptic curve and scalar multplication nP using this polynomial
    
    EC_basic_computation -> function to add, multiply, negate point on elliptic curve
    
    brute_force.sage -> brute force to count points on an elliptic curve
    
    test.sage -> set of test to check if our functions are correct
    
    graphic.sage -> graphics used to illustrate how efficient our method are (or how unefficient)


Warning : if you are using python 3.X when running Sage you may end up facing errors because some sage methods arent fully implemented in python3. Better to switch to python 2.7 to avoid any errors
