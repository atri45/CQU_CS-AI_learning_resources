package ui;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

import javax.swing.*;
/**
 *
 * @author contentcl
 * Menu是一个 菜单类，也是最为底层的一个类
 * 提供各个功能的按钮
 *
 * 此类未使用布局， 所以使用坐标固定了各个标签和按钮的位置
 *
 */

public class Menu extends JFrame implements ActionListener{

    JButton jb1, jb2, jb3,jb4,jb5,jb6,jb7, jb8;  //创建按钮
    JLabel jlb1, jlb2, jlb3;   //标签
    public String id;
    public float savings;
    public Menu(String id)
    {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/test01";//注意设置时区
            String username = "root";
            String passwords = "123";
            Connection conn = DriverManager.getConnection(url, username, passwords);
            String sql = "select savings from account where id="+id;
            PreparedStatement pstm = conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();
            while(rs.next()) {
                savings=rs.getFloat("savings");
            }
        } catch (SQLException | ClassNotFoundException b) {
            throw new RuntimeException(b);
        }
        jb1 = new JButton("查询");
        jb2 = new JButton("存款");
        jb3 = new JButton("取款");
        jb4 = new JButton("转账");
        jb5 = new JButton("改密");
        jb6 = new JButton("退卡");


        jlb1 = new JLabel("绵绵阳ATM机");
        jlb1.setFont(new   java.awt.Font("Dialog",   1,   23)); //设置字体类型， 是否加粗，字号
        jlb2 = new JLabel("欢迎您");
        jlb2.setFont(new   java.awt.Font("Dialog",   1,   20));
        jlb3 = new JLabel("请您选择服务");
        jlb3.setFont(new   java.awt.Font("Dialog",   1,   22));

        jb1.addActionListener(this);   //事件监听
        jb2.addActionListener(this);
        jb3.addActionListener(this);
        jb4.addActionListener(this);
        jb5.addActionListener(this);
        jb6.addActionListener(this);

        this.setTitle("绵绵阳的ATM机");  //设置窗体标题
        this.setSize(450, 440);         //设置窗体大小
        this.setLocation(400, 200);     //设置位置
        this.setLayout(null);           //设置布局，不采用布局

        //设置按钮的位置和大小
        jb1.setBounds( 0,50,90,60);
        jb2.setBounds( 0,150,90,60);
        jb3.setBounds( 0,250,90,60);
        jb4.setBounds( 354,50,90,60);
        jb5.setBounds( 354,150,90,60);
        jb6.setBounds( 354,250,90,60);

        //设置标签的位置和大小
        jlb1.setBounds(150,120,150,50);
        jlb2.setBounds(190,160,150,50);
        jlb3.setBounds(150,250,150,50);

        this.add(jb1);   //加入窗体
        this.add(jb2);
        this.add(jb3);
        this.add(jb4);
        this.add(jb5);
        this.add(jb6);
        this.add(jlb1);
        this.add(jlb2);
        this.add(jlb3);

        this.setDefaultCloseOperation(EXIT_ON_CLOSE);  //设置可关闭

        this.setVisible(true);  //设置可见
        this.setResizable(false);   //设置不可拉伸大小
    }

    @Override
    public void actionPerformed(ActionEvent e) {
//        // TODO Auto-generated method stub
        if (e.getActionCommand()=="查询")
        {
            //String order = e.getActionCommand();
            Savings savings=new Savings();
            savings.id=id;
            dispose();

        }
        else if (e.getActionCommand()=="存款")
        {


            SaveMoney saveMoney=new SaveMoney(id,savings);

            saveMoney.setId(id);
            saveMoney.setSavings(savings);
            dispose();

        }
        else if (e.getActionCommand()=="取款")
        {
            Withdrawal withdrawal=new Withdrawal(id,savings);
            withdrawal.setId(id);
            withdrawal.setSavings(savings);
            dispose();

        }
        else if (e.getActionCommand()=="转账")
        {
            Transfer transfer=new Transfer(id);
            transfer.setId(id);
            transfer.setSavings(savings);
            dispose();
        }
        else if (e.getActionCommand()=="改密")
        {
            ChangePassword changePassword=new ChangePassword(id);
            changePassword.setId(id);
            dispose();
        }


        else if (e.getActionCommand()=="退卡")
        {
            System.exit(0);;
        }

    }

}
