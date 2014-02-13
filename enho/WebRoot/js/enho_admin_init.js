InitCfg={
		"usermg":initUserMg,
		"goodsmg":initGoodsMg,
		"carmg":initCarMg,
		"rgroupmg":initRGroupMg,
		"rulemg":initRuleMg,
		"noticemg":initNoticeMg,
		"feedbackmg":initFeedBackMg,
		"appdocmg":initAppdocMg,
		"appmg":initAppMg,
		"usermg_qry":"mg/qryUserList.do",
		"usermg_add":"mg/addUserPre.do",
		"usermg_update":"mg/updateUserPre.do",
		"usermg_dtl":"mg/qryUserDtl.do",
		"usermg_del":"mg/delUser.do",
		"usermg_import":"mg/importUserPre.do",
		"goodsmg_qry":"mg/qryGoodsList.do",
		"goodsmg_add":"mg/addGoodsPre.do",
		"goodsmg_update":"mg/updateGoodsPre.do",
		"goodsmg_dtl":"mg/qryGoodsDtl.do",
		"goodsmg_del":"mg/delGoods.do",
		"carmg_qry":"mg/qryCarList.do",
		"carmg_add":"mg/addCarPre.do",
		"carmg_update":"mg/updateCarPre.do",
		"carmg_dtl":"mg/qryCarDtl.do",
		"carmg_del":"mg/delCar.do",
		"rgroupmg_qry":"mg/qryRGroupList.do",
		"rgroupmg_add":"mg/addRGroupPre.do",
		"rgroupmg_update":"mg/updateRGroupPre.do",
		"rgroupmg_dtl":"mg/qryRGroupDtl.do",
		"rgroupmg_del":"mg/delRGroup.do",
		"rulemg_qry":"mg/qryRuleList.do",
		"rulemg_add":"mg/addRulePre.do",
		"rulemg_update":"mg/updateRulePre.do",
		"rulemg_dtl":"mg/qryRuleDtl.do",
		"rulemg_del":"mg/delRule.do",
		"noticemg_qry":"",
		"noticemg_add":"",
		"noticemg_update":"",
		"noticemg_dtl":"",
		"noticemg_del":"",
		"noticemg_sendmsg":"mg/sendMsgPre.do",
		"noticemg_pushnotice":"mg/pushNoticePre.do",
		"feedbackmg_qry":"mg/qryFeedbackList.do",
		"feedbackmg_dtl":"mg/qryFeedbackDtl.do",
		"feedbackmg_del":"mg/delFeedback.do",
		"appdocmg_qry":"mg/qryAppdocList.do",
		"appdocmg_add":"mg/addAppdocPre.do",
		"appdocmg_update":"mg/updateAppdocPre.do",
		"appdocmg_dtl":"mg/qryAppdocDtl.do",
		"appdocmg_del":"mg/delAppdoc.do",
		"appmg_qry":"mg/qryAppList.do",
		"appmg_add":"mg/addAppPre.do",
		"appmg_update":"mg/updateAppPre.do",
		"appmg_dtl":"mg/qryAppDtl.do",
		"appmg_del":"mg/delApp.do"
};

