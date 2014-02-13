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
		"feedbackmg_qry":"mg/qryFeedbackList.do",
		"feedbackmg_dtl":"mg/qryFeedbackDtl.do",
		"feedbackmg_del":"mg/delFeedback.do",
		"appdocmg_qry":"",
		"appdocmg_add":"",
		"appdocmg_update":"",
		"appdocmg_dtl":"",
		"appdocmg_del":"",
		"appmg_qry":"mg/qryAppList.do",
		"appmg_add":"mg/addAppPre.do",
		"appmg_update":"mg/updateAppPre.do",
		"appmg_dtl":"mg/qryAppDtl.do",
		"appmg_del":"mg/delApp.do"
};

//创建选项卡
function createTab(tabsId,tabId,tabname,content,closable){
	$('#'+tabsId).tabs('add', {
					id:tabId,
					title : tabname,
					content : content,
					closable : closable
				});
}

//创建包含表格控件的选项卡
function createGridTab(tabsId,tabId,tabname,form,grid,button,closable){
	var content=form+button+grid;
	createTab(tabsId,tabId,tabname,content,closable);
}

//创建win
function createWin(nodeid,type,gridid){
	if(type=="add"){
		$('#win').window({
			width:600,    
			height:400,    
			modal:true,
			maximizable:false,
			collapsible:false,
			minimizable:false,
			resizable:false,
			title:"新增"
		});
		var url=InitCfg[nodeid+"_"+type]+"?gridid=grid_"+nodeid;
		$('#win').window('refresh', url);
	}else if(type=="update"){
		var arr=$("#"+gridid).datagrid('getSelections');
		if(!arr || arr==null || arr==undefined)return;
		if(arr && arr.length==0){
			$.messager.alert('提示',"请选择要修改的数据");
		}else if(arr && arr.length>1){
			$.messager.alert('提示',"只允许同时修改一条数据");
		}else{
			var url=InitCfg[nodeid+"_"+type]+"?gridid=grid_"+nodeid;
			var obj=arr[0];
			for(var key in obj){  
                url+="&"+key+"="+obj[key];  
            } 
			$('#win').window({
				width:600,    
				height:400,    
				modal:true,
				maximizable:false,
				collapsible:false,
				minimizable:false,
				resizable:false,
				title:"修改"
			});
			url=encodeURI(url);
			$('#win').window('refresh', url);
		}
	}else if(type="del"){
		var arr=$("#"+gridid).datagrid('getSelections');
		if(!arr || arr==null || arr==undefined)return;
		if(arr && arr.length==0){
			$.messager.alert('提示',"请选择要删除的数据");
		}else{
			$.messager.confirm('提示','您确定要删除吗?',
				function(r){
					if (r){
						var url=InitCfg[nodeid+"_"+type];
						var ids=[];
						for(var i=0,len=arr.length;i<len;i++){
							ids.push(arr[i].id);
						}
						$.ajax({
							type : "POST",
							traditional : true,
							url : url,
							data : {"id":ids},
							dataType : "json",
							success : function(data) {
								if(data.success){
									$.messager.alert('提示',data.msg);
									$('#grid_'+nodeid).datagrid('reload');    
								}else{
									$.messager.alert('提示',data.msg);
								}
							}
						});   
					}
				}
			);
		}
	}else{
	}
}


