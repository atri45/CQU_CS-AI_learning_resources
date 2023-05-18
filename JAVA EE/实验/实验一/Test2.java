import jdk.nashorn.internal.ir.WhileNode;

import java.util.Scanner;

public class Test2 {
    public static void main(String[] args){
        Scanner input=new Scanner(System.in);
        double a=input.nextDouble();
        double sum=0;
        int i=0;
        while (a!=101){
            sum+=a;
            a=input.nextDouble();
            i++;
        }
        System.out.println("平均成绩为：");
        System.out.println(sum/i);
    }
}