//用户管理
function initUserMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true},       
								 {field:'phone',title:'手机号码',width:100},        
								 {field:'type',title:'类型',width:100,
									 formatter: function(value,row,index){
											if (value=="1"){
												return "企业商家";
											}else if(value=="2"){
												return "个人货主";
											}else if(value=="3"){
												return "货运公司";
											}else if(value=="4"){
												return "个人司机";
											}else{}
										}
								 },   
								 {field:'integral',title:'积分',width:100},   
								 {field:'creditrating',title:'信誉值',width:100},   
								 {field:'isabled',title:'是否有效',width:100,
									 formatter: function(value,row,index){
											if (value=="1"){
												return "启用";
											}else if(value=="2"){
												return "停用";
											}else{}
										}
								 },   
								 {field:'name',title:'名称',width:100,hidden:true},
								 {field:'id',title:'id',width:100,hidden:true},
								 {field:'pwd',title:'用户密码',width:100,hidden:true},
								 {field:'tel',title:'固定电话',width:100,hidden:true},
								 {field:'x',title:'经度',width:100,hidden:true},
								 {field:'y',title:'纬度',width:100,hidden:true},
								 {field:'createtime',title:'创建时间',width:100,hidden:true},  
								 {field:'lastupdatetime',title:'最后修改时间',width:100,hidden:true},
								 {field:'invitecode',title:'邀请码',width:100,hidden:true},
								 {field:'invitecodecount',title:'邀请码可用次数',width:100,hidden:true},
								 {field:'markcount',title:'被评分次数',width:100,hidden:true},
								 
								 {field:'ent',title:'所属企业',width:100,hidden:true},
								 {field:'cardurl',title:'名片正面',width:100,hidden:true},
								 {field:'bcardurl',title:'名片背面',width:100,hidden:true},
								 {field:'blicenseurl',title:'营业执照',width:100,hidden:true},
								 {field:'idcardurl',title:'身份证',width:100,hidden:true},
								 {field:'dlicenseurl',title:'驾驶证',width:100,hidden:true},
								 {field:'rlicenseurl',title:'行驶证',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>用户类型：</label><select id='usertype_usearch'><option value='0'>请选择</option><option value='1'>企业商家</option><option value='2'>个人货主</option><option value='3'>货运公司</option><option value='4'>个人司机</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>手机号码：</label><input id='phone_usearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>是否启用：</label><select id='isabled_usearch'><option value='0'>请选择</option><option value='1'>启用</option><option value='2'>停用</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchUser(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"import\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>批量导入</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}

//货源管理
function initGoodsMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true}, 			       
								 /*{field:'startp',title:'出发省',width:100},        
								 {field:'startc',title:'出发市',width:100},   
								 {field:'startd',title:'出发区',width:100},   
								 {field:'endp',title:'到达省',width:100},   
								 {field:'endc',title:'到达市',width:100},
								 {field:'endd',title:'到达区',width:100},*/
								 {field:'weight',title:'重量',width:100},
								 {field:'carlength',title:'所需车长',width:100},
								 {field:'username',title:'联系人名称',width:100},
								 {field:'userphone',title:'联系人手机',width:100},
								 {field:'usertel',title:'联系人电话',width:100},
								 {field:'status',title:'货源状态',width:100,
									 formatter: function(value,row,index){
										if (value=="1"){
											return "正常";
										}else if(value=="2"){
											return "锁定";
										}else if(value=="3"){
											return "下架";
										}else{}
									}
								 },
								 {field:'createtime',title:'发布时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'id',title:'货源id',width:100,hidden:true}, 
								 {field:'image',title:'图片',width:100,hidden:true},
								 {field:'desc',title:'描述',width:100,hidden:true},
								 {field:'sendtime',title:'发货时间',width:100,hidden:true},
								 {field:'userid',title:'发布人id',width:100,hidden:true},
								 {field:'longitude',title:'经度',width:100,hidden:true},
								 {field:'latitude',title:'纬度',width:100,hidden:true},
								 {field:'remark',title:'备注',width:100,hidden:true},
								 {field:'pubphone',title:'发布人手机',width:100,hidden:true},
								 {field:'infotype',title:'信息类型',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
				var url=InitCfg[node.id+"_dtl"]+"?1=1";
				for(var key in rowData){  
	                url+="&"+key+"="+rowData[key];  
	            } 
				$('#win').window({
					width:800,    
					height:400,    
					modal:true,
					maximizable:false,
					collapsible:false,
					minimizable:false,
					resizable:false,
					title:"详情"
				});
				url=encodeURI(url);
				$('#win').window('refresh', url);
				$("#grid_"+node.id).datagrid('clearChecked');
		}
	};
	
	
	var form="<fieldset style='height:50px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>出发地：</label><select id='startp_gsearch'><option value=''>请选择省份</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='startc_gsearch'> <option value=''>请选择城市</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='startd_gsearch'> <option value=''>请选择区县</option></select><br/>"+
	"<label for='name'>到达地：</label><select id='endp_gsearch'> <option value=''>请选择省份</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='endc_gsearch'> <option value=''>请选择城市</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='endd_gsearch'> <option value=''>请选择区县</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchGoods(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
	pcdinit("startp_gsearch","startc_gsearch","startd_gsearch"); 
	pcdinit("endp_gsearch","endc_gsearch","endd_gsearch"); 
}
//车源管理
function initCarMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
								{field:'deal',title:'操作',width:100,checkbox:true}, 			       
								{field:'startp',title:'出发省',width:100},        
								{field:'startc',title:'出发市',width:100},   
								{field:'startd',title:'出发区',width:100},   
								{field:'endp',title:'到达省',width:100},   
								{field:'endc',title:'到达市',width:100},
								{field:'endd',title:'到达区',width:100},
								{field:'carno',title:'车牌号',width:100},
								{field:'weight',title:'载重',width:100},
								{field:'carlength',title:'车长',width:100},
								{field:'username',title:'联系人名称',width:100},
								{field:'userphone',title:'联系人手机',width:100},
								{field:'usertel',title:'联系人电话',width:100},
								{field:'status',title:'车源状态',width:100,
									formatter: function(value,row,index){
										if (value=="1"){
											return "正常";
										}else if(value=="2"){
											return "锁定";
										}else if(value=="3"){
											return "下架";
										}else{}
									}
								},
								{field:'createtime',title:'发布时间',width:100},
								{field:'lastupdatetime',title:'最后修改时间',width:100},
								{field:'id',title:'车源id',width:100,hidden:true}, 
								{field:'image',title:'图片',width:100,hidden:true},
								{field:'desc',title:'描述',width:100,hidden:true},
								{field:'sendtime',title:'发货时间',width:100,hidden:true},
								{field:'userid',title:'发布人id',width:100,hidden:true},
								{field:'longitude',title:'经度',width:100,hidden:true},
								{field:'latitude',title:'纬度',width:100,hidden:true},
								{field:'remark',title:'备注',width:100,hidden:true},
								{field:'infotype',title:'信息类型',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
				var url=InitCfg[node.id+"_dtl"]+"?1=1";
				for(var key in rowData){  
	                url+="&"+key+"="+rowData[key];  
	            } 
				$('#win').window({
					width:800,    
					height:400,    
					modal:true,
					maximizable:false,
					collapsible:false,
					minimizable:false,
					resizable:false,
					title:"详情"
				});
				url=encodeURI(url);
				$('#win').window('refresh', url);
				$("#grid_"+node.id).datagrid('clearChecked');
		}
	};
	
	
	var form="<fieldset style='height:50px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>出发地：</label><select id='startp_csearch'><option value=''>请选择省份</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='startc_csearch'> <option value=''>请选择城市</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='startd_csearch'> <option value=''>请选择区县</option></select><br/>"+
	"<label for='name'>到达地：</label><select id='endp_csearch'> <option value=''>请选择省份</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='endc_csearch'> <option value=''>请选择城市</option></select>&nbsp;&nbsp;&nbsp;&nbsp;<select id='endd_csearch'> <option value=''>请选择区县</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchCar(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
	pcdinit("startp_csearch","startc_csearch","startd_csearch"); 
	pcdinit("endp_csearch","endc_csearch","endd_csearch"); 
}

