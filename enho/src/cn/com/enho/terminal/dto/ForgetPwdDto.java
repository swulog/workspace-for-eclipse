package cn.com.enho.terminal.dto;

/**
 * 		找回密码参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-19 下午3:16:34
 */
public class ForgetPwdDto {

	private String phoneno;//手机号码（非空）
	private String verificationcode;//短信验证码（非空）
	private String newpwd;//新密码（非空）
	private String confirmpwd;//确认密码（非空）
	public String getPhoneno() {
		return phoneno;
	}
	public void setPhoneno(String phoneno) {
		this.phoneno = phoneno;
	}
	public String getVerificationcode() {
		return verificationcode;
	}
	public void setVerificationcode(String verificationcode) {
		this.verificationcode = verificationcode;
	}
	public String getNewpwd() {
		return newpwd;
	}
	public void setNewpwd(String newpwd) {
		this.newpwd = newpwd;
	}
	public String getConfirmpwd() {
		return confirmpwd;
	}
	public void setConfirmpwd(String confirmpwd) {
		this.confirmpwd = confirmpwd;
	}
}