//用户管理
function initUserMg(node){
	var queryParams={usertype:1,isabled:1};
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
												return "货主";
											}else if(value=="2"){
												return "车主";
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
								 {field:'markcount',title:'被评分次数',width:100,hidden:true}
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
						width:600,    
						height:400,    
						modal:true,
						maximizable:false,
						collapsible:false,
						minimizable:false,
						resizable:false,
						title:"详情"
					});
					$('#win').window('refresh', url);
					$("#grid_"+node.id).datagrid('clearChecked');
			}

		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>用户类型：</label><select id='usertype_usearch'><option value='1'>货主</option><option value='2'>车主</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>手机号码：</label><input id='phone_usearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>是否有效：</label><select id='isabled_usearch'><option value='1'>有效</option><option value='2'>无效</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchUser(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
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
								 {field:'startp',title:'出发省',width:100},        
								 {field:'startc',title:'出发市',width:100},   
								 {field:'startd',title:'出发区',width:100},   
								 {field:'endp',title:'到达省',width:100},   
								 {field:'endc',title:'到达市',width:100},
								 {field:'endd',title:'到达区',width:100},
								 {field:'weight',title:'重量',width:100},
								 {field:'carlength',title:'所需车长',width:100},
								 {field:'username',title:'联系人名称',width:100},
								 {field:'userphone',title:'联系人手机',width:100},
								 {field:'usertel',title:'联系人电话',width:100},
								 {field:'status',title:'货源状态',width:100},
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
					width:600,    
					height:400,    
					modal:true,
					maximizable:false,
					collapsible:false,
					minimizable:false,
					resizable:false,
					title:"详情"
				});
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
								{field:'status',title:'车源状态',width:100},
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
					width:600,    
					height:400,    
					modal:true,
					maximizable:false,
					collapsible:false,
					minimizable:false,
					resizable:false,
					title:"详情"
				});
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
	pcdinit("startp","startc","startd"); 
	pcdinit("endp","endc","endd"); 
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
						width:600,    
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
								 {field:'isabled',title:'是否启用',width:100},
								 {field:'groupname',title:'所属组名',width:100},
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'desc',title:'id',width:100,hidden:true},
								 {field:'groupid',title:'纬度',width:100,hidden:true},
								 {field:'id',title:'手机号码',width:100,hidden:true}
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
						width:600,    
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
	"<label for='name'>所属组名：</label><select id='groupid_rsearch'><option value=''>请选择</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<label for='name'>是否启用：</label><select id='isabled_rsearch'><option value='1'>启用</option><option value='2'>停用</option></select>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:searchRule(\""+node.id+"\")' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:createWin(\""+node.id+"\",\"add\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"update\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:createWin(\""+node.id+"\",\"del\",\"grid_"+node.id+"\")' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;border:0;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}


//通知信息管理
function initNoticeMg(){
	
}
//反馈信息管理
function initFeedBackMg(node){
	var queryParams={phone:1};
	var gridparam={
			url:node.attributes.url,
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true}, 
								 {field:'id',title:'id',width:100},       
								 {field:'content',title:'反馈内容',width:100},        
								 {field:'createtime',title:'创建时间',width:100},   
								 {field:'phone',title:'反馈人手机',width:100}  
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			}
		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>手机号码：</label><input id='phone_fsearch' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:search()' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:search()' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
	createGridTab('enho_tabs','tab_'+node.id,node.text,form,grid,button,true);
	$('#grid_'+node.id).datagrid(gridparam);
}

//app文档内容管理
function initAppdocMg(node){
	
	var queryParams={usertype:1};
	var gridparam={
			url:node.attributes.url,
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true}, 
								 {field:'id',title:'用户id',width:100},       
								 {field:'key',title:'手机号码',width:100},        
								 {field:'value',title:'固定电话',width:100},   
								 {field:'createtime',title:'信誉值',width:100},  
								 {field:'lastupdatetime',title:'信誉值',width:100} 
			]],				
			loadFilter: function(data){
					if (data.success){
						return data;
					} else {
						$.messager.alert('提示',data.msg);
					}
			}
		};
	
	
	var form="<fieldset style='height:30px;margin-top:10px;padding-left:10px;'>"+
	"<label for='name'>参数名称：</label><input id='phone' class='easyui-validatebox'>&nbsp;&nbsp;&nbsp;&nbsp;"+
	"<a href='javascript:search()' class='easyui-linkbutton'>查&nbsp;询</a>"+
	"</fieldset>";
	var button="<div style='margin-top:10px;padding-left:10px;padding-bottom:10px;'><a href='javascript:search()' class='easyui-linkbutton'>新&nbsp;增</a>&nbsp;&nbsp;<a href='javascript:search()' class='easyui-linkbutton'>修&nbsp;改</a>&nbsp;&nbsp;<a href='javascript:search()' class='easyui-linkbutton'>删&nbsp;除</a></div>";
	var grid="<table style='height:600px;' id=grid_"+node.id+" data-options='fitColumns:true,pagination:true,rownumbers:true,autoRowHeight:false'></table>";
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
								 {field:'key',title:'key',width:100},   
								 {field:'version',title:'value',width:100},
								 {field:'url',title:'是否启用',width:100},
								 {field:'size',title:'所属组名',width:100},
								 {field:'createtime',title:'创建时间',width:100},
								 {field:'lastupdatetime',title:'最后修改时间',width:100},
								 {field:'desc',title:'id',width:100,hidden:true},
								 {field:'id',title:'手机号码',width:100,hidden:true}
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
						width:600,    
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