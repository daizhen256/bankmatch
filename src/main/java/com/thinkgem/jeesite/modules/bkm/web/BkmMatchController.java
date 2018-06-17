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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.Collections3;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatch;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.bkm.service.BkmMatchService;
import com.thinkgem.jeesite.modules.sys.entity.Role;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.service.OfficeService;
import com.thinkgem.jeesite.modules.sys.service.SystemService;

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
		model.addAttribute("selectIds", Collections3.extractToString(matcherList, "matchUser", ","));
		model.addAttribute("officeList", officeService.findAll());
		return "modules/bkm/selectUserToMatch";
	}

	@RequiresPermissions("bkm:bkmMatch:edit")
	@RequestMapping(value = "save")
	public String save(BkmMatch bkmMatch, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, bkmMatch)){
			return form(bkmMatch, model);
		}
		bkmMatchService.save(bkmMatch);
		addMessage(redirectAttributes, "保存考试信息成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmMatch/?repage";
	}
	
	@RequiresPermissions("bkm:bkmMatch:edit")
	@RequestMapping(value = "delete")
	public String delete(BkmMatch bkmMatch, RedirectAttributes redirectAttributes) {
		bkmMatchService.delete(bkmMatch);
		addMessage(redirectAttributes, "删除考试信息成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmMatch/?repage";
	}

}