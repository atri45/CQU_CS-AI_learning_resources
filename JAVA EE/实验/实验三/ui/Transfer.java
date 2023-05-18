package ui;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;
import javax.swing.*;

public class Transfer  implements ActionListener{
    public String id;
    public float savings;
    JTextField money;
    JTextField account;
    JFrame frame;
    JPanel jpanel_1,jpanel_2,jpanel_3,jpanel_4;
    JButton button_enter,button_cancel;

    public void setId(String  id1){
        this.id=id1;
    }
    public void setSavings(float savings){
        this.savings=savings;
    }
    public Transfer (String id1) {


        frame=new JFrame("取款");

        jpanel_1=new JPanel();
        jpanel_1.add(new JLabel("本账户卡号:"+id1));

        jpanel_2=new JPanel();
        jpanel_2.add(new JLabel("对方账户:"));
        account=new JTextField(20);
        jpanel_2.add(account);

        jpanel_3=new JPanel();
        jpanel_3.add(new JLabel("转账金额:"));
        money=new JTextField(20);
        jpanel_3.add(money);

        jpanel_4=new JPanel();
        button_enter=new JButton("确定");
        jpanel_4.add(button_enter);
        button_cancel=new JButton("返回");
        jpanel_4.add(button_cancel);

        frame.add(jpanel_1);
        frame.add(jpanel_2);
        frame.add(jpanel_3);
        frame.add(jpanel_4);

        frame.setLayout(new FlowLayout());
        frame.setVisible(true);
        frame.setBounds(500,500,350,300);
        frame.setLocationRelativeTo(null);//在屏幕中间显示(居中显示)

        button_enter.addActionListener(this);
        button_cancel.addActionListener(this);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(e.getActionCommand().equals("确定"))//按下确定按钮
        {
            try {
                if((!account.getText().equals(""))||(!money.getText().equals(""))){
                    String otherAccount =account.getText();
                    String  transferMoney=money.getText();
                    try{
                        //调用Class.forName()方法加载驱动程序
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        String url="jdbc:mysql://localhost:3306/test01";    //JDBC的URL
                        Connection conn;
                        conn = DriverManager.getConnection(url,    "root","123");
                        Statement stmt = conn.createStatement(); //创建Statement对象
                        //修改数据的代码
                        if(savings-Float.parseFloat(transferMoney)>=0){
                            String sql1 = "update account set savings=savings-? where id=? ;" ;
                            String sql2 ="update account set savings=savings+? where id=? ;";
                            PreparedStatement pst1 = conn.prepareStatement(sql1);
                            PreparedStatement pst2 = conn.prepareStatement(sql2);
                            pst1.setString(1,transferMoney);
                            pst1.setString(2,id);
                            pst2.setString(1,transferMoney);
                            pst2.setString(2,otherAccount);
                            pst1.executeUpdate();
                            pst2.executeUpdate();
                            stmt.close();
                            conn.close();
                            JOptionPane.showMessageDialog(null, "转账成功");//弹窗
                        }
                        else {
                            JOptionPane.showMessageDialog(null, "余额不足");
                        }

                    }catch(Exception c)
                    {
                        c.printStackTrace();
                    }
                    account.setText("");
                    money.setText("");
                    Menu menu=new Menu(id);
                    menu.id=id;
                    frame.dispose();
                }
                else
                {
                    JOptionPane.showMessageDialog(null, "账户和转账金额不为空");

                }
            } catch (HeadlessException ex) {
                throw new RuntimeException(ex);
            }
        }
        else//按返回按钮
        {
            Menu menu=new Menu(id);
            menu.id=id;
            frame.dispose();
        }

    }
    public static void main(String [] args){
        Transfer transfer=new Transfer("123123" );
        transfer.setId("123123");
    }
}

