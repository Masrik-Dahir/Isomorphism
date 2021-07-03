# Helper graphs
# Masrik's degree matrix
import os
import csv

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

def adj_to_graph(gr):
    rows_num = 0
    G = Graph(gr.nrows())
    for i in gr:
        rows = list(i)
        for j in range(0,len(rows)):
            if (rows_num != j and rows[j] == 1):
                G.add_edge(rows_num,j)
        rows_num += 1

    return G

def switch(adj,a,b):
    if (adj.nrows() >= a and adj.nrows() >= b):
        new_list = []
        res = []

        higher_num = (a if a > b else b) -1
        higher_num_list = list(adj[higher_num])

        lower_num = (b if a > b else a) -1
        lower_num_list = list(adj[lower_num])

        for i in range (0, adj.nrows()):
            rows = list(adj[i])
            if i == lower_num:
                new_list.append(higher_num_list)
            elif i == higher_num:
                new_list.append(lower_num_list)
            else:
                new_list.append(rows)

        for rows in new_list:
            lower_list = []
            for j in range(0,len(rows)):
                if j == lower_num:
                    lower_list.append(rows[higher_num])

                elif j == higher_num:
                    lower_list.append(rows[lower_num])
                else:
                    lower_list.append(rows[j])

            res.append(lower_list)

        M = matrix(ZZ,res)
    return M

def compare(adj,a,b):
    if (adj.nrows() >= a and adj.nrows() >= b and a >= 1 and b >= 1):
        lower_num = (b if a>b else a) -1
        lower_num_list = list(adj[lower_num])

        higher_num = (a if a>b else b) -1
        higher_num_list = list(adj[higher_num])
        higher_num_list_updated = []


        for i in range(0, len(higher_num_list)):
            if i == higher_num:
                higher_num_list_updated.append(higher_num_list[lower_num])
            elif i == lower_num:
                higher_num_list_updated.append(higher_num_list[higher_num])
            else:
                higher_num_list_updated.append(higher_num_list[i])

        single_higher_num = int(''.join(map(str,higher_num_list_updated)))
        single_lower_num = int(''.join(map(str,lower_num_list)))

        if (single_higher_num > single_lower_num):
            return True
        else:
            return False

    elif adj.nrows() < a or a < 1:
        return "Invalid rows number for the second second parameter. The dimension of the matrix is %dx%d" %(adj.nrows(),adj.ncols())
    elif adj.nrows() < b or b < 1:
        return "Invalid rows number for the third second parameter. The dimension of the matrix is %dx%d" %(adj.nrows(),adj.ncols())


def reform(G):
    V = G.order()
    adj = G.adjacency_matrix()

    for i in range(1,V+1):
        for j in range(1,V+1):
            if compare(adj, j,i):
                adj = switch(adj, j,i)
            else:
                None
    return adj

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

def to_subgraph(G_copy):
    from sage.graphs.connectivity import connected_components_subgraphs
    remove_orphan(G_copy)
    L = connected_components_subgraphs(G_copy)
    lis = graphs_list.to_graph6(L).split("\n")
    for i in lis:
        if str(i) == "":
            lis.remove(i)
    graphs = []
    for i in lis:
        graphs.append(Graph(i))

    return graphs

def __isomorphic__(G,H):
    G_copy = G.copy()
    H_copy = H.copy()

    if (G.order() != H.order() or G.size() != H.size() or G.degree_sequence() != H.degree_sequence() or
       G.is_directed() != H.is_directed()):
        return False

    if ((G.order()*(G.order()-1))/2 == G.size()):
        return True

    G_num = remove_orphan(G_copy)
    H_num = remove_orphan(H_copy)

    if (G_num != H_num):
        return False

    else:

        G_subgraphs = to_subgraph(G_copy)
        H_subgraphs = to_subgraph(H_copy)

        G_adj_list = []
        H_adj_list = []

        for i in G_subgraphs:
            G_adj_list.append(reform(i))

        for i in H_subgraphs:
            H_adj_list.append(reform(i))

        res = []
        for i in G_adj_list:
            if i in H_adj_list:
                res.append(i)
                H_adj_list.remove(i)


        if G_adj_list == res and len(H_adj_list) == 0:
            return True
    return False


