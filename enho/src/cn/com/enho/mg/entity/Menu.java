package cn.com.enho.mg.entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * 		menu实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-9-16 下午12:36:36
 */
@Entity
@Table(name="t_menu")
public class Menu {

	private Integer t_menu_id;
	private String t_menu_code;
	private String t_menu_name;
	private String t_menu_url;
	private Integer t_menu_order;
	private Integer t_menu_isabled=1;
	
	/**
	 * 子节点
	 */
	private List<Menu> children = new ArrayList<Menu>();
	/**
	 * 父节点
	 */
	private Menu parent;
	
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "identity")
	@GeneratedValue(generator = "idGenerator")
	public Integer getT_menu_id() {
		return t_menu_id;
	}
	public void setT_menu_id(Integer t_menu_id) {
		this.t_menu_id = t_menu_id;
	}
	public String getT_menu_code() {
		return t_menu_code;
	}
	public void setT_menu_code(String t_menu_code) {
		this.t_menu_code = t_menu_code;
	}
	public String getT_menu_name() {
		return t_menu_name;
	}
	public void setT_menu_name(String t_menu_name) {
		this.t_menu_name = t_menu_name;
	}
	public String getT_menu_url() {
		return t_menu_url;
	}
	public void setT_menu_url(String t_menu_url) {
		this.t_menu_url = t_menu_url;
	}
	public Integer getT_menu_order() {
		return t_menu_order;
	}
	public void setT_menu_order(Integer t_menu_order) {
		this.t_menu_order = t_menu_order;
	}
	public Integer getT_menu_isabled() {
		return t_menu_isabled;
	}
	public void setT_menu_isabled(Integer t_menu_isabled) {
		this.t_menu_isabled = t_menu_isabled;
	}
	
	@OneToMany(mappedBy="parent",fetch=FetchType.LAZY)
	public List<Menu> getChildren() {
		return children;
	}
	public void setChildren(List<Menu> children) {
		this.children = children;
	}
	
	@ManyToOne
	@JoinColumn(name="t_menu_pid")
	public Menu getParent() {
		return parent;
	}
	public void setParent(Menu parent) {
		this.parent = parent;
	}
	
}