//规则组管理
function initRGroupMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true},   
			          			 {field:'name',title:'名称',width:100}, 
								 {field:'code',title:'编码',width:100},   
								 {field:'isabled',title:'是否启用',width:100,
									 formatter: function(value,row,index){
										if (value=="1"){
											return "启用";
										}else if(value=="2"){
											return "停用";
										}else{}
									}
								 },
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'id',title:'id',width:100,hidden:true}, 
								 {field:'desc',title:'描述',width:100,hidden:true,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>名称：</label><input id='name_rgsearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>是否启用：</label><select id='isabled_rgsearch'><option value='0'>请选择</option><option value='1'>启用</option><option value='2'>停用</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchRGroup(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}

//规则管理
function initRuleMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true},       
								 {field:'name',title:'名称',width:100},   
								 {field:'key',title:'key',width:100},   
								 {field:'value',title:'value',width:100},
								 {field:'isabled',title:'是否启用',width:100,
									 formatter: function(value,row,index){
											if (value=="1"){
												return "启用";
											}else if(value=="2"){
												return "停用";
											}else{}
									}
								 },
								 {field:'groupname',title:'所属组',width:100},
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'desc',title:'描述',width:100,hidden:true},
								 {field:'groupid',title:'所属组',width:100,hidden:true},
								 {field:'id',title:'id',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>名称：</label><input id='name_rsearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>key：</label><input id='key_rsearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>所属组：</label><select id='groupid_rsearch'><option value=''>请选择</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>是否启用：</label><select id='isabled_rsearch'><option value='0'>请选择</option><option value='1'>启用</option><option value='2'>停用</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchRule(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	
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
				$("#groupid_rsearch").html(html);
			}else{
				alert(data.msg);
			}
		}
	});
	
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}


