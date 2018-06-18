/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.dao.BkmMatchDao;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.bkm.dao.BkmMatchInfoDao;

/**
 * 考试管理Service
 * @author 代震
 * @version 2018-06-17
 */
@Service
@Transactional(readOnly = true)
public class BkmMatchService extends CrudService<BkmMatchDao, BkmMatch> {

	@Autowired
	private BkmMatchInfoDao bkmMatchInfoDao;
	
	public BkmMatch get(String id) {
		BkmMatch bkmMatch = super.get(id);
		BkmMatchInfo bkmMatchInfo = new BkmMatchInfo();
		bkmMatchInfo.setMatchId(bkmMatch.getId());
		bkmMatch.setBkmMatchInfoList(bkmMatchInfoDao.findList(bkmMatchInfo));
		return bkmMatch;
	}
	
	public List<BkmMatch> findList(BkmMatch bkmMatch) {
		return super.findList(bkmMatch);
	}
	
	public Page<BkmMatch> findPage(Page<BkmMatch> page, BkmMatch bkmMatch) {
		return super.findPage(page, bkmMatch);
	}
	
	public List<BkmMatchInfo> findInfoByMatch(BkmMatch bkmMatch){
		if(StringUtils.isBlank(bkmMatch.getId())) {
			return new ArrayList<BkmMatchInfo>();
		}
		BkmMatchInfo bkmMatchInfo = new BkmMatchInfo();
		bkmMatchInfo.setMatchId(bkmMatch.getId());
		List<BkmMatchInfo> list = bkmMatchInfoDao.findList(bkmMatchInfo);
		return list;
	}
	
	@Transactional(readOnly = false)
	public void save(BkmMatch bkmMatch) {
		super.save(bkmMatch);
		for (BkmMatchInfo bkmMatchInfo : bkmMatch.getBkmMatchInfoList()){
			if (BkmMatchInfo.DEL_FLAG_NORMAL.equals(bkmMatchInfo.getDelFlag())){
				if (StringUtils.isBlank(bkmMatchInfo.getId())){
					bkmMatchInfo.setMatchId(bkmMatch.getId());
					bkmMatchInfo.preInsert();
					bkmMatchInfoDao.insert(bkmMatchInfo);
				}else{
					bkmMatchInfo.preUpdate();
					bkmMatchInfoDao.update(bkmMatchInfo);
				}
			}else{
				bkmMatchInfoDao.delete(bkmMatchInfo);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(BkmMatch bkmMatch) {
		super.delete(bkmMatch);
		//bkmMatchInfoDao.delete(new BkmMatchInfo(bkmMatch));
	}
	
}