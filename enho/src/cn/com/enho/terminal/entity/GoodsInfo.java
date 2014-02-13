package cn.com.enho.terminal.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * 		货源信息实体类
 * 		author            ：      		xionglei 
 * 		createtime        ：  		2013-8-7 下午4:31:43
 */
@Entity
@Table(name="t_goods")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE,region="bb")
public class GoodsInfo implements Serializable{
	private static final long serialVersionUID = 1L;
	
	/**
	 * 主键，uuid
	 */
	private String t_goods_id;
	
	/**
	 * 货源重量
	 */
	private Double t_goods_weight;
	/**
	 * 货源描述
	 */
	private String t_goods_desc;
	/**
	 * 发货时间
	 */
	private String t_goods_sendtime;
	/**
	 * 所需车长
	 */
	private Double t_goods_carlength;
	/**
	 * 备注说明
	 */
	private String t_remark;
	/**
	 * 货源图片1
	 */
	private String t_goods_image1;
	/**
	 * 货源图片2
	 */
	private String t_goods_image2;
	/**
	 * 货源图片3
	 */
	private String t_goods_image3;
	/**
	 * 联系人名称
	 */
	private String t_goods_contactsname;
	/**
	 * 联系人手机号码
	 */
	private String t_goods_contactsphone;
	/**
	 * 联系人电话号码
	 */
	private String t_goods_contactstel;
	/**
	 * 所在经度
	 */
	private Double t_goods_x=0.0;
	/**
	 * 所在纬度
	 */
	private Double t_goods_y=0.0;
	/**
	 * 经纬度geohash编码
	 */
	private String t_goods_xycode="";
	/**
	 * 发布人id
	 */
	private User t_goods_userid;
	
	/**
	 * 有效期
	 */
	private String t_goods_effectivetime;
	/**
	 * 是否审核（1：未审核，2：已审核）
	 */
	private Integer t_goods_isaudit=1;
	/**
	 * 是否启用（1：启用，2：停用）
	 */
	private Integer t_goods_isabled=1;
	/**
	 * 交易状态（1：正常，2：锁定,3:下架）
	 */
	private Integer t_goods_status=1;
	/**
	 * 创建时间
	 */
	private String t_goods_createtime;
	/**
	 * 最后修改时间
	 */
	private String t_goods_lastupdatetime;
	/**
	 * 请求用户
	 */
	private String t_goods_requserid;
	/**
	 * 请求时间
	 */
	private String t_goods_reqtime;
	
	private List<Wayline> waylines;
	
