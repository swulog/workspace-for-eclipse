package cn.com.enho.terminal.service.impl;

import java.io.File;
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
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.JSONUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.GoodsDao;
import cn.com.enho.terminal.dto.PubGoodsDto;
import cn.com.enho.terminal.dto.QryGoodsList4NearDto;
import cn.com.enho.terminal.dto.QryGoodsListDto;
import cn.com.enho.terminal.dto.UpdateGoodsDto;
import cn.com.enho.terminal.entity.GoodsInfo;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.entity.Wayline;
import cn.com.enho.terminal.service.GoodsService;

/**
 * 		货源信息Service接口实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:35:38
 */
public class GoodsServiceImpl extends BaseServiceImpl implements GoodsService{

	@Autowired
	private GoodsDao goodsDao;
	
	/**
	 * 发布货源信息
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addGoods(PubGoodsDto pubGoodsDto, Result result) {
		// TODO Auto-generated method stub
		GoodsInfo goodsInfo=new GoodsInfo();
		
		String infoid=UUIDUtil.getUUID();//信息id
		goodsInfo.setT_goods_id(infoid);
		
		//路线(新版本)
		if(!StringUtils.isEmpty(pubGoodsDto.getWayline())){
			List<Wayline> list=JSONUtil.strToJson(pubGoodsDto.getWayline(),Wayline.class);
			for(int i=0,len=list.size();i<len;i++){
				list.get(i).setId(UUIDUtil.getUUID());
				list.get(i).setInfoid(infoid);
				
				//出发地-到达地处理-start
				String startp=list.get(i).getStartp();
				String startc=list.get(i).getStartc();
				String startd=list.get(i).getStartd();
				String endp=list.get(i).getEndp();
				String endc=list.get(i).getEndc();
				String endd=list.get(i).getEndd();
				if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
					if(StringUtils.isEmpty(startd)){
						if(startp.equals(startc)){
							list.get(i).setStartc("");
						}
					}else{
						if(startp.equals(startc)){
							list.get(i).setStartc(startd);
							list.get(i).setStartd("");
						}
					}
				}
				
				if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
					if(StringUtils.isEmpty(endd)){
						if(endp.equals(endc)){
							list.get(i).setEndc("");
						}
					}else{
						if(endp.equals(endc)){
							list.get(i).setEndc(endd);
							list.get(i).setEndd("");
						}
					}
				}
				//出发地-到达地处理-end
			}
			goodsInfo.setWaylines(list);
		}else{//老版本
			
			//出发地-到达地处理-start
			String startp=pubGoodsDto.getGoodsstartp();
			String startc=pubGoodsDto.getGoodsstartc();
			String startd=pubGoodsDto.getGoodsstartd();
			String endp=pubGoodsDto.getGoodsendp();
			String endc=pubGoodsDto.getGoodsendc();
			String endd=pubGoodsDto.getGoodsendd();
			
			if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
				if(StringUtils.isEmpty(startd)){
					if(startp.equals(startc)){
						startc="";
					}
				}else{
					if(startp.equals(startc)){
						startc=startd;
						startd="";
					}
				}
			}
			
			if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
				if(StringUtils.isEmpty(endd)){
					if(endp.equals(endc)){
						endc="";
					}
				}else{
					if(endp.equals(endc)){
						endc=endd;
						endd="";
					}
				}
			}
			//出发地-到达地处理-end
			
			List<Wayline> list=new ArrayList<Wayline>();
			Wayline wl=new Wayline();
			wl.setId(UUIDUtil.getUUID());
			wl.setInfoid(infoid);
			wl.setStartp(startp);
			wl.setStartc(startc);
			wl.setStartd(startd);
			wl.setEndp(endp);
			wl.setEndc(endc);
			wl.setEndd(endd);
			list.add(wl);
			goodsInfo.setWaylines(list);
		}
		
		
		
		goodsInfo.setT_goods_desc(StringUtil.nullToStr(pubGoodsDto.getGoodsdesc()));//描述
		goodsInfo.setT_goods_weight(pubGoodsDto.getGoodsweight());//重量
		goodsInfo.setT_goods_carlength(pubGoodsDto.getGoodscarlength());//所需车长
		goodsInfo.setT_goods_sendtime(StringUtil.nullToStr(pubGoodsDto.getGoodssendtime()));//发货时间
		goodsInfo.setT_remark(StringUtil.nullToStr(pubGoodsDto.getRemark()));//备注说明
		goodsInfo.setT_goods_image1(StringUtil.nullToStr(pubGoodsDto.getImageurl1()));//货源图片1
		goodsInfo.setT_goods_image2(StringUtil.nullToStr(pubGoodsDto.getImageurl2()));//货源图片2
		goodsInfo.setT_goods_image3(StringUtil.nullToStr(pubGoodsDto.getImageurl3()));//货源图片3
		goodsInfo.setT_goods_contactsname(pubGoodsDto.getGoodsusername().trim());//联系人名称
		goodsInfo.setT_goods_contactsphone(pubGoodsDto.getGoodsuserphone().trim());//联系人手机号码
		//goodsInfo.setT_goods_contactstel(StringUtil.nullToStr(pubGoodsDto.getGoodsusertel()));//联系人固话
		goodsInfo.setT_goods_x(StringUtil.nullToDouble(pubGoodsDto.getLongitude()));//经度
		goodsInfo.setT_goods_y(StringUtil.nullToDouble(pubGoodsDto.getLatitude()));//纬度
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(pubGoodsDto.getLongitude())==0 || StringUtil.nullToDouble(pubGoodsDto.getLatitude())==0){
			goodsInfo.setT_goods_xycode("");
		}else{
			goodsInfo.setT_goods_xycode(GeoHash.withCharacterPrecision(pubGoodsDto.getLatitude(),pubGoodsDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32());
		}
		
		User user=new User();
		user.setT_user_id(pubGoodsDto.getGoodsuserid().trim());
		goodsInfo.setT_goods_userid(user);//发布人id
		
		String currentTime=DateUtil.getCurrentTime4Str();
		goodsInfo.setT_goods_createtime(currentTime);//发布时间
		goodsInfo.setT_goods_lastupdatetime(currentTime);//最后修改时间
		
		this.goodsDao.insert(goodsInfo);
		
		//给货主增加积分
		StringBuilder sb=new StringBuilder();
		sb.append("update User u  set u.t_user_integral=u.t_user_integral+? where u.t_user_id=?");
		this.goodsDao.updateByHql(sb.toString(),Constants.DEFAULT_PUB_G,pubGoodsDto.getGoodsuserid().trim());
		
		//发布成功
		result.setSuccess(true);
		result.setMsg("发布成功");
		return;
	}

	/**
	 * 查询货源信息列表
	 */
	@SuppressWarnings({ "unchecked" })
	@Override
	public void qryGoodsList(QryGoodsListDto qryGoodsListDto, Result result) {
		// TODO Auto-generated method stub
		//出发地-到达地处理-start
		String startp=qryGoodsListDto.getGoodsstartp();
		String startc=qryGoodsListDto.getGoodsstartc();
		String startd=qryGoodsListDto.getGoodsstartd();
		String endp=qryGoodsListDto.getGoodsendp();
		String endc=qryGoodsListDto.getGoodsendc();
		String endd=qryGoodsListDto.getGoodsendd();
		if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
			if(StringUtils.isEmpty(startd)){
				if(startp.equals(startc)){
					qryGoodsListDto.setGoodsstartc("");
				}
			}else{
				if(startp.equals(startc)){
					qryGoodsListDto.setGoodsstartc(startd);
					qryGoodsListDto.setGoodsstartd("");
				}
			}
		}
		
