def reform(G):
    V = G.vertices()
    E = G.edges()
    
    d = []
    for v in V:
        G_copy = G.copy()
        G_copy.delete_vertices([v])
        V_copy = G.vertices()
        P = G_copy.copy()
        value = det(distance_matrix_special(G_copy))
        d.append(value)
        d.sort()
    return d

def remove_orphan(G):
    V_G = G.vertices()
    E_G = G.edges()
    
    lis =[]
    for v in V_G:
        if G.degree(v) == 0:
            lis.append(v)
    num = len(lis)
    G.delete_vertices(lis)
    return num

def is_isomorphic(G,H):
    G_ds = G.degree_sequence()
    H_ds = H.degree_sequence()
    G_ds.sort()
    H_ds.sort()
    
    if (G.order() != H.order() or G.size() != H.size() or G_ds != H_ds):
        return False
    
    G_copy = G.copy()
    H_copy = H.copy()
    
    G_num = remove_orphan(G_copy)
    H_num = remove_orphan(H_copy)
    
    G_ins = (distance_matrix(G_copy)*distance_matrix(H_copy)*distance_matrix(G_copy).transpose()*degree_matrix(G_copy)).eigenvalues()
    H_ins = (distance_matrix(H_copy)*distance_matrix(G_copy)*distance_matrix(H_copy).transpose()*degree_matrix(H_copy)).eigenvalues()
    G_ins.sort()
    H_ins.sort()
    
    if (G_ins == H_ins and G_num == H_num):
        return True
    return False

# Helper graphs
# Masrik's degree matrix
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
def k_regualr_graph(order):
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
            count = 0
        except ValueError:
            print("There is no {}-regular graph with Order {}.".format(t,order))
    return graph

# testting if all k-regular graph are isomorphic or not using my properties for order n
def test_k_regualr_graph(r):
    g = k_regualr_graph(r)
    for i,j in g.items():
        for i_i, j_j in g.items():
            if (i > i_i):
                a = (distance_matrix(j)*distance_matrix(j_j)*distance_matrix(j)).eigenvalues()
                b = (distance_matrix(j_j)*distance_matrix(j)*distance_matrix(j_j)).eigenvalues()
                a.sort()
                b.sort()
                if (a == b):
                    return "corrupt"
    return "Works"

# What if we have to include the degree matrix to make out hypothesis a success!
# testting if all graph are isomorphic or not using my properties for order n
#generate all non-isomorphic connect graphs with order n
def test_all_graph(ord):
    count = 0
    dictionary = {}
    lis = []

    for g in graphs.nauty_geng("%d -c" %(ord)):
        dictionary[str(g.graph6_string())] = g
        count = count +1
    print("There are a total of %d connected graphs" %(count))

    for i, j in dictionary.items():
        for i_i, j_j in dictionary.items():
            if (i > i_i):
                a = (distance_matrix(j)*distance_matrix(j_j)*distance_matrix(j)*degree_matrix(j)).eigenvalues()
                b = (distance_matrix(j_j)*distance_matrix(j)*distance_matrix(j_j)*degree_matrix(j_j)).eigenvalues()
                a.sort()
                b.sort()
                if (a == b):
                    return "corrupt"
    return "works"