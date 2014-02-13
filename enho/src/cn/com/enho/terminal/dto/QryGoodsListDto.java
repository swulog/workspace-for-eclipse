package cn.com.enho.terminal.dto;

/**
 * 		查询货源信息列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 下午2:27:52
 */
public class QryGoodsListDto {

	private String goodsstartp;//出发地（省）
	private String goodsstartc;//出发地（市）
	private String goodsstartd;//出发地（区）
	private String goodsendp; //到达地（省）
	private String goodsendc; //到达地（市）
	private String goodsendd; //到达地（区）
	private String userid;//发布人id
	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	
	private String baseurl;
	
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
	public Integer getCurrentpage() {
		return currentpage;
	}
	public void setCurrentpage(Integer currentpage) {
		this.currentpage = currentpage;
	}
	public Integer getPagesize() {
		return pagesize;
	}
	public void setPagesize(Integer pagesize) {
		this.pagesize = pagesize;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getBaseurl() {
		return baseurl;
	}
	public void setBaseurl(String baseurl) {
		this.baseurl = baseurl;
	}
	
}
