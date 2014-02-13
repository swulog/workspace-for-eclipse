function addRule(gridid){
			if(isEmpty($("#rulename_add").val())){
				$.messager.alert('提示',"规则名称不能为空");
				return;
			}
			if($("#rulename_add").val().length>20){
				$.messager.alert('提示',"规则名称不能超过20个字符");
				return;
			}
  			if(isEmpty($("#rulekey_add").val())){
  				$.messager.alert('提示',"规则key不能为空");
  				return;
  			}
  			if($("#rulekey_add").val().length>20){
  				$.messager.alert('提示',"规则key不能超过20个字符");
  				return;
  			}
  			if(!isEmpty($("#rulevalue_add").val()) && $("#rulevalue_add").val().length>20){
  				$.messager.alert('提示',"规则value不能超过20个字符");
  				return;
  			}
  			if(isEmpty($("#rulegroupid_add").val())){
  				$.messager.alert('提示',"规则所属组不能为空");
  				return;
  			}
  			if(!isEmpty($("#ruledesc_add").val()) && ($("#ruledesc_add").val().length>50)){
  				$.messager.alert('提示',"规则描述不能超过50个字符");
  				return;
  			}
  			$("#addruleform").ajaxSubmit(function(data){
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
function updateRule(gridid){
		if(isEmpty($("#rulename_update").val())){
			$.messager.alert('提示',"规则名称不能为空");
			return;
		}
		if($("#rulename_update").val().length>20){
			$.messager.alert('提示',"规则名称不能超过20个字符");
			return;
		}
		if(!isEmpty($("#rulevalue_update").val()) && $("#rulevalue_update").val().length>20){
			$.messager.alert('提示',"规则value不能超过20个字符");
			return;
		}
		if(isEmpty($("#rulegroupid_update").val())){
			$.messager.alert('提示',"规则所属组不能为空");
			return;
		}
		if(!isEmpty($("#ruledesc_update").val()) && ($("#ruledesc_update").val().length>50)){
			$.messager.alert('提示',"规则描述不能超过50个字符");
			return;
		}
		$("#updateruleform").ajaxSubmit(function(data){
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

function searchRule(nodeid){
	if(!isEmpty($("#name_rsearch").val()) && $("#name_rsearch").val().length>20){
			$.messager.alert('提示',"规则名称不能超过20个字符");
			return;
	}
	if(!isEmpty($("#key_rsearch").val()) && $("#key_rsearch").val().length>20){
		$.messager.alert('提示',"规则key不能超过20个字符");
		return;
	}
	var queryParams={
		name:$("#name_rsearch").val(),
		key:$("#key_rsearch").val(),
		groupid:$("#groupid_rsearch").val(),
		isabled:$("#isabled_rsearch").val()
	};
	var gridparam={
		url:InitCfg[nodeid+"_qry"],
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

function cancleAddRule(){
	$('#win').window('close');
}

function cancleUpdateRule(){
	$('#win').window('close');
}