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
	<script type="text/javascript" src="<%=basePath%>js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript">
		function getFullPath(obj) {    //得到图片的完整路径  
		    if(obj) {  
		        //ie  
		        if (window.navigator.userAgent.indexOf("MSIE") >= 1) {  
		            obj.select();  
		            return document.selection.createRange().text;  
		        }  
		        //firefox  
		        else if (window.navigator.userAgent.indexOf("Firefox") >= 1) {  
		            if (obj.files) {  
		                return obj.files.item(0).getAsDataURL();  
		            }  
		            return obj.value;  
		        }  
		        alert(obj.value);
		        return obj.value;  
		    }  
		} 
		
		$(function(){
			$("#loadFile").change(function () {  
		        var strSrc = $("#loadFile").val();  
		        alert(strSrc);
		        img = new Image();  
		        img.src = getFullPath(strSrc);  
		       	 //验证上传文件格式是否正确  
		        /* var pos = strSrc.lastIndexOf(".");  
		        var lastname = strSrc.substring(pos, strSrc.length);
		        if (lastname.toLowerCase() != ".jpg") {  
		            alert("您上传的文件类型为" + lastname + "，图片必须为 JPG 类型");  
		            return false;  
		        }  
		        //验证上传文件宽高比例  
		 
		        if (img.height / img.width > 1.5 || img.height / img.width < 1.25) {  
		            alert("您上传的图片比例超出范围，宽高比应介于1.25-1.5");  
		            return;  
		        }  
		        //验证上传文件是否超出了大小  
		        if (img.fileSize / 1024 > 150) {  
		            alert("您上传的文件大小超出了150K限制！");  
		            return false;  
		        } 	 */									
		        alert(getFullPath(this));
		        $("#stuPic").attr("src", getFullPath(this));
	   	 	});
		});
		
        
		
	</script>
</head>

<body>

<form>
	<img alt="图片" src="" id="stuPic" style="width:200px;height:200px;"/>
	<input type="file" id="loadFile" name="loadFile"/>
</form>

</body></html>