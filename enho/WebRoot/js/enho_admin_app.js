function addApp(gridid){
			if(isEmpty($("#appkey_add").val())){
				$.messager.alert('提示',"App key不能为空");
				return;
			}
			if($("#appkey_add").val().length>20){
				$.messager.alert('提示',"App key不能超过20个字符");
				return;
			}
  			if(isEmpty($("#appversion_add").val())){
  				$.messager.alert('提示',"App版本不能为空");
  				return;
  			}
  			if($("#appversion_add").val().length>10){
  				$.messager.alert('提示',"App版本不能超过10字符");
  				return;
  			}
  			if(isEmpty($("#appfile_add").val())){
  				$.messager.alert('提示',"请选择要上传的App文件");
  				return;
  			}
  			if(!isEmpty($("#appname_add").val()) && $("#appname_add").val().length>20){
  				$.messager.alert('提示',"App名称不能超过20个字符");
  				return;
  			}
  			if(!isEmpty($("#appdesc_add").val()) && ($("#appdesc_add").val().length>200)){
  				$.messager.alert('提示',"App描述不能超过200个字符");
  				return;
  			}
  			$("#addappform").ajaxSubmit(function(data){
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
function updateApp(gridid){
		if(!isEmpty($("#appname_update").val()) && $("#appname_update").val().length>20){
			$.messager.alert('提示',"App名称不能超过20个字符");
			return;
		}
		if(isEmpty($("#appversion_update").val())){
			$.messager.alert('提示',"App版本不能为空");
			return;
		}
		if($("#appversion_update").val().length>10){
			$.messager.alert('提示',"App版本不能超过10字符");
			return;
		}
		
		if(!isEmpty($("#appdesc_update").val()) && ($("#appdesc_update").val().length>200)){
			$.messager.alert('提示',"App描述不能超过200个字符");
			return;
		}
		$("#updateappform").ajaxSubmit(function(data){
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

function cancleAddApp(){
	$('#win').window('close');
}

function cancleUpdateApp(){
	$('#win').window('close');
}