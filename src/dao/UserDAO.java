package dao;

import vo.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    private String url = "jdbc:mysql://localhost:3306/sql_demo?useSSL=false&serverTimezone=UTC";
    // 数据库用户名
    private String username = "root";
    // 数据库密码
    private String password = "123456";

    /**
     * 用户登录验证方法
     * @param uname 用户名
     * @param pwd 密码
     * @return 如果验证成功返回User对象，否则返回null
     */
    public User login(String uname, String pwd) {
        // 声明数据库连接、预编译语句和结果集对象，初始化为null
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 加载MySQL JDBC驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 建立数据库连接
            conn = DriverManager.getConnection(url, username, password);
            // 创建SQL查询语句
            String sql = "SELECT * FROM T_USER WHERE USERNAME=? AND PASSWORD=?";
            // 创建预编译语句对象
            pstmt = conn.prepareStatement(sql);
            // 设置第一个占位符参数为用户名
            pstmt.setString(1, uname);
            // 设置第二个占位符参数为密码
            pstmt.setString(2, pwd);
            // 执行查询并获取结果集
            rs = pstmt.executeQuery();

            // 如果查询结果存在下一行记录，说明用户名和密码匹配
            if (rs.next()) {
                // 创建并返回包含用户信息的User对象
                return new User(
                        // 获取用户ID
                        rs.getInt("ID"),
                        // 获取用户名
                        rs.getString("USERNAME"),
                        // 获取密码
                        rs.getString("PASSWORD")
                );
            }

        } catch (Exception e) {
            // 捕获并打印异常堆栈信息
            e.printStackTrace();
        } finally {
            // 关闭结果集
            try { if(rs != null) rs.close(); } catch (Exception ignored) {}
            // 关闭预编译语句
            try { if(pstmt != null) pstmt.close(); } catch (Exception ignored) {}
            // 关闭数据库连接
            try { if(conn != null) conn.close(); } catch (Exception ignored) {}
        }
        // 如果验证失败或未找到匹配用户，返回null
        return null;
    }
}
