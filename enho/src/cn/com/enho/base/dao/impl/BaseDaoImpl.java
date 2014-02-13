package cn.com.enho.base.dao.impl;

import java.io.Serializable;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.dao.BaseDao;

/**
 * 		通用Dao实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-7 下午4:10:36
 */
public class BaseDaoImpl implements BaseDao{
	
	@Autowired
	private SessionFactory sessionFactory;

	@Override
	public void insert(Object object) {
		// TODO Auto-generated method stub
		this.sessionFactory.getCurrentSession().save(object);
	}
	
	@Override
	public void update(Object object) {
		// TODO Auto-generated method stub
		this.sessionFactory.getCurrentSession().saveOrUpdate(object);
	}

	@Override
	public void delete(Object object) {
		// TODO Auto-generated method stub
		this.sessionFactory.getCurrentSession().delete(object);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Object get(Class c,Serializable id) {
		// TODO Auto-generated method stub
		return this.sessionFactory.getCurrentSession().get(c, id);
	}

	@Override
	public Object findByHql(String hql, Object... values) {
		// TODO Auto-generated method stub
		Query query=this.sessionFactory.getCurrentSession().createQuery(hql);
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		return query.list();
	}

	@Override
	public Object findByHql(String hql, int startNo, int count,
			Object... values) {
		// TODO Auto-generated method stub
		Query query=this.sessionFactory.getCurrentSession().createQuery(hql);
		if(startNo>=0 && count>0){
			query.setFirstResult(startNo);
			query.setMaxResults(count);
		}
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		return query.list();
	}

	@Override
	public Object findBySql(String sql, Object... values) {
		// TODO Auto-generated method stub
		Query sqlQuery=this.sessionFactory.getCurrentSession().createSQLQuery(sql);
		for (int i = 0; i < values.length; i++) {
			sqlQuery.setParameter(i, values[i]);
		}
		return sqlQuery.list();
	}

	@Override
	public Object findBySql(String sql, int startNo, int count,
			Object... values) {
		// TODO Auto-generated method stub
		Query sqlQuery=this.sessionFactory.getCurrentSession().createSQLQuery(sql);
		if(startNo>=0 && count>0){
			sqlQuery.setFirstResult(startNo);
			sqlQuery.setMaxResults(count);
		}
		for (int i = 0; i < values.length; i++) {
			sqlQuery.setParameter(i, values[i]);
		}
		return sqlQuery.list();
	}
	
	@Override
	public Object findByHqlCache(String hql, Object... values) {
		// TODO Auto-generated method stub
		Query query=this.sessionFactory.getCurrentSession().createQuery(hql);
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		query.setCacheable(true);
		return query.list();
	}
	
	@Override
	public Object findByHqlCache(String hql, int startNo, int count,
			Object... values) {
		// TODO Auto-generated method stub
		Query query=this.sessionFactory.getCurrentSession().createQuery(hql);
		if(startNo>=0 && count>0){
			query.setFirstResult(startNo);
			query.setMaxResults(count);
		}
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		query.setCacheable(true);
		return query.list();
	}
	
	@Override
	public Object findBySqlCache(String sql, Object... values) {
		// TODO Auto-generated method stub
		Query sqlQuery=this.sessionFactory.getCurrentSession().createSQLQuery(sql);
		for (int i = 0; i < values.length; i++) {
			sqlQuery.setParameter(i, values[i]);
		}
		sqlQuery.setCacheable(true);
		return sqlQuery.list();
	}
	
	@Override
	public Object findBySqlCache(String sql, int startNo, int count,
			Object... values) {
		// TODO Auto-generated method stub
		Query sqlQuery=this.sessionFactory.getCurrentSession().createSQLQuery(sql);
		if(startNo>=0 && count>0){
			sqlQuery.setFirstResult(startNo);
			sqlQuery.setMaxResults(count);
		}
		for (int i = 0; i < values.length; i++) {
			sqlQuery.setParameter(i, values[i]);
		}
		sqlQuery.setCacheable(true);
		return sqlQuery.list();
	}

	@Override
	public Object updateByHql(String hql, Object... values) {
		// TODO Auto-generated method stub
		Query query=this.sessionFactory.getCurrentSession().createQuery(hql);
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		return query.executeUpdate();
	}

	@Override
	public Object updateBySql(String sql, Object... values) {
		// TODO Auto-generated method stub
		Query sqlQuery=this.sessionFactory.getCurrentSession().createSQLQuery(sql);
		for (int i = 0; i < values.length; i++) {
			sqlQuery.setParameter(i, values[i]);
		}
		return sqlQuery.executeUpdate();
	}

}
