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
		//初始化规则组下拉列表
		$.ajax({
			type : "POST",
			url : "mg/qryRGroupList.do",
			data : {"isabled":1},
			dataType : "json",
			success : function(data) {
				if(data.success){
					var html="<option value=''>请选择</option>";
					for(var i=0,len=data.rows.length;i<len;i++){
						html+="<option value='"+data.rows[i].id+"'>"+data.rows[i].name+"</option>";
					}
					$("#rulegroupid_add").html(html);
				}else{
					alert(data.msg);
				}
			}
		});
	</script>
	<form id="addruleform" method="post" action="mg/addRule.do">
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="name"  id="rulename_add"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">key：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="key" id="rulekey_add" /><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">value：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="value" id="rulevalue_add"/></td>
			<td><label for="name" style="font-size:12px;">是否启用：</label></td>
			<td><select name="isabled" style="width:150px;"><option value="1">启用</option><option value="2">停用</option></select></td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">所属组：</label></td>
			<td valign="top"><select name="groupid" id="rulegroupid_add" style="width:150px;"><option value="">请选择</option></select><span style="color:red;">&nbsp;*</span></td>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea name="desc" id="ruledesc_add" style="width:150px;height:100px;"></textarea></td>
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
				<a href="javascript:addRule('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleAddRule()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
