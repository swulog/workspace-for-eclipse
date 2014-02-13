package cn.com.enho.mg.dto;

/**
 * 		查询车源信息列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午10:09:09
 */
public class QryCarListDto {

	private String startp;//出发地（省）
	private String startc;//出发地（市）
	private String startd;//出发地（区）
	private String endp; //到达地（省）
	private String endc; //到达地（市）
	private String endd; //到达地（区）
	private String userid;//发布人id
	private Integer page; //请求页
	private Integer rows; //每页记录数
	
	private String baseurl;
	
	public String getStartp() {
		return startp;
	}
	public void setStartp(String startp) {
		this.startp = startp;
	}
	public String getStartc() {
		return startc;
	}
	public void setStartc(String startc) {
		this.startc = startc;
	}
	public String getStartd() {
		return startd;
	}
	public void setStartd(String startd) {
		this.startd = startd;
	}
	public String getEndp() {
		return endp;
	}
	public void setEndp(String endp) {
		this.endp = endp;
	}
	public String getEndc() {
		return endc;
	}
	public void setEndc(String endc) {
		this.endc = endc;
	}
	public String getEndd() {
		return endd;
	}
	public void setEndd(String endd) {
		this.endd = endd;
	}
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	public Integer getRows() {
		return rows;
	}
	public void setRows(Integer rows) {
		this.rows = rows;
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
