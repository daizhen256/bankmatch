/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.bkm.entity.QuestionAndAnswer;
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
		List<BkmMatchInfo> resultlist = super.findList(bkmMatchInfo);
		for(BkmMatchInfo info : resultlist) {
			Double setp = (double) info.getMatchStep();
			if(setp==0) {
				info.setMatchRightRate("0");
			}else {
				Double wrong = (double) info.getWrongNum();
				info.setMatchRightRate(String.valueOf((setp-wrong)/setp*100));
			}
		}
		return resultlist;
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
	
	public List generalAnswerList(String question, String answer) {
		List<QuestionAndAnswer> list = new ArrayList<QuestionAndAnswer>();
		JSONArray qarray = JSON.parseArray(question);
		JSONArray aarray = JSON.parseArray(answer);
		for(int i=0;i<qarray.size();i++) {
			QuestionAndAnswer qaa = new QuestionAndAnswer();
			qaa.setQuestion(qarray.getJSONObject(i).getString("question"));
			if(aarray!=null&&aarray.size()==qarray.size()) {
				qaa.setAnswer(aarray.getJSONObject(i).getString("answer"));
			}else {
				qaa.setAnswer("");
			}
			list.add(qaa);
		}
		return list;
	}
	
}