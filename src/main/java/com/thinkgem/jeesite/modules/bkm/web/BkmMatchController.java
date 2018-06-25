/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alibaba.fastjson.JSONObject;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.Collections3;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.bkm.service.BkmMatchService;
import com.thinkgem.jeesite.modules.sys.entity.JsonPackage;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.OfficeService;
import com.thinkgem.jeesite.modules.sys.service.SystemService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 考试管理Controller
 * @author 代震
 * @version 2018-06-17
 */
@Controller
@RequestMapping(value = "${adminPath}/bkm/bkmMatch")
public class BkmMatchController extends BaseController {

	@Autowired
	private BkmMatchService bkmMatchService;
	
	@Autowired
	private SystemService systemService;
	
	@Autowired
	private OfficeService officeService;
	
	@ModelAttribute
	public BkmMatch get(@RequestParam(required=false) String id) {
		BkmMatch entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = bkmMatchService.get(id);
		}
		if (entity == null){
			entity = new BkmMatch();
		}
		return entity;
	}
	
	@RequiresPermissions("bkm:bkmMatch:view")
	@RequestMapping(value = {"list", ""})
	public String list(BkmMatch bkmMatch, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<BkmMatch> page = bkmMatchService.findPage(new Page<BkmMatch>(request, response), bkmMatch); 
		model.addAttribute("page", page);
		return "modules/bkm/bkmMatchList";
	}

	@RequiresPermissions("bkm:bkmMatch:view")
	@RequestMapping(value = "form")
	public String form(BkmMatch bkmMatch, Model model) {
		model.addAttribute("bkmMatch", bkmMatch);
		return "modules/bkm/bkmMatchForm";
	}
	
	@RequiresPermissions("bkm:bkmMatch:view")
	@RequestMapping(value = "usertomatch")
	public String selectUserToRole(BkmMatch bkmMatch, Model model) {
		List<BkmMatchInfo> matcherList = bkmMatchService.findInfoByMatch(bkmMatch);
		model.addAttribute("match", bkmMatch);
		model.addAttribute("userList", matcherList);
		model.addAttribute("selectIds", Collections3.extractToString(matcherList, "matchUser.id", ","));
		model.addAttribute("selectNames", Collections3.extractToString(matcherList, "matchUser.name", ","));
		model.addAttribute("officeList", officeService.findAll());
		return "modules/bkm/selectUserToMatch";
	}

	@RequiresPermissions("bkm:bkmMatch:edit")
	@RequestMapping(value = "save")
	public String save(BkmMatch bkmMatch, Model model, RedirectAttributes redirectAttributes) {
		ArrayList<BkmMatchInfo> matchInfoList = new ArrayList<BkmMatchInfo>();
		String[] useridArr = bkmMatch.getBkmMatchInfoList().get(0).getMatchUser().getId().split(",");
		String[] usernameArr = bkmMatch.getBkmMatchInfoList().get(0).getMatchUser().getName().split(",");
		for(int i=0;i<useridArr.length;i++) {
			BkmMatchInfo newbean = new BkmMatchInfo();
			User matchUser = new User();
			matchUser.setId(useridArr[i]);
			matchUser.setName(usernameArr[i]);
			newbean.setMatchUser(matchUser);
			newbean.setPreStat("0");
			matchInfoList.add(newbean);
		}
		bkmMatch.setBkmMatchInfoList(matchInfoList);
		bkmMatch.setMatchPeopleCount(useridArr.length);
		bkmMatch.setMatchDate(new Date());
		bkmMatch.setMatchStat("0");
		if (!beanValidator(model, bkmMatch)){
			return form(bkmMatch, model);
		}
		bkmMatchService.save(bkmMatch);
		addMessage(redirectAttributes, "保存考试信息成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmMatch/form?id="+bkmMatch.getId();
	}
	
	@ResponseBody
	@RequestMapping(value = "startmatch")
	public JsonPackage startmatch(BkmMatch bkmMatch, Model model, RedirectAttributes redirectAttributes) {
		JsonPackage json = new JsonPackage();
		if (!beanValidator(model, bkmMatch)){
			json.setStatus(500);
			json.setMessage("数据验证出错，请联系管理员！");
		}
		bkmMatchService.startMatch(bkmMatch);
		json.setMessage("保存考试信息成功");
		return json;
	}
	
	@ResponseBody
	@RequestMapping(value = "stopmatch")
	public JsonPackage stopmatch(BkmMatch bkmMatch, Model model, RedirectAttributes redirectAttributes) {
		JsonPackage json = new JsonPackage();
		if (!beanValidator(model, bkmMatch)){
			json.setStatus(500);
			json.setMessage("数据验证出错，请联系管理员！");
		}
		bkmMatchService.stopMatch(bkmMatch);
		json.setMessage("保存考试信息成功");
		return json;
	}
	
	@RequiresPermissions("bkm:bkmMatch:edit")
	@RequestMapping(value = "delete")
	public String delete(BkmMatch bkmMatch, RedirectAttributes redirectAttributes) {
		bkmMatchService.delete(bkmMatch);
		addMessage(redirectAttributes, "删除考试信息成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmMatch/?repage";
	}
	
	@ResponseBody
    @RequestMapping(value = "getmatchpre", method=RequestMethod.GET)
	public JsonPackage getUserContact(String id) {
		BkmMatch bkmMatch = new BkmMatch();
		bkmMatch.setId(id);
		JsonPackage json = new JsonPackage();
		JSONObject result = new JSONObject();
		List<BkmMatchInfo> matcherList = bkmMatchService.findInfoByMatch(bkmMatch);
		result.put("data", matcherList);
		json.setResult(result);
		return json;
	}
	
	@ResponseBody
    @RequestMapping(value = "getMatchOrder", method=RequestMethod.GET)
	public JsonPackage getMatchOrder(String userid) {
		JsonPackage json = new JsonPackage();
		String matchinfoid = bkmMatchService.findInfoByUser(userid);
		json.setResult(matchinfoid);
		return json;
	}
	
	@RequestMapping(value = "matchinit")
	public String matchinit(BkmMatch bkmMatch, Model model) {
		User currentUser = UserUtils.getUser();
		List bkmMatchInfoList = new ArrayList<BkmMatchInfo>();
		for(int i=0; i<bkmMatch.getBkmMatchInfoList().size();i++) {
			if(currentUser.getId().equals(bkmMatch.getBkmMatchInfoList().get(i).getMatchUser().getId())) {
				bkmMatchInfoList.add(bkmMatch.getBkmMatchInfoList().get(i));
				break;
			}
		}
		bkmMatch.setBkmMatchInfoList(bkmMatchInfoList);
		Calendar calendar = Calendar.getInstance(); //得到日历
		calendar.setTime(bkmMatch.getMatchStartDate());//把当前时间赋给日历
		calendar.add(Calendar.MINUTE, bkmMatch.getMatchTime());  //设置为前2月
		bkmMatch.setMatchStartDate(calendar.getTime());
		model.addAttribute("bkmMatch", bkmMatch);
		return "modules/bkm/bkmMatchWrite";
	}
	
	@RequestMapping(value = "prepareok")
	public String prepareok(BkmMatch bkmMatch, Model model) {
		bkmMatchService.prepareok(bkmMatch);
		User currentUser = UserUtils.getUser();
		List bkmMatchInfoList = new ArrayList<BkmMatchInfo>();
		for(int i=0; i<bkmMatch.getBkmMatchInfoList().size();i++) {
			if(currentUser.getId().equals(bkmMatch.getBkmMatchInfoList().get(i).getMatchUser().getId())) {
				bkmMatchInfoList.add(bkmMatch.getBkmMatchInfoList().get(i));
				break;
			}
		}
		bkmMatch.setBkmMatchInfoList(bkmMatchInfoList);
		Calendar calendar = Calendar.getInstance(); //得到日历
		calendar.setTime(bkmMatch.getMatchStartDate());//把当前时间赋给日历
		calendar.add(Calendar.MINUTE, bkmMatch.getMatchTime());  //设置为前2月
		bkmMatch.setMatchStartDate(calendar.getTime());
		model.addAttribute("bkmMatch", bkmMatch);
		return "modules/bkm/bkmMatchWrite";
	}
	
	//考试交卷
	@RequestMapping(value = "matchok")
	public String matchok(BkmMatch bkmMatch, Model model) {
		bkmMatchService.matchok(bkmMatch);
		UserUtils.getSubject().logout();
		return "redirect:" + adminPath + "/login";
	}
	
	@ResponseBody
    @RequestMapping(value = "updatestep", method=RequestMethod.POST)
	public JsonPackage updatestep(String infoid,String type,int step,int wrong,String answers,String hsrType,String questions) {
		JsonPackage json = new JsonPackage();
		String jsonAnswers = answers.replaceAll("&quot;", "\"");
		String jsonQuestions = questions.replaceAll("&quot;", "\"");
		bkmMatchService.updateStep(infoid,type,step,wrong,jsonAnswers,hsrType,questions);
		return json;
	}
	
	

}