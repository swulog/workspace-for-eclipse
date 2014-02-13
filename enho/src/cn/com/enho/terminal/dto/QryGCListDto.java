package cn.com.enho.terminal.dto;

/**
 * 		查询车源货源列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-29 上午10:08:41
 */
public class QryGCListDto {

	private String startp;//出发地（省）
	private String startc;//出发地（市）
	private String startd;//出发地（区）
	private String endp; //到达地（省）
	private String endc; //到达地（市）
	private String endd; //到达地（区）
	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	private Integer flag;//分页标志（1：不分页，2：分页，默认分页）
	private String userid;//发布人id
	
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

	public String getBaseurl() {
		return baseurl;
	}

	public void setBaseurl(String baseurl) {
		this.baseurl = baseurl;
	}

	public Integer getFlag() {
		return flag;
	}

	public void setFlag(Integer flag) {
		this.flag = flag;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}
	
}
