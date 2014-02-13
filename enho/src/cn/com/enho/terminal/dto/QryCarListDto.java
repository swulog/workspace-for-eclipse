package cn.com.enho.terminal.dto;

/**
 * 		查询车源信息列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午10:09:09
 */
public class QryCarListDto {

	private String carstartp;//出发地（省）
	private String carstartc;//出发地（市）
	private String carstartd;//出发地（区）
	private String carendp; //到达地（省）
	private String carendc; //到达地（市）
	private String carendd; //到达地（区）
	private String userid;//发布人id
	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	private String baseurl;
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
