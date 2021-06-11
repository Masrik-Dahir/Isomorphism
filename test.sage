def duplicate(G):
    res_G = {}
    dup_dict = {}
    dup_dict_next = {}
    dup_list = []
    n = 0
    index = 0
    if (str(type(G)).replace('class','').replace('<','').replace('>','').replace('\'','').strip() == 'dict'):
        for i, j in G.items():
            index += 1
            a = list(j[0])
            a.sort()
            dup_list.append(a)
            dup_dict[i] = a,j[1]
            
        for i in dup_list:
            count = 0
            res = []
            res_g = None
            for key, value in G.items():
                if i in value:
                    count += 1
                    res.append(key)
                    res_g = len(res)
            dup_dict_next[str(res)] = res_g

    return dup_dict_next

def start(order):
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
            for i,j in graph.items():
                distance_eigen = list(distance_matrix(j).eigenvalues())
                distance_eigen.sort()
                dis_sp_list.append(distance_eigen)
                dis_sp_dict[i] = [round(num, 15) for num in distance_eigen], j
            res = []
            for i in dis_sp_list:
                if j not in res:
                    res.append(i)
                else:
                    print("corrupted!")
                    return None
            print("the total number of graphs for {}-regular order {} is {}".format(t,order,count))
            count = 0
        except ValueError:
            print("There is no {}-regular graph with Order {}.".format(t,order))
    return dis_sp_dict
