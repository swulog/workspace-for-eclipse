package cn.com.enho.terminal.dto;

/**
 * 		修改用户列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-14 上午10:26:28
 */
public class UpdateUserDto {

	private String userid;//用户id
	private String userphone; //用户手机号码
	private String usertel; //用户电话号码
	private Double userx; //用户经度
	private Double usery; //用户纬度
	private Integer	usertype; //用户类型
	private String username; //用户姓名
	private String userent;//所属企业
	private Integer usersex; //用户性别
	private Integer	userage; //用户年龄
	private String useraddr; //用户地址
	private String userdesc; //用户描述
	private Integer userdrivingyear; //用户驾龄
	private String useridcardno; //用户省份证号码
	private String userfn; //用户驾驶证档案号
	private String userpolicyno; //用户保险单号
	private String userhealth; //用户健康状况
	private String useravatar; //用户头像
	private String userlogo; //企业logo
	
	private String cardurl;//名片正面url
	private String bcardurl;//名片背面url
	private String blicenseurl;//营业执照url
	private String dlicenseurl;//驾驶证url
	private String rlicenseurl;//行驶证url
	
	private String baseurl;
	
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUserphone() {
		return userphone;
	}
	public void setUserphone(String userphone) {
		this.userphone = userphone;
	}
	public String getUsertel() {
		return usertel;
	}
	public void setUsertel(String usertel) {
		this.usertel = usertel;
	}
	public Double getUserx() {
		return userx;
	}
	public void setUserx(Double userx) {
		this.userx = userx;
	}
	public Double getUsery() {
		return usery;
	}
	public void setUsery(Double usery) {
		this.usery = usery;
	}
	public Integer getUsertype() {
		return usertype;
	}
	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Integer getUsersex() {
		return usersex;
	}
	public void setUsersex(Integer usersex) {
		this.usersex = usersex;
	}
	public Integer getUserage() {
		return userage;
	}
	public void setUserage(Integer userage) {
		this.userage = userage;
	}
	public String getUseraddr() {
		return useraddr;
	}
	public void setUseraddr(String useraddr) {
		this.useraddr = useraddr;
	}
	public String getUserdesc() {
		return userdesc;
	}
	public void setUserdesc(String userdesc) {
		this.userdesc = userdesc;
	}
	public Integer getUserdrivingyear() {
		return userdrivingyear;
	}
	public void setUserdrivingyear(Integer userdrivingyear) {
		this.userdrivingyear = userdrivingyear;
	}
	public String getUseridcardno() {
		return useridcardno;
	}
	public void setUseridcardno(String useridcardno) {
		this.useridcardno = useridcardno;
	}
	public String getUserfn() {
		return userfn;
	}
	public void setUserfn(String userfn) {
		this.userfn = userfn;
	}
	public String getUserpolicyno() {
		return userpolicyno;
	}
	public void setUserpolicyno(String userpolicyno) {
		this.userpolicyno = userpolicyno;
	}
	public String getUserhealth() {
		return userhealth;
	}
	public void setUserhealth(String userhealth) {
		this.userhealth = userhealth;
	}
	public String getUseravatar() {
		return useravatar;
	}
	public void setUseravatar(String useravatar) {
		this.useravatar = useravatar;
	}
	public String getUserlogo() {
		return userlogo;
	}
	public void setUserlogo(String userlogo) {
		this.userlogo = userlogo;
	}
	public String getCardurl() {
		return cardurl;
	}
	public void setCardurl(String cardurl) {
		this.cardurl = cardurl;
	}
	public String getBcardurl() {
		return bcardurl;
	}
	public void setBcardurl(String bcardurl) {
		this.bcardurl = bcardurl;
	}
	public String getBlicenseurl() {
		return blicenseurl;
	}
	public void setBlicenseurl(String blicenseurl) {
		this.blicenseurl = blicenseurl;
	}
	public String getDlicenseurl() {
		return dlicenseurl;
	}
	public void setDlicenseurl(String dlicenseurl) {
		this.dlicenseurl = dlicenseurl;
	}
	public String getRlicenseurl() {
		return rlicenseurl;
	}
	public void setRlicenseurl(String rlicenseurl) {
		this.rlicenseurl = rlicenseurl;
	}
	public String getBaseurl() {
		return baseurl;
	}
	public void setBaseurl(String baseurl) {
		this.baseurl = baseurl;
	}
	public String getUserent() {
		return userent;
	}
	public void setUserent(String userent) {
		this.userent = userent;
	}
	
}
