package com.university.utils;

import java.util.List;

public class PageModel<T> {

	private int count;//总条数
	private int size=10;//每页显示条数
	private int thisPage=1;//当前页
	private int sumPage;//总页数
	private List<T> list;//数据
	
	private int pre;//上一页
	private int next;//下一页
	private int first;//首页
	private int last;//尾页
	
	private String name;//属性名
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getCount() {
		return count;
	}
	
	//设置总条数（同时设置总页数）
	public void setCount(int count) {
		sumPage=(int)Math.ceil((double)count/size);
		this.count = count;
	}
	
	public int getSize() {
		return size;
	}
	public void setSize(int size) {
		this.size = size;
	}
	public int getThisPage() {
		return thisPage;
	}
	
	//设置当前页（同时设置首页、上一页、下一页、尾页）
	public void setThisPage(int thisPage) {
		pre=thisPage-1<=1?1:thisPage-1;
		next=thisPage+1>=sumPage?sumPage:thisPage+1;
		last=sumPage;
		first=1;
		this.thisPage = thisPage;
	}
	
	public int getSumPage() {
		return sumPage;
	}
	public List<T> getList() {
		return list;
	}
	public void setList(List<T> list) {
		this.list = list;
	}
	public int getPre() {
		return pre;
	}
	public int getNext() {
		return next;
	}
	public int getFirst() {
		return first;
	}
	public int getLast() {
		return last;
	}
}
