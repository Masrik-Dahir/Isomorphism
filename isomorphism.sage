# Helper graphs
# Masrik's degree matrix
import os
import csv

def sqare_matrix(G):
    G_M = G.incidence_matrix()
    G_rows = G_M.nrows()
    G_cols = G_M.ncols()

    H_rows = H_M.nrows()
    H_cols = H_M.ncols()


    a = []
    continu = True
    G_M_2 = []
    for i in G_M.rows():
        a.append(list(i))

    if (G_rows < G_cols):
        diff = G_cols - G_rows

        while (continu):
            t = []
            for i in range(0,G_cols):
                t.append(1)
            a.append(t)
            G_M_2 = matrix(ZZ,a)
            if (G_M_2.nrows() == G_M_2.ncols()):
                continu = False
    elif (G_rows > G_cols):
        diff = G_rows - G_cols

        while (continu):
            t = []
            for j in a:
                for i in range(0,diff):
                    j.append(1)

            G_M_2 = matrix(ZZ,a)
            if (G_M_2.nrows() == G_M_2.ncols()):
                continu = False
    return G_M_2

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
        my_file = open("Text_data/k_regular_graph(Order {}).txt".format(int(order)), "w")
        my_file.write("k_regular_graph(Order {})\n".format(int(order)))

#       Excel
        final_directory = os.path.join(current_directory, r'Excel_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        name = "Excel_data/k_regular_graph(Order {})".format(int(order)) + '.csv'

    count = 0
    graph = []
    dis_sp_list = []
    dis_sp_dict = {}
    lis = []
    range = order-1
    graph.append(["Graph String Name", "Masrik Form of adjacency matrix"])
    for t in [1..range]:
        try:

            for g in graphs.nauty_geng("{} -d{} -D{}".format(order,t,t)):
                count += 1
                g6 = g.graph6_string()
                graph.append([g6, reform(g)])
                lis.append(reform(g))
            print("the total number of {}-regular graph for order {} is {}".format(t,order,count))
            text += "the total number of {}-regular graphs for order {} is {}\n".format(t,order,count)
            count = 0
        except ValueError:
            text += "There is no {}-regular graph for Order {}.\n".format(t,order)
            print("There is no {}-regular graph for Order {}.".format(t,order))
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
        my_file = open("Text_data/all_graph(Order {}).txt".format(int(ord)), "w")
        my_file.write("all_graph(Order {})\n".format(int(ord)))

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
    for g in graphs.nauty_geng("{} -c".format(ord)):
        dictionary.append([g.graph6_string(), reform(g)])


        count = count +1
        lis.append(reform(g))
    print("There are {} connected graphs for order {}\n".format(count, ord))
    if (_type == "dict"):
        try:
#           Editing Test
            my_file.write("There are {} connected graphs for order {}\n".format(count, ord))

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
            my_file.write("There are {} connected graphs for order {}\n".format(count, ord))
            my_file.close()
        except:
            None
        return lis
    else:
        return "Either pick \"dict\" for dictionary or \"list\" for list"

def fullerenes(n,ipr_f=True, save = True, close = True):
    my_file = None
    name = None
    current_directory = os.getcwd()
    if (save == True):
#       Text
        final_directory = os.path.join(current_directory, r'Text_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        my_file = open("Text_data/fullerenes(Order {}).txt".format(int(n)), "w")
        my_file.write("fullerenes(Order {})\n".format(int(n)))

#       Excel
        final_directory = os.path.join(current_directory, r'Excel_data')
        if not os.path.exists(final_directory):
            os.makedirs(final_directory)
        name = 'Excel_data/' + str("fullerenes(Order ") + str(n) + ")" + '.csv'

    count = 0
    dic = []
    for g in graphs.fullerenes(n, ipr = ipr_f): #generate only fullerenes with isolted pentagons
        dic.append([g.graph6_string(), reform(g)])
        count += 1
    news = "There are {} fullerenes graphs with {} pantagons\n".format(count,"isolated" if ipr_f == True else "isolated and nonisolated")
    print(news)
    try:
        my_file.write(news)
        if close:
            my_file.close()

        with open(name, 'w', newline='') as file:
                writer = csv.writer(file)
                writer.writerows(dic)
    except:
        None
    dic_f = {}
    for i in dic:
        dic_f[i[0]] = i[1]
    return dic_f

# Confirming if a list has any duplicate values
def is_duplicate(order, lis):
    res = []
    pes = []
    if (isinstance(lis, list)):
        for i in lis:
            if i not in res:
                res.append(i)
            else:
                return "Duplicates Exist"
    elif (isinstance(lis, dict)):
        for i,j in lis.items():
            if j not in res:
                res.append(j)
                pes.append(i)
            else:
                if j in res:
                    ind = res.index(j)
                    other = pes[ind]
                return "Duplicates Exist for order {}-\n{} \n{}".format(order,i, other)


    return "No Duplicates for order {}".format(order)

def test_all_graph(order):
    name = "Text_data/all_graph(Order {}).txt".format(order)
    text = is_duplicate(order, all_graph(order))
    my_file = open("Text_data/all_graph(Order {}).txt".format(order), "a")
    with my_file as f:
        f.write(text)
    return text

def test_k_regular_graph(order):
    name = "Text_data/all_graph(Order {}).txt".format(order)
    text = is_duplicate(order, k_regular_graph(order))
    my_file = open("Text_data/k_regular_graph(Order {}).txt".format(order), "a")
    with my_file as f:
        f.write(text)
    return text

def test_fullerenes_graph(order):
    name = "Text_data/fullerenes(Order {}).txt".format(order)
    text = is_duplicate(order, fullerenes(order))
    my_file = open("Text_data/fullerenes(Order {}).txt".format(order), "a")
    with my_file as f:
        f.write(text)
    return text



def switch(adj,a,b):
    res = []
    M = None
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

def think_and_switch(adj,a,b):
    higher_num = (a if a > b else b) -1
    lower_num = (b if a > b else a) -1

    if (list(adj[higher_num]).count(1) > list(adj[lower_num]).count(1)):
        if (adj.nrows() >= a and adj.nrows() >= b):
            new_list = []
            res = []


            higher_num_list = list(adj[higher_num])
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
    else:
        return adj

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
        return "Invalid rows number for the second second parameter. The dimension of the matrix is {}x{}".format(adj.nrows(),adj.ncols())
    elif adj.nrows() < b or b < 1:
        return "Invalid rows number for the third second parameter. The dimension of the matrix is {}x{}".format(adj.nrows(),adj.ncols())
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
def reform(G):
    V = 0
    adj = None
    if _type(G) == "Graph":
        V = G.order()
        adj = G.adjacency_matrix()
    elif _type(G) == "Matrix":
        adj = G
        V = adj.nrows()

    switched_adj = adj

    for j in range(1,V+1):
        for i in range(j,V+1):
            switched_adj = think_and_switch(switched_adj, i,j)
    return switched_adj

def delete(adj):
    a = []
    for i in adj:
        b = list(i)
        b.pop(0)
        a.append(b)
    a.pop(0)
    M = matrix(ZZ,a)
    return M





def sort(G,n=1):
    V = 0
    adj = None
    if _type(G) == "Graph":
        V = G.order()
        adj = G.adjacency_matrix()
    elif _type(G) == "Matrix":
        adj = G
        V = adj.nrows()


    h_count = 0
    h_count_pos = 0
    h_count_dict = {}
    h_pos_list = []

    for i in range(0,adj.nrows()):
        count = list(adj[i]).count(1)
        h_count_dict[i] = count

        if count > h_count:
            h_count = count
            h_count_pos = i
    sorted_dic = {k: v for k, v in sorted(h_count_dict.items(), key=lambda x: x[1], reverse=True)}
#     print()
#     print(sorted_dic[h_count_pos+1])
    h_pos_list = list(sorted_dic.keys())
    adj_switched = switch(adj,n,h_pos_list[n-1]+1)

#     print(sorted_dic)
#     print(sorted_dic[h_pos_list[n-1]]+1)
    for i in range(n,sorted_dic[h_pos_list[n-1]]+1):
        if adj_switched[n-1][i] == 0:
            for j in range(n,adj.nrows()+1):
#                 print(V-j)
#                 print(adj_switched[0][V-j])
                if adj_switched[n-1][adj.nrows()-j] == 1:
#                     print(str(i)+" "+str(V-j))
                    adj_switched = switch(adj_switched,i+1,adj.nrows()-j+1)
                    break
#     , adj_switched[0]
    return adj_switched

def _type(a):
    return(str(type(a)).replace("<class 'sage.graphs.graph.","").replace("'>","").replace("<class 'sage.matrix.matrix_integer_dense.","").replace("_integer_dense",""))