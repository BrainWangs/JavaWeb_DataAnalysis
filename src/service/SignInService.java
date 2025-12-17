package service;

import dao.SignInDao;
import vo.User;

public class SignInService {
    private SignInDao signInDao;

    public SignInService() {
        this.signInDao = new SignInDao();
    }

    /**
     * 处理用户注册业务逻辑
     * @param user 包含用户名和密码的User对象
     * @return 注册结果，"success"表示成功，其他为错误信息
     */
    public String register(User user) {
        try {
            // 检查用户名是否已存在
            if (signInDao.checkUsernameExists(user.getUsername())) {
                return "用户名已存在";
            }

            // 执行注册
            boolean success = signInDao.register(user);
            return success ? "success" : "注册失败，请稍后重试";
        } catch (Exception e) {
            e.printStackTrace();
            return "注册过程中发生错误: " + e.getMessage();
        }
    }
}