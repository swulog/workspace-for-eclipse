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
    
    <title>My JSP 'importUserPre.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
    <form id="importuserform" method="post" action="mg/importUserConfirm.do" enctype="multipart/form-data">
    <table style="width:100%;">
    	<tr>
			<td><label for="name" style="font-size:12px;">批量导入：</label></td>
			<td>
				<input type="file" name="batchuser" id="batchuser_import"  style="width:200px;height:30px;"/>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
    </table>
    </form>
    <table style="width:100%">
		<tr>
			<td colspan="2" style="text-align:center;">
				<a href="javascript:importUser('${gridid}')" class='easyui-linkbutton'>导&nbsp;入</a>&nbsp;&nbsp;<a href='javascript:cancleImportUser()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
  </body>
</html>
