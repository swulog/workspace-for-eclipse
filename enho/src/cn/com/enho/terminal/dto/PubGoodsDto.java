package cn.com.enho.terminal.dto;

/**
 * 		发布货源信息参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:49:11
 */
public class PubGoodsDto {
	
	private String goodsstartp;//出发地（省）
	private String goodsstartc;//出发地（市）
	private String goodsstartd;//出发地（区）
	private String goodsendp;//到达地（省）
	private String goodsendc; //到达地（市）
	private String goodsendd; //到达地（区）
	private String wayline;
	private Double goodsweight; //货源重量
	private String goodsdesc; //货源描述
	private String goodssendtime; //发货时间
	private Double goodscarlength; //所需车长
	private String remark;//备注说明
	private String imageurl1;//货源图片1
	private String imageurl2;//货源图片2
	private String imageurl3;//货源图片3
	private String goodsimage;//货源图片
	private String goodsusername; //联系人姓名（非空）
	private String goodsuserphone; //联系人手机号（非空）
	private String goodsusertel; //联系人固话
	private Double longitude;//经度
	private Double latitude;//纬度
	private String goodsuserid; //发布人id
	private Integer usertype;//发布人用户类型
	
	public Double getGoodsweight() {
		return goodsweight;
	}
	public void setGoodsweight(Double goodsweight) {
		this.goodsweight = goodsweight;
	}
	public String getGoodsdesc() {
		return goodsdesc;
	}
	public void setGoodsdesc(String goodsdesc) {
		this.goodsdesc = goodsdesc;
	}
	public String getGoodssendtime() {
		return goodssendtime;
	}
	public void setGoodssendtime(String goodssendtime) {
		this.goodssendtime = goodssendtime;
	}
	public Double getGoodscarlength() {
		return goodscarlength;
	}
	public void setGoodscarlength(Double goodscarlength) {
		this.goodscarlength = goodscarlength;
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
	public String getGoodsusername() {
		return goodsusername;
	}
	public void setGoodsusername(String goodsusername) {
		this.goodsusername = goodsusername;
	}
	public String getGoodsuserphone() {
		return goodsuserphone;
	}
	public void setGoodsuserphone(String goodsuserphone) {
		this.goodsuserphone = goodsuserphone;
	}
	public String getGoodsusertel() {
		return goodsusertel;
	}
	public void setGoodsusertel(String goodsusertel) {
		this.goodsusertel = goodsusertel;
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
	public String getGoodsuserid() {
		return goodsuserid;
	}
	public void setGoodsuserid(String goodsuserid) {
		this.goodsuserid = goodsuserid;
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
	public String getGoodsstartp() {
		return goodsstartp;
	}
	public void setGoodsstartp(String goodsstartp) {
		this.goodsstartp = goodsstartp;
	}
	public String getGoodsstartc() {
		return goodsstartc;
	}
	public void setGoodsstartc(String goodsstartc) {
		this.goodsstartc = goodsstartc;
	}
	public String getGoodsstartd() {
		return goodsstartd;
	}
	public void setGoodsstartd(String goodsstartd) {
		this.goodsstartd = goodsstartd;
	}
	public String getGoodsendp() {
		return goodsendp;
	}
	public void setGoodsendp(String goodsendp) {
		this.goodsendp = goodsendp;
	}
	public String getGoodsendc() {
		return goodsendc;
	}
	public void setGoodsendc(String goodsendc) {
		this.goodsendc = goodsendc;
	}
	public String getGoodsendd() {
		return goodsendd;
	}
	public void setGoodsendd(String goodsendd) {
		this.goodsendd = goodsendd;
	}
	public String getGoodsimage() {
		return goodsimage;
	}
	public void setGoodsimage(String goodsimage) {
		this.goodsimage = goodsimage;
	}
	
}
