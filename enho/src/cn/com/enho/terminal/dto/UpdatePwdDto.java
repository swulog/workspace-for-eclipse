package cn.com.enho.terminal.dto;

/**
 * 		修改密码参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-25 下午4:02:17
 */
public class UpdatePwdDto {

	private String userid;
	private String useroldpwd;
	private String usernewpwd;
	private String confirmpwd;
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUseroldpwd() {
		return useroldpwd;
	}
	public void setUseroldpwd(String useroldpwd) {
		this.useroldpwd = useroldpwd;
	}
	public String getUsernewpwd() {
		return usernewpwd;
	}
	public void setUsernewpwd(String usernewpwd) {
		this.usernewpwd = usernewpwd;
	}
	public String getConfirmpwd() {
		return confirmpwd;
	}
	public void setConfirmpwd(String confirmpwd) {
		this.confirmpwd = confirmpwd;
	}
}
