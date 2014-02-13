function addCar(gridid){
		if(isEmpty($("#phoneno").val())){
			$.messager.alert('提示',"手机号码不能为空");
			return;
		}
		if(!(/^(1(([35][0-9])|(47)|[8][0123456789]))\d{8}$/.test($("#phoneno").val()))){
			$.messager.alert('提示',"手机号码格式不正确");
			return;
		}
		if(isEmpty($("#pwd").val())){
			$.messager.alert('提示',"用户密码不能为空");
			return;
		}
		if($("#pwd").val().length<6 || $("#pwd").val().length>12){
			$.messager.alert('提示',"用户密码长度应为6-12位");
			return;
		}
		if(isEmpty($("#usertype").val())){
			$.messager.alert('提示',"用户类型不能为空");
			return;
		}
		
		$("#adduserform").ajaxSubmit(function(data){
				var data=$.parseJSON(data);
				if(data.success){
					$.messager.alert('提示',data.msg);
					$('#win').window('close');
					$('#'+gridid).datagrid('reload');    
				}else{
					$.messager.alert('提示',data.msg);
				}
	});
}

function updateCar(gridid){
	if(isEmpty($("#phoneno").val())){
		$.messager.alert('提示',"手机号码不能为空");
		return;
	}
	if(!(/^(1(([35][0-9])|(47)|[8][0123456789]))\d{8}$/.test($("#phoneno").val()))){
		$.messager.alert('提示',"手机号码格式不正确");
		return;
	}
	if(isEmpty($("#pwd").val())){
		$.messager.alert('提示',"用户密码不能为空");
		return;
	}
	if($("#pwd").val().length<6 || $("#pwd").val().length>12){
		$.messager.alert('提示',"用户密码长度应为6-12位");
		return;
	}
	if(isEmpty($("#usertype").val())){
		$.messager.alert('提示',"用户类型不能为空");
		return;
	}
	
	$("#adduserform").ajaxSubmit(function(data){
			var data=$.parseJSON(data);
			if(data.success){
				$.messager.alert('提示',data.msg);
				$('#win').window('close');
				$('#'+gridid).datagrid('reload');    
			}else{
				$.messager.alert('提示',data.msg);
			}
});
}

function searchCar(nodeid){
	var queryParams={
			startp:$("#startp_csearch").val(),
			startc:$("#startc_csearch").val(),
			startd:$("#startd_csearch").val(),
			endp:$("#endp_csearch").val(),
			endc:$("#endc_csearch").val(),
			endd:$("#endd_csearch").val()
	};
	var gridparam={
			url:InitCfg[nodeid+"_qry"],
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
								}},
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
				$('#win').window('refresh', url);
				$("#grid_"+nodeid).datagrid('clearChecked');
		}
	};
	$('#grid_'+nodeid).datagrid(gridparam);
}