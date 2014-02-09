/**
 * 
 */
package com.ivorytower.app.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;





/**
 * @author longchao
 *
 */
@Entity
@Table(name="UserBaseInfo")

public class User {
	
	private static final long serialVersionUID = 1L;
	
	private String ubi_id;
	private String ubi_username;
	private String ubi_pwd;
	private String ubi_status;
	private String ubi_createtime;
	private String ubi_session;
	
	@Id
	public String getUbi_id() {
		return ubi_id;
	}
	
	public void setUbi_id(String ubi_id) {
		this.ubi_id = ubi_id;
	}
	
	@Column(unique=true,nullable=false)
	public String getUbi_username() {
		return ubi_username;
	}
	
	public void setUbi_username(String ubi_username) {
		this.ubi_username = ubi_username;
	}
	
	@Column(unique=true,nullable=false)
	public String getUbi_pwd() {
		return ubi_pwd;
	}
	
	public void setUbi_pwd(String ubi_pwd) {
		this.ubi_pwd = ubi_pwd;
	}
	
	@Column(unique=true,nullable=false)
	public String getUbi_status() {
		return ubi_status;
	}
	
	public void setUbi_status(String ubi_status) {
		this.ubi_status = ubi_status;
	}
	
	@Column(unique=true,nullable=false)
	public String getUbi_createtime() {
		return ubi_createtime;
	}
	
	public void setUbi_createtime(String ubi_createtime) {
		this.ubi_createtime = ubi_createtime;
	}
	
	@Column(unique=true,nullable=false)
	public String getUbi_session() {
		return ubi_session;
	}
	
	public void setUbi_session(String ubi_session) {
		this.ubi_session = ubi_session;
	}
	
}