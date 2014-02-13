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
	<form id="updateappdocform" method="post" action="mg/updateAppdoc.do">
	<input type="hidden" name="id" value="${id}"/>
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">类型：</label></td>
			<td width="75%">
				<label for="name" style="font-size:12px;">
					<c:if test="${type==1}">关于我们</c:if>
					<c:if test="${type==2}">免责声明</c:if>
				</label>
			</td>
			<td width="5%"><span style="color:red;"></span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="75%"><input class="easyui-validatebox" style="width:150px;" type="text" name="name" id="appdocname_update" value="${name}"/></td>
			<td width="5%"><span style="color:red;"></span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">标题：</label></td>
			<td width="75%"><input class="easyui-validatebox" style="width:95%;" type="text" name="title" id="appdoctitle_update" value="${title}"/></td>
			<td width="5%"><span style="color:red;"></span></td>
		</tr>
		<tr>
			<td width="20%" valign="top"><label for="name" style="font-size:12px;">内容：</label></td>
			<td width="75%"><textarea style="width:100%;height:300px;" name="content" id="appdoccontent_update">${content}</textarea></td>
			<td width="5%" valign="top"><span style="color:red;">&nbsp;*</span></td>
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
				<a href="javascript:updateAppdoc('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateAppdoc()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
