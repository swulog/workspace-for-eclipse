function searchFeedback(nodeid){
	var phone=$("#phone_fsearch").val();
	if(!isEmpty(phone) && !phone.match(/^(1(([35][0-9])|(47)|[8][0126789]))\\d{8}$/)){
		$.messager.alert('提示',"手机号码格式不正确");
		return;
	}
	var queryParams={
		phone:phone
	};
	var gridparam={
			url:InitCfg[nodeid+"_qry"],
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
					var url=InitCfg[nodeid+"_dtl"]+"?1=1";
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
					$("#grid_"+nodeid).datagrid('clearChecked');
			}

	};
	$('#grid_'+nodeid).datagrid(gridparam);
}
