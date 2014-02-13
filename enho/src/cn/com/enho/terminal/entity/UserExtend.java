package cn.com.enho.terminal.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


/**
 * 		用户扩展信息实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:32:27
 */
@Entity
@Table(name="t_user_extend")
public class UserExtend implements Serializable{

	private static final long serialVersionUID = 1L;
	
	/**
	 * 主键，uuid
	 */
	private String t_user_id;
	/**
	 * 用户性别（1：男，2：女）
	 */
	private Integer t_user_sex=1;
	/**
	 * 用户年龄
	 */
	private Integer t_user_age=0;
	/**
	 * 身份证号
	 */
	private String t_user_idcardno;
	/**
	 * 地址  
	 */
	private String t_user_addr;
	/**
	 * 描述
	 */
	private String t_user_desc;
	/**
	 * 用户驾龄
	 */
	private Integer t_user_drivingyear=0;
	/**
	 * 驾驶证档案号
	 */
	private String t_user_fn;
	/**
	 * 保险单号
	 */
	private String t_user_policyno;
	/**
	 * 用户健康状况
	 */
	private String t_user_health;
	/**
	 * 用户头像
	 */
	private String t_user_avatar;
	/**
	 * 用户名片正面url
	 */
	private String t_user_cardurl="";
	/**
	 * 用户名片背面url
	 */
	private String t_user_bcardurl="";
	/**
	 * 营业执照
	 */
	private String t_user_blicenseurl="";
	/**
	 * 驾驶证url
	 */
	private String t_user_dlicenseurl="";
	/**
	 * 行驶证url
	 */
	private String t_user_rlicenseurl="";
	
	@Id
	public String getT_user_id() {
		return t_user_id;
	}
	public void setT_user_id(String t_user_id) {
		this.t_user_id = t_user_id;
	}
	public Integer getT_user_sex() {
		return t_user_sex;
	}
	public void setT_user_sex(Integer t_user_sex) {
		this.t_user_sex = t_user_sex;
	}
	public Integer getT_user_age() {
		return t_user_age;
	}
	public void setT_user_age(Integer t_user_age) {
		this.t_user_age = t_user_age;
	}
	public Integer getT_user_drivingyear() {
		return t_user_drivingyear;
	}
	public void setT_user_drivingyear(Integer t_user_drivingyear) {
		this.t_user_drivingyear = t_user_drivingyear;
	}
	public String getT_user_idcardno() {
		return t_user_idcardno;
	}
	public void setT_user_idcardno(String t_user_idcardno) {
		this.t_user_idcardno = t_user_idcardno;
	}
	public String getT_user_fn() {
		return t_user_fn;
	}
	public void setT_user_fn(String t_user_fn) {
		this.t_user_fn = t_user_fn;
	}
	public String getT_user_policyno() {
		return t_user_policyno;
	}
	public void setT_user_policyno(String t_user_policyno) {
		this.t_user_policyno = t_user_policyno;
	}
	public String getT_user_health() {
		return t_user_health;
	}
	public void setT_user_health(String t_user_health) {
		this.t_user_health = t_user_health;
	}
	public String getT_user_avatar() {
		return t_user_avatar;
	}
	public void setT_user_avatar(String t_user_avatar) {
		this.t_user_avatar = t_user_avatar;
	}
	public String getT_user_addr() {
		return t_user_addr;
	}
	public void setT_user_addr(String t_user_addr) {
		this.t_user_addr = t_user_addr;
	}
	public String getT_user_desc() {
		return t_user_desc;
	}
	public void setT_user_desc(String t_user_desc) {
		this.t_user_desc = t_user_desc;
	}
	public String getT_user_cardurl() {
		return t_user_cardurl;
	}
	public void setT_user_cardurl(String t_user_cardurl) {
		this.t_user_cardurl = t_user_cardurl;
	}
	public String getT_user_bcardurl() {
		return t_user_bcardurl;
	}
	public void setT_user_bcardurl(String t_user_bcardurl) {
		this.t_user_bcardurl = t_user_bcardurl;
	}
	public String getT_user_blicenseurl() {
		return t_user_blicenseurl;
	}
	public void setT_user_blicenseurl(String t_user_blicenseurl) {
		this.t_user_blicenseurl = t_user_blicenseurl;
	}
	public String getT_user_dlicenseurl() {
		return t_user_dlicenseurl;
	}
	public void setT_user_dlicenseurl(String t_user_dlicenseurl) {
		this.t_user_dlicenseurl = t_user_dlicenseurl;
	}
	public String getT_user_rlicenseurl() {
		return t_user_rlicenseurl;
	}
	public void setT_user_rlicenseurl(String t_user_rlicenseurl) {
		this.t_user_rlicenseurl = t_user_rlicenseurl;
	}
}
