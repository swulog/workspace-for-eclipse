package com.ivorytower.comm;

import java.util.HashMap;
import java.util.Map;

/**
 * 		结果封装类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 下午5:53:41
 */
public class Result {

	/**
	 * 成功标志
	 */
	private boolean success;
	/**
	 * 消息
	 */
	private String msg;
	/**
	 * 数据
	 */
	private Map<Object,Object> data;
	
	public Result(){
		this.data=new HashMap<Object,Object>();
	}
	
	public boolean getSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Map<Object, Object> getData() {
		return data;
	}
	public void setData(Map<Object, Object> data) {
		this.data = data;
	}
	public void clear(){
		this.success=false;
		this.msg="";
		this.data.clear();
	}
}
