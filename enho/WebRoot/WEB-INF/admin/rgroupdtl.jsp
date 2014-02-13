<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
			<td width="12%"><label for="name" style="font-size:12px;">id：</label></td>
			<td width="43%"><label for="name" style="font-size:12px;">${id}</label></td>
			<td width="15%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="30%"><label for="name" style="font-size:12px;">${name}</label></td>
			
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">编码：</label></td>
			<td><label for="name" style="font-size:12px;">${code}</label></td>
			<td><label for="name" style="font-size:12px;">是否启用：</label></td> 
			<td><label for="name" style="font-size:12px;">${isabled}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">创建时间：</label></td>
			<td><label for="name" style="font-size:12px;">${createtime}</label></td>
			<td><label for="name" style="font-size:12px;">修改时间：</label></td> 
			<td><label for="name" style="font-size:12px;">${lastupdatetime}</label></td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea disabled style="font-size:12px;height:100px;">${desc}</textarea></td>
			<td><label for="name" style="font-size:12px;">&nbsp;</label></td> 
			<td><label for="name" style="font-size:12px;">&nbsp;</label></td>
		</tr>
	</table>
</body>
</html>
