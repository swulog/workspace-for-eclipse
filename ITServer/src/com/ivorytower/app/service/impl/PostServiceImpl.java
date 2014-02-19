package com.ivorytower.app.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ivorytower.app.dto.QryPostDetailDto;
import com.ivorytower.app.dto.QryPostMoreDetailDto;
import com.ivorytower.app.dto.QryPostsListDto;
import com.ivorytower.app.entity.Postlistinfo;
import com.ivorytower.app.entity.Userbaseinfo;
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
				mapData.put("istop", tmp[2]);
				mapData.put("title", tmp[3]);
				mapData.put("content", tmp[4]);
				mapData.put("replynum", tmp[5]);
				mapData.put("userid", tmp[6]);
				mapData.put("userimage", tmp[7]);
				mapData.put("userlevel", tmp[8]);
				mapData.put("usersex", tmp[9]);
				mapData.put("username", tmp[10]);
				mapData.put("lastreplytime", tmp[11]);
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
		sb.append("select pdi.*,uei.uei_nickname,uei.uei_sex,uei.uei_age,uei.uei_level,uei.uei_avatar ");
		sb.append(" from PostDetailInfo pdi,UserExpandInfo uei where 1=1 ");
		sb.append(" and pdi.pdi_userid = uei.uei_id ");
		sb.append(" and pdi.pdi_id = " + dto.getPostid());
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
				mapData.put("userimage", tmp[4]);
				mapData.put("username", tmp[9]);
				mapData.put("usersex", tmp[10]);
				mapData.put("userlevel", tmp[7]);
				mapData.put("content", tmp[4]);
				mapData.put("time", tmp[8]);
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
				sb.append(" and pdi.pdi_id = " + dto.getPostid());
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
						mapData.put("userimage", tmp[4]);
						mapData.put("username", tmp[9]);
						mapData.put("usersex", tmp[10]);
						mapData.put("userlevel", tmp[7]);
						mapData.put("content", tmp[4]);
						mapData.put("time", tmp[8]);
						listData.add(mapData);
					}
				}
				result.getData().put("list", listData);
				result.setMsg("成功");
	}

}
