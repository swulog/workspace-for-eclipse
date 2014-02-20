package com.ivorytower.app.dto;

public class SearchPostDto {
	
	//for request
	private int posttypeid;
	private String keyword;
	private int pageno;
	private int pagesize;
	
	public int getPosttypeid() {
		return posttypeid;
	}
	public void setPosttypeid(int posttypeid) {
		this.posttypeid = posttypeid;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public int getPageno() {
		return pageno;
	}
	public void setPageno(int pageno) {
		this.pageno = pageno;
	}
	public int getPagesize() {
		return pagesize;
	}
	public void setPagesize(int pagesize) {
		this.pagesize = pagesize;
	}

}
