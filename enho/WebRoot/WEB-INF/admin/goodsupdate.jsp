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
		var startp='${startp}';
		var startc='${startc}';
		var startd='${startd}';
		var endp='${endp}';
		var endc='${endc}';
		var endd='${endd}';
		pcdinit("startp_gupdate","startc_gupdate","startd_gupdate",startp,startc,startd); 
		pcdinit("endp_gupdate","endc_gupdate","endd_gupdate",endp,endc,endd); 
	</script>
	<form id="updategoodsform" method="post" action="mg/updateGoods.do">
	<input type="hidden" name="startp" id="ustartp" value=""/>
	<input type="hidden" name="startc" id="ustartc"  value=""/>
	<input type="hidden" name="startd" id="ustartd"  value=""/>
	<input type="hidden" name="endp" id="uendp"  value=""/>
	<input type="hidden" name="endc" id="uendc"  value=""/>
	<input type="hidden" name="endd" id="uendd"  value=""/>
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发省：</label></td>
			<td width="30%"><select id='startp_gupdate'><option value=''>请选择省份</option></select><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">出发市：</label></td>
			<td width="30%"><select id='startc_gupdate'> <option value=''>请选择城市</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发区：</label></td>
			<td width="30%"><select id='startd_gupdate'> <option value=''>请选择区县</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">到达省：</label></td>
			<td width="30%"><select id='endp_gupdate'> <option value=''>请选择省份</option></select><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">到达市：</label></td>
			<td width="30%"><select id='endc_gupdate'> <option value=''>请选择城市</option></select></td>
			<td width="20%"><label for="name" style="font-size:12px;">到达区：</label></td>
			<td width="30%"><select id='endd_gupdate'> <option value=''>请选择区县</option></select></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">货源描述：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="desc" id="desc_gupdate" value="${desc}"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">重量：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="weight" id="weight_gupdate" value="${weight}" /><span style="font-size:12px;">吨</span><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">所需车长：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="carlength" id="carlength_gupdate" value="${carlength}" /><span style="font-size:12px;">米</span><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">发货时间：</label></td>
			<td width="30%"><input name="sendtime" id="sendtime_gupdate" type="text"  style="width:150px;" value="${sendtime}"><img onclick="WdatePicker({el:'sendtime_gupdate',readOnly:true})" src="js/My97DatePicker/skin/datePicker.gif" width="16" height="22" ></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">发布人手机：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="pubphone" id="pubphone_gupdate" value="${pubphone}"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">货源图片：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="image" id="image_gupdate" value="${image}"/></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">联系人名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="username" id="username_gupdate" value="${username}"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">联系人手机：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="userphone" id="userphone_gupdate" value="${userphone}"/><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">联系人电话：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="usertel" id="usertel_gupdate" value="${usertel}"/></td>
			<td width="20%"><label for="name" style="font-size:12px;">经度：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="longitude" id="longitude_gupdate" value="${longitude}"/></td>
		</tr>
		<tr>
			<td valign="top" width="20%"><label for="name" style="font-size:12px;">纬度：</label></td>
			<td valign="top" width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="latitude" id="latitude_gupdate" value="${latitude}"/></td>
			<td valign="top" width="20%"><label for="name" style="font-size:12px;">备注：</label></td>
			<td width="30%"><textarea  style="width:150px;height:100px;" name="remark" id="remark_gupdate">${remark}</textarea></td>
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
				<a href="javascript:updateGoods('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateGoods()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
