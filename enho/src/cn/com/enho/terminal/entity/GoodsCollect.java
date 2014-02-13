package cn.com.enho.terminal.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 		货源信息收藏关系实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:27:45
 */
@Entity
@Table(name="t_collect_goods")
public class GoodsCollect implements Serializable{

	private static final long serialVersionUID = 1L;
	/**
	 * id
	 */
	private String t_collect_goods_id;
	/**
	 * user
	 */
	private User user;
	/**
	 * goods
	 */
	private GoodsInfo goods;
	/**
	 * 收藏时间
	 */
	private String t_collect_goods_createtime;
	
	@Id
	public String getT_collect_goods_id() {
		return t_collect_goods_id;
	}
	public void setT_collect_goods_id(String t_collect_goods_id) {
		this.t_collect_goods_id = t_collect_goods_id;
	}
	@ManyToOne
	@JoinColumn(name="t_collect_goods_userid")
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	@ManyToOne
	@JoinColumn(name="t_collect_goods_goodsid")
	public GoodsInfo getGoods() {
		return goods;
	}
	public void setGoods(GoodsInfo goods) {
		this.goods = goods;
	}
	@Column(nullable=false)
	public String getT_collect_goods_createtime() {
		return t_collect_goods_createtime;
	}
	public void setT_collect_goods_createtime(String t_collect_goods_createtime) {
		this.t_collect_goods_createtime = t_collect_goods_createtime;
	}
}
