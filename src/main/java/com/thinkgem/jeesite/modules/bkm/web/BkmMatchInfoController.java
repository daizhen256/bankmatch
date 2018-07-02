/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.bkm.service.BkmMatchInfoService;
import com.thinkgem.jeesite.modules.bkm.service.BkmMatchService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 考试历史管理Controller
 * @author 代震
 * @version 2018-06-23
 */
@Controller
@RequestMapping(value = "${adminPath}/bkm/bkmMatchInfo")
public class BkmMatchInfoController extends BaseController {

	@Autowired
	private BkmMatchInfoService bkmMatchInfoService;
	
	@Autowired
	private BkmMatchService bkmMatchService;
	
	@ModelAttribute
	public BkmMatchInfo get(@RequestParam(required=false) String id) {
		BkmMatchInfo entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = bkmMatchInfoService.get(id);
		}
		if (entity == null){
			entity = new BkmMatchInfo();
		}
		return entity;
	}
	
	/**
	 * 查看成绩单列表
	 * @param bkmMatchInfo
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("bkm:bkmMatchInfo:view")
	@RequestMapping(value = {"list", ""})
	public String list(BkmMatchInfo bkmMatchInfo, HttpServletRequest request, HttpServletResponse response, Model model) {
		bkmMatchInfo.setMatchUser(UserUtils.getUser());
		List<BkmMatchInfo> page = bkmMatchInfoService.findList(bkmMatchInfo); 
		model.addAttribute("list", page);
		return "modules/bkm/bkmMatchInfoList";
	}

	/**
	 * 查看成绩单详细
	 * @param bkmMatchInfo
	 * @param model
	 * @return
	 */
	@RequiresPermissions("bkm:bkmMatchInfo:view")
	@RequestMapping(value = "form")
	public String form(BkmMatchInfo bkmMatchInfo, Model model) {
		BkmMatch bkmMatch = bkmMatchService.get(bkmMatchInfo.getMatchId());
		Double setp = (double) bkmMatchInfo.getMatchStep();
		Double wrong = (double) bkmMatchInfo.getWrongNum();
		if(setp==0) {
			bkmMatchInfo.setMatchRightRate("0");
		} else {
			bkmMatchInfo.setMatchRightRate(String.valueOf((setp-wrong)/setp*100));
		}
		model.addAttribute("bkmMatchInfo", bkmMatchInfo);
		String question = bkmMatchInfo.getMatchHse();
		String answer = bkmMatchInfo.getMatchAnswer();
		model.addAttribute("qalist", bkmMatchInfoService.generalAnswerList(question, answer));
		model.addAttribute("bkmMatch", bkmMatch);
		return "modules/bkm/bkmMatchInfoForm";
	}

}