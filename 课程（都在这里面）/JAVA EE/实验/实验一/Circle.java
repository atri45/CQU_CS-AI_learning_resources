import java.util.Scanner;

public class Circle {
    double radius;
    double x;
    double y;
    void whatRelationship(Circle c1,Circle c2){
        double d=Math.sqrt((c1.x-c2.x)*(c1.x-c2.x)+(c1.y-c2.y)*(c1.y-c2.y));
        if(d<=Math.abs(c1.radius-c2.radius)){
            System.out.println("Circle2 is inside Circl1");
        }else if(d<=c1.radius+c2.radius){
            System.out.println("Circle2 overlaps Circle1");
        }else{
            System.out.println(" Circle2 does not overlaps circle1");
        }
    }
    public static void main(String[] args){
        Circle c1=new Circle();
        Circle c2=new Circle();
        Scanner input=new Scanner(System.in);
        System.out.println(" Enter circle1¡¯s center x-, y-coordinates, and radius:");
        c1.x=input.nextDouble();
        c1.y=input.nextDouble();
        c1.radius=input.nextDouble();
        System.out.println("Enter circle2¡¯s center x-, y-coordinates, and radius:");
        c2.x=input.nextDouble();
        c2.y=input.nextDouble();
        c2.radius=input.nextDouble();
        c1.whatRelationship(c1,c2);
    }
}
