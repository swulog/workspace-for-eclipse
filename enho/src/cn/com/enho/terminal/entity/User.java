package cn.com.enho.terminal.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

/**
 * 		用户信息实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:31:59
 */
@Entity
@Table(name="t_user")
public class User implements Serializable{

	private static final long serialVersionUID = 1L;
	
	/**
	 * 主键，uuid
	 */
	private String t_user_id;
	/**
	 * 手机号码，也是登陆名
	 */
	private String t_user_phone;
	/**
	 * 登陆密码
	 */
	private String t_user_pwd;
	/**
	 * 用户类型（1：货主，2：车主）
	 */
	private Integer t_user_type;
	/**
	 * 用户电话号码
	 */
	private String t_user_tel;
	/**
	 * 名称
	 */
	private String t_user_name;
	/**
	 * 用户积分
	 */
	private Double t_user_integral=0.0;
	/**
	 * 用户信誉值
	 */
	private Double t_user_creditrating=0.0;
	/**
	 * 经度
	 */
	private Double t_user_x=0.0;
	/**
	 * 纬度
	 */
	private Double t_user_y=0.0;
	/**
	 * 经纬度geohash编码
	 */
	private String t_user_xycode="";
	/**
	 * 是否启用（1：启用，2：停用）
	 */
	private Integer t_user_isabled=1;
	/**
	 * 用户状态（1：在线，2：离线）
	 */
	private Integer t_user_status=2;
	/**
	 * 创建时间
	 */
	private String t_user_createtime;
	/**
	 * 最后修改时间
	 */
	private String t_user_lastupdatetime;
	/**
	 * 货源信息列表
	 */
	private List<GoodsInfo> goodsList;
	/**
	 * 车源信息列表
	 */
	private List<CarInfo> carList;
	/**
	 * 反馈信息列表
	 */
	private List<FeedBack> feedbackList;
	/**
	 *用户扩展信息 
	 */
	private UserExtend userExtend;
	/**
	 * 邀请码
	 */
	private String t_user_invitecode;
	/**
	 * 可用邀请次数
	 */
	private Integer t_user_invitecodecount;
	/**
	 * 评分人数
	 */
	private Integer t_user_markcount=0;
	/**
	 * 用户来源（1：android，2：ios，3：web，4：后台手动添加）
	 */
	private Integer t_user_src;
	/**
	 * 用户所属企业
	 */
	private String t_user_ent;
	
	
	@Id
	public String getT_user_id() {
		return t_user_id;
	}
	public void setT_user_id(String t_user_id) {
		this.t_user_id = t_user_id;
	}
	@Column(unique=true,nullable=false)
	public String getT_user_phone() {
		return t_user_phone;
	}
	public void setT_user_phone(String t_user_phone) {
		this.t_user_phone = t_user_phone;
	}
	@Column(nullable=false)
	public String getT_user_pwd() {
		return t_user_pwd;
	}
	public void setT_user_pwd(String t_user_pwd) {
		this.t_user_pwd = t_user_pwd;
	}
	@Column(nullable=false)
	public Integer getT_user_type() {
		return t_user_type;
	}
	public void setT_user_type(Integer t_user_type) {
		this.t_user_type = t_user_type;
	}
	public String getT_user_tel() {
		return t_user_tel;
	}
	public void setT_user_tel(String t_user_tel) {
		this.t_user_tel = t_user_tel;
	}
	public String getT_user_name() {
		return t_user_name;
	}
	public void setT_user_name(String t_user_name) {
		this.t_user_name = t_user_name;
	}
	public Double getT_user_integral() {
		return t_user_integral;
	}
	public void setT_user_integral(Double t_user_integral) {
		this.t_user_integral = t_user_integral;
	}
	public Double getT_user_creditrating() {
		return t_user_creditrating;
	}
	public void setT_user_creditrating(Double t_user_creditrating) {
		this.t_user_creditrating = t_user_creditrating;
	}
	public Double getT_user_x() {
		return t_user_x;
	}
	public void setT_user_x(Double t_user_x) {
		this.t_user_x = t_user_x;
	}
	public Double getT_user_y() {
		return t_user_y;
	}
	public void setT_user_y(Double t_user_y) {
		this.t_user_y = t_user_y;
	}
	public String getT_user_xycode() {
		return t_user_xycode;
	}
	public void setT_user_xycode(String t_user_xycode) {
		this.t_user_xycode = t_user_xycode;
	}
	public Integer getT_user_isabled() {
		return t_user_isabled;
	}
	public void setT_user_isabled(Integer t_user_isabled) {
		this.t_user_isabled = t_user_isabled;
	}
	public Integer getT_user_status() {
		return t_user_status;
	}
	public void setT_user_status(Integer t_user_status) {
		this.t_user_status = t_user_status;
	}
	@Column(nullable=false)
	public String getT_user_createtime() {
		return t_user_createtime;
	}
	public void setT_user_createtime(String t_user_createtime) {
		this.t_user_createtime = t_user_createtime;
	}
	public String getT_user_lastupdatetime() {
		return t_user_lastupdatetime;
	}
	public void setT_user_lastupdatetime(String t_user_lastupdatetime) {
		this.t_user_lastupdatetime = t_user_lastupdatetime;
	}
	
	@OneToMany(fetch=FetchType.LAZY,mappedBy="t_goods_userid",cascade=CascadeType.REMOVE)
	public List<GoodsInfo> getGoodsList() {
		return goodsList;
	}
	public void setGoodsList(List<GoodsInfo> goodsList) {
		this.goodsList = goodsList;
	}
	
	@OneToMany(fetch=FetchType.LAZY,mappedBy="t_car_userid",cascade=CascadeType.REMOVE)
	public List<CarInfo> getCarList() {
		return carList;
	}
	public void setCarList(List<CarInfo> carList) {
		this.carList = carList;
	}
	
	@OneToOne(cascade = CascadeType.ALL)
	@PrimaryKeyJoinColumn
	public UserExtend getUserExtend() {
		return userExtend;
	}
	public void setUserExtend(UserExtend userExtend) {
		this.userExtend = userExtend;
	}
	public String getT_user_invitecode() {
		return t_user_invitecode;
	}
	public void setT_user_invitecode(String t_user_invitecode) {
		this.t_user_invitecode = t_user_invitecode;
	}
	public Integer getT_user_invitecodecount() {
		return t_user_invitecodecount;
	}
	public void setT_user_invitecodecount(Integer t_user_invitecodecount) {
		this.t_user_invitecodecount = t_user_invitecodecount;
	}
	public Integer getT_user_markcount() {
		return t_user_markcount;
	}
	public void setT_user_markcount(Integer t_user_markcount) {
		this.t_user_markcount = t_user_markcount;
	}
	public Integer getT_user_src() {
		return t_user_src;
	}
	public void setT_user_src(Integer t_user_src) {
		this.t_user_src = t_user_src;
	}
	public String getT_user_ent() {
		return t_user_ent;
	}
	public void setT_user_ent(String t_user_ent) {
		this.t_user_ent = t_user_ent;
	}
	@OneToMany(fetch=FetchType.LAZY,mappedBy="user",cascade=CascadeType.REMOVE)
	public List<FeedBack> getFeedbackList() {
		return feedbackList;
	}
	public void setFeedbackList(List<FeedBack> feedbackList) {
		this.feedbackList = feedbackList;
	}
	
}
