function addAppdoc(gridid){
	var appdoctype_add=$("#appdoctype_add").val();
	var appdoccontent_add=$("#appdoccontent_add").val();
	
	if(isEmpty(appdoctype_add)){
		$.messager.alert('提示',"类型不能为空");
		return;
	}
	if(isEmpty(appdoccontent_add)){
		$.messager.alert('提示',"内容不能为空");
		return;
	}
	
	if(!isEmpty($("#appdocname_add").val()) && $("#appdocname_add").val().length>50){
		$.messager.alert('提示',"名称不能超过50个字");
		return;
	}
	if(!isEmpty($("#appdoctitle_add").val()) && $("#appdoctitle_add").val().length>50){
		$.messager.alert('提示',"标题不能超过50个字");
		return;
	}
	if(appdoccontent_add.length>65535){
		$.messager.alert('提示',"内容不能超过64K");
		return;
	}
	
	$("#addappdocform").ajaxSubmit(function(data){
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

function updateAppdoc(gridid){
	var appdoccontent_update=$("#appdoccontent_update").val();
	
	if(isEmpty(appdoccontent_update)){
		$.messager.alert('提示',"内容不能为空");
		return;
	}
	
	if(!isEmpty($("#appdocname_update").val()) && $("#appdocname_update").val().length>50){
		$.messager.alert('提示',"名称不能超过50个字");
		return;
	}
	if(!isEmpty($("#appdoctitle_update").val()) && $("#appdoctitle_update").val().length>50){
		$.messager.alert('提示',"标题不能超过50个字");
		return;
	}
	if(appdoccontent_update.length>65535){
		$.messager.alert('提示',"内容不能超过64K");
		return;
	}
	
	$("#updateappdocform").ajaxSubmit(function(data){
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



function cancleAddAppdoc(){
	$('#win').window('close');
}
function cancleUpdateAppdoc(){
	$('#win').window('close');
}