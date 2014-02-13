<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'sendmsgpre.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
  
  <body>
  <script type="text/javascript">
  	/* function initvalue(type){
  		if(type=='1'){
  			if($("#phonenos_send").val()=='多个手机号码用","分隔,一次最多对100个手机发送'){
  				$("#phonenos_send").val('');
  			}
  		}else if(type=='2'){
  			if($("#phonenos_send").val()==''){
  				$("#phonenos_send").val('多个手机号码用","分隔,一次最多对100个手机发送');
  			}
  		}else if(type=='3'){
  			if($("#msgcontent_send").val()=='短信内容最多支持300个字,普通短信70个字/条,发送短信时请在内容后加签名：【XX公司或XX网名称】,否者会被屏蔽'){
  				$("#msgcontent_send").val('');
  			}
  		}else if(type=='4'){
  			if($("#msgcontent_send").val()==''){
  				$("#msgcontent_send").val('短信内容最多支持300个字,普通短信70个字/条,发送短信时请在内容后加签名：【XX公司或XX网名称】,否者会被屏蔽');
  			}
  		}else{}
  	} */
  </script>
    <form id="sendmsgform" method="post" action="mg/sendMsg.do">
	<table style="width:100%;">
		<tr>
			<td width="20%" valign="top"><label for="name" style="font-size:12px;">手机号码：</label></td>
			<td width="75%"><textarea  style="width:100%;height:100px;resize: none;" name="phonenos" id="phonenos_send"></textarea></td>
			<td><span style="color:red;">*</span></td>
		</tr>
		<tr>
			<td width="20%" valign="top"><label for="name" style="font-size:12px;">短信内容：</label></td>
			<td width="75%"><textarea  style="width:100%;height:300px;resize: none;" name="msgcontent" id="msgcontent_send"></textarea></td>
			<td><span style="color:red;">*</span></td>
		</tr>
		<tr style="height:30px;">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td width="20%" valign="top"><label for="name" style="font-size:12px;"></label></td>
			<td width="75%" style="font-size:12px;color:red;">
				1.多个手机号码用","分隔,一次最多对100个手机发送<br/>
				2.短信内容最多支持300个字,普通短信70个字/条,发送短信时请在内容后加签名：【XX公司或XX网名称】,否者会被屏蔽
			</td>
			<td></td>
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
				<a href="javascript:sendMsg('${gridid}')" class='easyui-linkbutton'>发&nbsp;送</a>&nbsp;&nbsp;<a href='javascript:cancleSendMsg()' class='easyui-linkbutton'>取&nbsp;消</a>
			</td>
		</tr>
	</table>
	</form>
  </body>
</html>
