package dao;

import vo.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    /**
     * 用户登录验证方法
     * @param uname 用户名
     * @param pwd 密码
     * @return 如果验证成功返回User对象，否则返回null
     */
    public User login(String uname, String pwd) {
        // SQL查询语句
        String sql = "SELECT * FROM T_USER WHERE USERNAME=? AND PASSWORD=?";

        // 使用try-with-resources自动关闭资源
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // 设置查询参数
            pstmt.setString(1, uname);
            pstmt.setString(2, pwd);
            
            // 执行查询并获取结果
            try (ResultSet rs = pstmt.executeQuery()) {
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
            }
        } catch (Exception e) {
            // 捕获并打印异常堆栈信息
            e.printStackTrace();
        }
        
        // 如果验证失败或未找到匹配用户，返回null
        return null;
    }
}