		if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
			if(StringUtils.isEmpty(endd)){
				if(endp.equals(endc)){
					qryGoodsListDto.setGoodsendc("");
				}
			}else{
				if(endp.equals(endc)){
					qryGoodsListDto.setGoodsendc(endd);
					qryGoodsListDto.setGoodsendd("");
				}
			}
		}
		//出发地-到达地处理-end
		
		
		StringBuilder sb=new StringBuilder();
		sb.append("select distinct(g) from GoodsInfo g left join g.waylines w where 1=1 ");
		
		if(!StringUtils.isEmpty(qryGoodsListDto.getGoodsstartp()) && !"全国".equals(qryGoodsListDto.getGoodsstartp().trim())){
			sb.append(" and (w.startp like '%"+qryGoodsListDto.getGoodsstartp().trim()+"%' or w.startp='全国')");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getGoodsstartc())){
			sb.append(" and (w.startc like '%"+qryGoodsListDto.getGoodsstartc().trim()+"%' or w.startc='' or w.startc is null)");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getGoodsstartd())){
			sb.append(" and (w.startd like '%"+qryGoodsListDto.getGoodsstartd().trim()+"%' or w.startd='' or w.startd is null)");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getGoodsendp()) && !"全国".equals(qryGoodsListDto.getGoodsendp().trim())){
			sb.append(" and (w.endp like '%"+qryGoodsListDto.getGoodsendp().trim()+"%' or w.endp='全国')");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getGoodsendc())){
			sb.append(" and (w.endc like '%"+qryGoodsListDto.getGoodsendc().trim()+"%' or w.endc='' or w.endc is null)");
		}
		if(!StringUtils.isEmpty(qryGoodsListDto.getGoodsendd())){
			sb.append(" and (w.endd like '%"+qryGoodsListDto.getGoodsendd().trim()+"%' or w.endd='' or w.endd is null)");
		}
		
		//查询我发布
		if(!StringUtils.isEmpty(qryGoodsListDto.getUserid())){
			sb.append(" and g.t_goods_userid.t_user_id='"+qryGoodsListDto.getUserid().trim()+"'");
		}else{
			sb.append(" and (g.t_goods_status="+Constants.STATUS_NORMAL+" or g.t_goods_status="+Constants.STATUS_LOCK+")");
		}
		
		sb.append(" and g.t_goods_isabled="+Constants.ABLE_YES);
		
		sb.append(" order by g.t_goods_lastupdatetime desc");
		
		List<Object> list=(List<Object>)this.goodsDao.findByHql(sb.toString(), (qryGoodsListDto.getCurrentpage()-1)*qryGoodsListDto.getPagesize(), qryGoodsListDto.getPagesize());
		
		String baseurl=qryGoodsListDto.getBaseurl()==null?"":qryGoodsListDto.getBaseurl();
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				GoodsInfo gi=(GoodsInfo)(list.get(i));
				mapData.put("goodsid", gi.getT_goods_id());//id
				mapData.put("wayline", gi.getWaylines());//路线列表
				
				if(gi.getWaylines()!=null && gi.getWaylines().size()>0){
					Wayline wl=gi.getWaylines().get(0);
					mapData.put("goodsstartp", wl.getStartp());//出发地（省）
					mapData.put("goodsstartc", wl.getStartc());//出发地（市）
					mapData.put("goodsstartd", wl.getStartd());//出发地（区）
					mapData.put("goodsendp", wl.getEndp());//到达地（省）
					mapData.put("goodsendc", wl.getEndc());//到达地（市）
					mapData.put("goodsendd", wl.getEndd());//到达地（区）
				}
				
				mapData.put("goodimage", "");//货源图片地址
				
				String image1=gi.getT_goods_image1();
				String image2=gi.getT_goods_image2();
				String image3=gi.getT_goods_image3();
				 
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
				
				mapData.put("goodsdesc", gi.getT_goods_desc());//货源描述
				mapData.put("goodsweight", gi.getT_goods_weight());//货源重量
				mapData.put("goodssendtime", gi.getT_goods_sendtime());//发货时间
				mapData.put("goodscarlength", gi.getT_goods_carlength());//所需车长
				mapData.put("goodsusername", gi.getT_goods_contactsname());//联系人姓名
				mapData.put("goodsuserphone", gi.getT_goods_contactsphone());//联系人手机号
				mapData.put("goodsusertel", gi.getT_goods_contactstel());//联系人固话
				mapData.put("goodsuserid", gi.getT_goods_userid().getT_user_id());//发布人id
				
				String cardurl=gi.getT_goods_userid().getUserExtend().getT_user_cardurl();
				String bcardurl=gi.getT_goods_userid().getUserExtend().getT_user_bcardurl();
				String blicenseurl=gi.getT_goods_userid().getUserExtend().getT_user_blicenseurl();
				String dlicenseurl=gi.getT_goods_userid().getUserExtend().getT_user_dlicenseurl();
				String rlicenseurl=gi.getT_goods_userid().getUserExtend().getT_user_rlicenseurl();
				
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
				
				
				mapData.put("pusertype", gi.getT_goods_userid().getT_user_type());//发布人用户类型
				mapData.put("pentname", StringUtil.nullToStr(gi.getT_goods_userid().getT_user_ent()));//发布人企业名称
				mapData.put("goodslastupdatetime", gi.getT_goods_lastupdatetime());//货源最后修改时间
				mapData.put("goodsstatus", gi.getT_goods_status());//货源状态
				mapData.put("longitude", gi.getT_goods_x());//经度
				mapData.put("latitude", gi.getT_goods_y());//纬度
				mapData.put("goodscreatetime", gi.getT_goods_createtime());//发布时间
				mapData.put("remark", gi.getT_remark());//备注
				mapData.put("infotype", Constants.INFO_G);//信息类型
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}

	/**
	 * 查询货源信息详情
	 */
	@Override
	public void qryGoodsDtl(String goodsid,String baseurl,Result result) {
		// TODO Auto-generated method stub
		GoodsInfo goodsInfo=(GoodsInfo)this.goodsDao.get(GoodsInfo.class, goodsid);
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		if(goodsInfo!=null){
			result.getData().put("goodsid", goodsInfo.getT_goods_id());//id
			
			
			result.getData().put("wayline", goodsInfo.getWaylines());//路线列表
			
			String image1=goodsInfo.getT_goods_image1();
			String image2=goodsInfo.getT_goods_image2();
			String image3=goodsInfo.getT_goods_image3();
			 
			if(image1!=null && !"".equals(image1)){
				image1=baseurl+image1;
			}
			if(image2!=null && !"".equals(image2)){
				image2=baseurl+image2;
			}
			if(image3!=null && !"".equals(image3)){
				image3=baseurl+image3;
			}
			
			result.getData().put("imageurl1", image1);//货源图片1地址
			result.getData().put("imageurl2", image2);//货源图片2地址
			result.getData().put("imageurl3", image3);//货源图片3地址
			
			result.getData().put("goodsweight", goodsInfo.getT_goods_weight());//重量
			result.getData().put("goodsdesc", goodsInfo.getT_goods_desc());//描述
			result.getData().put("goodssendtime", goodsInfo.getT_goods_sendtime());//发货时间
			result.getData().put("goodscarlength", goodsInfo.getT_goods_carlength());//所需车长
			result.getData().put("goodsusername", goodsInfo.getT_goods_contactsname());//联系人名称
			result.getData().put("goodsuserphone", goodsInfo.getT_goods_contactsphone());//联系人手机号码
			result.getData().put("goodsusertel", goodsInfo.getT_goods_contactstel());//联系人固话
			result.getData().put("goodsuserid", goodsInfo.getT_goods_userid().getT_user_id());//发布人id
			
			String cardurl=goodsInfo.getT_goods_userid().getUserExtend().getT_user_cardurl();
			String bcardurl=goodsInfo.getT_goods_userid().getUserExtend().getT_user_bcardurl();
			String blicenseurl=goodsInfo.getT_goods_userid().getUserExtend().getT_user_blicenseurl();
			String dlicenseurl=goodsInfo.getT_goods_userid().getUserExtend().getT_user_dlicenseurl();
			String rlicenseurl=goodsInfo.getT_goods_userid().getUserExtend().getT_user_rlicenseurl();
			
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
			
			result.getData().put("cardurl", cardurl);
			result.getData().put("bcardurl", bcardurl);
			result.getData().put("blicenseurl", blicenseurl);
			result.getData().put("dlicenseurl", dlicenseurl);
			result.getData().put("rlicenseurl", rlicenseurl);
			
			
			result.getData().put("pusertype", goodsInfo.getT_goods_userid().getT_user_type());
			result.getData().put("pentname", StringUtil.nullToStr(goodsInfo.getT_goods_userid().getT_user_ent()));//发布人企业名称
			result.getData().put("goodslastupdatetime", goodsInfo.getT_goods_lastupdatetime());//最后修改时间
			result.getData().put("goodsstatus", goodsInfo.getT_goods_status());//货源状态
			result.getData().put("longitude", goodsInfo.getT_goods_x());//经度
			result.getData().put("latitude", goodsInfo.getT_goods_y());//纬度
			result.getData().put("goodscreatetime", goodsInfo.getT_goods_createtime());//发布时间
			result.getData().put("remark", goodsInfo.getT_remark());//备注
			result.getData().put("infotype", Constants.INFO_G);//信息类型
		}
	}

	/**
	 * 修改货源信息
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void updateGoods(UpdateGoodsDto updateGoodsDto, Result result) {
		// TODO Auto-generated method stub
		List<Wayline> list=new ArrayList<Wayline>();
		
		//路线 （新版本）
		if(!StringUtils.isEmpty(updateGoodsDto.getWayline())){
			list=JSONUtil.strToJson(updateGoodsDto.getWayline(),Wayline.class);
			for(int i=0,len=list.size();i<len;i++){
				list.get(i).setId(UUIDUtil.getUUID());
				list.get(i).setInfoid(updateGoodsDto.getGoodsid());
				
				//出发地-到达地处理-start
				String startp=list.get(i).getStartp();
				String startc=list.get(i).getStartc();
				String startd=list.get(i).getStartd();
				String endp=list.get(i).getEndp();
				String endc=list.get(i).getEndc();
				String endd=list.get(i).getEndd();
				if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
					if(StringUtils.isEmpty(startd)){
						if(startp.equals(startc)){
							list.get(i).setStartc("");
						}
					}else{
						if(startp.equals(startc)){
							list.get(i).setStartc(startd);
							list.get(i).setStartd("");
						}
					}
				}
				
				if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
					if(StringUtils.isEmpty(endd)){
						if(endp.equals(endc)){
							list.get(i).setEndc("");
						}
					}else{
						if(endp.equals(endc)){
							list.get(i).setEndc(endd);
							list.get(i).setEndd("");
						}
					}
				}
				//出发地-到达地处理-end
			}
		}else{//老版本
			//出发地-到达地处理-start
			String startp=updateGoodsDto.getGoodsstartp();
			String startc=updateGoodsDto.getGoodsstartc();
			String startd=updateGoodsDto.getGoodsstartd();
			String endp=updateGoodsDto.getGoodsendp();
			String endc=updateGoodsDto.getGoodsendc();
			String endd=updateGoodsDto.getGoodsendd();
			
			if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
				if(StringUtils.isEmpty(startd)){
					if(startp.equals(startc)){
						startc="";
					}
				}else{
					if(startp.equals(startc)){
						startc=startd;
						startd="";
					}
				}
			}
			
			if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
				if(StringUtils.isEmpty(endd)){
					if(endp.equals(endc)){
						endc="";
					}
				}else{
					if(endp.equals(endc)){
						endc=endd;
						endd="";
					}
				}
			}
			//出发地-到达地处理-end
			Wayline wl=new Wayline();
			wl.setId(UUIDUtil.getUUID());
			wl.setInfoid(updateGoodsDto.getGoodsid());
			wl.setStartp(startp);
			wl.setStartc(startc);
			wl.setStartd(startd);
			wl.setEndp(endp);
			wl.setEndc(endc);
			wl.setEndd(endd);
			list.add(wl);
		}
		
		
		Double t_goods_weight=updateGoodsDto.getGoodsweight();//重量
		String t_goods_desc=StringUtil.nullToStr(updateGoodsDto.getGoodsdesc());//描述
		String t_goods_sendtime=StringUtil.nullToStr(updateGoodsDto.getGoodssendtime());//发货时间
		Double t_goods_carlength=updateGoodsDto.getGoodscarlength();//所需车长
		String t_remark=StringUtil.nullToStr(updateGoodsDto.getRemark());//备注说明
		String t_goods_image1=StringUtil.nullToStr(updateGoodsDto.getImageurl1());//货源图片1
		String t_goods_image2=StringUtil.nullToStr(updateGoodsDto.getImageurl2());//货源图片2
		String t_goods_image3=StringUtil.nullToStr(updateGoodsDto.getImageurl3());//货源图片3
		String t_goods_contactsname=updateGoodsDto.getGoodsusername().trim();//联系人名称
		String t_goods_contactsphone=updateGoodsDto.getGoodsuserphone().trim();//联系人手机号码
		String t_goods_contactstel=StringUtil.nullToStr(updateGoodsDto.getGoodsusertel());//联系人电话号码
		Double t_goods_x=StringUtil.nullToDouble(updateGoodsDto.getLongitude());//所在经度
		Double t_goods_y=StringUtil.nullToDouble(updateGoodsDto.getLatitude());//所在纬度
		String t_goods_xycode="";
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(updateGoodsDto.getLongitude())==0 || StringUtil.nullToDouble(updateGoodsDto.getLatitude())==0){
			t_goods_xycode="";
		}else{
			t_goods_xycode=GeoHash.withCharacterPrecision(updateGoodsDto.getLatitude(),updateGoodsDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32();
		}
		String t_goods_lastupdatetime=DateUtil.getCurrentTime4Str();//最后修改时间
		
		
		GoodsInfo goodsInfo=(GoodsInfo)this.goodsDao.get(GoodsInfo.class, updateGoodsDto.getGoodsid());
		int isabled=goodsInfo.getT_goods_isabled();
		int status=goodsInfo.getT_goods_status();
		if(isabled==Constants.ABLE_NO){
			result.setSuccess(false);
			result.setMsg("此信息无效");
			return;
		}else if(status==Constants.STATUS_LOCK){
			result.setSuccess(false);
			result.setMsg("此信息正在交易中,不允许修改");
			return;
		}else if(status==Constants.STATUS_DOWN){
			result.setSuccess(false);
			result.setMsg("此信息已下架,不允许修改");
			return;
		}else{
			goodsInfo.setWaylines(list);
			goodsInfo.setT_goods_weight(t_goods_weight);
			goodsInfo.setT_goods_desc(t_goods_desc);
			goodsInfo.setT_goods_sendtime(t_goods_sendtime);
			goodsInfo.setT_goods_carlength(t_goods_carlength);
			goodsInfo.setT_remark(t_remark);
			
			if(!"2".equals(t_goods_image1)){
				goodsInfo.setT_goods_image1(t_goods_image1);
			}
			if(!"2".equals(t_goods_image2)){
				goodsInfo.setT_goods_image2(t_goods_image2);
			}
			if(!"2".equals(t_goods_image3)){
				goodsInfo.setT_goods_image3(t_goods_image3);
			}
			
			goodsInfo.setT_goods_contactsname(t_goods_contactsname);
			goodsInfo.setT_goods_contactsphone(t_goods_contactsphone);
			goodsInfo.setT_goods_contactstel(t_goods_contactstel);
			goodsInfo.setT_goods_x(t_goods_x);
			goodsInfo.setT_goods_y(t_goods_y);
			goodsInfo.setT_goods_xycode(t_goods_xycode);
			goodsInfo.setT_goods_lastupdatetime(t_goods_lastupdatetime);
			
			this.goodsDao.update(goodsInfo);
			
			//删除原来的路线
			StringBuilder sb=new StringBuilder();
			sb.append("delete from Wayline w where w.infoid is null");
			this.goodsDao.updateByHql(sb.toString());
			
			
			//修改成功
			result.setSuccess(true);
			result.setMsg("修改成功");
			return;
		}
	}

	/**
	 * 删除货源信息
	 */
	@Override
	public void deleteGoods(String goodsid,String desdir,Result result) {
		// TODO Auto-generated method stub
		GoodsInfo gi=(GoodsInfo)this.goodsDao.get(GoodsInfo.class, goodsid);
		String image1=gi.getT_goods_image1();
		String image2=gi.getT_goods_image2();
		String image3=gi.getT_goods_image3();
		
		this.goodsDao.delete(gi);
		
		if(image1!=null && !"".equals(image1)){
			File oldfile=new File(desdir+image1.substring(image1.lastIndexOf("/")));
			//如果存在则删除
			if(oldfile.exists()){
				oldfile.delete();
			}
		}
		
		if(image2!=null && !"".equals(image2)){
			File oldfile=new File(desdir+image2.substring(image2.lastIndexOf("/")));
			//如果存在则删除
			if(oldfile.exists()){
				oldfile.delete();
			}
		}
		
		if(image3!=null && !"".equals(image3)){
			File oldfile=new File(desdir+image3.substring(image3.lastIndexOf("/")));
			//如果存在则删除
			if(oldfile.exists()){
				oldfile.delete();
			}
		}
		
		//删除成功
		result.setSuccess(true);
		result.setMsg("删除成功");
	}

	/**
	 * 查询附近的货源信息列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryGoodsList4Near(QryGoodsList4NearDto qryGoodsList4NearDto,
			Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		List<GoodsInfo> list=null;
		
		//获取当前经纬度的geohash编码
		GeoHash geoHash=GeoHash.withCharacterPrecision(qryGoodsList4NearDto.getLatitude(),qryGoodsList4NearDto.getLongitude(),Constants.DEFAULT_XY_PRECISION);
		
		//获取当前坐标块周围8个块的geohash编码
		GeoHash[] geoHashs=geoHash.getAdjacent();
		
		sb.append("from GoodsInfo g where 1=1 and (");
		for(int i=0,len=geoHashs.length;i<len;i++){
			String geoHashStr=geoHashs[i].toBase32();
			if(i==len-1){
				sb.append("g.t_goods_xycode like '"+geoHashStr.substring(0, Constants.DEFAULT_MATCH_LEN)+"%'");
			}else{
				sb.append("g.t_goods_xycode like '"+geoHashStr.substring(0, Constants.DEFAULT_MATCH_LEN)+"%' or ");
			}
		}
		sb.append(" or g.t_goods_xycode like '"+geoHash.toBase32().substring(0, Constants.DEFAULT_MATCH_LEN)+"%')");
		sb.append(" and g.t_goods_isabled="+Constants.ABLE_YES);
		sb.append(" and (g.t_goods_status="+Constants.STATUS_NORMAL+" or g.t_goods_status="+Constants.STATUS_LOCK+")");
		sb.append(" order by g.t_goods_lastupdatetime desc");
		
		if(qryGoodsList4NearDto.getFlag()==null || qryGoodsList4NearDto.getFlag()==2){//分页
			list=(List<GoodsInfo>)this.goodsDao.findByHql(sb.toString(), (qryGoodsList4NearDto.getCurrentpage()-1)*qryGoodsList4NearDto.getPagesize(), qryGoodsList4NearDto.getPagesize());
		}else{//不分页
			list=(List<GoodsInfo>)this.goodsDao.findByHql(sb.toString());
		}
		
		String baseurl=qryGoodsList4NearDto.getBaseurl()==null?"":qryGoodsList4NearDto.getBaseurl();
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("goodsid", list.get(i).getT_goods_id());//id
				mapData.put("wayline", list.get(i).getWaylines());//路线列表
				
				if(list.get(i).getWaylines()!=null && list.get(i).getWaylines().size()>0){//老版本
					Wayline wl=list.get(i).getWaylines().get(0);
					mapData.put("goodsstartp", wl.getStartp());//出发地（省）
					mapData.put("goodsstartc", wl.getStartc());//出发地（市）
					mapData.put("goodsstartd", wl.getStartd());//出发地（区）
					mapData.put("goodsendp", wl.getEndp());//到达地（省）
					mapData.put("goodsendc", wl.getEndc());//到达地（市）
					mapData.put("goodsendd", wl.getEndd());//到达地（区）
				}
				
				mapData.put("goodimage", "");//老版本
				
				String image1=list.get(i).getT_goods_image1();
				String image2=list.get(i).getT_goods_image2();
				String image3=list.get(i).getT_goods_image3();
				 
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
				
				mapData.put("goodsdesc", list.get(i).getT_goods_desc());//货源描述
				mapData.put("goodsweight", list.get(i).getT_goods_weight());//货源重量
				mapData.put("goodssendtime", list.get(i).getT_goods_sendtime());//发货时间
				mapData.put("goodscarlength", list.get(i).getT_goods_carlength());//所需车长
				mapData.put("goodsusername", list.get(i).getT_goods_contactsname());//联系人姓名
				mapData.put("goodsuserphone", list.get(i).getT_goods_contactsphone());//联系人手机号
				mapData.put("goodsusertel", list.get(i).getT_goods_contactstel());//联系人固话
				mapData.put("goodsuserid", list.get(i).getT_goods_userid().getT_user_id());//发布人id
				
				String cardurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_cardurl();
				String bcardurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_bcardurl();
				String blicenseurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_blicenseurl();
				String dlicenseurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_dlicenseurl();
				String rlicenseurl=list.get(i).getT_goods_userid().getUserExtend().getT_user_rlicenseurl();
				
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
				
				mapData.put("pusertype", list.get(i).getT_goods_userid().getT_user_type());//发布人类型
				mapData.put("pentname", StringUtil.nullToStr(list.get(i).getT_goods_userid().getT_user_ent()));//发布人企业名称
				mapData.put("goodslastupdatetime", list.get(i).getT_goods_lastupdatetime());//货源最后修改时间
				mapData.put("goodscreatetime", list.get(i).getT_goods_createtime());//发布时间
				mapData.put("remark", list.get(i).getT_remark());//备注
				Double latitude=list.get(i).getT_goods_y();//纬度
				Double longitude=list.get(i).getT_goods_x();//经度
				mapData.put("longitude", longitude);//经度
				mapData.put("latitude", latitude);//纬度
				//计算距离
				Double distance=VincentyGeodesy.distanceInMeters(new WGS84Point(qryGoodsList4NearDto.getLatitude(),qryGoodsList4NearDto.getLongitude()),new WGS84Point(latitude,longitude));
				mapData.put("goodsdistance", distance);//距离
				mapData.put("goodsstatus", list.get(i).getT_goods_status());//货源状态
				mapData.put("type", Constants.INFO_G);//信息类型
				
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
		return;
	}
	
}
