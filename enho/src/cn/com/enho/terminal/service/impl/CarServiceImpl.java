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
import cn.com.enho.terminal.dao.CarDao;
import cn.com.enho.terminal.dto.PubCarDto;
import cn.com.enho.terminal.dto.QryCarList4NearDto;
import cn.com.enho.terminal.dto.QryCarListDto;
import cn.com.enho.terminal.dto.UpdateCarDto;
import cn.com.enho.terminal.entity.CarInfo;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.entity.Wayline;
import cn.com.enho.terminal.service.CarService;

/**
 * 		车源信息Service接口实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:33:00
 */
public class CarServiceImpl extends BaseServiceImpl implements CarService{

	@Autowired
	private CarDao carDao;
	
	/**
	 * 发布车源信息
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void addCar(PubCarDto pubCarDto, Result result) {
		// TODO Auto-generated method stub
		CarInfo carInfo=new CarInfo();
		String infoid=UUIDUtil.getUUID();
		carInfo.setT_car_id(infoid);//id
		
		//路线(新版本)
		if(!StringUtils.isEmpty(pubCarDto.getWayline())){
			List<Wayline> list=JSONUtil.strToJson(pubCarDto.getWayline(),Wayline.class);
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
			carInfo.setWaylines(list);
		}else{//(老版本)
			
			//出发地-到达地处理-start
			String startp=pubCarDto.getCarstartp();
			String startc=pubCarDto.getCarstartc();
			String startd=pubCarDto.getCarstartd();
			String endp=pubCarDto.getCarendp();
			String endc=pubCarDto.getCarendc();
			String endd=pubCarDto.getCarendd();
			
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
			carInfo.setWaylines(list);
		}
		
		
		carInfo.setT_car_no(StringUtil.nullToStr(pubCarDto.getCarno().trim()));//车牌号
		carInfo.setT_car_weight(pubCarDto.getCarweight());//载重
		carInfo.setT_car_length(pubCarDto.getCarlength());//车长
		carInfo.setT_car_desc(StringUtil.nullToStr(pubCarDto.getCardesc()));//描述
		carInfo.setT_car_sendtime(StringUtil.nullToStr(pubCarDto.getCarsendtime()));//发车时间
		carInfo.setT_car_image1(StringUtil.nullToStr(pubCarDto.getImageurl1()));//车源图片1
		carInfo.setT_car_image2(StringUtil.nullToStr(pubCarDto.getImageurl2()));//车源图片2
		carInfo.setT_car_image3(StringUtil.nullToStr(pubCarDto.getImageurl3()));//车源图片3
		carInfo.setT_remark(StringUtil.nullToStr(pubCarDto.getRemark()));//备注说明
		carInfo.setT_car_contactsname(pubCarDto.getCarusername().trim());//联系人名称
		carInfo.setT_car_contactsphone(pubCarDto.getCaruserphone().trim());//联系人手机号码
		//carInfo.setT_car_contactstel(StringUtil.nullToStr(pubCarDto.getCarusertel()));//联系人固话号码
		carInfo.setT_car_x(StringUtil.nullToDouble(pubCarDto.getLongitude()));//所在经度
		carInfo.setT_car_y(StringUtil.nullToDouble(pubCarDto.getLatitude()));//所在纬度
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(pubCarDto.getLongitude())==0 || StringUtil.nullToDouble(pubCarDto.getLatitude())==0){
			carInfo.setT_car_xycode("");
		}else{
			carInfo.setT_car_xycode(GeoHash.withCharacterPrecision(pubCarDto.getLatitude(),pubCarDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32());
		}
		
		User user=new User();
		user.setT_user_id(pubCarDto.getCaruserid().trim());
		carInfo.setT_car_userid(user);//发布人id
		
		String currentTime=DateUtil.getCurrentTime4Str();
		carInfo.setT_car_createtime(currentTime);//发布时间
		carInfo.setT_car_lastupdatetime(currentTime);//最后修改时间
		
		this.carDao.insert(carInfo);
		
		//给车主增加积分
		StringBuilder sb=new StringBuilder();
		sb.append("update User u  set u.t_user_integral=u.t_user_integral+? where u.t_user_id=?");
		this.carDao.updateByHql(sb.toString(), Constants.DEFAULT_PUB_C,pubCarDto.getCaruserid().trim());
		
		//发布成功
		result.setSuccess(true);
		result.setMsg("发布成功");
		return;
	}

	/**
	 * 查询车源信息列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryCarList(QryCarListDto qryCarListDto, Result result) {
		// TODO Auto-generated method stub
		
		//出发地-到达地处理-start
		String startp=qryCarListDto.getCarstartp();
		String startc=qryCarListDto.getCarstartc();
		String startd=qryCarListDto.getCarstartd();
		String endp=qryCarListDto.getCarendp();
		String endc=qryCarListDto.getCarendc();
		String endd=qryCarListDto.getCarendd();
		if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
			if(StringUtils.isEmpty(startd)){
				if(startp.equals(startc)){
					qryCarListDto.setCarstartc("");
				}
			}else{
				if(startp.equals(startc)){
					qryCarListDto.setCarstartc(startd);
					qryCarListDto.setCarstartd("");
				}
			}
		}
		
		if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
			if(StringUtils.isEmpty(endd)){
				if(endp.equals(endc)){
					qryCarListDto.setCarendc("");
				}
			}else{
				if(endp.equals(endc)){
					qryCarListDto.setCarendc(endd);
					qryCarListDto.setCarendd("");
				}
			}
		}
		//出发地-到达地处理-end
		
		StringBuilder sb=new StringBuilder();
		sb.append("select distinct(c) from CarInfo c join c.waylines w where 1=1");
		
		if(!StringUtils.isEmpty(qryCarListDto.getCarstartp()) && !"全国".equals(qryCarListDto.getCarstartp().trim())){
			sb.append(" and (w.startp like '%"+qryCarListDto.getCarstartp().trim()+"%' or w.startp='全国')");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarstartc())){
			sb.append(" and (w.startc like '%"+qryCarListDto.getCarstartc().trim()+"%' or w.startc='' or w.startc is null)");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarstartd())){
			sb.append(" and (w.startd like '%"+qryCarListDto.getCarstartd().trim()+"%' or w.startd='' or w.startd is null)");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarendp()) && !"全国".equals(qryCarListDto.getCarendp().trim())){
			sb.append(" and (w.endp like '%"+qryCarListDto.getCarendp().trim()+"%' or w.endp='全国')");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarendc())){
			sb.append(" and (w.endc like '%"+qryCarListDto.getCarendc().trim()+"%' or w.endc='' or w.endc is null)");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarendd())){
			sb.append(" and (w.endd like '%"+qryCarListDto.getCarendd().trim()+"%' or w.endd='' or w.endd is null)");
		}
		//查询已发布
		if(!StringUtils.isEmpty(qryCarListDto.getUserid())){
			sb.append(" and c.t_car_userid.t_user_id='"+qryCarListDto.getUserid().trim()+"'");
		}else{
			sb.append(" and (c.t_car_status="+Constants.STATUS_NORMAL+" or c.t_car_status="+Constants.STATUS_LOCK+")");
		}
		sb.append(" and c.t_car_isabled="+Constants.ABLE_YES);
		
		sb.append(" order by c.t_car_lastupdatetime desc,c.t_car_userid.t_user_creditrating desc");
		
		List<Object> list=(List<Object>)this.carDao.findByHql(sb.toString(), (qryCarListDto.getCurrentpage()-1)*qryCarListDto.getPagesize(), qryCarListDto.getPagesize());
		
		String baseurl=qryCarListDto.getBaseurl()==null?"":qryCarListDto.getBaseurl();
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				CarInfo ci=(CarInfo)(list.get(i));
				mapData.put("carid", ci.getT_car_id());//id
				mapData.put("wayline", ci.getWaylines());//路线列表
				
				if(ci.getWaylines()!=null && ci.getWaylines().size()>0){//老版本
					Wayline wl=ci.getWaylines().get(0);
					mapData.put("carstartp", wl.getStartp());//出发地（省）
					mapData.put("carstartc", wl.getStartc());//出发地（市）
					mapData.put("carstartd", wl.getStartd());//出发地（区）
					mapData.put("carendp", wl.getEndp());//到达地（省）
					mapData.put("carendc", wl.getEndc());//到达地（市）
					mapData.put("carendd", wl.getEndd());//到达地（区）
				}
				
				mapData.put("cardesc", ci.getT_car_desc());//车源描述
				mapData.put("carweight", ci.getT_car_weight());//载重
				mapData.put("carlength", ci.getT_car_length());//车长
				mapData.put("carno", ci.getT_car_no());//车牌号
				
				String image1=ci.getT_car_image1();
				String image2=ci.getT_car_image2();
				String image3=ci.getT_car_image3();
				 
				if(image1!=null && !"".equals(image1)){
					image1=baseurl+image1;
				}
				if(image2!=null && !"".equals(image2)){
					image2=baseurl+image2;
				}
				if(image3!=null && !"".equals(image3)){
					image3=baseurl+image3;
				}
				
				mapData.put("carimage", "");//老版本
				mapData.put("imageurl1", image1);//车源图片1地址
				mapData.put("imageurl2", image2);//车源图片2地址
				mapData.put("imageurl3", image3);//车源图片3地址
				
				mapData.put("carusername", ci.getT_car_contactsname());//联系人姓名
				mapData.put("caruserphone", ci.getT_car_contactsphone());//联系人手机号
				mapData.put("carusertel", ci.getT_car_contactstel());//联系人电话
				mapData.put("caruserid", ci.getT_car_userid().getT_user_id());//发布人id
				
				String cardurl=ci.getT_car_userid().getUserExtend().getT_user_cardurl();
				String bcardurl=ci.getT_car_userid().getUserExtend().getT_user_bcardurl();
				String blicenseurl=ci.getT_car_userid().getUserExtend().getT_user_blicenseurl();
				String dlicenseurl=ci.getT_car_userid().getUserExtend().getT_user_dlicenseurl();
				String rlicenseurl=ci.getT_car_userid().getUserExtend().getT_user_rlicenseurl();
				
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
				
				mapData.put("pusertype", ci.getT_car_userid().getT_user_type());
				mapData.put("pentname", StringUtil.nullToStr(ci.getT_car_userid().getT_user_ent()));//发布人企业名称
				mapData.put("carlastupdatetime", ci.getT_car_lastupdatetime());//车源最后修改时间
				mapData.put("carsendtime", ci.getT_car_sendtime());//发车时间
				mapData.put("carstatus", ci.getT_car_status());//车源状态
				mapData.put("longitude", ci.getT_car_x());//经度
				mapData.put("latitude", ci.getT_car_y());//纬度
				mapData.put("remark", ci.getT_remark());//备注说明
				mapData.put("carcreatetime", ci.getT_car_createtime());//发布时间
				mapData.put("infotype", Constants.INFO_C);//信息类型
				
				
				//评星
				double creditrating=ci.getT_car_userid().getT_user_creditrating();
				int markcount=ci.getT_car_userid().getT_user_markcount();
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
	 * 查询需要发送短信的手机号码
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<String> qryPhone4SendMsg(QryCarListDto qryCarListDto) {
		// TODO Auto-generated method stub
		//出发地-到达地处理-start
				String startp=qryCarListDto.getCarstartp();
				String startc=qryCarListDto.getCarstartc();
				String startd=qryCarListDto.getCarstartd();
				String endp=qryCarListDto.getCarendp();
				String endc=qryCarListDto.getCarendc();
				String endd=qryCarListDto.getCarendd();
				if(!StringUtils.isEmpty(startp) && !StringUtils.isEmpty(startc)){
					if(StringUtils.isEmpty(startd)){
						if(startp.equals(startc)){
							qryCarListDto.setCarstartc("");
						}
					}else{
						if(startp.equals(startc)){
							qryCarListDto.setCarstartc(startd);
							qryCarListDto.setCarstartd("");
						}
					}
				}
				
				if(!StringUtils.isEmpty(endp) && !StringUtils.isEmpty(endc)){
					if(StringUtils.isEmpty(endd)){
						if(endp.equals(endc)){
							qryCarListDto.setCarendc("");
						}
					}else{
						if(endp.equals(endc)){
							qryCarListDto.setCarendc(endd);
							qryCarListDto.setCarendd("");
						}
					}
				}
		//出发地-到达地处理-end
		
		
		StringBuilder sb=new StringBuilder();
		sb.append("select distinct c.t_car_contactsphone from CarInfo c join c.waylines w where 1=1");
		
		if(!StringUtils.isEmpty(qryCarListDto.getCarstartp()) && !"全国".equals(qryCarListDto.getCarstartp().trim())){
			sb.append(" and (w.startp like '%"+qryCarListDto.getCarstartp().trim()+"%' or w.startp='全国')");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarstartc())){
			sb.append(" and (w.startc like '%"+qryCarListDto.getCarstartc().trim()+"%' or w.startc='' or w.startc is null)");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarstartd())){
			sb.append(" and (w.startd like '%"+qryCarListDto.getCarstartd().trim()+"%' or w.startd='' or w.startd is null)");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarendp()) && !"全国".endsWith(qryCarListDto.getCarendp().trim())){
			sb.append(" and (w.endp like '%"+qryCarListDto.getCarendp().trim()+"%' or w.endp='全国')");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarendc())){
			sb.append(" and (w.endc like '%"+qryCarListDto.getCarendc().trim()+"%' or w.endc='' or w.endc is null)");
		}
		if(!StringUtils.isEmpty(qryCarListDto.getCarendd())){
			sb.append(" and (w.endd like '%"+qryCarListDto.getCarendd().trim()+"%' or w.endd='' or w.endd is null)");
		}
		sb.append(" order by c.t_car_lastupdatetime desc");
		
		List<String> list=(List<String>)this.carDao.findByHql(sb.toString());
		
		return list;
	}
	

	/**
	 * 查询车源信息详情
	 */
	@Override
	public void qryCarDtl(String carid,String baseurl,Result result) {
		// TODO Auto-generated method stub
		CarInfo carInfo=(CarInfo)this.carDao.get(CarInfo.class, carid);
		
		//查询成功
		result.setSuccess(true);
		result.setMsg("查询成功");
		if(carInfo!=null){
			result.getData().put("carid", carInfo.getT_car_id());//id
			result.getData().put("wayline", carInfo.getWaylines());//路线列表
			
			result.getData().put("carno", carInfo.getT_car_no());//车牌号
			result.getData().put("carweight", carInfo.getT_car_weight());//载重
			result.getData().put("carlength", carInfo.getT_car_length());//车长
			result.getData().put("cardesc", carInfo.getT_car_desc());//车源描述
			
			String image1=carInfo.getT_car_image1();
			String image2=carInfo.getT_car_image2();
			String image3=carInfo.getT_car_image3();
			 
			if(image1!=null && !"".equals(image1)){
				image1=baseurl+image1;
			}
			if(image2!=null && !"".equals(image2)){
				image2=baseurl+image2;
			}
			if(image3!=null && !"".equals(image3)){
				image3=baseurl+image3;
			}
			
			result.getData().put("imageurl1", image1);//车源图片1
			result.getData().put("imageurl2", image2);//车源图片2
			result.getData().put("imageurl3", image3);//车源图片3
			
			result.getData().put("carusername", carInfo.getT_car_contactsname());//发布人姓名
			result.getData().put("caruserphone", carInfo.getT_car_contactsphone());//发布人手机号
			result.getData().put("carusertel", carInfo.getT_car_contactstel());//发布人电话
			result.getData().put("caruserid", carInfo.getT_car_userid().getT_user_id());//发布人id
			
			String cardurl=carInfo.getT_car_userid().getUserExtend().getT_user_cardurl();
			String bcardurl=carInfo.getT_car_userid().getUserExtend().getT_user_bcardurl();
			String blicenseurl=carInfo.getT_car_userid().getUserExtend().getT_user_blicenseurl();
			String dlicenseurl=carInfo.getT_car_userid().getUserExtend().getT_user_dlicenseurl();
			String rlicenseurl=carInfo.getT_car_userid().getUserExtend().getT_user_rlicenseurl();
			
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
			
			result.getData().put("pusertype",carInfo.getT_car_userid().getT_user_type());
			result.getData().put("pentname",StringUtil.nullToStr(carInfo.getT_car_userid().getT_user_ent()));
			result.getData().put("carlastupdatetime", carInfo.getT_car_lastupdatetime());//最后修改时间
			result.getData().put("carsendtime", carInfo.getT_car_sendtime());//发车时间
			result.getData().put("carstatus", carInfo.getT_car_status());//车源状态
			result.getData().put("longitude", carInfo.getT_car_x());//经度
			result.getData().put("latitude", carInfo.getT_car_y());//纬度
			result.getData().put("remark", carInfo.getT_remark());//备注说明
			result.getData().put("carcreatetime", carInfo.getT_car_createtime());//发布时间
			result.getData().put("infotype", Constants.INFO_C);//车源图片
			
			//评星
			double creditrating=carInfo.getT_car_userid().getT_user_creditrating();
			int markcount=carInfo.getT_car_userid().getT_user_markcount();
			int averagescore=0;
			
			if(markcount==0){
				averagescore=0;
			}else{
				averagescore=(int)Math.round(creditrating);
			}
			
			result.getData().put("userstar",averagescore);
		}
		return;
	}

