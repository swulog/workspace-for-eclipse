package cn.com.enho.terminal.dto;

/**
 * 		修改货源信息参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午4:20:30
 */
public class UpdateGoodsDto {

	private String goodsid;//id
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
	private String goodsimage;//货源图片
	private String imageurl1;//货源图片1
	private String imageurl2;//货源图片2
	private String imageurl3;//货源图片3
	private Double longitude; //经度
	private Double latitude; //纬度
	private String goodsusername; //发布人姓名
	private String goodsuserphone; //发布人手机号
	private String goodsusertel; //发布人电话
	public String getGoodsid() {
		return goodsid;
	}
	public void setGoodsid(String goodsid) {
		this.goodsid = goodsid;
	}
	
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
