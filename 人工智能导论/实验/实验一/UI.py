from tkinter import *
from test1 import *
import copy
import sys
import datetime
from pythonds.graphs import Graph, Vertex

def run1():
    global g
    global start3
    a = str(inp1.get())
    b = str(inp2.get())
    n=var.get()
    if n==0:
        BFS(g, g.getVertex(get_key(a, city_dic)), g.getVertex(get_key(b, city_dic)))
        exit()
    if n==1:
        print("-" * 50 + "DFS" + "-" * 50)
        print("open".ljust(60, " ") + "close")
        DFS(g, g.getVertex(get_key(a, city_dic)), g.getVertex(get_key(b, city_dic)))
    if n==2:
        A_(g,g.getVertex(get_key(a,city_dic)),g.getVertex(get_key(b,city_dic)))
        exit()


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

root= Tk()

root.title('罗马尼亚独家导航')
root.geometry('600x300') # 这里的乘号不是 * ，而是小写英文字母 x
Label(root,text='请选择要使用的算法并输入出发地和目的地',font='华文新魏').pack()
inp1 = Entry(root)
inp1.place(relx=0.1, rely=0.2, relwidth=0.3, relheight=0.15)
inp2 = Entry(root)
inp2.place(relx=0.6, rely=0.2, relwidth=0.3, relheight=0.15)

var = IntVar()
rd1 = Radiobutton(root,text="BFS",variable=var,value=0)
rd1.pack()
rd2 = Radiobutton(root,text="DFS",variable=var,value=1)
rd2.pack()
rd3 = Radiobutton(root,text="A*",variable=var,value=2)
rd3.pack()

btn1 = Button(root, text='开始导航', command=run1)
btn1.place(relx=0.35, rely=0.4, relwidth=0.3, relheight=0.2)
root.mainloop()
