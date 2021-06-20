def create_all_graphs(order):
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

def test_all_graphs(r):
    g = start(r)
    for i,j in g.items():
        for i_i, j_j in g.items():
            if (i != i_i):
                a = [round(i, 15) for i in (distance_matrix(j)*distance_matrix(j_j)*distance_matrix(j)).eigenvalues()]
                b = [round(i, 15) for i in (distance_matrix(j_j)*distance_matrix(j)*distance_matrix(j_j)).eigenvalues()]
                a.sort()
                b.sort()
                if (a == b):
                    return "corrupt"
    return "Works"
