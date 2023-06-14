package ui;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;
import javax.swing.*;

public class Withdrawal  implements ActionListener{
    public String id;
    public float savings;
    JTextField money;
    JFrame frame;
    JPanel jpanel_1,jpanel_2,jpanel_3,jpanel_4;
    JButton button_enter,button_cancel;
    JLabel yue;

    public void setSavings(float savings){
        this.savings=savings;
    }
    public void setId(String  id1){
        this.id=id1;

    }
    public Withdrawal (String id1,float savings1) {


        frame=new JFrame("取款");

        jpanel_1=new JPanel();
        jpanel_1.add(new JLabel("账户卡号:"+id1));

        jpanel_2=new JPanel();
        yue=new JLabel("账户余额:"+savings1);
        jpanel_2.add(yue);

        jpanel_3=new JPanel();
        jpanel_3.add(new JLabel("取款金额:"));
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
                if(!money.getText().equals("")){
                    String more =money.getText();
                    try{
                        //调用Class.forName()方法加载驱动程序
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        String url="jdbc:mysql://localhost:3306/test01";    //JDBC的URL
                        Connection conn;
                        conn = DriverManager.getConnection(url,    "root","123");
                        Statement stmt = conn.createStatement(); //创建Statement对象
                        //修改数据的代码
                        String sql2 = "update account set savings=savings-? where id=?";
                        PreparedStatement pst = conn.prepareStatement(sql2);
                        pst.setString(1,more);
                        pst.setString(2,id);
                        pst.executeUpdate();
                        stmt.close();
                        conn.close();
                    }catch(Exception c)
                    {
                        c.printStackTrace();
                    }

                    JOptionPane.showMessageDialog(null, "取款成功");//弹窗
                    money.setText("");//把存款金额清空
                    Menu menu=new Menu(id);
                    menu.id=id;
                    frame.dispose();
                }
                else
                {
                    JOptionPane.showMessageDialog(null, "输入的存款金额不得为空");

                }
            }
            catch (NumberFormatException e1)
            {

                JOptionPane.showMessageDialog(null, "输入数据类型错误，请输入整数");
                money.setText("");//把存款金额清空
            }
            catch (Exception e1)
            {
                JOptionPane.showMessageDialog(null, e1.getMessage());
                money.setText("");//把存款金额清空
            }
        }
        else//按返回按钮
        {
            Menu menu=new Menu(id);
            menu.id=id;
            frame.dispose();
        }

    }

}

