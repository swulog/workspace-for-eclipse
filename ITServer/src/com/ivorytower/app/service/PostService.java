/**
 * 
 */
package com.ivorytower.app.service;

import java.util.List;

import com.ivorytower.app.dto.QryPostDetailDto;
import com.ivorytower.app.dto.QryPostMoreDetailDto;
import com.ivorytower.app.dto.QryPostsListDto;
import com.ivorytower.app.entity.Postlistinfo;
import com.ivorytower.app.entity.Userbaseinfo;
import com.ivorytower.comm.Result;

/**
 * @author lc
 *
 */
public interface PostService extends BaseService {
//	public void addUserbaseinfo(Userbaseinfo userbaseinfo);
//	public Userbaseinfo getUserbaseinfoById(int id);
//	public List<Userbaseinfo> findUserbaseinfoByName(String name);
//	
	public void queryPostList(QryPostsListDto dto,Result result);
	public void queryPostDetail(QryPostDetailDto dto,Result result);
	public void queryPostMoreDetail(QryPostMoreDetailDto dto,Result result);
	
}
