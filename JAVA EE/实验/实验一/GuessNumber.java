import java.util.Random;
import java.util.Scanner;

public class GuessNumber {
    public static void main(String[] args){
        Random r = new Random();
        int n=r.nextInt(101)-1;
        Scanner input=new Scanner(System.in);
        int i=input.nextInt();
        while(i!=n){
            if(i<n){
                System.out.println("小了");
            }else{
                System.out.println("了");
            }
            i=input.nextInt();
        }
        System.out.println("猜对了");


    }
}
