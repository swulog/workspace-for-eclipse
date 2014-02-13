package com.ivorytower.app.dao;


import java.io.Serializable;


/**
 * 		通用Dao接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:10:09
 */
@SuppressWarnings("rawtypes")
public interface BaseDao extends Dao{
	public Object get(Class c,Serializable id);
	public void insert(Object object);
	public void update(Object object);
	public void delete(Object object);
	public Object findByHql(String hql,Object...values);
	public Object findByHql(String hql,int startNo,int count,Object...values);
	public Object findBySql(String sql,Object...values);
	public Object findBySql(String sql,int startNo,int count,Object...values);
	public Object findByHqlCache(String hql,Object...values);
	public Object findByHqlCache(String hql,int startNo,int count,Object...values);
	public Object findBySqlCache(String sql,Object...values);
	public Object findBySqlCache(String sql,int startNo,int count,Object...values);
	public Object updateByHql(String hql,Object...values);
	public Object updateBySql(String sql,Object...values);
}
