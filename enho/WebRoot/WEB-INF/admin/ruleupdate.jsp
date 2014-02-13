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
	<form id="updateruleform" method="post" action="mg/updateRule.do">
	<script type="text/javascript">
		//初始化规则组下拉列表
		var groupid='${groupid}';
		$.ajax({
			type : "POST",
			url : "mg/qryRGroupList.do",
			data : {"isabled":1},
			dataType : "json",
			success : function(data) {
				if(data.success){
					var html="<option value=''>请选择</option>";
					for(var i=0,len=data.rows.length;i<len;i++){
						if(groupid==data.rows[i].id){
							html+="<option selected='selected' value='"+data.rows[i].id+"'>"+data.rows[i].name+"</option>";
						}else{
							html+="<option value='"+data.rows[i].id+"'>"+data.rows[i].name+"</option>";
						}
					}
					$("#rulegroupid_update").html(html);
					
				}else{
					alert(data.msg);
				}
			}
		});
	</script>
	<input type="hidden" name="id" value='${id}'/>
	<input type="hidden" name="key" value='${key}'/>
	<table style="width:100%;">
		<tr>
			<td width="20%"><label for="name" style="font-size:12px;">名称：</label></td>
			<td width="30%"><input class="easyui-validatebox" style="width:150px;" type="text" name="name"  id="rulename_update" value="${name}"/><span style="color:red;">&nbsp;*</span></td>
			<td width="20%"><label for="name" style="font-size:12px;">key：</label></td>
			<td width="30%"><label for="name" style="font-size:12px;">${key}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">value：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="value" id="rulevalue_update" value="${value}" /></td>
			<td><label for="name" style="font-size:12px;">是否启用：</label></td>
			<td valign="top">
				<select name="isabled" style="width:150px;">
					<option value='1' <c:if test="${isabled==1}">selected="selected"</c:if>>启用</option>
					<option value='2' <c:if test="${isabled==2}">selected="selected"</c:if>>停用</option>
				</select>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">所属组：</label></td>
			<td valign="top"><select name="groupid" id="rulegroupid_update" style="width:150px;"><option value="">请选择</option></select><span style="color:red;">&nbsp;*</span></td>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td>
			<td><textarea name="ruledesc_update" style="width:150px;height:100px;">${desc}</textarea></td>
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
				<a href="javascript:updateRule('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateRule()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
