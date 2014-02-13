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
	<script type="text/javascript">
		function updateapp_file(flag){
			if(flag==1){
				$("#newfileinfo").css("display","block");
				$("#appfile_update").attr("disabled",false);
				$("#upbtn1").css("display","none");
			}else if(flag==2){
				$("#newfileinfo").css("display","none");
				$("#appfile_update").attr("disabled",true);
				$("#upbtn1").css("display","inline");
			}else{}
			
			
		}
	</script>
	<form id="updateappform" method="post" action="mg/updateApp.do" enctype="multipart/form-data">
	<input type="hidden" name="id" value='${id}'/>
	<input type="hidden" name="key" value='${key}'/>
	<input type="hidden" name="oldappfileurl" value='${url}'/>
	<table style="width:100%;">
		<tr>
			<td width="10%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="25%"><input class="easyui-validatebox" style="width:150px;" type="text" name="name" id="appname_update" value="${name}"/></td>
			<td width="15%"><label for="name" style="font-size:12px;">AppKey：</label></td>
			<td width="45%">${key}</td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">版本：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="version" id="appversion_update" value="${version}" /><span style="color:red;">&nbsp;*</span></td>
			<td><label for="name" style="font-size:12px;">文件：</label></td>
			<td>
				<div id="oldfileinfo"><span>${url}</span>&nbsp;&nbsp;<a id="upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:updateapp_file(1)">修改</a></div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><div id="newfileinfo" style="display:none;"><input type="file" name="appfile" id="appfile_update" disabled/><a id="upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:updateapp_file(2)">取消</a></div></td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea name="desc" id="appdesc_update" style="width:150px;height:100px;">${desc}</textarea></td>
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
				<a href="javascript:updateApp('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateApp()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
