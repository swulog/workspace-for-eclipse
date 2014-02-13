package cn.com.enho.terminal.dto;

/**
 * 		发布车源信息参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:49:11
 */
public class PubCarDto {
	
	private String carstartp;//出发地（省）
	private String carstartc;//出发地（市）
	private String carstartd;//出发地（区）
	private String carendp;//到达地（省）
	private String carendc; //到达地（市）
	private String carendd; //到达地（区）
	
	private String wayline;//路线
	private String carno;//车牌号
	private Double carweight; //载重
	private Double carlength; //车长
	private String cardesc; //车源描述
	private String carsendtime;//发车时间
	private Double longitude; //经度
	private Double latitude; //纬度
	private String remark;//备注说明
	private String carimage;//车源图片
	private String imageurl1;//车源图片1
	private String imageurl2;//车源图片2
	private String imageurl3;//车源图片3
	private String caruserid; //发布人id
	private Integer usertype;//发布人用户类型（非空）
	private String carusername; //联系人姓名
	private String caruserphone; //联系人手机号
	private String carusertel; //联系人电话
	public String getCarstartp() {
		return carstartp;
	}
	public void setCarstartp(String carstartp) {
		this.carstartp = carstartp;
	}
	public String getCarstartc() {
		return carstartc;
	}
	public void setCarstartc(String carstartc) {
		this.carstartc = carstartc;
	}
	public String getCarstartd() {
		return carstartd;
	}
	public void setCarstartd(String carstartd) {
		this.carstartd = carstartd;
	}
	public String getCarendp() {
		return carendp;
	}
	public void setCarendp(String carendp) {
		this.carendp = carendp;
	}
	public String getCarendc() {
		return carendc;
	}
	public void setCarendc(String carendc) {
		this.carendc = carendc;
	}
	public String getCarendd() {
		return carendd;
	}
	public void setCarendd(String carendd) {
		this.carendd = carendd;
	}
	public String getCarno() {
		return carno;
	}
	public void setCarno(String carno) {
		this.carno = carno;
	}
	public Double getCarweight() {
		return carweight;
	}
	public void setCarweight(Double carweight) {
		this.carweight = carweight;
	}
	public Double getCarlength() {
		return carlength;
	}
	public void setCarlength(Double carlength) {
		this.carlength = carlength;
	}
	public String getCardesc() {
		return cardesc;
	}
	public void setCardesc(String cardesc) {
		this.cardesc = cardesc;
	}
	public String getCarsendtime() {
		return carsendtime;
	}
	public void setCarsendtime(String carsendtime) {
		this.carsendtime = carsendtime;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public String getImageurl1() {
		return imageurl1;
	}
	public void setImageurl1(String imageurl1) {
		this.imageurl1 = imageurl1;
	}
	public String getImageurl2() {
		return imageurl2;
	}
	public void setImageurl2(String imageurl2) {
		this.imageurl2 = imageurl2;
	}
	public String getImageurl3() {
		return imageurl3;
	}
	public void setImageurl3(String imageurl3) {
		this.imageurl3 = imageurl3;
	}
	public String getCaruserid() {
		return caruserid;
	}
	public void setCaruserid(String caruserid) {
		this.caruserid = caruserid;
	}
	public String getCarusername() {
		return carusername;
	}
	public void setCarusername(String carusername) {
		this.carusername = carusername;
	}
	public String getCaruserphone() {
		return caruserphone;
	}
	public void setCaruserphone(String caruserphone) {
		this.caruserphone = caruserphone;
	}
	public String getCarusertel() {
		return carusertel;
	}
	public void setCarusertel(String carusertel) {
		this.carusertel = carusertel;
	}
	public Integer getUsertype() {
		return usertype;
	}
	public void setUsertype(Integer usertype) {
		this.usertype = usertype;
	}
	public String getWayline() {
		return wayline;
	}
	public void setWayline(String wayline) {
		this.wayline = wayline;
	}
	public String getCarimage() {
		return carimage;
	}
	public void setCarimage(String carimage) {
		this.carimage = carimage;
	}
}
