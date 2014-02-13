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
	<table style="width:100%;">
		<tr>
			<td width="12%"><label for="name" style="font-size:12px;">id：</label></td>
			<td width="43%"><label for="name" style="font-size:12px;">${id}</label></td>
			<td width="15%"><label for="name" style="font-size:12px;">手机号码：</label></td>
			<td width="30%"><label for="name" style="font-size:12px;">${phone}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">用户类型：</label></td> 
			<td>
				<label for="name" style="font-size:12px;">
					<c:if test="${type==1}">企业商家</c:if>
					<c:if test="${type==2}">个人货主</c:if>
					<c:if test="${type==3}">货运公司</c:if>
					<c:if test="${type==4}">个人司机</c:if>
				</label>
			</td>
			<td><label for="name" style="font-size:12px;">用户名称：</label></td>
			<td><label for="name" style="font-size:12px;">${name}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">固话号码：</label></td> 
			<td><label for="name" style="font-size:12px;">${tel}</label></td>
			<td><label for="name" style="font-size:12px;">用户积分：</label></td>
			<td><label for="name" style="font-size:12px;">${integral}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">信&nbsp;誉&nbsp;值：</label></td> 
			<td><label for="name" style="font-size:12px;">${creditrating}</label></td>
			<td><label for="name" style="font-size:12px;">经&nbsp;&nbsp;&nbsp;&nbsp;度：</label></td>
			<td><label for="name" style="font-size:12px;">${x}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">纬&nbsp;&nbsp;&nbsp;&nbsp;度：</label></td> 
			<td><label for="name" style="font-size:12px;">${y}</label></td>
			<td><label for="name" style="font-size:12px;">是否有效:</label></td>
			<td><label for="name" style="font-size:12px;">${isabled}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">创建时间：</label></td> 
			<td><label for="name" style="font-size:12px;">${createtime}</label></td>
			<td><label for="name" style="font-size:12px;">修改时间：</label></td>
			<td><label for="name" style="font-size:12px;">${lastupdatetime}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">邀请码：</label></td> 
			<td><label for="name" style="font-size:12px;">${invitecode}</label></td>
			<td><label for="name" style="font-size:12px;">邀请码次数：</label></td>
			<td><label for="name" style="font-size:12px;">${invitecodecount}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">评分次数：</label></td> 
			<td><label for="name" style="font-size:12px;">${markcount}</label></td>
			<td><label for="name" style="font-size:12px;">用户密码：</label></td>
			<td><label for="name" style="font-size:12px;">${pwd}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">所属企业：</label></td> 
			<td><label for="name" style="font-size:12px;">${ent}</label></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<c:if test="${type==1 || type==3}">
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">名片正面：</label></td>
			<td>
				<img alt="名片正面" src="${cardurl}" style="width:150px;height:150px;"/>
			</td>
			<td valign="top"><label for="name" style="font-size:12px;">名片背面：</label></td>
			<td>
				<img alt="名片背面" src="${bcardurl}" style="width:150px;height:150px;"/>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">营业执照：</label></td>
			<td>
				<img alt="名片背面" src="${blicenseurl}" style="width:150px;height:150px;"/>
			</td>
		</tr>
		</c:if>
		
		<c:if test="${type==4}">
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">身份证：</label></td>
			<td>
				<img alt="身份证" src="${idcardurl}" style="width:150px;height:150px;"/>
			</td>
			<td valign="top"><label for="name" style="font-size:12px;">驾驶证：</label></td>
			<td>
				<img alt="驾驶证" src="${dlicenseurl}" style="width:150px;height:150px;"/>
			</td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">行驶证：</label></td>
			<td>
				<img alt="行驶证" src="${rlicenseurl}" style="width:150px;height:150px;"/>
			</td>
		</tr>
		</c:if>
	</table>
</body>
</html>
