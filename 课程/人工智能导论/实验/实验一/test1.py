import copy
import sys
import datetime

from pythonds.graphs import Graph, Vertex
from pythonds.basic import Queue

#----------------------------------------------------BFS----------------------------------------------------------------
def BFS(graph,start,end):
    start2 = datetime.datetime.now()
    print("-"*50+"BFS"+"-"*50)
    start.setDistance(0)
    start.setPred(None)
    vertQueue = Queue()
    vertQueue.enqueue(start)
    print("open".ljust(60," ")+"close")
    close_tmp = []
    open_tmp = []
    parents=dict()
    path=[str(end.id)]
    weight_all=0
    while (vertQueue.size() > 0):
        currentVert = vertQueue.dequeue()
        try:
            close_tmp.append(city_dic[currentVert.id])
        except:
            continue
        for nbr in currentVert.getConnections():
            if (nbr.getColor() == 'white'):
                nbr.setColor('gray')
                nbr.setDistance(currentVert.getDistance() + 1)
                nbr.setPred(currentVert)
                vertQueue.enqueue(nbr)
                try:
                    parents[str(nbr.id)]=str(currentVert.id)
                    open_tmp.append(city_dic[nbr.id])
                except:
                    break
        open_s=" ".join(open_tmp).ljust(60," ")
        close_s=" ".join(close_tmp)
        print(open_s+close_s)
        if (end.id == currentVert.id):
            key=str(end.id)
            while end.id!=start.id:
                try:
                    farther=parents[key]
                    path.append(farther)
                    key=farther
                except:
                    break
            path.reverse()
            end2 = datetime.datetime.now()
            print('时间代价为{0}微秒'.format((end2 - start2).microseconds))
            print("路径是：",end="")
            for i in range(len(path)-1):
                v1=graph.getVertex(int(path[i]))
                v2=graph.getVertex(int(path[i+1]))
                loss=v1.getWeight(v2)
                weight_all+=loss
                print(city_dic[int(path[i])]+"--({0})-->".format(loss),end="")
            for i in range(len(path)-1,len(path)):
                print(city_dic[int(path[i])])
            print("总路径代价为: {0}".format(weight_all))

            return
        try:
            del open_tmp[0]
        except:
            continue
        currentVert.setColor('black')


#----------------------------------------------------DFS----------------------------------------------------------------
parents = dict()
path=[]
open_tmp1 = []
close_tmp1 = []
num=1
m=''
def DFS(graph, start,end):
    global num
    global m
    global path
    global parents
    global start3
    start3 = datetime.datetime.now()

    path=[str(end.id)]
    open_tmp1.append(city_dic[start.id])
    open_s = " ".join(open_tmp1).ljust(40, " ")
    if num==1:
        print(open_s)
        m=open_tmp1.pop(0)
        close_tmp1.append(str(m))
        num = num + 1
    else:
        print(open_s,end='')
        close_s = " ".join(close_tmp1)
        print(close_s)
        i=open_tmp1.pop(0)
        close_tmp1.append(str(i))

    if start.id==end.id:
        num=num+1
        key = str(end.id)
        k=0
        while k<len(parents):
            try:
                farther = parents[key]
                path.append(farther)
                key = farther
                k=k+1
            except:
                break
        path.reverse()
        weight_all=0
        print("路径是：", end="")
        for i in range(len(path) - 1):
            v1 = graph.getVertex(int(path[i]))
            v2 = graph.getVertex(int(path[i + 1]))
            loss = v1.getWeight(v2)
            weight_all += loss
            print(city_dic[int(path[i])] + "--({0})-->".format(loss), end="")
        for i in range(len(path) - 1, len(path)):
            print(city_dic[int(path[i])])
        print("总路径代价为: {0}".format(weight_all))
        end3 = datetime.datetime.now()
        print('时间代价为{0}微秒'.format((end3 - start3).microseconds))
        exit()

    start.setColor('black')
    for aVertex in start.getConnections():
        if aVertex.getColor()=='white':
            parents[str(aVertex.id)] = str(start.id)
            DFS(graph,aVertex,end)

