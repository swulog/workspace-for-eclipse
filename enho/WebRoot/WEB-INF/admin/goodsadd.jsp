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
		pcdinit("startp_gadd","startc_gadd","startd_gadd"); 
		pcdinit("endp_gadd","endc_gadd","endd_gadd"); 
	</script>
	<form id="addgoodsform" method="post" action="mg/addGoods.do">
	<input type="hidden" name="startp" id="hstartp" value=""/>
	<input type="hidden" name="startc" id="hstartc"  value=""/>
	<input type="hidden" name="startd" id="hstartd"  value=""/>
	<input type="hidden" name="endp" id="hendp"  value=""/>
	<input type="hidden" name="endc" id="hendc"  value=""/>
	<input type="hidden" name="endd" id="hendd"  value=""/>
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发省：</label></td>
			<td width="30%"><select id='startp_gadd'><option value=''>请选择省份</option></select><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">出发市：</label></td>
			<td width="30%"><select id='startc_gadd'> <option value=''>请选择城市</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发区：</label></td>
			<td width="30%"><select id='startd_gadd'> <option value=''>请选择区县</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">到达省：</label></td>
			<td width="30%"><select id='endp_gadd'> <option value=''>请选择省份</option></select><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">到达市：</label></td>
			<td width="30%"><select id='endc_gadd'> <option value=''>请选择城市</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">到达区：</label></td>
			<td width="30%"><select id='endd_gadd'> <option value=''>请选择区县</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">货源描述：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="desc" id="desc_gadd"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">重量：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="weight" id="weight_gadd"/><span style="font-size:12px;">吨</span><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">所需车长：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="carlength" id="carlength_gadd"/><span style="font-size:12px;">米</span><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">发货时间：</label></td>
			<td width="30%"><input name="sendtime" id="sendtime_gadd" type="text"  style="width:150px;"><img onclick="WdatePicker({el:'sendtime_gadd',readOnly:true})" src="js/My97DatePicker/skin/datePicker.gif" width="16" height="22" ></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">发布人手机：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="user" id="user_gadd"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">货源图片：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="image" id="image_gadd"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">联系人名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="username" id="username_gadd"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">联系人手机：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="userphone" id="userphone_gadd"/><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">联系人电话：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="usertel" id="usertel_gadd"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">经度：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="longitude" id="longitude_gadd"/></td>
		</tr>
		<tr>
			<td valign="top" width="20%"><label for="name" style="font-size:12px;">纬度：</label></td>
			<td valign="top" width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="latitude" id="latitude_gadd"/></td>
			<td valign="top" width="20%"><label for="name" style="font-size:12px;">备注：</label></td>
			<td width="30%"><textarea  style="width:150px;height:100px;" name="remark" id="remark_gadd"></textarea></td>
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
				<a href="javascript:addGoods('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleAddGoods()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
