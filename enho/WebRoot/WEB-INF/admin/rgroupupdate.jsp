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
	<form id="updatergroupform" method="post" action="mg/updateRGroup.do">
	<input type="hidden" name="id" value='${id}'/>
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="30%"><label for="name" style="font-size:12px;">${name}</label></td>
			<td width="20%"><label for="name" style="font-size:12px;">编码：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="code" id="rgroupcode_update" value="${code}"/></td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">是否启用：</label></td>
			<td valign="top">
				<select name="isabled" style="width:150px;">
					<option value='1' <c:if test="${isabled==1}">selected="selected"</c:if>>启用</option>
					<option value='2' <c:if test="${isabled==2}">selected="selected"</c:if>>停用</option>
				</select>
			</td>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea name="desc" id="rgroupdesc_update" style="width:150px;height:100px;font-size:12px;">${desc}</textarea></td>
		</tr>
		<tr style="height:30px;">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<table style="width:100%">
		<tr>
			<td colspan="2" style="text-align:center;">
				<a href="javascript:updateRgroup('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateRgroup()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
