package dao;

import vo.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class SignInDao {

    /**
     * 检查用户名是否已存在
     * @param username 要检查的用户名
     * @return 存在返回true，否则返回false
     */
    public boolean checkUsernameExists(String username) throws Exception {
        String sql = "SELECT COUNT(*) FROM T_USER WHERE USERNAME=?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * 将用户信息插入数据库完成注册
     * @param user 包含用户名和密码的User对象
     * @return 注册成功返回true，否则返回false
     */
    public boolean register(User user) throws Exception {
        String sql = "INSERT INTO T_USER (USERNAME, PASSWORD) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());

            // 执行插入，返回受影响的行数
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}