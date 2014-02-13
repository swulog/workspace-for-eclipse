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
		<%-- <tr>
			<td width="20%"><label for="name" style="font-size:12px;">出发省：</label></td>
			<td width="30%"><label for="name" style="font-size:12px;">${startp}</label></td>
			<td width="20%"><label for="name" style="font-size:12px;">出发市：</label></td>
			<td width="30%"><label for="name" style="font-size:12px;">${startc}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">出发区：</label></td> 
			<td><label for="name" style="font-size:12px;">${startd}</label></td>
			<td><label for="name" style="font-size:12px;">到达省：</label></td>
			<td><label for="name" style="font-size:12px;">${endp}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">到达市：</label></td> 
			<td><label for="name" style="font-size:12px;">${endc}</label></td>
			<td><label for="name" style="font-size:12px;">到达区：</label></td>
			<td><label for="name" style="font-size:12px;">${endd}</label></td>
		</tr> --%>
		<tr>
			<td><label for="name" style="font-size:12px;">重量：</label></td> 
			<td><label for="name" style="font-size:12px;">${weight}吨</label></td>
			<td><label for="name" style="font-size:12px;">所需车长：</label></td>
			<td><label for="name" style="font-size:12px;">${carlength}米</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">联系人名称：</label></td> 
			<td><label for="name" style="font-size:12px;">${username}</label></td>
			<td><label for="name" style="font-size:12px;">联系人手机：</label></td>
			<td><label for="name" style="font-size:12px;">${userphone}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">联系人电话：</label></td> 
			<td><label for="name" style="font-size:12px;">${usertel}</label></td>
			<td><label for="name" style="font-size:12px;">货源状态：</label></td>
			<td>
				<label for="name" style="font-size:12px;">
					<c:if test="${status==1}">正常</c:if>
					<c:if test="${status==2}">锁定</c:if>
					<c:if test="${status==3}">下架</c:if>
				</label>
			</td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">发布时间：</label></td> 
			<td><label for="name" style="font-size:12px;">${createtime}</label></td>
			<td><label for="name" style="font-size:12px;">最后修改时间：</label></td>
			<td><label for="name" style="font-size:12px;">${lastupdatetime}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">发货时间：</label></td> 
			<td><label for="name" style="font-size:12px;">${sendtime}</label></td>
			<td><label for="name" style="font-size:12px;">经度</label></td>
			<td><label for="name" style="font-size:12px;">${longitude}</label></td>
		</tr>
		<tr>
			<td><label for="name" style="font-size:12px;">纬度：</label></td> 
			<td><label for="name" style="font-size:12px;">${latitude}</label></td>
			<td><label for="name" style="font-size:12px;">发布人手机：</label></td> 
			<td><label for="name" style="font-size:12px;">${pubphone}</label></td>
		</tr>
		<tr>
			<td valign="top"><label for="name" style="font-size:12px;">描述：</label></td> 
			<td valign="top"><label for="name" style="font-size:12px;">${desc}</label></td>
			<td valign="top"><label for="name" style="font-size:12px;">备注</label></td>
			<td><textarea disabled style="font-size:12px;width:150px;height:100px;">${remark}</textarea></td>
		</tr>
	</table>
</body>
</html>
