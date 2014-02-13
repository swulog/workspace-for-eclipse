package cn.com.enho.mg.entity;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * 		规则组实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-22 下午3:27:29
 */
@Entity
@Table(name="t_rgroup")
public class RGroup {

	private String t_rgroup_id;
	private String t_rgroup_code;
	private String t_rgroup_name;
	private String t_rgroup_desc;
	private Integer t_rgroup_isabled;
	private String t_rgroup_createtime;
	private String t_rgroup_lastupdatetime;
	
	private List<Rule> rules;

	@Id
	public String getT_rgroup_id() {
		return t_rgroup_id;
	}

	public void setT_rgroup_id(String t_rgroup_id) {
		this.t_rgroup_id = t_rgroup_id;
	}

	public String getT_rgroup_code() {
		return t_rgroup_code;
	}

	public void setT_rgroup_code(String t_rgroup_code) {
		this.t_rgroup_code = t_rgroup_code;
	}

	@Column(unique=true,nullable=false)
	public String getT_rgroup_name() {
		return t_rgroup_name;
	}

	public void setT_rgroup_name(String t_rgroup_name) {
		this.t_rgroup_name = t_rgroup_name;
	}

	public String getT_rgroup_desc() {
		return t_rgroup_desc;
	}

	public void setT_rgroup_desc(String t_rgroup_desc) {
		this.t_rgroup_desc = t_rgroup_desc;
	}

	@OneToMany(fetch=FetchType.LAZY,mappedBy="group")
	public List<Rule> getRules() {
		return rules;
	}

	public void setRules(List<Rule> rules) {
		this.rules = rules;
	}

	public Integer getT_rgroup_isabled() {
		return t_rgroup_isabled;
	}

	public void setT_rgroup_isabled(Integer t_rgroup_isabled) {
		this.t_rgroup_isabled = t_rgroup_isabled;
	}

	public String getT_rgroup_createtime() {
		return t_rgroup_createtime;
	}

	public void setT_rgroup_createtime(String t_rgroup_createtime) {
		this.t_rgroup_createtime = t_rgroup_createtime;
	}

	public String getT_rgroup_lastupdatetime() {
		return t_rgroup_lastupdatetime;
	}

	public void setT_rgroup_lastupdatetime(String t_rgroup_lastupdatetime) {
		this.t_rgroup_lastupdatetime = t_rgroup_lastupdatetime;
	}
	
}
