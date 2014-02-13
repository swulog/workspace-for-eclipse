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
	<style>
</style>
  </head>

<body>
	<script type="text/javascript">
		function update_file(flag,name){
			if(flag==1){
				$("#"+name+"updatediv").css("display","block");
				$("#"+name+"_update").attr("disabled",false);
				$("#"+name+"btndiv").css("display","none");
			}else if(flag==2){//删除
				$.ajax({
						type : "POST",
						url : "mg/delImg.do",
						data : {},
						dataType : "json",
						success : function(data) {
							
						}
				});
				$("#"+name+"updatediv").css("display","block");
				$("#"+name+"_update").attr("disabled",false);
				$("#"+name+"btndiv").css("display","none");
				$("#"+name+"_upbtn3").css("display","none");
				$("#"+name+"updateimg").css("display","none");
			}else if(flag==3){
				$("#"+name+"updatediv").css("display","none");
				$("#"+name+"_update").attr("disabled",true);
				$("#"+name+"btndiv").css("display","block");
			}else{}
		}
	</script>
	<form id="updateuserform" method="post" action="mg/updateUser.do">
	<input type="hidden" name="id" value='${id}'/>
	<input type="hidden" name="id" value='${type}'/>
	<table style="width:100%;">
		<tr>
			<td width="15%"><label for="name" style="font-size:12px;">手机号码：</label></td>
			<td width="35%"><input class="easyui-validatebox" style="width:150px;" type="text" name="phone" id="phoneno_update" value='${phone}'/><span style="color:red;">&nbsp;*</span></td>
			<td width="15%"><label for="name" style="font-size:12px;">用户密码：</label></td>
			<td width="35%"><input class="easyui-validatebox" style="width:150px;" type="password" name="pwd" id="pwd_update" value='${pwd}' /><span style="color:red;">&nbsp;*</span></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">用户类型：</label></td> 
			<td><label for="name" style="font-size:12px;">
				<c:if test="${type==1}">企业商家</c:if>
				<c:if test="${type==2}">个人货主</c:if>
				<c:if test="${type==3}">货运公司</c:if>
				<c:if test="${type==4}">个人司机</c:if>
			</label></td>
			<td><label for="name" style="font-size:12px;">用户名称：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="name" id="name_update" value='${name}'/></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">固话号码：</label></td> 
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="tel" id="tel_update" value='${tel}'/></td>
			<td><label for="name" style="font-size:12px;">用户积分：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="integral" id="integral_update" value='${integral}'/></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">信&nbsp;誉&nbsp;值：</label></td> 
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="creditrating" id="creditrating_update" value='${creditrating}' /></td>
			<td><label for="name" style="font-size:12px;">经&nbsp;&nbsp;&nbsp;&nbsp;度：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="x" value='${x}' id="x_update"/></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">纬&nbsp;&nbsp;&nbsp;&nbsp;度：</label></td> 
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="y" value='${y}' id="y_update"/></td>
			<td><label for="name" style="font-size:12px;">是否启用：</label></td>
			<td>
				<select id='isabled'>
					<option value='1' <c:if test="${isabled==1}">selected="selected"</c:if>>启用</option>
					<option value='2' <c:if test="${isabled==2}">selected="selected"</c:if>>停用</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">邀请码：</label></td> 
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="invitecode" value='${invitecode}' id="invitecode_update"/></td>
			<td><label for="name" style="font-size:12px;">邀请码可用次数：</label></td>
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="invitecodecount" value='${invitecodecount}' id="invitecodecount_update"/></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">被评分次数：</label></td> 
			<td><input class="easyui-validatebox" style="width:150px;" type="text" name="markcount" value='${markcount}' id="markcount_update"/></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<c:if test="${type==1 || type==3}">
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">名片正面：</label></td>
			<td valign="top">
				<img id="cardupdateimg" alt="名片正面" src="${cardurl}" style="width:150px;height:150px;"/>
				<div id="cardbtndiv"><a id="card_upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(1,'card')">修改</a>&nbsp;&nbsp;<a id="card_upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(2,'card')">删除</a></div>
				<div id="cardupdatediv" style="display:none;"><input type="file" name="card" id="card_update" style="width:150px;" disabled/><a id="card_upbtn3" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(3,'card')">取消</a></div>
			</td>
			<td valign="top"><label for="name" style="font-size:12px;">名片背面：</label></td>
			<td valign="top">
				<img id="bcardupdateimg" alt="名片背面" src="${bcardurl}" style="width:150px;height:150px;"/>
				<div id="bcardbtndiv"><a id="bcard_upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(1,'bcard')">修改</a>&nbsp;&nbsp;<a id="bcard_upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(2,'bcard')">删除</a></div>
				<div id="bcardupdatediv" style="display:none;"><input type="file" name="bcard" id="bcard_update" style="width:150px;" disabled/><a id="bcard_upbtn3" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(3,'bcard')">取消</a></div>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">营业执照：</label></td>
			<td valign="top">
				<img id="blicenseupdateimg" alt="营业执照" src="${blicenseurl}" style="width:150px;height:150px;"/>
				<div id="blicensebtndiv"><a id="blicense_upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(1,'blicense')">修改</a>&nbsp;&nbsp;<a id="blicense_upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(2,'blicense')">删除</a></div>
				<div id="blicenseupdatediv" style="display:none;"><input type="file" name="blicense" id="blicense_update" style="width:150px;" disabled/><a id="blicense_upbtn3" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(3,'blicense')">取消</a></div>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</c:if>
		
		<c:if test="${type==4}">
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">身份证：</label></td>
			<td valign="top">
				<img id="idcardupdateimg" alt="身份证" src="${idcardurl}" style="width:150px;height:150px;"/>
				<div id="idcardbtndiv"><a id="idcard_upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(1,'idcard')">修改</a>&nbsp;&nbsp;<a id="idcard_upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(2,'idcard')">删除</a></div>
				<div id="idcardupdatediv" style="display:none;"><input type="file" name="idcard" id="idcard_update" style="width:150px;" disabled/><a id="idcard_upbtn3" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(3,'idcard')">取消</a></div>
			</td>
			<td valign="top"><label for="name" style="font-size:12px;">驾驶证：</label></td>
			<td valign="top">
				<img id="dlicenseupdateimg" alt="驾驶证" src="${dlicenseurl}" style="width:150px;height:150px;"/>
				<div id="dlicensebtndiv"><a id="dlicense_upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(1,'dlicense')">修改</a>&nbsp;&nbsp;<a id="dlicense_upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(2,'dlicense')">删除</a></div>
				<div id="dlicenseupdatediv" style="display:none;"><input type="file" name="dlicense" id="dlicense_update" style="width:150px;" disabled/><a id="dlicense_upbtn3" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(3,'dlicense')">取消</a></div>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">行驶证：</label></td>
			<td valign="top">
				<img id="rlicenseupdateimg" alt="行驶证" src="${rlicenseurl}" style="width:150px;height:150px;"/>
				<div id="rlicensebtndiv"><a id="rlicense_upbtn1" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(1,'rlicense')">修改</a>&nbsp;&nbsp;<a id="rlicense_upbtn2" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(2,'rlicense')">删除</a></div>
				<div id="rlicenseupdatediv" style="display:none;"><input type="file" name="rlicense" id="rlicense_update" style="width:150px;" disabled/><a id="rlicense_upbtn3" style="display:inline;width:40px;height:20px;background:#EEE;border:1px solid #999;text-align:center;text-decoration:none;" href="javascript:update_file(3,'rlicense')">取消</a></div>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</c:if>
		
		
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
				<a href="javascript:updateUser('${gridid}')" class='easyui-linkbutton'>确&nbsp;认</a>&nbsp;&nbsp;<a href='javascript:cancleUpdateUser()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
