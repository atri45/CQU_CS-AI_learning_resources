//java 泛型实现单链表的基本操作　　
public class LinkedList<T> {
    private Node<T> head;
    private Node<T> tail;
    public LinkedList(){
        head = tail=null;
    }
    public static class Node<T>{
        T data;
        Node<T> next;
//        中间节点
        Node(T data,Node<T> next){
            this.data=data;
            this.next=next;
        }
//        尾节点
        Node(T data){
            this.data=data;
            this.next=null;
        }

    }
    public void addHead(T point){   //为空链表增加头结点
        head=new Node<T>(point);
        if(tail==null){
            tail=head;
        }
    }
    public void addTail(T point){
        tail=new Node<T>(point);
        head.next=tail;
    }
    public boolean insert(T point){
        Node<T>   preNext=head.next;
        Node<T> newNode=new Node(point,preNext);
        if(head.next!=null){
            preNext=head.next;
            head.next=newNode;
            newNode.next=preNext;
        }
        return true;
    }

    public void delete(T data){   //删除某一节点
        Node<T> curr=head,prev=null;
        boolean b=false;
        while(curr!=null){

            if(curr.data.equals(data)){
                if(curr==head){   //如果删除的是头节点
                    head=curr.next;
                    b=true;
                    return;
                }
                if(curr==tail){ //如果删除的是尾节点
                    tail=prev;
                    prev.next=null;
                    b=true;
                    return;
                }
                else{  //  如果删除的是中间节点（即非头节点或非尾节点）
                    prev.next=curr.next;
                    b=true;
                    return;
                }

            }
            prev=curr;
            curr=curr.next;
        }
        if(b==false){
            System.out.println('\n'+"没有这个数据");
        }

    }
    public T getValue(){
        return head.data;
    }
    public int getNum(T data){
        int n=0;
        Node<T>   curr=head;
        curr=head;
        while(curr!=null){
            if (curr.data.equals(data)){
                n++;
            }
            curr=curr.next;

        }
        return n;
    }
    public  boolean isEmpty(){
        if(head!=null&&tail!=null){
            return true;
        }
        return false;
    }
    public void show(){    //打印链表
        Node<T>   curr=head;
        if(isEmpty()){
            System.out.print(head.data+" ");
            curr=head.next;
        }
        else{
            System.out.println("链表错误");
            return;
        }

        while(curr!=null){
            System.out.print(curr.data+" ");
            curr=curr.next;
            if (curr==null){
                System.out.print('\n');
            }
        }
    }

    public static void main(String[] args) {
        LinkedList<Integer> list=new LinkedList<Integer>();
//插入元素
        list.addHead(4);
        list.addTail(3);
        list.insert(2);
        list.insert(1);
//删除元素
        System.out.print("链表结果为:");
        list.show();
        list.delete(4);
        System.out.print("删除后链表为:");
        list.show();
//返回元素
        System.out.print("访问的元素为:");
        int a=list.getValue();
        System.out.println(a);
//返回个数
        System.out.print("1的个数为:");
        System.out.println(list.getNum(1));
    }

}  