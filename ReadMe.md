# 基于Jsp+Servlet的数据可视化管理系统

## 项目介绍

## 技术栈







## 问题记录

### 1.正确使用上下文路径的重要性
在jsp页面调用Servlet时，必须使用**绝对路径**，不能使用相对路径。而绝对路径使用El表达式动态获取
`${pageContext.request.contextPath}` 给出当前页面的上下文路径。