	/**
	 * 修改车源信息
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void updateCar(UpdateCarDto updateCarDto, Result result) {
		// TODO Auto-generated method stub
		List<Wayline> list=new ArrayList<Wayline>();
		
		//路线 （新版本）
		if(!StringUtils.isEmpty(updateCarDto.getWayline())){
			list=JSONUtil.strToJson(updateCarDto.getWayline(),Wayline.class);
			for(int i=0,len=list.size();i<len;i++){
				list.get(i).setId(UUIDUtil.getUUID());
				list.get(i).setInfoid(updateCarDto.getCarid());
				
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
		}else{
			//出发地-到达地处理-start
			String startp=updateCarDto.getCarstartp();
			String startc=updateCarDto.getCarstartc();
			String startd=updateCarDto.getCarstartd();
			String endp=updateCarDto.getCarendp();
			String endc=updateCarDto.getCarendc();
			String endd=updateCarDto.getCarendd();
			
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
			wl.setInfoid(updateCarDto.getCarid());
			wl.setStartp(startp);
			wl.setStartc(startc);
			wl.setStartd(startd);
			wl.setEndp(endp);
			wl.setEndc(endc);
			wl.setEndd(endd);
			list.add(wl);
		}
		
		
		String t_car_no=StringUtil.nullToStr(updateCarDto.getCarno().trim());//车牌号
		Double t_car_weight=updateCarDto.getCarweight();//载重
		Double t_car_length=updateCarDto.getCarlength();//车长
		String t_car_desc=StringUtil.nullToStr(updateCarDto.getCardesc());//描述
		String t_car_sendtime=StringUtil.nullToStr(updateCarDto.getCarsendtime());//发车时间
		String t_car_image1=StringUtil.nullToStr(updateCarDto.getImageurl1());//车源图片1
		String t_car_image2=StringUtil.nullToStr(updateCarDto.getImageurl2());//车源图片2
		String t_car_image3=StringUtil.nullToStr(updateCarDto.getImageurl3());//车源图片3
		String t_remark=StringUtil.nullToStr(updateCarDto.getRemark());//备注说明
		String t_car_contactsname=updateCarDto.getCarusername().trim();//联系人名称
		String t_car_contactsphone=updateCarDto.getCaruserphone().trim();//联系人手机号码
		String t_car_contactstel=StringUtil.nullToStr(updateCarDto.getCarusertel());//联系人固话号码
		Double t_car_x=StringUtil.nullToDouble(updateCarDto.getLongitude());//所在经度
		Double t_car_y=StringUtil.nullToDouble(updateCarDto.getLatitude());//所在纬度
		String t_car_xycode="";
		//获取经纬度geohash编码
		if(StringUtil.nullToDouble(updateCarDto.getLongitude())==0 || StringUtil.nullToDouble(updateCarDto.getLatitude())==0){
			t_car_xycode="";
		}else{
			t_car_xycode=GeoHash.withCharacterPrecision(updateCarDto.getLatitude(),updateCarDto.getLongitude(),Constants.DEFAULT_XY_PRECISION).toBase32();
		}
		String t_car_lastupdatetime=DateUtil.getCurrentTime4Str();//最后修改时间
		
		CarInfo carInfo=(CarInfo)this.carDao.get(CarInfo.class, updateCarDto.getCarid());
		int isabled=carInfo.getT_car_isabled();
		int status=carInfo.getT_car_status();
		if(isabled==Constants.ABLE_NO){
			result.setSuccess(true);
			result.setMsg("此信息无效");
			return;
		}else if(status==Constants.STATUS_LOCK){
			result.setSuccess(true);
			result.setMsg("此信息正在交易中,不允许修改");
			return;
		}else if(status==Constants.STATUS_DOWN){
			result.setSuccess(true);
			result.setMsg("此信息已下架,不允许修改");
			return;
		}else{
			carInfo.setWaylines(list);
			carInfo.setT_car_no(t_car_no);
			carInfo.setT_car_weight(t_car_weight);
			carInfo.setT_car_length(t_car_length);
			carInfo.setT_car_desc(t_car_desc);
			carInfo.setT_car_sendtime(t_car_sendtime);
			
			if(!"2".equals(t_car_image1)){
				carInfo.setT_car_image1(t_car_image1);
			}
			if(!"2".equals(t_car_image2)){
				carInfo.setT_car_image2(t_car_image2);
			}
			if(!"2".equals(t_car_image3)){
				carInfo.setT_car_image3(t_car_image3);
			}
			
			carInfo.setT_remark(t_remark);
			carInfo.setT_car_contactsname(t_car_contactsname);
			carInfo.setT_car_contactsphone(t_car_contactsphone);
			carInfo.setT_car_contactstel(t_car_contactstel);
			carInfo.setT_car_x(t_car_x);
			carInfo.setT_car_y(t_car_y);
			carInfo.setT_car_xycode(t_car_xycode);
			carInfo.setT_car_lastupdatetime(t_car_lastupdatetime);
			
			this.carDao.update(carInfo);
			
			//删除原来的路线
			StringBuilder sb=new StringBuilder();
			sb.append("delete from Wayline w where w.infoid is null");
			this.carDao.updateByHql(sb.toString());
			
			//发布成功
			result.setSuccess(true);
			result.setMsg("修改成功");
			return;
		}
	}

	/**
	 * 删除车源信息
	 */
	@Override
	public void deleteCar(String carid,String desdir,Result result) {
		// TODO Auto-generated method stub
		CarInfo ci=(CarInfo)this.carDao.get(CarInfo.class, carid);
		String image1=ci.getT_car_image1();
		String image2=ci.getT_car_image2();
		String image3=ci.getT_car_image3();
		
		this.carDao.delete(ci);
		
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
	 * 查询附近的车源信息列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryCarList4Near(QryCarList4NearDto qryCarList4NearDto,
			Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		List<CarInfo> list=null;
		
		//获取当前经纬度的geohash编码
		GeoHash geoHash=GeoHash.withCharacterPrecision(qryCarList4NearDto.getLatitude(),qryCarList4NearDto.getLongitude(),Constants.DEFAULT_XY_PRECISION);
		
		//获取当前坐标块周围8个块的geohash编码
		GeoHash[] geoHashs=geoHash.getAdjacent();
		
		sb.append("from CarInfo c where 1=1 and (");
		for(int i=0,len=geoHashs.length;i<len;i++){
			String geoHashStr=geoHashs[i].toBase32();
			if(i==len-1){
				sb.append("c.t_car_xycode like '"+geoHashStr.substring(0, Constants.DEFAULT_MATCH_LEN)+"%'");
			}else{
				sb.append("c.t_car_xycode like '"+geoHashStr.substring(0, Constants.DEFAULT_MATCH_LEN)+"%' or ");
			}
		}
		sb.append(" or c.t_car_xycode like '"+geoHash.toBase32().substring(0, Constants.DEFAULT_MATCH_LEN)+"%')");
		sb.append(" and c.t_car_isabled="+Constants.ABLE_YES);
		sb.append(" and (c.t_car_status="+Constants.STATUS_NORMAL+" or c.t_car_status="+Constants.STATUS_LOCK+")");
		sb.append(" order by c.t_car_lastupdatetime desc,c.t_car_userid.t_user_creditrating desc");
		
		if(qryCarList4NearDto.getFlag()==null || qryCarList4NearDto.getFlag()==2){//分页
			list=(List<CarInfo>)this.carDao.findByHql(sb.toString(), (qryCarList4NearDto.getCurrentpage()-1)*qryCarList4NearDto.getPagesize(), qryCarList4NearDto.getPagesize());
		}else{//不分页
			list=(List<CarInfo>)this.carDao.findByHql(sb.toString());
		}
		
		String baseurl=qryCarList4NearDto.getBaseurl()==null?"":qryCarList4NearDto.getBaseurl();
		
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("carid", list.get(i).getT_car_id());//id
				mapData.put("wayline", list.get(i).getWaylines());//路线列表
				
				if(list.get(i).getWaylines()!=null && list.get(i).getWaylines().size()>0){//老版本
					Wayline wl=list.get(i).getWaylines().get(0);
					mapData.put("carstartp", wl.getStartp());//出发地（省）
					mapData.put("carstartc", wl.getStartc());//出发地（市）
					mapData.put("carstartd", wl.getStartd());//出发地（区）
					mapData.put("carendp", wl.getEndp());//到达地（省）
					mapData.put("carendc", wl.getEndc());//到达地（市）
					mapData.put("carendd", wl.getEndd());//到达地（区）
				}
				
				mapData.put("cardesc", list.get(i).getT_car_desc());//车源描述
				mapData.put("carweight", list.get(i).getT_car_weight());//载重
				mapData.put("carlength", list.get(i).getT_car_length());//车长
				mapData.put("carno", list.get(i).getT_car_no());//车牌号
				
				String image1=list.get(i).getT_car_image1();
				String image2=list.get(i).getT_car_image2();
				String image3=list.get(i).getT_car_image3();
				 
				if(image1!=null && !"".equals(image1)){
					image1=baseurl+image1;
				}
				if(image2!=null && !"".equals(image2)){
					image2=baseurl+image2;
				}
				if(image3!=null && !"".equals(image3)){
					image3=baseurl+image3;
				}
				
				mapData.put("carimage", "");//老版本
				mapData.put("imageurl1", image1);//车源图片1地址
				mapData.put("imageurl2", image2);//车源图片2地址
				mapData.put("imageurl3", image3);//车源图片3地址
				
				mapData.put("carusername", list.get(i).getT_car_contactsname());//联系人姓名
				mapData.put("caruserphone", list.get(i).getT_car_contactsphone());//联系人手机号
				mapData.put("carusertel", list.get(i).getT_car_contactstel());//联系人电话
				mapData.put("caruserid", list.get(i).getT_car_userid().getT_user_id());//发布人id
				
				String cardurl=list.get(i).getT_car_userid().getUserExtend().getT_user_cardurl();
				String bcardurl=list.get(i).getT_car_userid().getUserExtend().getT_user_bcardurl();
				String blicenseurl=list.get(i).getT_car_userid().getUserExtend().getT_user_blicenseurl();
				String dlicenseurl=list.get(i).getT_car_userid().getUserExtend().getT_user_dlicenseurl();
				String rlicenseurl=list.get(i).getT_car_userid().getUserExtend().getT_user_rlicenseurl();
				
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
				
				mapData.put("pusertype",list.get(i).getT_car_userid().getT_user_type());
				mapData.put("pentname",StringUtil.nullToStr(list.get(i).getT_car_userid().getT_user_ent()));//发布人企业名称
				mapData.put("carlastupdatetime", list.get(i).getT_car_lastupdatetime());//车源最后修改时间
				mapData.put("carsendtime", list.get(i).getT_car_sendtime());//发车时间
				mapData.put("carstatus", list.get(i).getT_car_status());//车源状态
				mapData.put("remark", list.get(i).getT_remark());//备注说明
				mapData.put("carcreatetime", list.get(i).getT_car_createtime());//发布时间
				Double latitude=list.get(i).getT_car_y();//纬度
				Double longitude=list.get(i).getT_car_x();//经度
				mapData.put("longitude", longitude);//经度
				mapData.put("latitude", latitude);//纬度
				//计算距离
				Double distance=VincentyGeodesy.distanceInMeters(new WGS84Point(qryCarList4NearDto.getLatitude(),qryCarList4NearDto.getLongitude()),new WGS84Point(latitude,longitude));
				mapData.put("cardistance", distance);//距离
				mapData.put("type", Constants.INFO_C);//信息类型
				
				//评星
				double creditrating=list.get(i).getT_car_userid().getT_user_creditrating();
				int markcount=list.get(i).getT_car_userid().getT_user_markcount();
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

}
