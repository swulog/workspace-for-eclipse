package cn.com.enho.terminal.service;

import cn.com.enho.base.service.BaseService;
import cn.com.enho.comm.Result;
import cn.com.enho.terminal.dto.PubGoodsDto;
import cn.com.enho.terminal.dto.QryGoodsList4NearDto;
import cn.com.enho.terminal.dto.QryGoodsListDto;
import cn.com.enho.terminal.dto.UpdateGoodsDto;

/**
 * 		货源信息Service接口
 * 		author            ：      		xionglei   
 * 		createtime        ：  		2013-8-9 上午11:18:20
 */
public interface GoodsService extends BaseService{

	public void addGoods(PubGoodsDto pubGoodsDto,Result result);//发布货源信息
	public void qryGoodsList(QryGoodsListDto qryGoodsListDto,Result result);//查询货源信息列表
	public void qryGoodsDtl(String goodsid,String baseurl,Result result);//查询货源信息详情
	public void updateGoods(UpdateGoodsDto updateGoodsDto,Result result);//修改货源信息
	public void deleteGoods(String goodsid,String desdir,Result result);//删除货源信息
	public void qryGoodsList4Near(QryGoodsList4NearDto qryGoodsList4NearDto,Result result);//查询附近的货源信息列表
}
