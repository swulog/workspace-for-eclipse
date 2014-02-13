package cn.com.enho.terminal.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 		路线实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-10-17 上午10:50:10
 */
@Entity
@Table(name="t_wayline")
public class Wayline implements Serializable{

	private static final long serialVersionUID = 9093994201199864462L;
	private String id;
	private String startp;
	private String startc;
	private String startd;
	private String endp;
	private String endc;
	private String endd;
	private String infoid;
	
	@Id
	@Column(name="t_wayline_id")
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	@Column(name="t_wayline_startp",nullable=false)
	public String getStartp() {
		return startp;
	}
	public void setStartp(String startp) {
		this.startp = startp;
	}
	@Column(name="t_wayline_startc")
	public String getStartc() {
		return startc;
	}
	public void setStartc(String startc) {
		this.startc = startc;
	}
	@Column(name="t_wayline_startd")
	public String getStartd() {
		return startd;
	}
	public void setStartd(String startd) {
		this.startd = startd;
	}
	@Column(name="t_wayline_endp",nullable=false)
	public String getEndp() {
		return endp;
	}
	public void setEndp(String endp) {
		this.endp = endp;
	}
	@Column(name="t_wayline_endc")
	public String getEndc() {
		return endc;
	}
	public void setEndc(String endc) {
		this.endc = endc;
	}
	@Column(name="t_wayline_endd")
	public String getEndd() {
		return endd;
	}
	public void setEndd(String endd) {
		this.endd = endd;
	}
	@Column(name="t_info_id")
	public String getInfoid() {
		return infoid;
	}
	public void setInfoid(String infoid) {
		this.infoid = infoid;
	}
}