#----------------------------------------------------A*----------------------------------------------------------------
def A_(graph,start,end):
    start1 = datetime.datetime.now()
    print("-"*50+"A*"+"-"*50)
    start.setDistance(0)
    start.setPred(None)
    vertQueue = Queue()
    vertQueue.enqueue(start)
    print("open".ljust(60," ")+"close")
    close_tmp = []
    open_tmp=[]
    path=[start.id]
    num_t=0
    open_dic=dict()
    while (vertQueue.size() > 0):
        currentVert = vertQueue.dequeue()
        vertDic_tmp = dict()
        close_tmp.append(city_dic[currentVert.id])
        weight_all = 0
        for i in range(len(path) - 1):
            v1 = graph.getVertex(int(path[i]))
            v2 = graph.getVertex(int(path[i + 1]))
            loss = v1.getWeight(v2)
            weight_all += loss
        for nbr in currentVert.getConnections():
            if (nbr.getColor() == 'white'):
                x=copy.deepcopy(nbr)
                x.setColor('white')
                if num_t==1:
                    weight_all = 0
                    print("路径是：", end="")
                    for i in range(len(path) - 1):
                        v1 = graph.getVertex(int(path[i]))
                        v2 = graph.getVertex(int(path[i+1]))
                        loss = v1.getWeight(v2)
                        weight_all += loss
                        print(city_dic[int(path[i])] + "--({0})-->".format(loss), end="")
                    for i in range(len(path) - 1, len(path)):
                        print(city_dic[int(path[i])])
                    print("总路径代价为: {0}".format(weight_all))
                    end1 = datetime.datetime.now()
                    print('时间代价为{0}微秒'.format((end1 - start1).microseconds))
                    return 0
                if end.id==nbr.id:
                    num_t+=1
                g_n=weight_all
                nbr.setDistance(currentVert.getDistance() + 1)
                nbr.setPred(currentVert)
                h_n=g.getDistance(graph.getVertex(nbr.id),end)
                f_n=g_n+h_n
                vertDic_tmp[f_n]=nbr
        m=1
        s_t = ''
        for i in sorted(vertDic_tmp):
            open_tmp.append(city_dic[vertDic_tmp[i].id])
            if m==1:
                s_t=city_dic[vertDic_tmp[i].id]
                path.append(vertDic_tmp[i].id)
                vertQueue.enqueue(vertDic_tmp[i])
                m+=1
        for i in sorted(open_dic):
            print(i)
        currentVert.setColor('black')
        open_s=" ".join(open_tmp).ljust(60," ")
        print(open_s,end='')
        open_tmp.remove(s_t)
        close_s=" ".join(close_tmp)
        print(close_s)



#----------------------------------------------------数据处理------------------------------------------------------------
def get_key(val,my_dict):
    for key, value in my_dict.items():
         if val == value:
             return key
cityname=["Arad","Bucharest","Craiova","Drobeta","Eforie","Fagaras","Giurgiu",
                    "Hirsova","lasi","Lugoj","Mehadia","Neamt","Oradea","Pitesti","Rimnicu",
                    "Sibiu","Timisoara","Urziceni","Vaslui","Zerind"]

city_dic=dict(zip([i for i in range(len(cityname))],cityname))

get_key("Arad",city_dic)
g = Graph()
with open("城市信息/cityposi.txt",'r') as f:
        listOfLines=f.readlines()
        for i in range(len(listOfLines)):
            a=listOfLines[i].split()
            g.addVertex(i,int(a[1]),int(a[2]))
with open("城市信息/cityinfo.txt", 'r') as f:
    listOfLines = f.readlines()
    for i in range(len(listOfLines)):
        a = listOfLines[i].split()
        for j in range(1,(int(len(a)/2-1))+1):
            g.addEdge(get_key("{0}".format(a[0]), city_dic), get_key("{0}".format(a[2*j]), city_dic), int(a[2*j+1]))

if __name__ == '__main__':
    g1=copy.deepcopy(g)
    g2=copy.deepcopy(g1)


    A_(g2,g2.getVertex(get_key("Arad", city_dic)), g2.getVertex(get_key("Bucharest", city_dic)))



    BFS(g1,g1.getVertex(get_key("Arad",city_dic)),g1.getVertex(get_key("Bucharest",city_dic)))


    print("-"*50+"DFS"+"-"*50)
    print("open".ljust(60," ")+"close")
    DFS(g,g.getVertex(get_key("Arad",city_dic)),g.getVertex(get_key("Bucharest",city_dic)))
