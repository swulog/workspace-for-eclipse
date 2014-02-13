function sendMsg(gridid){
	var phonenos_send=$("#phonenos_send").val();
	var msgcontent_send=$("#msgcontent_send").val();
	
	if(isEmpty(phonenos_send)){
		$.messager.alert('提示',"手机号码不能为空");
		return;
	}
	
	if(!(/^((1(([35][0-9])|(47)|[8][0123456789]))\d{8})(\,(1(([35][0-9])|(47)|[8][0123456789]))\d{8})*$/.test(phonenos_send))){
		$.messager.alert('提示',"手机号码格式不正确");
		return;
	}
	
	if(phonenos_send.split(",").length>100){
		$.messager.alert('提示',"手机号码不能超过100个");
		return;
	}
	if(isEmpty(msgcontent_send)){
		$.messager.alert('提示',"短信内容不能为空");
		return;
	}
	
	if(msgcontent_send.length>300){
		$.messager.alert('提示',"短信内容不能超过300个字");
		return;
	}
	
	$("#sendmsgform").ajaxSubmit(function(data){
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


function cancleSendMsg(){
	$('#win').window('close');
}