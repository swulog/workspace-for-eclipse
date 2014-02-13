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
	<form id="addrgroupform" method="post" action="mg/addRGroup.do">
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="name" id="rgroupname_add" /><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">编码：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="code" id="rgroupcode_add"/></td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">是否启用：</label></td>
			<td valign="top"><select name="isabled" id="isabled" style="width:150px;"><option value="1">启用</option><option value="2">停用</option></select></td>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea name="desc" id="rgroupdesc_add" style="width:150px;height:100px;"></textarea></td>
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
				<a href="javascript:addRgroup('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleAddRgroup()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
