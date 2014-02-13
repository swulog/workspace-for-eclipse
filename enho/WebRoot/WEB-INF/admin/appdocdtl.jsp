<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>

<body>
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">id：</label></td>
			<td width="80%"><label for="name" style="font-size:12px;">${id}</label></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">类型：</label></td>
			<td width="80%">
				<label for="name" style="font-size:12px;">
					<c:if test="${type==1}">关于我们</c:if>
					<c:if test="${type==2}">免责声明</c:if>
				</label>
			</td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="80%"><label for="name" style="font-size:12px;">${name}</label></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">标题：</label></td>
			<td width="80%"><label for="name" style="font-size:12px;">${title}</label></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">创建时间：</label></td>
			<td width="80%"><label for="name" style="font-size:12px;">${createtime}</label></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">最后修改时间：</label></td>
			<td width="80%"><label for="name" style="font-size:12px;">${lastupdatetime}</label></td>
		</tr>
		<tr>
			<td width="20%" valign="top"><label for="name" style="font-size:12px;">内容：</label></td>
			<td width="80%"><textarea readonly style="width:100%;height:300px;font-size:12px;">${content}</textarea></td>
		</tr>
	</table>
</body>
</html>
