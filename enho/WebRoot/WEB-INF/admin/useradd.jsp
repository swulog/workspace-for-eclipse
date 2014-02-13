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
		function imgswitch(val){
			if(val=='1'){
				$("#ebus1").css("display","block");
				$("#ebus2").css("display","block");
				$("#pdriver1").css("display","none");
				$("#pdriver2").css("display","none");
			}else if(val=='2'){
				$("#ebus1").css("display","none");
				$("#ebus2").css("display","none");
				$("#pdriver1").css("display","none");
				$("#pdriver2").css("display","none");
			}else if(val=='3'){
				$("#ebus1").css("display","block");
				$("#ebus2").css("display","block");
				$("#pdriver1").css("display","none");
				$("#pdriver2").css("display","none");
			}else if(val=='4'){
				$("#ebus1").css("display","none");
				$("#ebus2").css("display","none");
				$("#pdriver1").css("display","block");
				$("#pdriver2").css("display","block");
			}else{}
		}
	</script>
	<form id="adduserform" method="post" action="mg/addUser.do" enctype="multipart/form-data">
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">手机号码：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="phone"  id="phoneno_add"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">用户密码：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="password" name="pwd" id="pwd_add" /><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">用户类型：</label></td>
			<td><select onchange="imgswitch(this.value);" name="type" id="usertype_add" style="width:150px;"><option value="1" selected>企业商家</option><option value="2">个人货主</option><option value="3">货运公司</option><option value="4">个人司机</option></select><span style="color:red;">&nbsp;*</span></td>
			<td><label for="name" style="font-size:12px;">用户名称：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="name" id="name_add"/></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">所属企业：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="ent" id="ent_add"/></td>
			<td><label for="name" style="font-size:12px;">固话号码：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="tel" id="tel_add"/></td>
		</tr>
		<tr id="ebus1">
			<td><label for="name" style="font-size:12px;">名片正面：</label></td>
			<td><input type="file" name="card" id="card_add" style="width:150px;"/></td>
			<td><label for="name" style="font-size:12px;">名片背面：</label></td>
			<td><input type="file" name="bcard" id="bcard_add" style="width:150px;"/></td>
		</tr>
		<tr id="ebus2">
			<td><label for="name" style="font-size:12px;">营业执照：</label></td>
			<td><input type="file" name="blicense" id="blicense_add" style="width:150px;"/></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr style="display:none;" id="pdriver1">
			<td><label for="name" style="font-size:12px;">身份证：</label></td>
			<td><input type="file" name="idcard" id="idcard_add" style="width:150px;"/></td>
			<td><label for="name" style="font-size:12px;">驾驶证：</label></td>
			<td><input type="file" name="dlicense" id="dlicense_add" style="width:150px;"/></td>
		</tr>
		<tr style="display:none;" id="pdriver2">
			<td><label for="name" style="font-size:12px;">行驶证：</label></td>
			<td><input type="file" name="rlicense" id="rlicense_add" style="width:150px;"/></td>
			<td>&nbsp;</td>
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
				<a href="javascript:addUser('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleAddUser()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
