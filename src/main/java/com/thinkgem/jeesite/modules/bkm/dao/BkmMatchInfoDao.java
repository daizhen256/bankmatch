/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.dao;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;

/**
 * 考试管理DAO接口
 * @author 代震
 * @version 2018-06-17
 */
@MyBatisDao
public interface BkmMatchInfoDao extends CrudDao<BkmMatchInfo> {
	
	public int updateHse(BkmMatchInfo entity);
	
	public int updateState(BkmMatchInfo entity);
	
	public String findInfoByUser(String userid);
	
	public int stepOK(String id,int matchStep,String answers);
	
	public int stepWrong(String id,int matchStep,String answers,int wrongNum);
	
	public int stepRandOK(String id,int matchStep,String answers,String questions);
	
	public int stepRandWrong(String id,int matchStep,String answers,int wrongNum,String questions);

	public List<BkmMatchInfo> findTodayAllList(BkmMatchInfo entity);
}