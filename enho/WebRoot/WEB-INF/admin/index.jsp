<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>即时货运后台管理系统</title>
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>css/easyui/themes/icon.css">
<script type="text/javascript" src="<%=basePath%>js/easyui/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery.form.js"></script>
<script type="text/javascript" src="<%=basePath%>js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/city/public-script.js"></script>
<script type="text/javascript" src="<%=basePath%>js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_comm.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_init.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_rgroup.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_rule.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_user.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_goods.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_car.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_feedback.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_app.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_notice.js"></script>
<script type="text/javascript" src="<%=basePath%>js/enho_admin_appdoc.js"></script>
<style type="text/css">
	html,body {
		width: 100%;
		height: 100%;
		margin: 0px;
		overflow: auto;
	}
	#foot{
	    		width:100%;
	    		margin:auto;
	    		text-align:center;
	}
	.exit{
	    		float:right;
	    		margin-top:30px;
	    		margin-right:30px;
	}
	select{
		width:150px;
	}
</style>
<script type="text/javascript">
	$(function(){
		$('#enho_tree').tree({
			onClick: function(node){
					//非叶子节点
					if(!$('#enho_tree').tree('isLeaf',node.target)){
						return;
					}
					$('#enho_tabs').css("display","block");
					//检测是否存在
					if($('#enho_tabs').tabs('exists',node.text)){
						$('#enho_tabs').tabs('select',node.text);
						$('#grid_'+node.id).datagrid('reload');
						return;
					}
					
					InitCfg[node.id](node);
				}
		});
	});
	
	
</script>
</head>

<body>
	<div id="enho_layout" class="easyui-layout" style="width:100%;height:100%;" data-options="fit:true,resize:false">
		<div data-options="region:'north',collapsible:false,minHeight:60,maxHeight:60" style="height:60px;">
			<a href='###' class='exit'>退出系统</a>
		</div>
		<div data-options="region:'west',title:'菜单',minWidth:150,maxWidth:150" style="width:150px;">
			<ul id="enho_tree" class="easyui-tree" data-options="url:'mg/getMenu.do'"></ul>
		</div>
		<div data-options="region:'center',title:'内容'" style="padding:5px;background:#eee;width:100%;">
			<div id="enho_tabs" class="easyui-tabs" style="width:100%;height:100%;display:none;" data-options="fit:true">
			</div>
		</div>
		<div id="foot" data-options="region:'south',collapsible:false,minHeight:30,maxHeight:30" style="height:30px;">
			<span style='color:gray;text-align:center;'>Copyright © 重庆宏程万里科技有限公司</span>
		</div>
	</div>
	<div id="win"></div>
</body>
</html>
