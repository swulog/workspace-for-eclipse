package com.university.dao.impl;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.university.dao.IBaseDAO;


/** 统一数据访问接口实现 */
public class BaseDAOImpl extends HibernateDaoSupport implements IBaseDAO {

	/** 统计指定类的所有持久化对象 */
	public int countAll(String clazz) {
		final String hql = "select count(*) from " + clazz + " as a";
		@SuppressWarnings({ "unchecked", "rawtypes" })
		Long count = (Long) getHibernateTemplate().execute(
				new HibernateCallback() {
					public Object doInHibernate(Session session)
							throws HibernateException {
						Query query = session.createQuery(hql);
						query.setMaxResults(1);
						return query.uniqueResult();
					}
				});
		return count.intValue();
	}

	/** 统计指定类的查询结果 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public int countQuery(String hql) {
		final String counthql = hql;
		Long count = (Long) getHibernateTemplate().execute(
				new HibernateCallback() {
					public Object doInHibernate(Session session)
							throws HibernateException {
						Query query = session.createQuery(counthql);
						query.setMaxResults(1);
						return query.uniqueResult();
					}
				});
		return count.intValue();
	}

	/** 查询指定类的满足条件的持久化对象 */
	public List querySQL(String hql) {
		final String hql1 = hql;
		return getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createSQLQuery(hql1);
				return query.list();
			}
		});
	}

	/** 删除指定ID的持久化对象 */
	@SuppressWarnings("rawtypes")
	public void delById(Class clazz, Serializable id) {
		getHibernateTemplate().delete(getHibernateTemplate().load(clazz, id));
	}
	
//	public int delByMoreIds(String hql){
//		final String hql1 = hql;
//		return getHibernateTemplate().executeFind(new HibernateCallback(){
//			@Override
//			public Object doInHibernate(Session session)
//					throws HibernateException, SQLException {
//				int number = session.createQuery(hql1).executeUpdate();
//				return number;
//			}
//		});
//	}

	/** 装载指定类的所有持久化对象 */
	public List<?> listAll(String clazz) {
		return getHibernateTemplate().find(
				"from " + clazz + " as a order by a.id desc");
	}

	/** 分页装载指定类的所有持久化对象 */
	public List<?> listAll(String clazz, int pageNo, int pageSize) {
		final int pNo = pageNo;
		final int pSize = pageSize;
		final String hql = "from " + clazz + " as a order by a.id desc";
		List<?> list = getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createQuery(hql);
				query.setMaxResults(pSize);
				query.setFirstResult((pNo - 1) * pSize);
				List<?> result = query.list();
				if (!Hibernate.isInitialized(result))
					Hibernate.initialize(result);
				return result;
			}
		});
		return list;
	}

	/** 加载指定ID的持久化对象 */
	@SuppressWarnings("rawtypes")
	public Object loadById(Class clazz, Serializable id) {
		return getHibernateTemplate().get(clazz, id);
	}

	/** 加载满足条件的持久化对象 */
	public Object loadObject(String hql) {
		final String hql1 = hql;
		Object obj = null;
		List<?> list = getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createQuery(hql1);
				return query.list();
			}
		});
		if (list.size() > 0)
			obj = list.get(0);
		return obj;
	}

	/** 查询指定类的满足条件的持久化对象 */
	public List<?> query(String hql) {
		final String hql1 = hql;
		return getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createQuery(hql1);
				return query.list();
			}
		});
	}

	/** 分页查询指定类的满足条件的持久化对象 */
	public List<?> query(String hql, int pageNo, int pageSize) {
		final int pNo = pageNo;
		final int pSize = pageSize;
		final String hql1 = hql;
		return getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createQuery(hql1);
				query.setMaxResults(pSize);
				query.setFirstResult((pNo - 1) * pSize);
				List<?> result = query.list();
				if (!Hibernate.isInitialized(result))
					Hibernate.initialize(result);
				return result;
			}
		});
	}
	
	public void save(Object obj){
		getHibernateTemplate().save(obj);
	}
	
	@Override
	public void update(Object obj) {
		getHibernateTemplate().update(obj);
	}

	/** 保存或更新指定的持久化对象 */
	public void saveOrUpdate(Object obj) {
		getHibernateTemplate().saveOrUpdate(obj);
	}

	/** 根据SQL保存或更新指定的持久化对象 */
	public Object saveOrUpdateSQL(String hql) {
		final String hql1 = hql;
		Object obj = null;
		List<?> list = getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createQuery(hql1);
				return query.list();
			}
		});
		if (list.size() > 0)
			obj = list.get(0);
		return obj;
	}

	/** 条件更新数据 */
	public int update(String hql) {
		final String hql1 = hql;
		return ((Integer) getHibernateTemplate().execute(
				new HibernateCallback() {
					public Object doInHibernate(Session session)
							throws HibernateException {
						Query query = session.createQuery(hql1);
						return query.executeUpdate();
					}
				})).intValue();
	}

	/** 从连接池中取得一个JDBC连接 */
	@SuppressWarnings("deprecation")
	public Connection getConnection() {
		return getHibernateTemplate().getSessionFactory().getCurrentSession().connection();
	}