//通知信息管理
function initNoticeMg(node){
	/*var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true},       
								 {field:'name',title:'名称',width:100},   
								 {field:'key',title:'AppKey',width:100},   
								 {field:'version',title:'版本',width:100},
								 {field:'url',title:'路径',width:100},
								 {field:'size',title:'大小',width:100},
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'desc',title:'描述',width:100,hidden:true},
								 {field:'id',title:'id',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:600,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};*/
	var form="";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"sendmsg\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>发送短信</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"pushnotice\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>推送消息</a></div>";
	var grid="";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	//$('#grid_'+node.id).datagrid(gridparam);
}
//反馈信息管理
function initFeedBackMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true}, 
								 {field:'content',title:'反馈内容',width:100},        
								 {field:'createtime',title:'反馈时间',width:100},   
								 {field:'phone',title:'反馈人手机',width:100},
								 {field:'id',title:'id',width:100,hidden:true}  
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>手机号码：</label><input id='phone_fsearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchFeedback(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}

//app文档内容管理
function initAppdocMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true},       
								 {field:'type',title:'类型',width:100,formatter: 
									 function(value,row,index){
										if (value=="1"){
											return "关于我们";
										}else if(value=="2"){
											return "免责声明";
										}else{}
								 }},   
								 {field:'name',title:'名称',width:100},   
								 {field:'title',title:'标题',width:100},   
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'content',title:'内容',width:100,hidden:true},
								 {field:'id',title:'id',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	var form="";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}


//App管理
function initAppMg(node){
	var queryParams={};
	var gridparam={
			url:InitCfg[node.id+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true},       
								 {field:'name',title:'名称',width:100},   
								 {field:'key',title:'AppKey',width:100},   
								 {field:'version',title:'版本',width:100},
								 {field:'url',title:'路径',width:100},
								 {field:'size',title:'大小',width:100},
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'desc',title:'描述',width:100,hidden:true},
								 {field:'id',title:'id',width:100,hidden:true}
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			},
			onDblClickRow: function(rowIndex, rowData){
					var url=InitCfg[node.id+"_dtl"]+"?1=1";
					for(var key in rowData){  
		                url+="&"+key+"="+rowData[key];  
		            } 
					$('#win').window({
						width:800,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					url=encodeURI(url);
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	var form="";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}