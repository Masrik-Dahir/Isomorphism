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

def is_isomorphic_masrik(G,H):
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
