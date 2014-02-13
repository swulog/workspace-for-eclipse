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
		pcdinit("startp_gupdate","startc_gupdate","startd_gupdate"); 
		pcdinit("endp_gupdate","endc_gupdate","endd_gupdate"); 
	</script>
	<form id="addgoodsform" method="post" action="mg/addGoods.do">
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发省：</label></td>
			<td width="30%"><select id='startp_gadd'><option value=''>请选择省份</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">出发市：</label></td>
			<td width="30%"><select id='startc_gadd'> <option value=''>请选择城市</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发区：</label></td>
			<td width="30%"><select id='startd_gadd'> <option value=''>请选择区县</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">到达省：</label></td>
			<td width="30%"><select id='endp_gsearch'> <option value=''>请选择省份</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">到达市：</label></td>
			<td width="30%"><select id='endc_gsearch'> <option value=''>请选择城市</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">到达区：</label></td>
			<td width="30%"><select id='endd_gsearch'> <option value=''>请选择区县</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">货源描述：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="desc"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">重量：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="weight"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">所需车长：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="carlength"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">发货时间：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="sendtime"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">备注：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="remark"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">货源图片：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="image"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">联系人名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="username"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">联系人手机：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="userphone"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">联系人电话：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="usertel"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">经度：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="longitude"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">纬度：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="latitude"/></td>
			<td width="20%">&nbsp;</td>
			<td width="30%">&nbsp;</td>
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
				<a href="javascript:updateCar('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateCar()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
