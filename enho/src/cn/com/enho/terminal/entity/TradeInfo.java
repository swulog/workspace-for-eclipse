package cn.com.enho.terminal.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 交易记录实体类
 * @author xionglei
 *
 */
@Entity
@Table(name="t_trade")
public class TradeInfo {

	private String t_trade_id;
	private String t_trade_goodsid;
	private String t_trade_carid;
	private String t_trade_goodsname;
	private String t_trade_carname;
	private String t_trade_goodsphone;
	private String t_trade_carphone;
	private Integer t_trade_ismark_gc=1;
	private Integer t_trade_ismark_cg=1;
	private Double t_trade_score_gc=0.0;
	private Double t_trade_score_cg=0.0;
	private String t_trade_createtime;
	private String t_trade_marktime;
	private Integer t_trade_type;
	
	@Id
	public String getT_trade_id() {
		return t_trade_id;
	}
	public void setT_trade_id(String t_trade_id) {
		this.t_trade_id = t_trade_id;
	}
	public String getT_trade_goodsid() {
		return t_trade_goodsid;
	}
	public void setT_trade_goodsid(String t_trade_goodsid) {
		this.t_trade_goodsid = t_trade_goodsid;
	}
	public String getT_trade_carid() {
		return t_trade_carid;
	}
	public void setT_trade_carid(String t_trade_carid) {
		this.t_trade_carid = t_trade_carid;
	}
	public String getT_trade_goodsname() {
		return t_trade_goodsname;
	}
	public void setT_trade_goodsname(String t_trade_goodsname) {
		this.t_trade_goodsname = t_trade_goodsname;
	}
	public String getT_trade_carname() {
		return t_trade_carname;
	}
	public void setT_trade_carname(String t_trade_carname) {
		this.t_trade_carname = t_trade_carname;
	}
	public String getT_trade_goodsphone() {
		return t_trade_goodsphone;
	}
	public void setT_trade_goodsphone(String t_trade_goodsphone) {
		this.t_trade_goodsphone = t_trade_goodsphone;
	}
	public String getT_trade_carphone() {
		return t_trade_carphone;
	}
	public void setT_trade_carphone(String t_trade_carphone) {
		this.t_trade_carphone = t_trade_carphone;
	}
	public Integer getT_trade_ismark_gc() {
		return t_trade_ismark_gc;
	}
	public void setT_trade_ismark_gc(Integer t_trade_ismark_gc) {
		this.t_trade_ismark_gc = t_trade_ismark_gc;
	}
	public Integer getT_trade_ismark_cg() {
		return t_trade_ismark_cg;
	}
	public void setT_trade_ismark_cg(Integer t_trade_ismark_cg) {
		this.t_trade_ismark_cg = t_trade_ismark_cg;
	}
	public Double getT_trade_score_gc() {
		return t_trade_score_gc;
	}
	public void setT_trade_score_gc(Double t_trade_score_gc) {
		this.t_trade_score_gc = t_trade_score_gc;
	}
	public Double getT_trade_score_cg() {
		return t_trade_score_cg;
	}
	public void setT_trade_score_cg(Double t_trade_score_cg) {
		this.t_trade_score_cg = t_trade_score_cg;
	}
	public String getT_trade_createtime() {
		return t_trade_createtime;
	}
	public void setT_trade_createtime(String t_trade_createtime) {
		this.t_trade_createtime = t_trade_createtime;
	}
	public String getT_trade_marktime() {
		return t_trade_marktime;
	}
	public void setT_trade_marktime(String t_trade_marktime) {
		this.t_trade_marktime = t_trade_marktime;
	}
	public Integer getT_trade_type() {
		return t_trade_type;
	}
	public void setT_trade_type(Integer t_trade_type) {
		this.t_trade_type = t_trade_type;
	}
	
}
