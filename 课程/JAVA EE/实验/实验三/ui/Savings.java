package ui;
import dates.DBOperation;
import dates.MySqlConnection;

import javax.swing.*;
import javax.swing.table.JTableHeader;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class Savings extends JFrame {
    private JScrollPane scpDemo;
    public String id;
    private JTableHeader jth;
    private JTable tabDemo;
    private JButton btnShow;
    private JButton bt1;
    private JButton bt2;
    private JButton back;


    {
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public Savings() {
        super("余额查询");        //JFrame的标题名称
        this.setSize(450, 500);          //控制窗体大小
        this.setLayout(null);        //自定义布局
        this.setLocation(400, 200);        //点击运行以后，窗体在屏幕的位置
        this.scpDemo = new JScrollPane();
        this.bt1 = new JButton("确定");
        this.bt2 = new JButton("取消");
        this.back = new JButton("返回");
        this.btnShow = new JButton("显示余额");
        this.bt1.setBounds(100, 480, 100, 30);
        this.bt2.setBounds(380, 480, 100, 30);
        this.scpDemo.setBounds(10, 50, 580, 400);    //设置滚动框大小
        this.btnShow.setBounds(10, 10, 120, 30);    //设置按钮
        this.back.setBounds(300, 10, 120, 30);    //设置按钮
        this.btnShow.addActionListener(new ActionListener()    //给“显示数据”按钮添加事件响应。
        {
            public void actionPerformed(ActionEvent ae) {
                btnShow_ActionPerformed(ae);
            }
        });
        /********按钮“确定”的响应*******/
        this.bt1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });
        /******按钮 “取消”的响应*****/
        this.bt2.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });

        this.back.addActionListener(new ActionListener()    //给“back”按钮添加事件响应。
        {
            public void actionPerformed(ActionEvent ae) {
                Menu menu=new Menu(id);
                menu.id=id;
                dispose();
            }
        });

        /******* 将组件加入到窗体中******/
        add(this.scpDemo);
        add(this.back);

        add(this.btnShow);
        add(this.bt1);
        add(this.bt2);
        this.setVisible(true);
        this.setDefaultCloseOperation(EXIT_ON_CLOSE);
    }

    public static void main(String[] args) {
        new Savings();
    }

    /***连接数据库并显示到表格中***/
    public void btnShow_ActionPerformed(ActionEvent ae) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/test01";//注意设置时区
            String username = "root";
            String passwords = "123";
            Connection conn = DriverManager.getConnection(url, username, passwords);
            String sql = "select * from account where id="+id;
            PreparedStatement pstm = conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
            }
            rs = pstm.executeQuery();
            // 将查询获得的记录数据，转换成适合生成JTable的数据形式
            Object[][] info = new Object[count][6];
            String[] title = {"用户账号", "用户余额"};
            count = 0;
            while (rs.next()) {
                info[count][0] = Integer.valueOf(rs.getInt("id"));
                info[count][1] = rs.getString("savings");
                count++;
            }
            // 创建JTable
            this.tabDemo = new JTable(info, title);
            // 显示表头
            this.jth = this.tabDemo.getTableHeader();
            // 将JTable加入到带滚动条的面板中
            this.scpDemo.getViewport().add(tabDemo);
        } catch (ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
            JOptionPane.showMessageDialog(null, "数据源错误", "错误", JOptionPane.ERROR_MESSAGE);
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            JOptionPane.showMessageDialog(null, "数据操作错误", "错误", JOptionPane.ERROR_MESSAGE);
        }
    }
}