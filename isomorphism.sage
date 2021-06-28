# Helper graphs
# Masrik's degree matrix
import time

def degree_matrix(G):
    a = []
    length = len(G.vertices())
    n = 0
    for i in G.vertices():
        b = []
        for j in range(0,length):
            b.append(0)
        b[n] = G.degree(i)
        a.append(b)

        n += 1

    M = matrix(ZZ,a)
    return M

# Masrik's distance Matrix
def distance_matrix(G):
    V = G.vertices()
    E = G.vertices()
    length = len(V)
    dict = G.distance_all_pairs()

    dic = {}
    n = 0
    for v in G.vertices(sort=True):
        dic[v] = n
        n += 1

    a = []
    for i, j in dict.items():
        b = []
        for k in range(0,G.order()):
            b.append(0)
        for j_1, j_2 in j.items():
            b[dic[j_1]] = j_2
        a.append(b)

    M = matrix(ZZ,a)
    return M

# Masrik's is_isomorphic()
def is_isomorphic(G,H):

    G_copy = G.copy()
    H_copy = H.copy()


    G_ins = (distance_matrix(G_copy)*distance_matrix(H_copy)*distance_matrix(G_copy).transpose()*degree_matrix(G_copy)).eigenvalues()
    H_ins = (distance_matrix(H_copy)*distance_matrix(G_copy)*distance_matrix(H_copy).transpose()*degree_matrix(H_copy)).eigenvalues()
    G_ins.sort()
    H_ins.sort()

    if (G_ins == H_ins):
        return True
    return False

#generate all non-isomorphic connect graphs with order n
def engine(ord):
    count = 0
    dictionary = {}
    lis = []

    for g in graphs.nauty_geng("%d -c" %(ord)):
        dictionary[str(g.graph6_string())] = g
        count = count +1
    print("There are a total of %d connected graphs" %(count))

    for i, j in dictionary.items():
        for m, n in dictionary.items():
            if m != i:
                if is_isomorphic(j,n):
                    print(i)
                    print(m)
                    return "Error"
    return "works"

# Takes any order and generate all k-regular graph possible
def k_regular_graph(order,my_file=None):
    count = 0
    graph = {}
    dis_sp_list = []
    dis_sp_dict = {}
    range = order-1
    for t in [1..range]:
        try:
            for g in graphs.nauty_geng("%d -d%d -D%d" %(order,t,t)):
                count += 1
                g6 = g.graph6_string()
                graph[g6] = g
            print("the total number of graphs for {}-regular order {} is {}".format(t,order,count))
            try:
                my_file.write("the total number of graphs for {}-regular order {} is {}\n".format(t,order,count))
            except:
                None
            count = 0
        except ValueError:
            try:
                my_file.write("the total number of graphs for {}-regular order {} is {}\n".format(t,order,count))
            except:
                None
            print("There is no {}-regular graph with Order {}.".format(t,order))
    return graph

