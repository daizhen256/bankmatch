/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.bkm.entity.BkmHsrLib;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.dao.BkmHsrLibDao;
import com.thinkgem.jeesite.modules.bkm.dao.BkmMatchDao;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
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
	
	@Autowired
	private BkmHsrLibDao bkmHsrLibDao;
	
	public BkmMatch get(String id) {
		BkmMatch bkmMatch = super.get(id);
		BkmMatchInfo bkmMatchInfo = new BkmMatchInfo();
		bkmMatchInfo.setMatchId(bkmMatch.getId());
		List<BkmMatchInfo> bkmMatchInfoList = bkmMatchInfoDao.findList(bkmMatchInfo);
		if(bkmMatchInfoList!=null) {
			for(int i = 0;i<bkmMatchInfoList.size();i++) {
				BkmMatchInfo bean = bkmMatchInfoList.get(i);
				// 准备状态 0:未准备 1:准备就绪 2:考试完毕
				if("0".equals(bean.getPreStat())) {
					bean.setPreStat("未准备");
				} else if("1".equals(bean.getPreStat())) {
					bean.setPreStat("准备就绪");
				} else {
					bean.setPreStat("考试完毕");
				}
			}
		}
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
	public void startMatch(BkmMatch bkmMatch) {
		bkmMatch.setMatchStat("1");
		super.save(bkmMatch);
		if(bkmMatch.getHsrType()==0) {
			JSONArray matchHse = getMatchHse(bkmMatch.getHsrNum()); 
			for (BkmMatchInfo bkmMatchInfo : bkmMatch.getBkmMatchInfoList()){
				bkmMatchInfo.setMatchHse(matchHse.toJSONString());
				bkmMatchInfo.preUpdate();
				bkmMatchInfoDao.updateHse(bkmMatchInfo);
			}
		}else if(bkmMatch.getHsrType()==2) {
			JSONArray matchHse = getMatchHseFromLib(bkmMatch.getHsrNum()); 
			for (BkmMatchInfo bkmMatchInfo : bkmMatch.getBkmMatchInfoList()){
				bkmMatchInfo.setMatchHse(matchHse.toJSONString());
				bkmMatchInfo.preUpdate();
				bkmMatchInfoDao.updateHse(bkmMatchInfo);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void stopMatch(BkmMatch bkmMatch) {
		bkmMatch.setMatchStat("2");
		super.save(bkmMatch);
		for (BkmMatchInfo bkmMatchInfo : bkmMatch.getBkmMatchInfoList()){
			bkmMatchInfo.setPreStat("2");
			bkmMatchInfo.preUpdate();
			bkmMatchInfoDao.updateState(bkmMatchInfo);
		}
	}
	
	private JSONArray getMatchHse(int hsrnum) {
		JSONArray hse = new JSONArray();
		Random rand = new Random();
		DecimalFormat dcmFmt = new DecimalFormat("0.00");
		for(int i=0;i<hsrnum;i++) {
			JSONObject question = new JSONObject();
			 float f = rand.nextFloat() * 1000;
			question.put("question", dcmFmt.format(f));
			hse.add(question);
		}
		return hse;
	}
	
	private JSONArray getMatchHseFromLib(int hsrnum) {
		JSONArray hse = new JSONArray();
		List<BkmHsrLib> libquestionlist = bkmHsrLibDao.findRandomList(hsrnum);
		for(BkmHsrLib bkmHsrLib : libquestionlist) {
			JSONObject question = new JSONObject();
			question.put("question",bkmHsrLib.getHsrQuestion());
			question.put("libid",bkmHsrLib.getHsrLibId());
			hse.add(question);
		}
		return hse;
	}
	
	@Transactional(readOnly = false)
	public void delete(BkmMatch bkmMatch) {
		super.delete(bkmMatch);
		//bkmMatchInfoDao.delete(new BkmMatchInfo(bkmMatch));
	}
	
	public String findInfoByUser(String userid){
		String infoid = bkmMatchInfoDao.findInfoByUser(userid);
		return infoid;
	}
	
	@Transactional(readOnly = false)
	public void prepareok(BkmMatch bkmMatch) {
		User currentUser = UserUtils.getUser();
		for (BkmMatchInfo bkmMatchInfo : bkmMatch.getBkmMatchInfoList()){
			if(currentUser.getId().equals(bkmMatchInfo.getMatchUser().getId())) {
				bkmMatchInfo.setPreStat("1");
				bkmMatchInfo.preUpdate();
				bkmMatchInfoDao.updateState(bkmMatchInfo);
				break;
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void matchok(BkmMatch bkmMatch) {
		User currentUser = UserUtils.getUser();
		for (BkmMatchInfo bkmMatchInfo : bkmMatch.getBkmMatchInfoList()){
			if(currentUser.getId().equals(bkmMatchInfo.getMatchUser().getId())) {
				bkmMatchInfo.setPreStat("2");
				bkmMatchInfo.preUpdate();
				bkmMatchInfoDao.updateState(bkmMatchInfo);
				bkmMatchInfoDao.updateHse(bkmMatchInfo);
				break;
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void updateStep(String infoid,String type,int step,int wrong,String answers,String hsrType,String questions) {
		if("0".equals(hsrType)||"2".equals(hsrType)) {
			if("0".equals(type)) {
				bkmMatchInfoDao.stepOK(infoid,step,answers);
			}else {
				bkmMatchInfoDao.stepWrong(infoid,step,answers,wrong);
			}
		} else {
			if("0".equals(type)) {
				bkmMatchInfoDao.stepRandOK(infoid,step,answers,questions);
			}else {
				bkmMatchInfoDao.stepRandWrong(infoid,step,answers,wrong,questions);
			}
		}
	}
	
}