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
 * 		车源信息实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:31:21
 */
@Entity
@Table(name="t_car")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE,region="aa")
public class CarInfo implements Serializable{

	private static final long serialVersionUID = 1L;
	
	/**
	 * 主键，uuid
	 */
	private String t_car_id;
	/**
	 * 车牌号
	 */
	private String t_car_no;
	/**
	 * 载重
	 */
	private Double t_car_weight;
	/**
	 * 车长
	 */
	private Double t_car_length;
	/**
	 * 车源描述
	 */
	private String t_car_desc;
	/**
	 * 发车时间
	 */
	private String t_car_sendtime;
	/**
	 * 车源图片
	 */
	private String t_car_image1;
	/**
	 * 车源图片
	 */
	private String t_car_image2;
	/**
	 * 车源图片
	 */
	private String t_car_image3;
	/**
	 * 备注说明
	 */
	private String t_remark;
	/**
	 * 联系人名称
	 */
	private String t_car_contactsname;
	/**
	 * 联系人手机号码
	 */
	private String t_car_contactsphone;
	/**
	 * 联系人电话号码
	 */
	private String t_car_contactstel;
	/**
	 * 所在经度
	 */
	private Double t_car_x=0.0;
	/**
	 * 所在纬度
	 */
	private Double t_car_y=0.0;
	/**
	 * 经纬度geohash编码
	 */
	private String t_car_xycode="";
	/**
	 * 发布人id
	 */
	private User t_car_userid;
	
	/**
	 * 是否审核（1：未审核，2：已审核）
	 */
	private Integer t_car_isaudit=1;
	/**
	 * 是否启用（1：启用，2：停用）
	 */
	private Integer t_car_isabled=1;
	/**
	 * 交易状态（1：正常，2：锁定，3：下架）
	 */
	private Integer t_car_status=1;
	/**
	 * 创建时间
	 */
	private String t_car_createtime;
	/**
	 * 最后修改时间
	 */
	private String t_car_lastupdatetime;
	
	/**
	 * 有效时间
	 */
	private String t_car_effectivetime;
	
	/**
	 * 请求用户
	 */
	private String t_car_requserid;
	
	private String t_car_reqtime;
	
	private List<Wayline> waylines;
	
	@Id
	public String getT_car_id() {
		return t_car_id;
	}
	public void setT_car_id(String t_car_id) {
		this.t_car_id = t_car_id;
	}
	//@Column(nullable=false)
	public String getT_car_no() {
		return t_car_no;
	}
	public void setT_car_no(String t_car_no) {
		this.t_car_no = t_car_no;
	}
	//@Column(nullable=false)
	public Double getT_car_weight() {
		return t_car_weight;
	}
	public void setT_car_weight(Double t_car_weight) {
		this.t_car_weight = t_car_weight;
	}
	//@Column(nullable=false)
	public Double getT_car_length() {
		return t_car_length;
	}
	public void setT_car_length(Double t_car_length) {
		this.t_car_length = t_car_length;
	}
	//@Column(nullable=false)
	public String getT_car_desc() {
		return t_car_desc;
	}
	public void setT_car_desc(String t_car_desc) {
		this.t_car_desc = t_car_desc;
	}
	public Double getT_car_x() {
		return t_car_x;
	}
	public void setT_car_x(Double t_car_x) {
		this.t_car_x = t_car_x;
	}
	public Double getT_car_y() {
		return t_car_y;
	}
	public void setT_car_y(Double t_car_y) {
		this.t_car_y = t_car_y;
	}
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="t_car_userid")
	public User getT_car_userid() {
		return t_car_userid;
	}
	public void setT_car_userid(User t_car_userid) {
		this.t_car_userid = t_car_userid;
	}
	public Integer getT_car_isaudit() {
		return t_car_isaudit;
	}
	public void setT_car_isaudit(Integer t_car_isaudit) {
		this.t_car_isaudit = t_car_isaudit;
	}
	public Integer getT_car_isabled() {
		return t_car_isabled;
	}
	public void setT_car_isabled(Integer t_car_isabled) {
		this.t_car_isabled = t_car_isabled;
	}
	public Integer getT_car_status() {
		return t_car_status;
	}
	public void setT_car_status(Integer t_car_status) {
		this.t_car_status = t_car_status;
	}
	@Column(nullable=false)
	public String getT_car_createtime() {
		return t_car_createtime;
	}
	public void setT_car_createtime(String t_car_createtime) {
		this.t_car_createtime = t_car_createtime;
	}
	public String getT_car_lastupdatetime() {
		return t_car_lastupdatetime;
	}
	public void setT_car_lastupdatetime(String t_car_lastupdatetime) {
		this.t_car_lastupdatetime = t_car_lastupdatetime;
	}
	public String getT_car_sendtime() {
		return t_car_sendtime;
	}
	public void setT_car_sendtime(String t_car_sendtime) {
		this.t_car_sendtime = t_car_sendtime;
	}
	public String getT_car_effectivetime() {
		return t_car_effectivetime;
	}
	public void setT_car_effectivetime(String t_car_effectivetime) {
		this.t_car_effectivetime = t_car_effectivetime;
	}
	public String getT_car_xycode() {
		return t_car_xycode;
	}
	public void setT_car_xycode(String t_car_xycode) {
		this.t_car_xycode = t_car_xycode;
	}
	public String getT_car_image1() {
		return t_car_image1;
	}
	public void setT_car_image1(String t_car_image1) {
		this.t_car_image1 = t_car_image1;
	}
	public String getT_car_image2() {
		return t_car_image2;
	}
	public void setT_car_image2(String t_car_image2) {
		this.t_car_image2 = t_car_image2;
	}
	public String getT_car_image3() {
		return t_car_image3;
	}
	public void setT_car_image3(String t_car_image3) {
		this.t_car_image3 = t_car_image3;
	}
	public String getT_remark() {
		return t_remark;
	}
	public void setT_remark(String t_remark) {
		this.t_remark = t_remark;
	}
	@Column(nullable=false)
	public String getT_car_contactsname() {
		return t_car_contactsname;
	}
	public void setT_car_contactsname(String t_car_contactsname) {
		this.t_car_contactsname = t_car_contactsname;
	}
	@Column(nullable=false)
	public String getT_car_contactsphone() {
		return t_car_contactsphone;
	}
	public void setT_car_contactsphone(String t_car_contactsphone) {
		this.t_car_contactsphone = t_car_contactsphone;
	}
	public String getT_car_contactstel() {
		return t_car_contactstel;
	}
	public void setT_car_contactstel(String t_car_contactstel) {
		this.t_car_contactstel = t_car_contactstel;
	}
	public String getT_car_requserid() {
		return t_car_requserid;
	}
	public void setT_car_requserid(String t_car_requserid) {
		this.t_car_requserid = t_car_requserid;
	}
	public String getT_car_reqtime() {
		return t_car_reqtime;
	}
	public void setT_car_reqtime(String t_car_reqtime) {
		this.t_car_reqtime = t_car_reqtime;
	}
	
	@OneToMany(fetch=FetchType.LAZY,cascade=CascadeType.ALL)
	@JoinColumn(name="t_info_id")
	public List<Wayline> getWaylines() {
		return waylines;
	}
	public void setWaylines(List<Wayline> waylines) {
		this.waylines = waylines;
	}
}
