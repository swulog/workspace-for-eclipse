/**
 * 
 */
package com.ivorytower.app.service;


import com.ivorytower.app.dto.AddNewPostDto;
import com.ivorytower.app.dto.CollectPostDto;
import com.ivorytower.app.dto.DeletePostDto;
import com.ivorytower.app.dto.ModifyPostDto;
import com.ivorytower.app.dto.QryPostDetailDto;
import com.ivorytower.app.dto.QryPostMoreDetailDto;
import com.ivorytower.app.dto.QryPostsListDto;
import com.ivorytower.app.dto.ReplyPostDto;
import com.ivorytower.app.dto.ReportPostDto;
import com.ivorytower.app.dto.SearchPostDto;
import com.ivorytower.comm.Result;

/**
 * @author lc
 *
 */
public interface PostService extends BaseService {

	public void queryPostList(QryPostsListDto dto,Result result);
	public void queryPostDetail(QryPostDetailDto dto,Result result);
	public void queryPostMoreDetail(QryPostMoreDetailDto dto,Result result);
	
	public void collectPost(CollectPostDto dto,Result result);
	public void reportPost(ReportPostDto dto,Result result);
	
	public void addNewPost(AddNewPostDto dto,Result result);
	public void modifyPost(ModifyPostDto dto,Result result);
	public void replyPost(ReplyPostDto dto,Result result);
	
	public void deletePost(DeletePostDto dto,Result result);
	
	public void searchPost(SearchPostDto dto,Result result);
	
}
	
