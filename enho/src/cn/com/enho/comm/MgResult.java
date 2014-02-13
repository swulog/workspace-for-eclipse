package cn.com.enho.comm;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 		结果封装类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 下午5:53:41
 */
public class MgResult {

	/**
	 * 成功标志
	 */
	private boolean success;
	/**
	 * 消息
	 */
	private String msg;
	/**
	 * 数据内容
	 */
	private List<Map<Object,Object>> rows;
	/**
	 * 总行数
	 */
	private int total;
	
	public MgResult(){
		this.rows=new ArrayList<Map<Object,Object>>();
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
	public List<Map<Object, Object>> getRows() {
		return rows;
	}

	public void setRows(List<Map<Object, Object>> rows) {
		this.rows = rows;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}
	public void clear(){
		this.success=false;
		this.msg="";
		this.rows.clear();
	}
}
