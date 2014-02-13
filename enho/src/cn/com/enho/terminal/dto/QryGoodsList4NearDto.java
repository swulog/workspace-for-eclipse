package cn.com.enho.terminal.dto;

/**
 * 		查询附近货源信息列表参数
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-12 上午10:09:09
 */
public class QryGoodsList4NearDto {

	private Double longitude;//经度
	private Double latitude;//纬度
	private Integer currentpage; //请求页
	private Integer pagesize; //每页记录数
	private Integer flag;//分页标志（1：不分页，2：分页）
	
	private String baseurl;
	
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
	public Integer getFlag() {
		return flag;
	}
	public void setFlag(Integer flag) {
		this.flag = flag;
	}
	public String getBaseurl() {
		return baseurl;
	}
	public void setBaseurl(String baseurl) {
		this.baseurl = baseurl;
	}
	
}
