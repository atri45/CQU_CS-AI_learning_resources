import java.util.Scanner;

public class Loan {
    public static void  main(String arg[]){
        Scanner input1=new Scanner(System.in);
        Scanner input2=new Scanner(System.in);
        int loanAmount=input1.nextInt();
        int nummberOfYear=input2.nextInt();
        double yearRate=0.05;
        int n=1;
        System.out.println("Interest Rate \t Monthly Payment \t Total Payment");
        while(yearRate<=0.08125){
            double mouthRate=yearRate/12;
            double monthlyPayment=(loanAmount*mouthRate)/(1-(1/(Math.pow(1+mouthRate,nummberOfYear*12))));
            double totalPayment=monthlyPayment*nummberOfYear*12;
            System.out.format("%.3f%%\t%.2f\t%.2f\n",yearRate*100,monthlyPayment,totalPayment);
            yearRate=yearRate+n*0.00125;
        }



    }
}
