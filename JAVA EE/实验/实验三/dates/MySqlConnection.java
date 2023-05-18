package dates;

import ui.Window;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class MySqlConnection{//连接类

    private String DBDriver;
    private String DBURL;
    private String DBUser;
    private String DBPass;
    private Connection conn=null;   //连接
    private Statement stmt=null;   //报错
    public MySqlConnection(){
        DBDriver="com.mysql.cj.jdbc.Driver";
        DBURL="jdbc:mysql://localhost:3306/test01";
        DBUser="root";//用户名
        DBPass="123";//数据库密码
        try{
            Class.forName(DBDriver);//加载驱动程序
            //System.out.println("数据库驱动程序加载成功");
        }catch(Exception e){
            e.printStackTrace();
        }
        try{
            conn=DriverManager.getConnection(DBURL,DBUser,DBPass);//取得连接对象
            stmt=conn.createStatement();//取得SQL语句对象
            System.out.println("连接数据库成功");
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public Connection getMySqlConnection(){
        return conn;
    }
    public Statement getMySqlStatement(){
        return stmt;
    }
    public void closeMySqlConnection(){//关闭数据库连接
        try{
            stmt.close();
            conn.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args){
//        UI界面
        Window win=new Window();
        win.show();


    }
}
