/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.bkm.entity.BkmHsrLib;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.bkm.entity.QuestionAndAnswer;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import com.thinkgem.jeesite.modules.bkm.dao.BkmHsrLibDao;
import com.thinkgem.jeesite.modules.bkm.dao.BkmMatchInfoDao;

/**
 * 考试历史管理Service
 * @author 代震
 * @version 2018-06-23
 */
@Service
@Transactional(readOnly = true)
public class BkmMatchInfoService extends CrudService<BkmMatchInfoDao, BkmMatchInfo> {

	@Autowired
	private BkmMatchInfoDao bkmMatchInfoDao;
	
	@Autowired
	private BkmHsrLibDao bkmHsrLibDao;
	
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
		if(question.indexOf("&quot;")!=-1) {
			question = question.replaceAll("&quot;", "\"");
		}
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
	
	@Transactional(readOnly = false)
	public void updateTodayHsrLib() {
		BkmMatchInfo bkmMatchInfo = new BkmMatchInfo();
		bkmMatchInfo.setDelFlag("0");
		Map<String,BkmHsrLib> libmap = new HashMap<String,BkmHsrLib>();
		List<BkmMatchInfo> resultlist = bkmMatchInfoDao.findTodayAllList(bkmMatchInfo);
		for(BkmMatchInfo info : resultlist) {
			String question = info.getMatchHse();
			String answer = info.getMatchAnswer();
			if(answer==null) {
				continue;
			}
			if(question.indexOf("&quot;")!=-1) {
				question = question.replaceAll("&quot;", "\"");
			}
			if(answer.indexOf("&quot;")!=-1) {
				answer = answer.replaceAll("&quot;", "\"");
			}
			JSONArray qarray = JSON.parseArray(question);
			JSONArray aarray = JSON.parseArray(answer);
			for(int i = 0;i<aarray.size();i++) {
				JSONObject qobj = qarray.getJSONObject(i);
				JSONObject aobj = aarray.getJSONObject(i);
				if(!qobj.containsKey("libid")) {
					break;
				}
				if(libmap.containsKey(qobj.getString("libid"))) {
					BkmHsrLib khl = libmap.get(qobj.getString("libid"));
					khl.setHsrUsedTime(String.valueOf(Integer.valueOf(libmap.get(qobj.getString("libid")).getHsrUsedTime())+1));
					if(qobj.getString("question").equals(aobj.getString("answer"))) {
						khl.setHsrRightTime(String.valueOf(Integer.valueOf(libmap.get(qobj.getString("libid")).getHsrRightTime())+1));
					}else {
						khl.setHsrRightTime(String.valueOf(Integer.valueOf(libmap.get(qobj.getString("libid")).getHsrRightTime())));
					}
					libmap.put(qobj.getString("libid"), khl);
				}else {
					BkmHsrLib khl = new BkmHsrLib();
					khl.setHsrLibId(Long.valueOf(qobj.getString("libid")));
					khl.setHsrUsedTime("1");
					if(qobj.getString("question").equals(aobj.getString("answer"))) {
						khl.setHsrRightTime("1");
					}else {
						khl.setHsrRightTime("0");
					}
					libmap.put(qobj.getString("libid"), khl);
				}
			}
		}
		for (Map.Entry<String, BkmHsrLib> entry : libmap.entrySet()) {
			// Map.entry<Integer,String> 映射项（键-值对） 有几个方法：用上面的名字entry
			// entry.getKey() ;entry.getValue(); entry.setValue();
			// map.entrySet() 返回此映射中包含的映射关系的 Set视图。
			//System.out.println("key= " + entry.getKey() + " and value= " + entry.getValue());
			bkmHsrLibDao.updateRightInfo(entry.getValue());
		}
	}
	
}