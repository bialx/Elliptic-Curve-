load("brute_force.sage")

#Time execution of brute force method to compute the set of point of an elliptic curve

def brute_force_graph(bound):
    time = [(p, cputime(brute_force(p, 2,1))) for p in prime_range(bound)]
    g = plot(line(time, legend_label ='brute force #E, with E : y^2 = x^3 + 2*x + 1 ', rgbcolor = 'red'))
    g.save("../rapport/pictures/brute_force_cputime.png")
    return