	@Id
	public String getT_goods_id() {
		return t_goods_id;
	}
	public void setT_goods_id(String t_goods_id) {
		this.t_goods_id = t_goods_id;
	}
	@Column(nullable=false)
	public Double getT_goods_weight() {
		return t_goods_weight;
	}
	public void setT_goods_weight(Double t_goods_weight) {
		this.t_goods_weight = t_goods_weight;
	}
	@Column(nullable=false)
	public String getT_goods_desc() {
		return t_goods_desc;
	}
	public void setT_goods_desc(String t_goods_desc) {
		this.t_goods_desc = t_goods_desc;
	}
	public String getT_goods_sendtime() {
		return t_goods_sendtime;
	}
	public void setT_goods_sendtime(String t_goods_sendtime) {
		this.t_goods_sendtime = t_goods_sendtime;
	}
	@Column(nullable=false)
	public Double getT_goods_carlength() {
		return t_goods_carlength;
	}
	public void setT_goods_carlength(Double t_goods_carlength) {
		this.t_goods_carlength = t_goods_carlength;
	}
	public Double getT_goods_x() {
		return t_goods_x;
	}
	public void setT_goods_x(Double t_goods_x) {
		this.t_goods_x = t_goods_x;
	}
	public Double getT_goods_y() {
		return t_goods_y;
	}
	public void setT_goods_y(Double t_goods_y) {
		this.t_goods_y = t_goods_y;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="t_goods_userid")
	public User getT_goods_userid() {
		return t_goods_userid;
	}
	public void setT_goods_userid(User t_goods_userid) {
		this.t_goods_userid = t_goods_userid;
	}
	public String getT_goods_effectivetime() {
		return t_goods_effectivetime;
	}
	public void setT_goods_effectivetime(String t_goods_effectivetime) {
		this.t_goods_effectivetime = t_goods_effectivetime;
	}
	public Integer getT_goods_isaudit() {
		return t_goods_isaudit;
	}
	public void setT_goods_isaudit(Integer t_goods_isaudit) {
		this.t_goods_isaudit = t_goods_isaudit;
	}
	public Integer getT_goods_isabled() {
		return t_goods_isabled;
	}
	public void setT_goods_isabled(Integer t_goods_isabled) {
		this.t_goods_isabled = t_goods_isabled;
	}
	public Integer getT_goods_status() {
		return t_goods_status;
	}
	public void setT_goods_status(Integer t_goods_status) {
		this.t_goods_status = t_goods_status;
	}
	@Column(nullable=false)
	public String getT_goods_createtime() {
		return t_goods_createtime;
	}
	public void setT_goods_createtime(String t_goods_createtime) {
		this.t_goods_createtime = t_goods_createtime;
	}
	public String getT_goods_lastupdatetime() {
		return t_goods_lastupdatetime;
	}
	public void setT_goods_lastupdatetime(String t_goods_lastupdatetime) {
		this.t_goods_lastupdatetime = t_goods_lastupdatetime;
	}
	public String getT_goods_xycode() {
		return t_goods_xycode;
	}
	public void setT_goods_xycode(String t_goods_xycode) {
		this.t_goods_xycode = t_goods_xycode;
	}
	public String getT_remark() {
		return t_remark;
	}
	public void setT_remark(String t_remark) {
		this.t_remark = t_remark;
	}
	public String getT_goods_image1() {
		return t_goods_image1;
	}
	public void setT_goods_image1(String t_goods_image1) {
		this.t_goods_image1 = t_goods_image1;
	}
	public String getT_goods_image2() {
		return t_goods_image2;
	}
	public void setT_goods_image2(String t_goods_image2) {
		this.t_goods_image2 = t_goods_image2;
	}
	public String getT_goods_image3() {
		return t_goods_image3;
	}
	public void setT_goods_image3(String t_goods_image3) {
		this.t_goods_image3 = t_goods_image3;
	}
	@Column(nullable=false)
	public String getT_goods_contactsname() {
		return t_goods_contactsname;
	}
	public void setT_goods_contactsname(String t_goods_contactsname) {
		this.t_goods_contactsname = t_goods_contactsname;
	}
	@Column(nullable=false)
	public String getT_goods_contactsphone() {
		return t_goods_contactsphone;
	}
	public void setT_goods_contactsphone(String t_goods_contactsphone) {
		this.t_goods_contactsphone = t_goods_contactsphone;
	}
	public String getT_goods_contactstel() {
		return t_goods_contactstel;
	}
	public void setT_goods_contactstel(String t_goods_contactstel) {
		this.t_goods_contactstel = t_goods_contactstel;
	}
	public String getT_goods_requserid() {
		return t_goods_requserid;
	}
	public void setT_goods_requserid(String t_goods_requserid) {
		this.t_goods_requserid = t_goods_requserid;
	}
	public String getT_goods_reqtime() {
		return t_goods_reqtime;
	}
	public void setT_goods_reqtime(String t_goods_reqtime) {
		this.t_goods_reqtime = t_goods_reqtime;
	}
	
	@OneToMany(fetch=FetchType.LAZY,cascade=CascadeType.ALL)
	@JoinColumn(name="t_info_id")
	public List<Wayline> getWaylines() {
		return waylines;
	}
	public void setWaylines(List<Wayline> waylines) {
		this.waylines = waylines;
	}
	
	
	/*public Long getVersion() {
		return version;
	}
	public void setVersion(Long version) {
		this.version = version;
	}*/
	
}
