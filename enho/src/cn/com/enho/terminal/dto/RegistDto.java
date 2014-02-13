package cn.com.enho.terminal.dto;

/**
 * 		注册参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-8 下午1:42:55
 */
public class RegistDto {

	/**
	 * 手机号码
	 */
	private String phoneno;
	/**
	 * 用户密码
	 */
	private String userpwd;
	/**
	 * 确认密码
	 */
	private String confirmpwd;
	/**
	 * 用户类型
	 */
	private int usertype;
	/**
	 * 短信验证码
	 */
	private String verificationcode;
	/**
	 * 邀请码
	 */
	private String invitecode;
	
	
	public String getPhoneno() {
		return phoneno;
	}
	public void setPhoneno(String phoneno) {
		this.phoneno = phoneno;
	}
	public String getUserpwd() {
		return userpwd;
	}
	public void setUserpwd(String userpwd) {
		this.userpwd = userpwd;
	}
	public String getConfirmpwd() {
		return confirmpwd;
	}
	public void setConfirmpwd(String confirmpwd) {
		this.confirmpwd = confirmpwd;
	}
	public int getUsertype() {
		return usertype;
	}
	public void setUsertype(int usertype) {
		this.usertype = usertype;
	}
	public String getVerificationcode() {
		return verificationcode;
	}
	public void setVerificationcode(String verificationcode) {
		this.verificationcode = verificationcode;
	}
	public String getInvitecode() {
		return invitecode;
	}
	public void setInvitecode(String invitecode) {
		this.invitecode = invitecode;
	}
	
}
