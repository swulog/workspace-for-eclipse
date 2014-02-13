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
	<form id="addappform" method="post" action="mg/addApp.do" enctype="multipart/form-data">
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="name" id="appname_add" /></td>
			<td width="20%"><label for="name" style="font-size:12px;">AppKey：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="key" id="appkey_add"/><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">版本：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="version" id="appversion_add" /><span style="color:red;">&nbsp;*</span></td>
			<td><label for="name" style="font-size:12px;">文件：</label></td>
			<td>
				<input  class="easyui-validatebox" style="width:150px;" type="file" name="appfile" id="appfile_add"/>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea name="desc" id="appdesc_add" style="width:150px;height:100px;"></textarea></td>
			<td valign="top">&nbsp;</td>
			<td>&nbsp;</td>
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
				<a href="javascript:addApp('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleAddApp()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
