/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.dao;

import java.util.List;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.bkm.entity.BkmHsrLib;

/**
 * 题库信息管理DAO接口
 * @author 代震
 * @version 2018-06-19
 */
@MyBatisDao
public interface BkmHsrLibDao extends CrudDao<BkmHsrLib> {
	
	public List<BkmHsrLib> findRandomList(int randomSuu);
	
}