package cn.com.enho.terminal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import cn.com.enho.base.service.impl.BaseServiceImpl;
import cn.com.enho.comm.Result;
import cn.com.enho.comm.util.DateUtil;
import cn.com.enho.comm.util.StringUtil;
import cn.com.enho.comm.util.UUIDUtil;
import cn.com.enho.terminal.dao.CollectCarDao;
import cn.com.enho.terminal.dto.QryCollectCarListDto;
import cn.com.enho.terminal.entity.CarCollect;
import cn.com.enho.terminal.entity.CarInfo;
import cn.com.enho.terminal.entity.User;
import cn.com.enho.terminal.service.CollectCarService;

/**
 * 		车源信息收藏Service实现类
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-15 下午2:58:46
 */
public class CollectCarServiceImpl extends BaseServiceImpl implements CollectCarService{

	@Autowired
	private CollectCarDao collectCarDao;
	
	/**
	 * 收藏车源信息
	 */
	@Override
	public void addCollectCar(String userid, String carid, Result result) {
		// TODO Auto-generated method stub
		CarCollect carCollect=new CarCollect();
		carCollect.setT_collect_car_id(UUIDUtil.getUUID());//id
		carCollect.setT_collect_car_createtime(DateUtil.getCurrentTime4Str());//收藏时间
		
		User user=new User();
		user.setT_user_id(userid);
		CarInfo car=new CarInfo();
		car.setT_car_id(carid);
		
		carCollect.setUser(user);//用户
		carCollect.setCar(car);//车源信息
		
		this.collectCarDao.insert(carCollect);
		
		//收藏成功
		result.setSuccess(false);
		result.setMsg("收藏成功");
	}

	/**
	 * 查询收藏的车源信息列表
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void qryCollectCarList(QryCollectCarListDto qryCollectCarListDto,
			Result result) {
		// TODO Auto-generated method stub
		StringBuilder sb=new StringBuilder();
		sb.append("from CarCollect c where c.user.t_user_id=? order by c.t_collect_car_createtime desc");
		List<CarCollect> list=(List<CarCollect>)this.collectCarDao.findByHql(sb.toString(), (qryCollectCarListDto.getCurrentpage()-1)*qryCollectCarListDto.getPagesize(), qryCollectCarListDto.getPagesize(), qryCollectCarListDto.getUserid());
	
		List<Object> listData=new ArrayList<Object>();
		if(list!=null && list.size()>0){
			for(int i=0,len=list.size();i<len;i++){
				Map<Object,Object> mapData=new HashMap<Object,Object>();
				mapData.put("user_car_collectid", list.get(i).getT_collect_car_id());//id
				mapData.put("userid", list.get(i).getUser().getT_user_id());//用户id
				mapData.put("carid", list.get(i).getCar().getT_car_id());//车源信息id
				mapData.put("cardesc", StringUtil.nullToStr(list.get(i).getCar().getT_car_desc()));//车源描述
				listData.add(mapData);
			}
		}
		
		result.setSuccess(true);
		result.setMsg("查询成功");
		result.getData().put("list", listData);
	}

	/**
	 * 删除已收藏的车源信息
	 */
	@Override
	public void deleteCollectCar(String user_car_collectid, Result result) {
		// TODO Auto-generated method stub
		CarCollect carCollect=new CarCollect();
		carCollect.setT_collect_car_id(user_car_collectid);
		this.collectCarDao.delete(carCollect);
		
		//删除成功
		result.setSuccess(false);
		result.setMsg("删除成功");
	}

}
