class Point{
    int x,y;
    void setXY(int m,int n){
        x=m;
        y=n;
    }
}
public class Example4_4 {
    public static void main (String args[]){
        Point p1=null, p2=null;
        p1=new Point();
        p2=new Point();
        System.out.println("p1的引用:"+p1);
        System.out.println("p2的引用:"+p2);
        p1.setXY(111,222);
        p2.setXY(-10,120);
        System.out.println("p1的x，y坐标"+p1.x+','+p1.y);
        System.out.println("p2的x，y坐标"+p2.x+','+p2.y);
        p1=p2;
        System.out.println("p2->p1后");
        int address=System.identityHashCode(p1);
        System.out.printf("p1的引用%x\n",address);
        address=System.identityHashCode(p2);
        System.out.printf("p2的引用%x\n",address);
        System.out.println("p1的x，y坐标"+p1.x+','+p1.y);
        System.out.println("p2的x，y坐标"+p2.x+','+p2.y);
    }

}
