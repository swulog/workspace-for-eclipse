package cn.com.enho.terminal.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * 		车源信息收藏关系实体类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:28:18
 */
@Entity
@Table(name="t_collect_car")
public class CarCollect implements Serializable{

	private static final long serialVersionUID = 1L;
	/**
	 * id
	 */
	private String t_collect_car_id;
	/**
	 * user
	 */
	private User user;
	/**
	 * car
	 */
	private CarInfo car;
	/**
	 * 收藏时间
	 */
	private String t_collect_car_createtime;
	
	@Id
	public String getT_collect_car_id() {
		return t_collect_car_id;
	}
	public void setT_collect_car_id(String t_collect_car_id) {
		this.t_collect_car_id = t_collect_car_id;
	}
	@ManyToOne
	@JoinColumn(name="t_collect_car_userid")
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	@ManyToOne
	@JoinColumn(name="t_collect_car_carid")
	public CarInfo getCar() {
		return car;
	}
	public void setCar(CarInfo car) {
		this.car = car;
	}
	@Column(nullable=false)
	public String getT_collect_car_createtime() {
		return t_collect_car_createtime;
	}
	public void setT_collect_car_createtime(String t_collect_car_createtime) {
		this.t_collect_car_createtime = t_collect_car_createtime;
	}
}
