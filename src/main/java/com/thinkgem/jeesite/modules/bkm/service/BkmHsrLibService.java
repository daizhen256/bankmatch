/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.bkm.entity.BkmHsrLib;
import com.thinkgem.jeesite.modules.bkm.dao.BkmHsrLibDao;

/**
 * 题库信息管理Service
 * @author 代震
 * @version 2018-06-19
 */
@Service
@Transactional(readOnly = true)
public class BkmHsrLibService extends CrudService<BkmHsrLibDao, BkmHsrLib> {

	public BkmHsrLib get(String id) {
		return super.get(id);
	}
	
	public List<BkmHsrLib> findList(BkmHsrLib bkmHsrLib) {
		return super.findList(bkmHsrLib);
	}
	
	public Page<BkmHsrLib> findPage(Page<BkmHsrLib> page, BkmHsrLib bkmHsrLib) {
		return super.findPage(page, bkmHsrLib);
	}
	
	@Transactional(readOnly = false)
	public void save(BkmHsrLib bkmHsrLib) {
		super.save(bkmHsrLib);
	}
	
	@Transactional(readOnly = false)
	public void delete(BkmHsrLib bkmHsrLib) {
		super.delete(bkmHsrLib);
	}
	
}