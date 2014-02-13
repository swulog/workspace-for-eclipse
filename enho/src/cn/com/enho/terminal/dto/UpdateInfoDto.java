package cn.com.enho.terminal.dto;

/**
 * 		修改货源，车源信息状态
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-21 下午3:53:35
 */
public class UpdateInfoDto {

	private String id;//信息id
	private String value;//
	private String type;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
}
