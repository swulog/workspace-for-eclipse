package com.university.dao;

import java.io.Serializable;
import java.sql.Connection;
import java.util.List;

import org.hibernate.Session;


/** 统一数据访问接口 */
public interface IBaseDAO {
	
	public Session getSessions();

	/** 加载指定ID的持久化对象 */
	@SuppressWarnings("rawtypes")
	public Object loadById(Class clazz, Serializable id);

	/** 加载满足条件的持久化对象 */
	public Object loadObject(String hql);

	/** 删除指定ID的持久化对象 */
	@SuppressWarnings("rawtypes")
	public void delById(Class clazz, Serializable id);
	
	/**保存方法*/
	public void save(Object obj);
	
	/** 保存或更新指定的持久化对象 */
	public void update(Object obj);

	/** 保存或更新指定的持久化对象 */
	public void saveOrUpdate(Object obj);

	/** 根据SQL保存或更新指定的持久化对象 */
	public Object saveOrUpdateSQL(String sql);

	/** 装载指定类的所有持久化对象 */
	public List listAll(String clazz);

	/** 分页装载指定类的所有持久化对象 */
	public List listAll(String clazz, int pageNo, int pageSize);

	/** 统计指定类的所有持久化对象 */
	public int countAll(String clazz);

	/** 查询指定类的满足条件的持久化对象 */
	public List query(String hql);

	/** 查询指定类的满足条件的持久化对象 */
	public List querySQL(String hql);

	/** 分页查询指定类的满足条件的持久化对象 */
	public List query(String hql, int pageNo, int pageSize);

	/** 统计指定类的查询结果 */
	public int countQuery(String hql);
	
	/** 条件更新数据 */
	public int update(String hql);
	/** 从连接池中取得一个JDBC连接 */
	public Connection getConnection();

//	/*** 分页查询 ***/
//	public List<Object> search(PageCommon pageCommon, StringBuffer hql,
//			StringBuffer sql);
//
//	/**** 分页查询 ****/
//	public List<Object> search1(PageCommon pageCommon, StringBuffer hql);

	/** 执行存储过程 */
	public void execProc(String sql);
	/**
	 * 用SQL查询访问结果集
	 * @param sql
	 * @return
	 */
	public List<Object> searchBySql(String sql);
	public List<Object> searchBySql(String sql, int pageNo, int pageSize);
	/**
	 * 根据SQL统计结果集
	 * @param sql
	 * @return
	 */
	public Integer countBySql(String sql);
}
