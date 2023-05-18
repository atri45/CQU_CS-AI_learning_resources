package dates;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBOperation{
    private MySqlConnection myDB=null;
    private Connection conn=null;
    private Statement stmt=null;
    private int scores;
    private int number1=0;
    private int number2=0;
    private String name;
    private String password;
    public DBOperation(MySqlConnection myDB){
        conn=myDB.getMySqlConnection();//取得对象
        stmt=myDB.getMySqlStatement();//取得sql语句
    }
    public void insertData(String id,String password){
        try{
            String newType1=new String(id.getBytes(),"GBK");//字节转码
            String newType2=new String(password.getBytes(),"GBK");
            String sql="INSERT INTO user(id,password)VALUES('"+newType1+"','"+newType2+"')";
            stmt.executeUpdate(sql);//更新语句
        }catch(Exception e1){
            e1.printStackTrace();
        }
    }
    public ResultSet selectData(String id1) throws SQLException {
        String sql = "SELECT * FROM account where id=" + id1;
        ResultSet rs = null;
        try {
            rs = stmt.executeQuery(sql);
            String id;
            String password;
            System.out.println("id" + '\t' + '\t' + "password");
            while (rs.next()) {//指针向后移动
                id = rs.getString("id");
                password = rs.getString("savings");
                System.out.println(id + '\t' + '\t' + password);

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rs;
    }
    public void deleteData(String  id){
        String sql="DELETE FROM user WHERE id="+id+"";
        System.out.print(sql);
        try{
            stmt.executeUpdate(sql);
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    public void updatePassword(String id,String password){//修改密码
        String sql="UPDATE user SET password="+password+" where id="+id;
        try{
            stmt.executeUpdate(sql);
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
    public boolean  selectPassword(String mpassword){//查询密码
        String sql="SELECT id,password FROM user";
        try{
            ResultSet rs=stmt.executeQuery(sql);//返回结果集
            while(rs.next()){//指针向后移动
                password=rs.getString("password");
                number2++;
                //System.out.print(rs.getString("password")+"  ");
                if(password.equals(mpassword)&&(number2==number1)){
                    //System.out.print("number2:"+number2);
                    return true;
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }
    public boolean selectName(String mid){//查询id
        String sql="SELECT id,password FROM user";
        try{
            ResultSet rs=stmt.executeQuery(sql);//返回结果集
            while(rs.next()){//指针向后移动
                name=rs.getString("id");
                number1++;
                if(name.equals(mid)){
                    //System.out.print("number1:"+number1);
                    return true;
                }
            }


        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }
    public int getScores(){
        return scores;
    }
    public String getName(){
        return name;
    }
    public String getPassword(){
        return password;
    }

    public void setNumber1(){
        number1=0;
    }
    public void setNumber2(){
        number2=0;
    }
}