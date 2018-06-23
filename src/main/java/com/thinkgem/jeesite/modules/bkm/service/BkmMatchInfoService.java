/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import com.thinkgem.jeesite.modules.bkm.dao.BkmMatchInfoDao;

/**
 * 考试历史管理Service
 * @author 代震
 * @version 2018-06-23
 */
@Service
@Transactional(readOnly = true)
public class BkmMatchInfoService extends CrudService<BkmMatchInfoDao, BkmMatchInfo> {

	public BkmMatchInfo get(String id) {
		return super.get(id);
	}
	
	public List<BkmMatchInfo> findList(BkmMatchInfo bkmMatchInfo) {
		return super.findList(bkmMatchInfo);
	}
	
	public Page<BkmMatchInfo> findPage(Page<BkmMatchInfo> page, BkmMatchInfo bkmMatchInfo) {
		User currentUser = UserUtils.getUser();
		bkmMatchInfo.setMatchUser(currentUser);
		return super.findPage(page, bkmMatchInfo);
	}
	
	@Transactional(readOnly = false)
	public void save(BkmMatchInfo bkmMatchInfo) {
		super.save(bkmMatchInfo);
	}
	
	@Transactional(readOnly = false)
	public void delete(BkmMatchInfo bkmMatchInfo) {
		super.delete(bkmMatchInfo);
	}
	
}