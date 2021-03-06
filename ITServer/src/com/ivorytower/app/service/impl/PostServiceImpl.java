package com.ivorytower.app.service.impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

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
import com.ivorytower.app.entity.Postlistinfo;
import com.ivorytower.app.service.PostService;
import com.ivorytower.comm.Result;

@Service("postservice")
public class PostServiceImpl extends BaseServiceImpl implements PostService {

	@SuppressWarnings("unchecked")
	@Override
	public void queryPostList(QryPostsListDto dto,Result result) {
		
		if(dto.getPosttypeid()<=0) {
			result.setSuccess(false);
			result.setMsg("没有帖子类型");
			return;
		}
		
		// TODO Auto-generated method stub
		
		StringBuilder sb=new StringBuilder();
		sb.append("select pli.*,uei.uei_nickname,uei.uei_sex,uei.uei_age,uei.uei_level,uei.uei_avatar ");
		sb.append(" from PostListInfo pli,UserExpandInfo uei where 1=1 ");
		sb.append(" and pli.pli_userid = uei.uei_id ");
		sb.append(" and pli.pli_ptiid = " + dto.getPosttypeid());
		sb.append(" limit " + (dto.getPageno()-1)*dto.getPagesize() + "," + dto.getPagesize());
		
		
		List<Object[]> list= (List<Object[]>)this.getBaseDao().findBySql(sb.toString());
		List<Object> listData=new ArrayList<Object>();
		if (list.size() > 0) {
			for (int i=0;i<list.size();i++) {
				Object tmp[] = list.get(i);
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("postid", tmp[0]);
				mapData.put("posttype", tmp[1]);
				mapData.put("istop", tmp[5]);
				mapData.put("title", tmp[2]);
				mapData.put("content", tmp[3]);
				mapData.put("replynum", tmp[6]);
				mapData.put("userid", tmp[4]);
				mapData.put("userimage", tmp[7]);
				mapData.put("userlevel", tmp[8]);
				mapData.put("usersex", tmp[9]);
				mapData.put("usernickname", tmp[10]);
				mapData.put("lastreplytime", tmp[7]);
				listData.add(mapData);
			}
		}
		result.getData().put("list", listData);
		result.setMsg("成功");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void queryPostDetail(QryPostDetailDto dto, Result result) {
		// TODO Auto-generated method stub
		if(dto.getPostid()<0) {
			result.setSuccess(false);
			result.setMsg("没有帖子id");
			return;
		}
		
		// TODO Auto-generated method stub
		
		StringBuilder sb=new StringBuilder();
		sb.append("select result1.* ,uei.uei_nickname,uei.uei_sex,uei.uei_age,uei.uei_level,uei.uei_avatar ");
		sb.append(" from (select * from PostDetailInfo pdi where pdi.pdi_parentid = " + dto.getPostid() + " and pdi.pdi_level = 1 ");
		sb.append(" union all ");
		sb.append(" select * from PostDetailInfo pdi1 where pdi1.pdi_parentid in  ");
		sb.append(" (select pdi2.pdi_id from PostDetailInfo pdi2 where pdi2.pdi_parentid = " + dto.getPostid());
		sb.append("  and pdi2.pdi_level = 1) and pdi1.pdi_level = 2) result1,UserExpandInfo uei where result1.pdi_userid = uei.uei_id ");
		sb.append(" order by result1.pdi_id");
		sb.append(" limit " + (dto.getPageno()-1)*dto.getPagesize() + "," + dto.getPagesize());
		
		System.out.println(sb.toString());
		List<Object[]> list= (List<Object[]>)this.getBaseDao().findBySql(sb.toString());
		List<Object> listData=new ArrayList<Object>();
		if (list.size() > 0) {
			for (int i=0;i<list.size();i++) {
				Object tmp[] = list.get(i);
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("postid", tmp[0]);
				mapData.put("parentid", tmp[1]);
				mapData.put("title", tmp[2]);
				mapData.put("userid", tmp[5]);
				mapData.put("postlevel", tmp[6]);
				mapData.put("time", tmp[7]);
				mapData.put("usernickname", tmp[8]);
				mapData.put("usersex", tmp[9]);
				mapData.put("userlevel", tmp[10]);
				mapData.put("userimage", tmp[11]);
				listData.add(mapData);
			}
		}
		result.getData().put("list", listData);
		result.setMsg("成功");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void queryPostMoreDetail(QryPostMoreDetailDto dto, Result result) {
		// TODO Auto-generated method stub
				if(dto.getPostid()<0) {
					result.setSuccess(false);
					result.setMsg("没有帖子id");
					return;
				}
				
				// TODO Auto-generated method stub
				
				StringBuilder sb=new StringBuilder();
				sb.append("select pdi.*,uei.uei_nickname,uei.uei_sex,uei.uei_age,uei.uei_level,uei.uei_avatar ");
				sb.append(" from PostDetailInfo pdi,UserExpandInfo uei where 1=1 ");
				sb.append(" and pdi.pdi_userid = uei.uei_id ");
				sb.append(" and pdi.pdi_parentid = " + dto.getPostid());
				sb.append(" and pdi.pdi_level = 2");
				sb.append(" limit " + (dto.getPageno()-1)*dto.getPagesize() + "," + dto.getPagesize());
				
				List<Object[]> list= (List<Object[]>)this.getBaseDao().findBySql(sb.toString());
				List<Object> listData=new ArrayList<Object>();
				if (list.size() > 0) {
					for (int i=0;i<list.size();i++) {
						Object tmp[] = list.get(i);
						Map<Object,Object> mapData=new HashMap<Object,Object>();
						mapData.put("postid", tmp[0]);
						mapData.put("parentid", tmp[1]);
						mapData.put("userid", tmp[5]);
						mapData.put("userimage", tmp[11]);
						mapData.put("usernickname", tmp[8]);
						mapData.put("usersex", tmp[10]);
						mapData.put("userlevel", tmp[9]);
						mapData.put("title", tmp[2]);
						mapData.put("time", tmp[7]);
						listData.add(mapData);
					}
				}
				result.getData().put("list", listData);
				result.setMsg("成功");
	}

	@Override
	public void collectPost(CollectPostDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void reportPost(ReportPostDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addNewPost(AddNewPostDto dto, Result result) {
		// TODO Auto-generated method stub		
		Postlistinfo postinfo = new Postlistinfo();
		postinfo.setPliPtiid(dto.getPosttype());
		postinfo.setPliTitle(dto.getTitle());
		postinfo.setPliContent(dto.getContent());
		postinfo.setPliUserid(dto.getUserid());
		postinfo.setPliIstop(0);
		postinfo.setPliReplynum(0);
		postinfo.setPliStatus(1);
		postinfo.setPliReportnum(0);
		postinfo.setPliCreatetime(new Timestamp(Calendar.getInstance().getTime().getTime()));
		this.getBaseDao().insert(postinfo);

	}

	@Override
	public void modifyPost(ModifyPostDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void replyPost(ReplyPostDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deletePost(DeletePostDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void searchPost(SearchPostDto dto, Result result) {
		// TODO Auto-generated method stub
		
	}

}
