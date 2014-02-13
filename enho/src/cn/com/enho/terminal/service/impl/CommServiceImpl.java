package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import ch.hsr.geohash.GeoHash;
import ch.hsr.geohash.WGS84Point;
import ch.hsr.geohash.util.VincentyGeodesy;
import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.constants.Constants;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.mg.entity.AppInfo;
import cn.com.enho.terminal.dao.CommDao;
import cn.com.enho.terminal.dto.QryGCList4NearDto;
import cn.com.enho.terminal.dto.QryGCListDto;
import cn.com.enho.terminal.entity.Doc;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.entity.Wayline;
import cn.com.enho.terminal.service.CommService;

/**
 * 		通用service
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-21 下午3:25:30
 */
public class CommServiceImpl extends BaseServiceImpl implements CommService{

	@Autowired
	private CommDao commDao;
	
	/**
	 * 查询app doc
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryAppdoc(Integer type, Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from Doc d where d.t_doc_type=?");
		List<Doc> list=(List<Doc>)this.commDao.findByHql(sb.toString(),type);
		if(list!=null && list.size()>0){
			Doc doc=list.get(0);
			result.getData().put("type", type);
			result.getData().put("name", doc.getT_doc_name());
			result.getData().put("title", doc.getT_doc_title());
			result.getData().put("content", doc.getT_doc_content());
			result.getData().put("createtime", doc.getT_doc_createtime());
			result.getData().put("lastupdatetime", doc.getT_doc_lastupdatetime());
		}
		result.setSuccess(true);
		result.setMsg("查询成功");
		return;
	}

	
	/**
	 * 查询附件的货源车源列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryGCList4Near(QryGCList4NearDto qryGCList4NearDto,String baseurl,
			Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		List<Object[]> list=null;
		
		//获取当前经纬度的geohash编码
		GeoHash geoHash=GeoHash.withCharacterPrecision(qryGCList4NearDto.getLatitude(),qryGCList4NearDto.getLongitude(),Constants.DEFAULT_XY_PRECISION);
		
		//获取当前坐标块周围8个块的geohash编码
		GeoHash[] geoHashs=geoHash.getAdjacent();
		
		sb.append("select t.id,t.image1,t.image2,t.image3,t.descr,t.weight,t.length,t.contactsname,t.contactsphone,t.contactstel,t.userid,t.lastupdatetime,t.latitude,t.longitude,t.carno,t.type,t.status,t.sendtime,t.remark,t.createtime,t.creditrating,t.markcount,t.usertype from goods_carview t where 1=1 and (");
		for(int i=0,len=geoHashs.length;i<len;i++){
			String geoHashStr=geoHashs[i].toBase32();
			if(i==len-1){
				sb.append("t.xycode like '"+geoHashStr.substring(0, Constants.DEFAULT_MATCH_LEN)+"%'");
			}else{
				sb.append("t.xycode like '"+geoHashStr.substring(0, Constants.DEFAULT_MATCH_LEN)+"%' or ");
			}
		}
		sb.append(" or t.xycode like '"+geoHash.toBase32().substring(0, Constants.DEFAULT_MATCH_LEN)+"%')");
		sb.append(" and t.isabled="+Constants.ABLE_YES);
		sb.append(" and (t.status="+Constants.STATUS_NORMAL+" or t.status="+Constants.STATUS_LOCK+")");
		sb.append(" order by t.lastupdatetime desc,t.creditrating desc");
		
		
		if(qryGCList4NearDto.getFlag()==null || qryGCList4NearDto.getFlag()==2){//分页
			list=(List<Object[]>)this.commDao.findBySql(sb.toString(), (qryGCList4NearDto.getCurrentpage()-1)*qryGCList4NearDto.getPagesize(), qryGCList4NearDto.getPagesize());
		}else{//不分页
			list=(List<Object[]>)this.commDao.findBySql(sb.toString());
		}
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i)[0]);//id
				StringBuilder sbwayline=new StringBuilder();
				sbwayline.append("from Wayline w where w.infoid='"+list.get(i)[0]+"'");
				List<Wayline> waylineList=(List<Wayline>)this.commDao.findByHql(sbwayline.toString());
				mapData.put("wayline", waylineList);//路线列表
				
				if(waylineList!=null && waylineList.size()>0){
					Wayline wl=waylineList.get(0);
					mapData.put("startp", wl.getStartp());//出发地（省）
					mapData.put("startc", wl.getStartc());//出发地（市）
					mapData.put("startd", wl.getStartd());//出发地（区）
					mapData.put("endp", wl.getEndp());//到达地（省）
					mapData.put("endc", wl.getEndc());//到达地（市）
					mapData.put("endd", wl.getEndd());//到达地（区）
				}
				
				mapData.put("image", "");//车源图片
				
				
				String image1=(list.get(i)[1]==null)?"":list.get(i)[1].toString();
				String image2=(list.get(i)[2]==null)?"":list.get(i)[2].toString();
				String image3=(list.get(i)[3]==null)?"":list.get(i)[3].toString();
				 
				if(image1!=null && !"".equals(image1)){
					image1=baseurl+image1;
				}
				if(image2!=null && !"".equals(image2)){
					image2=baseurl+image2;
				}
				if(image3!=null && !"".equals(image3)){
					image3=baseurl+image3;
				}
				
				mapData.put("imageurl1", image1);//货源图片1地址
				mapData.put("imageurl2", image2);//货源图片2地址
				mapData.put("imageurl3", image3);//货源图片3地址
				
				mapData.put("desc", list.get(i)[4]);//车源描述
				mapData.put("weight", list.get(i)[5]);//载重
				mapData.put("length", list.get(i)[6]);//车长
				mapData.put("username", list.get(i)[7]);//联系人姓名
				//String userphone=list.get(i)[12].toString().substring(0, list.get(i)[12].toString().length()-3)+"***";
				mapData.put("userphone", list.get(i)[8].toString());//联系人手机号
				mapData.put("usertel", list.get(i)[9]);//联系人电话
				mapData.put("userid", list.get(i)[10]);//发布人id
				User u=(User)this.commDao.get(User.class,list.get(i)[10].toString());
				mapData.put("pusertype", u.getT_user_type());//发布人类型
				mapData.put("pentname", StringUtil.nullToStr(u.getT_user_ent()));//发布人企业名称
				
				String cardurl=StringUtil.nullToStr(u.getUserExtend().getT_user_cardurl());//名片正面图片url
				String bcardurl=StringUtil.nullToStr(u.getUserExtend().getT_user_bcardurl());//名片反面图片url
				String blicenseurl=StringUtil.nullToStr(u.getUserExtend().getT_user_blicenseurl());//营业执照图片url
				String dlicenseurl=StringUtil.nullToStr(u.getUserExtend().getT_user_dlicenseurl());//驾驶证图片url
				String rlicenseurl=StringUtil.nullToStr(u.getUserExtend().getT_user_rlicenseurl());//行驶证图片url
				
				if(cardurl!=null && !"".equals(cardurl)){
					cardurl=baseurl+cardurl;
				}
				if(bcardurl!=null && !"".equals(bcardurl)){
					bcardurl=baseurl+bcardurl;
				}
				if(blicenseurl!=null && !"".equals(blicenseurl)){
					blicenseurl=baseurl+blicenseurl;
				}
				if(dlicenseurl!=null && !"".equals(dlicenseurl)){
					dlicenseurl=baseurl+dlicenseurl;
				}
				if(rlicenseurl!=null && !"".equals(rlicenseurl)){
					rlicenseurl=baseurl+rlicenseurl;
				}
				
				mapData.put("cardurl", cardurl);
				mapData.put("bcardurl", bcardurl);
				mapData.put("blicenseurl", blicenseurl);
				mapData.put("dlicenseurl", dlicenseurl);
				mapData.put("rlicenseurl", rlicenseurl);
				
				mapData.put("lastupdatetime", list.get(i)[11]);//车源最后修改时间
				
				Double latitude=(Double)list.get(i)[12];//纬度
				Double longitude=(Double)list.get(i)[13];//经度
				mapData.put("carno", list.get(i)[14]);//车牌号
				mapData.put("longitude", longitude);//经度
				mapData.put("latitude", latitude);//纬度
				
				//计算距离
				Double distance=VincentyGeodesy.distanceInMeters(new WGS84Point(qryGCList4NearDto.getLatitude(),qryGCList4NearDto.getLongitude()),new WGS84Point(latitude,longitude));
				mapData.put("distance", distance);//距离
				mapData.put("type", list.get(i)[15]);//类型
				mapData.put("status", list.get(i)[16]);//信息状态
				mapData.put("sendtime", list.get(i)[17]);//发车时间
				mapData.put("remark", list.get(i)[18]);//备注说明
				mapData.put("createtime", list.get(i)[19]);//发布时间
				
				//评星
				double creditrating=(Double)list.get(i)[20];
				int markcount=(Integer)list.get(i)[21];
				int averagescore=0;
				
				if(markcount==0){
					averagescore=0;
				}else{
					averagescore=(int)Math.round(creditrating);
				}
				mapData.put("userstar",averagescore);
				
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}


	/**
	 * 查询车源货源列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryGCList(QryGCListDto qryGCListDto, String baseurl,Result result) {
		// TODO Auto-generated method stub
		//出发地-到达地处理-start
		String startp=qryGCListDto.getStartp();
		String startc=qryGCListDto.getStartc();
		String startd=qryGCListDto.getStartd();
		String endp=qryGCListDto.getEndp();
		String endc=qryGCListDto.getEndc();
		String endd=qryGCListDto.getEndd();
		if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
			if(StringUtils.isEmpty(startd)){
				if(startp.equals(startc)){
					qryGCListDto.setStartc("");
				}
			}else{
				if(startp.equals(startc)){
					qryGCListDto.setStartc(startd);
					qryGCListDto.setStartd("");
				}
			}
		}
		
		if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
			if(StringUtils.isEmpty(endd)){
				if(endp.equals(endc)){
					qryGCListDto.setEndc("");
				}
			}else{
				if(endp.equals(endc)){
					qryGCListDto.setEndc(endd);
					qryGCListDto.setEndd("");
				}
			}
		}
		//出发地-到达地处理-end
		
		
		List<Object[]> list=null;
		StringBuilder sb=new StringBuilder();
		sb.append("select distinct t.id,t.image1,t.image2,t.image3,t.descr,t.weight,t.length,t.contactsname,t.contactsphone,t.contactstel,t.userid,t.lastupdatetime,t.latitude,t.longitude,t.carno,t.type,t.status,t.sendtime,t.remark,t.createtime,t.creditrating,t.markcount,t.usertype from goods_carview t left join t_wayline w on t.id=w.t_info_id where 1=1");
		
		if(!StringUtils.isEmpty(qryGCListDto.getStartp()) && !"全国".equals(qryGCListDto.getStartp().trim())){
			sb.append(" and (w.t_wayline_startp like '%"+qryGCListDto.getStartp().trim()+"%' or w.t_wayline_startp='全国')");
		}
		if(!StringUtils.isEmpty(qryGCListDto.getStartc())){
			sb.append(" and (w.t_wayline_startc like '%"+qryGCListDto.getStartc().trim()+"%' or w.t_wayline_startc='' or w.t_wayline_startc is null)");
		}
		if(!StringUtils.isEmpty(qryGCListDto.getStartd())){
			sb.append(" and (w.t_wayline_startd like '%"+qryGCListDto.getStartd().trim()+"%' or w.t_wayline_startd='' or w.t_wayline_startd is null)");
		}
		if(!StringUtils.isEmpty(qryGCListDto.getEndp()) && !"全国".equals(qryGCListDto.getEndp())){
			sb.append(" and (w.t_wayline_endp like '%"+qryGCListDto.getEndp().trim()+"%' or w.t_wayline_endp='全国')");
		}
		if(!StringUtils.isEmpty(qryGCListDto.getEndc())){
			sb.append(" and (w.t_wayline_endc like '%"+qryGCListDto.getEndc().trim()+"%' or w.t_wayline_endc='' or w.t_wayline_endc is null)");
		}
		if(!StringUtils.isEmpty(qryGCListDto.getEndd())){
			sb.append(" and (w.t_wayline_endd like '%"+qryGCListDto.getEndd().trim()+"%' or w.t_wayline_endd='' or w.t_wayline_endd is null)");
		}
		
		//查询我的发布(货运部)
		if(!StringUtils.isEmpty(qryGCListDto.getUserid())){
			sb.append(" and t.userid='"+qryGCListDto.getUserid().trim()+"'");
		}else{
			sb.append(" and (t.status="+Constants.STATUS_NORMAL+" or t.status="+Constants.STATUS_LOCK+")");
		}
		
		sb.append(" and t.isabled="+Constants.ABLE_YES);
		sb.append(" order by t.lastupdatetime desc,t.creditrating desc");
		
		if(qryGCListDto.getFlag()==null || qryGCListDto.getFlag()==2){//分页
			list=(List<Object[]>)this.commDao.findBySql(sb.toString(), (qryGCListDto.getCurrentpage()-1)*qryGCListDto.getPagesize(), qryGCListDto.getPagesize());
		}else{//不分页
			list=(List<Object[]>)this.commDao.findBySql(sb.toString());
		}
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("id", list.get(i)[0]);//id
				StringBuilder sbwayline=new StringBuilder();
				sbwayline.append("from Wayline w where w.infoid='"+list.get(i)[0]+"'");
				List<Wayline> waylineList=(List<Wayline>)this.commDao.findByHql(sbwayline.toString());
				mapData.put("wayline", waylineList);//路线列表
				
				String image1=(list.get(i)[1]==null)?"":list.get(i)[1].toString();
				String image2=(list.get(i)[2]==null)?"":list.get(i)[2].toString();
				String image3=(list.get(i)[3]==null)?"":list.get(i)[3].toString();
				 
				if(image1!=null && !"".equals(image1)){
					image1=baseurl+image1;
				}
				if(image2!=null && !"".equals(image2)){
					image2=baseurl+image2;
				}
				if(image3!=null && !"".equals(image3)){
					image3=baseurl+image3;
				}
				
				mapData.put("imageurl1", image1);//货源图片1地址
				mapData.put("imageurl2", image2);//货源图片2地址
				mapData.put("imageurl3", image3);//货源图片3地址
				
				mapData.put("desc", list.get(i)[4]);//车源描述
				mapData.put("weight", list.get(i)[5]);//载重
				mapData.put("length", list.get(i)[6]);//车长
				mapData.put("username", list.get(i)[7]);//联系人姓名
				//String userphone=list.get(i)[12].toString().substring(0, list.get(i)[12].toString().length()-3)+"***";
				mapData.put("userphone", list.get(i)[8].toString());//联系人手机号
				mapData.put("usertel", list.get(i)[9]);//联系人电话
				mapData.put("userid", list.get(i)[10]);//发布人id
				User u=(User)this.commDao.get(User.class,list.get(i)[10].toString());
				mapData.put("pusertype", u.getT_user_type());//发布人类型
				mapData.put("pentname", StringUtil.nullToStr(u.getT_user_ent()));//发布人企业名称
				
				
				String cardurl=StringUtil.nullToStr(u.getUserExtend().getT_user_cardurl());//名片正面图片url
				String bcardurl=StringUtil.nullToStr(u.getUserExtend().getT_user_bcardurl());//名片反面图片url
				String blicenseurl=StringUtil.nullToStr(u.getUserExtend().getT_user_blicenseurl());//营业执照图片url
				String dlicenseurl=StringUtil.nullToStr(u.getUserExtend().getT_user_dlicenseurl());//驾驶证图片url
				String rlicenseurl=StringUtil.nullToStr(u.getUserExtend().getT_user_rlicenseurl());//行驶证图片url
				
				if(cardurl!=null && !"".equals(cardurl)){
					cardurl=baseurl+cardurl;
				}
				if(bcardurl!=null && !"".equals(bcardurl)){
					bcardurl=baseurl+bcardurl;
				}
				if(blicenseurl!=null && !"".equals(blicenseurl)){
					blicenseurl=baseurl+blicenseurl;
				}
				if(dlicenseurl!=null && !"".equals(dlicenseurl)){
					dlicenseurl=baseurl+dlicenseurl;
				}
				if(rlicenseurl!=null && !"".equals(rlicenseurl)){
					rlicenseurl=baseurl+rlicenseurl;
				}
				
				mapData.put("cardurl", cardurl);
				mapData.put("bcardurl", bcardurl);
				mapData.put("blicenseurl", blicenseurl);
				mapData.put("dlicenseurl", dlicenseurl);
				mapData.put("rlicenseurl", rlicenseurl);
				
				mapData.put("lastupdatetime", list.get(i)[11]);//车源最后修改时间
				
				Double latitude=(Double)list.get(i)[12];//纬度
				Double longitude=(Double)list.get(i)[13];//经度
				mapData.put("carno", list.get(i)[14]);//车牌号
				mapData.put("longitude", longitude);//经度
				mapData.put("latitude", latitude);//纬度
				
				//计算距离
				mapData.put("type", list.get(i)[15]);//类型
				mapData.put("status", list.get(i)[16]);//信息状态
				mapData.put("sendtime", list.get(i)[17]);//发车时间
				mapData.put("remark", list.get(i)[18]);//备注说明
				mapData.put("createtime", list.get(i)[19]);//发布时间
				
				//评星
				double creditrating=(Double)list.get(i)[20];
				int markcount=(Integer)list.get(i)[21];
				int averagescore=0;
				
				if(markcount==0){
					averagescore=0;
				}else{
					averagescore=(int)Math.round(creditrating);
				}
				mapData.put("userstar",averagescore);
				
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}


	//根据appkey查询app路径
	@SuppressWarnings("unchecked")
	@Override
	public List<AppInfo> qryApp(String appkey) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from AppInfo a where a.t_app_key=?");
		List<AppInfo> list=(List<AppInfo>)this.commDao.findByHql(sb.toString(), appkey);
		if(list!=null && list.size()>0){
			return list;
		}else{
			return null;
		}
	}
}
