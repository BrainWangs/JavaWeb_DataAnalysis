package service;

import dao.UserDAO;
import vo.User;

public class UserLogin {
    private UserDAO userDAO;
    
    public UserLogin() {
        this.userDAO = new UserDAO();
    }
    // 实现登录业务逻辑
    public User login(String username, String password) {
        return userDAO.login(username, password);
    }
}