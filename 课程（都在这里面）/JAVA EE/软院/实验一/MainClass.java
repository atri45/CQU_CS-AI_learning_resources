class TV{
    int channel;
    void setChannel(int channel){
        this.channel=channel;
    }
    int getChannel(){
        return channel;
    }
    void showProgram(){
        System.out.printf("�����տ���Ƶ����CCTY-%d\n",channel);
    }
}
class Family{
    TV  homeTV;
    void buyTV(TV a){
        homeTV=a;
    }
    void remoteControl(int a){
        homeTV.channel=a;
    }
    void seeTV(){
        System.out.println("�����ڿ�������");
        homeTV.showProgram();
    }
}
public class MainClass {
    public static void main(String[] args){
        TV haierTV=new TV();
        Family zhangSanFamly=new Family();
        zhangSanFamly.buyTV(haierTV);
        haierTV.setChannel(20);
        System.out.println("�����ӿ�");
        zhangSanFamly.seeTV();
        System.out.println("����CCTV-6");
        zhangSanFamly.remoteControl(6);
        zhangSanFamly.seeTV();
    }
}
