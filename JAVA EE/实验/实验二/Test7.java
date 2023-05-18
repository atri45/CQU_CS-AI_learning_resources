class AAA{
    static {
        System.out.println('a');
    }
}

public class Test7 {
    public static void main(String[] args){
        AAA a =new AAA();
        System.out.println('b');
    }
}
