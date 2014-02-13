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
			width:800,    
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
				width:800,    
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
	}else if(type=="del"){
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
	}else if(type=="import"){
		$('#win').window({
			width:800,    
			height:400,    
			modal:true,
			maximizable:false,
			collapsible:false,
			minimizable:false,
			resizable:false,
			title:"批量导入"
		});
		var url=InitCfg[nodeid+"_"+type]+"?gridid=grid_"+nodeid;
		$('#win').window('refresh', url);
	}else if(type=="sendmsg"){
		$('#win').window({
			width:800,    
			height:400,    
			modal:true,
			maximizable:false,
			collapsible:false,
			minimizable:false,
			resizable:false,
			title:"发送短信"
		});
		var url=InitCfg[nodeid+"_"+type]+"?gridid=grid_"+nodeid;
		$('#win').window('refresh', url);
	}else if(type=="pushnotice"){
		$('#win').window({
			width:800,    
			height:400,    
			modal:true,
			maximizable:false,
			collapsible:false,
			minimizable:false,
			resizable:false,
			title:"推送通知"
		});
		var url=InitCfg[nodeid+"_"+type]+"?gridid=grid_"+nodeid;
		$('#win').window('refresh', url);
	}else{}
}

function isEmpty(value){
	if(value!=null && value!="" && value!=undefined && value!="null" && value!="undefined"){
		return false;
	}else{
		return true;
	}
}