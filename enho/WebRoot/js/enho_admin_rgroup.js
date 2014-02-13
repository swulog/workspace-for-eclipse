function addRgroup(gridid){
  			if(isEmpty($("#rgroupname_add").val())){
  				$.messager.alert('提示',"规则组名称不能为空");
  				return;
  			}
  			if($("#rgroupname_add").val().length>5){
  				$.messager.alert('提示',"规则组名称不能超过5个字符");
  				return;
  			}
  			if(!isEmpty($("#rgroupcode_add").val()) && ($("#rgroupcode_add").val().length>5)){
  				$.messager.alert('提示',"规则编码不能超过5个字符");
  				return;
  			}
  			if(!isEmpty($("#rgroupdesc_add").val()) && ($("#rgroupdesc_add").val().length>50)){
  				$.messager.alert('提示',"规则组描述不能超过50个字符");
  				return;
  			}
  			$("#addrgroupform").ajaxSubmit(function(data){
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
function updateRgroup(gridid){
	if(!isEmpty($("#rgroupcode_update").val()) && ($("#rgroupcode_update").val().length>5)){
			$.messager.alert('提示',"规则编码不能超过5个字符");
			return;
		}
	if(!isEmpty($("#rgroupdesc_update").val()) && ($("#rgroupdesc_update").val().length>50)){
			$.messager.alert('提示',"规则描述不能超过50个字符");
			return;
	}
	$("#updatergroupform").ajaxSubmit(function(data){
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

function searchRGroup(nodeid){
	if(!isEmpty($("#name_rgsearch").val()) && ($("#name_rgsearch").val().length>5)){
		$.messager.alert('提示',"规则组名称不能超过5个字符");
		return;
	}
	var queryParams={
		name:$("#name_rgsearch").val(),
		isabled:$("#isabled_rgsearch").val()
	};
	var gridparam={
		url:InitCfg[nodeid+"_qry"],
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

function cancleAddRgroup(){
	$('#win').window('close');
}

function cancleUpdateRgroup(){
	$('#win').window('close');
}