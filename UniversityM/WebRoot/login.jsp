<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">


<title>登录</title>
<link href="css/skin.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery-1.4.1.js"></script>

</head>

<body>
	<form name="loginform" action="loginSysUser.action" method="post">
		用户名：<input type="text" name="sysuser.userName" /><br/>
		密 &nbsp;&nbsp;码：<input type="password" name="sysuser.passWord"/><br/><br/>
		<input type="submit" value="提交" />
	</form>
</body>