/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.web;

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
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.bkm.entity.BkmMatchInfo;
import com.thinkgem.jeesite.modules.bkm.service.BkmMatchInfoService;

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
	
	@RequiresPermissions("bkm:bkmMatchInfo:view")
	@RequestMapping(value = {"list", ""})
	public String list(BkmMatchInfo bkmMatchInfo, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<BkmMatchInfo> page = bkmMatchInfoService.findPage(new Page<BkmMatchInfo>(request, response), bkmMatchInfo); 
		model.addAttribute("page", page);
		return "modules/bkm/bkmMatchInfoList";
	}

	@RequiresPermissions("bkm:bkmMatchInfo:view")
	@RequestMapping(value = "form")
	public String form(BkmMatchInfo bkmMatchInfo, Model model) {
		model.addAttribute("bkmMatchInfo", bkmMatchInfo);
		return "modules/bkm/bkmMatchInfoForm";
	}

	@RequiresPermissions("bkm:bkmMatchInfo:edit")
	@RequestMapping(value = "save")
	public String save(BkmMatchInfo bkmMatchInfo, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, bkmMatchInfo)){
			return form(bkmMatchInfo, model);
		}
		bkmMatchInfoService.save(bkmMatchInfo);
		addMessage(redirectAttributes, "保存历史记录成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmMatchInfo/?repage";
	}
	
	@RequiresPermissions("bkm:bkmMatchInfo:edit")
	@RequestMapping(value = "delete")
	public String delete(BkmMatchInfo bkmMatchInfo, RedirectAttributes redirectAttributes) {
		bkmMatchInfoService.delete(bkmMatchInfo);
		addMessage(redirectAttributes, "删除历史记录成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmMatchInfo/?repage";
	}

}