# testting if all k-regular graph are isomorphic or not using my properties for order n
def test_k_regular_graph(r, save=False):
    my_file = None
    if (save == True):
        name = str(time.time()).replace(".","")
        my_file = open("test_k_regualr_graph("+str(r)+") "+name + ".txt", "w")
        my_file.write("Tested: test_k_regualr_graph("+str(r)+")\n")

    g = k_regular_graph(r,my_file)
    for i,j in g.items():
        for i_i, j_j in g.items():
            if (i > i_i):
                a = (distance_matrix(j)*distance_matrix(j_j)*distance_matrix(j)).eigenvalues()
                b = (distance_matrix(j_j)*distance_matrix(j)*distance_matrix(j_j)).eigenvalues()
                a.sort()
                b.sort()
                if (a == b):
                    try:
                        my_file.write("Corrupt\n")
                        my_file.write("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                    except:
                        None
                    print("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                    return "corrupt" + "\nTwo graphs found:\n"+str(i)+"\n\n"+str(i_i)
    try:
        my_file.write("Works")
    except:
        None
    return "Works"

# What if we have to include the degree matrix to make out hypothesis a success!
# testting if all graph are isomorphic or not using my properties for order n
#generate all non-isomorphic connect graphs with order n
def test_all_graph(ord,save = False):
    if (save == True):
        name = str(time.time()).replace(".","")
        my_file = open("test_all_graph("+str(ord)+") "+name + ".txt", "w")
        my_file.write("Tested: test_all_graph("+str(ord)+")\n")

    count = 0
    dictionary = {}
    lis = []

    for g in graphs.nauty_geng("%d -c" %(ord)):
        dictionary[str(g.graph6_string())] = g
        count = count +1
    print("There are a total of %d connected graphs" %(count))
    try:
        my_file.write("There are a total of %d connected graphs\n" %(count))
    except:
        None

    for i, j in dictionary.items():
        for i_i, j_j in dictionary.items():
            if (i > i_i):
                a = (distance_matrix(j)*distance_matrix(j_j)*distance_matrix(j)*degree_matrix(j)).eigenvalues()
                b = (distance_matrix(j_j)*distance_matrix(j)*distance_matrix(j_j)*degree_matrix(j_j)).eigenvalues()
                a.sort()
                b.sort()
                if (a == b):
                    try:
                        my_file.write("Corrupt\n")
                        my_file.write("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                    except:
                        None
                    print("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                    return "corrupt" + "\nTwo graphs found:\n"+str(i)+"\n\n"+str(i_i)
    try:
        my_file.write("Works")
    except:
        None
    return "works"

# Let's try with adjacency matrix
def test_all_graph_adj(ord,save=False):
    if (save == True):
        name = str(time.time()).replace(".","")
        my_file = open("test_all_graph_adj("+str(ord)+") " + name + ".txt", "w")
        my_file.write("Tested: test_all_graph_adj("+str(ord)+")\n")
    count = 0
    dictionary = {}
    lis = []

    for g in graphs.nauty_geng("%d -c" %(ord)):
        dictionary[str(g.graph6_string())] = g
        count = count +1
    print("There are a total of %d connected graphs" %(count))
    try:
        my_file.write("There are a total of %d connected graphs\n" %(count))
    except:
        None

    for i, j in dictionary.items():
        for i_i, j_j in dictionary.items():
            if (i > i_i):
                a = (j.adjacency_matrix()*j_j.adjacency_matrix()*j.adjacency_matrix()*degree_matrix(j)).eigenvalues()
                b = (j_j.adjacency_matrix()*j.adjacency_matrix()*j_j.adjacency_matrix()*degree_matrix(j_j)).eigenvalues()
                a.sort()
                b.sort()
                if (a == b):
                    try:
                        my_file.write("Corrupt\n")
                        my_file.write("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                    except:
                        None
                    print("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                    return "corrupt" + "\nTwo graphs found:\n"+str(i)+"\n\n"+str(i_i)
    try:
        my_file.write("Works")
    except:
        None
    return "works"

def test_k_regular_graph_adj(r,save = False):
    my_file = None
    if (save == True):
        name = str(time.time()).replace(".","")
        my_file = open("Tested: test_k_regualr_graph_adj("+str(r)+") "+name + ".txt", "w")
        my_file.write("Tested: test_k_regualr_graph_adj("+str(r)+")\n")
    
    g = k_regular_graph(r,my_file)
        
    for i,j in g.items():
        for i_i, j_j in g.items():
            if (i > i_i):
                a = (j.adjacency_matrix()*j_j.adjacency_matrix()*j.adjacency_matrix()*degree_matrix(j)).eigenvalues()
                b = (j_j.adjacency_matrix()*j.adjacency_matrix()*j_j.adjacency_matrix()*degree_matrix(j_j)).eigenvalues()
                a.sort()
                b.sort()
                try:
                    my_file.write("Corrupt\n")
                    my_file.write("Two graphs found:\n"+str(i)+"\n\n"+str(i_i))
                except:
                    None
                return "corrupt" + "\nTwo graphs found:\n"+str(i)+"\n\n"+str(i_i)
    try:
        my_file.write("Works")
    except:
        None
    return "Works"
