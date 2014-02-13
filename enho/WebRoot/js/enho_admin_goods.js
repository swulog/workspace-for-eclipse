function addGoods(gridid){
		if(isEmpty($("#startp_gadd").find("option:selected").text())){
			$.messager.alert('提示',"出发省不能为空");
			return;
		}
		if(isEmpty($("#endp_gadd").find("option:selected").text())){
			$.messager.alert('提示',"到达省不能为空");
			return;
		}
		if(isEmpty($("#desc_gadd").val())){
			$.messager.alert('提示',"货源描述不能为空");
			return;
		}
		if($("#desc_gadd").val().length>100){
			$.messager.alert('提示',"货源描述不能超过100个字符");
			return;
		}
		if(isEmpty($("#weight_gadd").val())){
			$.messager.alert('提示',"货源重量不能为空");
			return;
		}
		if(!(/^\d+(\.\d+)?$/.test($("#weight_gadd").val()))){
			$.messager.alert('提示',"货源重量格式不正确");
			return;
		}
		if(isEmpty($("#carlength_gadd").val())){
			$.messager.alert('提示',"所需车长不能为空");
			return;
		}
		if(!(/^\d+(\.\d+)?$/.test($("#carlength_gadd").val()))){
			$.messager.alert('提示',"所需车长格式不正确");
			return;
		}
		if(isEmpty($("#user_gadd").val())){
			$.messager.alert('提示',"发布人手机不能为空");
			return;
		}
		if(!(/^(1(([35][0-9])|(47)|[8][0123456789]))\d{8}$/.test($("#user_gadd").val()))){
			$.messager.alert('提示',"发布人手机格式不正确");
			return;
		}
		if(isEmpty($("#username_gadd").val())){
			$.messager.alert('提示',"联系人名称不能为空");
			return;
		}
		if($("#username_gadd").val().length>20){
			$.messager.alert('提示',"联系人名称长度不能超过20个字符");
			return;
		}
		if(isEmpty($("#userphone_gadd").val())){
			$.messager.alert('提示',"联系人手机不能为空");
			return;
		}
		if(!(/^(1(([35][0-9])|(47)|[8][0123456789]))\d{8}$/.test($("#userphone_gadd").val()))){
			$.messager.alert('提示',"联系人手机格式不正确");
			return;
		}
		if(!isEmpty($("#usertel_gadd").val()) && !(/\d{2,5}-\d{7,8}/.test($("#usertel_gadd").val()))){
			$.messager.alert('提示',"电话号码格式不正确");
			return;
		}
		if(!isEmpty($("#longitude_gadd").val()) && !(/^\d+(\.\d+)?$/.test($("#longitude_gadd").val()))){
			$.messager.alert('提示',"经度格式不正确");
			return;
		}
		if(!isEmpty($("#latitude_gadd").val()) && !(/^\d+(\.\d+)?$/.test($("#latitude_gadd").val()))){
			$.messager.alert('提示',"纬度格式不正确");
			return;
		}
		if(!isEmpty($("#remark_gadd").val()) && $("#remark_gadd").val().length>100){
			$.messager.alert('提示',"备注不能超过100个字符");
			return;
		}
		
		$("#hstartp").val($("#startp_gadd").find("option:selected").text());
		$("#hstartc").val($("#startc_gadd").find("option:selected").text());
		$("#hstartd").val($("#startd_gadd").find("option:selected").text());
		$("#hendp").val($("#endp_gadd").find("option:selected").text());
		$("#hendc").val($("#endc_gadd").find("option:selected").text());
		$("#hendd").val($("#endd_gadd").find("option:selected").text());
		
		$("#addgoodsform").ajaxSubmit(function(data){
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

function updateGoods(gridid){
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

function searchGoods(nodeid){
	var queryParams={
			startp:$("#startp_gsearch").val(),
			startc:$("#startc_gsearch").val(),
			startd:$("#startd_gsearch").val(),
			endp:$("#endp_gsearch").val(),
			endc:$("#endc_gsearch").val(),
			endd:$("#endd_gsearch").val()
		};
	var gridparam={
			url:InitCfg[nodeid+"_qry"],
			queryParams:queryParams,
			loadMsg:"数据加载中...",
			columns:[[ 
			          			 {field:'deal',title:'操作',width:100,checkbox:true}, 			       
								/* {field:'startp',title:'出发省',width:100},        
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