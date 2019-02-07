load("brute_force.sage")
load("schoof.sage")

#Time execution of brute force method to compute the set of point of an elliptic curve

def brute_force_graph(bound):
    time = [(p, -cputime(brute_force(p, 2,1))) for p in prime_range(bound)]
    g = plot(line(time, legend_label ='brute force #E, with E : y^2 = x^3 + 2*x + 1 ', rgbcolor = 'red'))
    g.axes_labels([' prime p', 'time'])
    g.save("../rapport/pictures/brute_force_cputime.png")
    return

def schoof_graph(bound):
    time = []
    for p in prime_range(bound):
        try:
            E = EllipticCurve(GF(p), [2,1])
            print (p)
            time.append((p, cputime(schoof2(E))))
        except:
            continue

    g = plot(line(time, legend_label ='schoof #E, with E : y^2 = x^3 + 2*x + 1 ', rgbcolor = 'red'))
    g.axes_labels([' prime p', 'time'])
    g.save("../rapport/pictures/schoof_cputime.png")
    return

def brute_force_vs_schoof(bound):
    time2 = []
    time1 = [(p, -cputime(brute_force(p, 2,1))) for p in prime_range(bound)]
    print (time1)
    for p in prime_range(bound):
        try:
            E = EllipticCurve(GF(p), [2,1])
            time2.append((p, cputime(schoof2(E))))
        except:
            continue
    g1 = plot(line(time1, legend_label ='brute force', rgbcolor = 'red'))
    g2 = plot(line(time2, legend_label ='schoof', rgbcolor = 'blue'))
    g = g1 + g2
    g.axes_labels([' prime p', 'time'])
    g.save("../rapport/pictures/schoof_vs_bruteforce.png")
    return