//	public List<Object> search(PageCommon pageCommon, StringBuffer hql,
//			StringBuffer sql) {
//		List<Object> list = null;
//		Session session = getSession();
//		try {
//			pageCommon.setCountNum(this.getAllNum(sql));// 给工具类PageCommon赋予记录总数
//			Query query = session.createQuery(hql.toString());
//			query.setFirstResult(pageCommon.getFireNum()).setMaxResults(
//					pageCommon.getPAGENUM());// 第一条记录
//			list = query.list();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			session.close();
//		}
//		return list;
//	}

//	public List<Object> search1(PageCommon pageCommon, StringBuffer hql) {
//		List<Object> list = null;
//		Session session = getSession();
//		try {
//			Query query = session.createQuery(hql.toString());
//			Query query1 = session.createQuery(hql.toString());
//			pageCommon.setCountNum(query1.list().size());// 给工具类PageCommon赋予记录总数
//			query.setFirstResult(pageCommon.getFireNum()).setMaxResults(
//					pageCommon.getPAGENUM());// 第一条记录
//			list = query.list();
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			session.close();
//		}
//		return list;
//	}

	/**
	 * 获取总记录数
	 * 
	 * @return
	 */
	private int getAllNum(StringBuffer hql) {
		Session session = getSession();
		try {
			Integer t = (Integer) session.createSQLQuery(hql.toString()).uniqueResult();
			if (t != null)
				return t.intValue();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return 0;
	}

	public Session getSessions() {
		return this.getSession();
	}

	@SuppressWarnings("deprecation")
	@Override
	public void execProc(String sql) {
		// JDBC方法
		try {
			Connection conn = this.getSession().connection();
			Statement stat = conn.createStatement();
			stat.execute(sql);
			conn.close();
		} catch (DataAccessResourceFailureException e) {
			e.printStackTrace();
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	@SuppressWarnings("unchecked")
	public List<Object> searchBySql(String sql) {
		List<Object> list = null;
		Session session = getSession();
		try {
			Query sqlquery=session.createSQLQuery(sql);
			list = sqlquery.list();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public Integer countBySql(String sql) {
		Integer count=null;
		Session session = getSession();
		try {
			Query sqlquery=session.createSQLQuery(sql);
			count = Integer.valueOf(String.valueOf(sqlquery.uniqueResult()));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return count;
	}

	@Override
	public List<Object> searchBySql(String sql, int pageNo, int pageSize) {
		final int pNo = pageNo;
		final int pSize = pageSize;
		final String hql1 = sql;
		List executeFind = getHibernateTemplate().executeFind(new HibernateCallback() {
			public Object doInHibernate(Session session)
					throws HibernateException {
				Query query = session.createSQLQuery(hql1);
				query.setMaxResults(pSize);
				query.setFirstResult((pNo - 1) * pSize);
				List<Object> result = query.list();
				if (!Hibernate.isInitialized(result))
					Hibernate.initialize(result);
				return result;
			}
		});
		return executeFind;
	}
}
