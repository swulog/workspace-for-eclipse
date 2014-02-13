package cn.com.enho.mg.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 		规则实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-17 下午2:46:52
 */
@Entity
@Table(name="t_rule")
public class Rule {

	/**
	 * id
	 */
	private String t_rule_id;
	/**
	 * name
	 */
	private String t_rule_name;
	/**
	 * key
	 */
	private String t_rule_key;
	/**
	 * value
	 */
	private String t_rule_value;
	/**
	 * desc
	 */
	private String t_rule_desc;
	/**
	 * 是否生效(1:生效，2：失效)
	 */
	private Integer t_rule_isabled=1;
	/**
	 * 创建时间
	 */
	private String t_rule_createtime;
	/**
	 * 最后修改时间
	 */
	private String t_rule_lastupdatetime;
	/**
	 * 所属规则组
	 */
	private RGroup group;
	
	@Id
	public String getT_rule_id() {
		return t_rule_id;
	}
	public void setT_rule_id(String t_rule_id) {
		this.t_rule_id = t_rule_id;
	}
	@Column(unique=true,nullable=true)
	public String getT_rule_key() {
		return t_rule_key;
	}
	public void setT_rule_key(String t_rule_key) {
		this.t_rule_key = t_rule_key;
	}
	public String getT_rule_value() {
		return t_rule_value;
	}
	public void setT_rule_value(String t_rule_value) {
		this.t_rule_value = t_rule_value;
	}
	public Integer getT_rule_isabled() {
		return t_rule_isabled;
	}
	public void setT_rule_isabled(Integer t_rule_isabled) {
		this.t_rule_isabled = t_rule_isabled;
	}
	public String getT_rule_createtime() {
		return t_rule_createtime;
	}
	public void setT_rule_createtime(String t_rule_createtime) {
		this.t_rule_createtime = t_rule_createtime;
	}
	public String getT_rule_lastupdatetime() {
		return t_rule_lastupdatetime;
	}
	public void setT_rule_lastupdatetime(String t_rule_lastupdatetime) {
		this.t_rule_lastupdatetime = t_rule_lastupdatetime;
	}
	public String getT_rule_name() {
		return t_rule_name;
	}
	public void setT_rule_name(String t_rule_name) {
		this.t_rule_name = t_rule_name;
	}
	public String getT_rule_desc() {
		return t_rule_desc;
	}
	public void setT_rule_desc(String t_rule_desc) {
		this.t_rule_desc = t_rule_desc;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="t_rgroup_id")
	public RGroup getGroup() {
		return group;
	}
	public void setGroup(RGroup group) {
		this.group = group;
	}
}