# Takes any order and generate all k-regular graph possible
def k_regular_graph(order, _type = "dict", save=True):

    my_file = None
    name = None
    current_directory = os.getcwd()
    text = ""

    if (save == True):
#       Text
        final_directory = os.path.join(current_directory, r'Text_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        my_file = open("Text_data/k_regular_graph(Order %d).txt" %(int(order)), "w")
        my_file.write("k_regular_graph(Order %d)\n" %(int(order)))

#       Excel
        final_directory = os.path.join(current_directory, r'Excel_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        name = "Excel_data/k_regular_graph(Order %d)" %(int(order)) + '.csv'

    count = 0
    graph = []
    dis_sp_list = []
    dis_sp_dict = {}
    lis = []
    range = order-1
    graph.append(["Graph String Name", "Masrik Form of adjacency matrix"])
    for t in [1..range]:
        try:

            for g in graphs.nauty_geng("%d -d%d -D%d" %(order,t,t)):
                count += 1
                g6 = g.graph6_string()
                graph.append([g6, reform(g)])
                lis.append(reform(g))
            print("the total number of graphs for {}-regular order {} is {}".format(t,order,count))
            text += "the total number of graphs for {}-regular order {} is {}\n".format(t,order,count)
            count = 0
        except ValueError:
            text += "There is no {}-regular graph with Order {}.\n".format(t,order)
            print("There is no {}-regular graph with Order {}.".format(t,order))
    try:
#       Editing Text
        my_file.write(text)
        my_file.close()
#       Editing Excel
        with open(name, 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerows(graph)
    except:
        None
    if _type == "dict":
        dictionary_f = {}
        for i in graph:
            dictionary_f[i[0]] = i[1]
        return dictionary_f
    elif _type == "list":
        return lis
    else:
        return "Either pick \"dict\" for dictionary or \"list\" for list"



# Finding all_graph for order n
def all_graph(ord, _type = "dict", save = True):
    my_file = None
    name = None
    current_directory = os.getcwd()
    if (save == True):
#       Text
        final_directory = os.path.join(current_directory, r'Text_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        my_file = open("Text_data/all_graph(Order %d).txt" %(int(ord)), "w")
        my_file.write("all_graph(Order %d)\n" %(int(ord)))

#       Excel
        final_directory = os.path.join(current_directory, r'Excel_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        name = 'Excel_data/' + str("all_graph(Order ") + str(ord) + ")" + '.csv'

    count = 0
    dictionary = []
    dictionary_f = {}
    lis = []



    dictionary.append(["Graph String Name", "Masrik Form of Adjacency Matrix"])
    for g in graphs.nauty_geng("%d -c" %(ord)):
        dictionary.append([g.graph6_string(), reform(g)])


        count = count +1
        lis.append(reform(g))
    print("There are a total of %d connected graphs for order %d\n" %(count, ord))
    if (_type == "dict"):
        try:
#           Editing Test
            my_file.write("There are a total of %d connected graphs for order %d\n" %(count, ord))

#           Editing Excel
            with open(name, 'w', newline='') as file:
                writer = csv.writer(file)
                writer.writerows(dictionary)
        except:
            None
        for i in dictionary:
            dictionary_f[i[0]] = i[1]
        return dictionary_f
    elif (_type == "list"):
        try:
            my_file.write("There are a total of %d connected graphs for order %d\n" %(count, ord))
            my_file.close()
        except:
            None
        return lis
    else:
        return "Either pick \"dict\" for dictionary or \"list\" for list"


# Confirming if a list has any duplicate values
def is_duplicate(lis):
    res = []
    pes = []
    order = -1
    if (isinstance(lis, list)):
        order = lis[0].nrows()
        for i in lis:
            if i not in res:
                res.append(i)
            else:
                return "Duplicates Exist"
    elif (isinstance(lis, dict)):
        r = lis[list(lis.keys())[1]].nrows()

        for i,j in lis.items():
            if j not in res:
                res.append(j)
                pes.append(i)
            else:
                if j in res:
                    ind = res.index(j)
                    other = pes[ind]
                return "Duplicates Exist for order %d-\n%s \n%s" %(r,i, other)


    return "No Duplicates for order %d" %(r)

