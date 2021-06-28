# Masrik's is_isomorphic()
load("isomorphism.sage")

# testing fullerenes with masrik's is_isomorphic function
def fullerenes(n,ipr_f=True):
    count = 0
    dic = {}
    for g in graphs.fullerenes(n, ipr = ipr_f): #generate only fullerenes with isolted pentagons
        dic[g.graph6_string()] = g
        count += 1
    print("There are a total of %d fullerenes graphs with %s pantagons" %(count,"isolated" if ipr_f == True else "isolated and nonisolated"))
    return dic

def test_fullerenes(n,ipr_f=True,save=False):
    if (save == True):
        name = str(time.time()).replace(".","")
        my_file = open("test_fullerenes("+str(n)+", "+str(ipr_f)+") " +name + ".txt", "w")
        my_file.write("test_fullerenes("+str(n)+", "+str(ipr_f)+")\n")

    g = fullerenes(n,ipr_f)
    for i,j in g.items():
        for i_i, j_j in g.items():
            if (i > i_i):
                if(is_isomorphic(i,i_i)):
                    if(not i.is_isomorphic(i_i)):
                        try:
                            my_file.write("Corrupt\n")
                            my_file.write("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                        except:
                            None
                        print("The corrupt graphs:\n"+str(i)+"\n\n"+str(i_i)+"\n")
                        return "Corrupt"

    try:
        my_file.write("Works\n")
    except:
        None
    return "Works"









