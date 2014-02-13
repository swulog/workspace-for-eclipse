function addUser(gridid){
  			if(isEmpty($("#phoneno_add").val())){
  				$.messager.alert('提示',"手机号码不能为空");
  				return;
  			}
  			if(!(/^(1(([35][0-9])|(47)|[8][0123456789]))\d{8}$/.test($("#phoneno_add").val()))){
  				$.messager.alert('提示',"手机号码格式不正确");
  				return;
  			}
  			if(isEmpty($("#pwd_add").val())){
  				$.messager.alert('提示',"用户密码不能为空");
  				return;
  			}
  			if($("#pwd_add").val().length<6 || $("#pwd_add").val().length>12){
  				$.messager.alert('提示',"用户密码长度应为6-12位");
  				return;
  			}
  			if(isEmpty($("#usertype_add").val())){
  				$.messager.alert('提示',"用户类型不能为空");
  				return;
  			}
  			if(!isEmpty($("#name_add").val()) && $("#name_add").val().length>50){
  				$.messager.alert('提示',"用户名称不能超过50个字符");
  				return;
  			}
  			if(!isEmpty($("#ent_add").val()) && $("#ent_add").val().length>50){
  				$.messager.alert('提示',"所属企业不能超过50个字符");
  				return;
  			}
  			if(!isEmpty($("#tel_add").val()) && !(/\d{2,5}-\d{7,8}/.test($("#tel_add").val()))){
  				$.messager.alert('提示',"电话号码格式不正确");
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
function updateUser(gridid){
	if(isEmpty($("#phoneno_update").val())){
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
	if(!isEmpty($("#name_update").val()) && $("#name_update").val()>50){
		$.messager.alert('提示',"用户名称不能超过50个字符");
		return;
	}
	if(!isEmpty($("#tel_update").val()) && !(/\d{2,5}-\d{7,8}/.test($("#tel_update").val()))){
		$.messager.alert('提示',"固话号码格式不正确");
		return;
	}
	if(!isEmpty($("#integral_update").val()) && !(/^\d+(\.\d+)?$/.test($("#integral_update").val()))){
		$.messager.alert('提示',"积分格式不正确");
		return;
	}
	if(!isEmpty($("#integral_update").val()) && $("#integral_update").val()>20){
		$.messager.alert('提示',"积分不能超过20个字符");
		return;
	}
	if(!isEmpty($("#creditrating_update").val()) && !(/^\d+(\.\d+)?$/.test($("#creditrating_update").val()))){
		$.messager.alert('提示',"信誉值格式不正确");
		return;
	}
	if(!isEmpty($("#creditrating_update").val()) && $("#creditrating_update").val()>20){
		$.messager.alert('提示',"信誉值不能超过20个字符");
		return;
	}
	if(!isEmpty($("#x_update").val()) && !(/^\d+(\.\d+)?$/.test($("#x_update").val()))){
		$.messager.alert('提示',"经度格式不正确");
		return;
	}
	if(!isEmpty($("#x_update").val()) && $("#x_update").val()>30){
		$.messager.alert('提示',"经度不能超过30个字符");
		return;
	}
	if(!isEmpty($("#y_update").val()) && !(/^\d+(\.\d+)?$/.test($("#y_update").val()))){
		$.messager.alert('提示',"纬度格式不正确");
		return;
	}
	if(!isEmpty($("#y_update").val()) && $("#y_update").val()>20){
		$.messager.alert('提示',"纬度不能超过30个字符");
		return;
	}
	if(!isEmpty($("#invitecode").val()) && !(/^\d{5}$/.test($("#invitecode").val()))){
		$.messager.alert('提示',"邀请码格式不正确");
		return;
	}
	if(!isEmpty($("#invitecodecount").val()) && !(/^\d$/.test($("#invitecodecount").val()))){
		$.messager.alert('提示',"邀请码可用次数格式不正确");
		return;
	}
	if(!isEmpty($("#markcount").val()) && !(/^\d$/.test($("#markcount").val()))){
		$.messager.alert('提示',"被评分次数格式不正确");
		return;
	}
	
	$("#updateuserform").ajaxSubmit(function(data){
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

function searchUser(nodeid){
	if(!isEmpty($("#phone_usearch").val()) && !(/^\d+$/.test($("#phone_usearch").val()))){
		$.messager.alert('提示',"手机号码格式不正确");
		return;
	}  
	var queryParams={
		usertype:$("#usertype_usearch").val(),
		phoneno:$("#phone_usearch").val(),
		isabled:$("#isabled_usearch").val()
	};
	var gridparam={
			url:InitCfg[nodeid+"_qry"],
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
								 {field:'cardurl',title:'名片正面/省份证',width:100,hidden:true},
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

function importUser(gridid){
	var url=$("#batchuser_import").val();
	if(isEmpty(url)){
		$.messager.alert('提示',"请选择文件");
		return;
	}
	var suff=url.substring(url.lastIndexOf(".")+1);
	if(suff!="xls" && suff!="xlsx"){
		$.messager.alert('提示',"必须是xls/xlsx文件");
		return;
	}
	$("#importuserform").ajaxSubmit(function(data){
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


function cancleAddUser(){
	$('#win').window('close');
}
function cancleUpdateUser(){
	$('#win').window('close');
}
function cancleImportUser(){
	$('#win').window('close');
}