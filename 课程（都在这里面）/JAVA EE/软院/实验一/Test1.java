import java.util.Scanner;

public class Test1 {
    public static void main(String[] arg){
        Scanner input=new Scanner(System.in);
        int a=input.nextInt();
        String a1=Integer.toString(a);
        char[] chars=a1.toCharArray();
        String reverse="";
        for(int i=chars.length-1;i>=0;i--){
            reverse+=chars[i];
        }
        if(reverse.equals(a1)){
            System.out.println("是回文的");
        }else{
            System.out.println("不是回文的");
        }
    }
}
