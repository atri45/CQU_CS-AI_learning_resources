package ui;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;
import javax.swing.*;

public class ChangePassword  implements ActionListener{
    public String id;
    JTextField newPassword;
    JFrame frame;
    JPanel jpanel_1,jpanel_2,jpanel_3,jpanel_4;
    JButton button_enter,button_cancel;

    public void setId(String  id1){
        this.id=id1;

    }
    public ChangePassword (String id1) {


        frame=new JFrame("取款");

        jpanel_1=new JPanel();
        jpanel_1.add(new JLabel("账户卡号:"+id1));



        jpanel_3=new JPanel();
        jpanel_3.add(new JLabel("新密码:"));
        newPassword=new JTextField(20);
        jpanel_3.add(newPassword);

        jpanel_4=new JPanel();
        button_enter=new JButton("确定");
        jpanel_4.add(button_enter);
        button_cancel=new JButton("返回");
        jpanel_4.add(button_cancel);

        frame.add(jpanel_1);
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
                if(!newPassword.getText().equals("")){
                    String newPasswordText =newPassword.getText();
                    System.out.println(newPasswordText);
                    try{
                        //调用Class.forName()方法加载驱动程序
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        String url="jdbc:mysql://localhost:3306/test01";    //JDBC的URL
                        Connection conn;
                        conn = DriverManager.getConnection(url,    "root","123");
                        Statement stmt = conn.createStatement(); //创建Statement对象
                        //修改数据的代码update user set password=123 where id=123123
                        String sql2 = "update user set password=? where id=?";
                        PreparedStatement pst = conn.prepareStatement(sql2);
                        pst.setString(1,newPasswordText);
                        pst.setString(2,id);
                        pst.executeUpdate();
                        stmt.close();
                        conn.close();
                    }catch(Exception c)
                    {
                        c.printStackTrace();
                    }

                    JOptionPane.showMessageDialog(null, "密码修改成功");//弹窗
                    newPassword.setText("");//把存款金额清空
                    Menu menu=new Menu(id);
                    menu.id=id;
                    frame.dispose();
                }
                else
                {
                    JOptionPane.showMessageDialog(null, "输入的密码不得为空");

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
        ChangePassword changePassword=new ChangePassword("123123");
        changePassword.setId("123123");
}
}

