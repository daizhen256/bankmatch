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
import com.thinkgem.jeesite.modules.bkm.entity.BkmHsrLib;
import com.thinkgem.jeesite.modules.bkm.service.BkmHsrLibService;

/**
 * 题库信息管理Controller
 * @author 代震
 * @version 2018-06-19
 */
@Controller
@RequestMapping(value = "${adminPath}/bkm/bkmHsrLib")
public class BkmHsrLibController extends BaseController {

	@Autowired
	private BkmHsrLibService bkmHsrLibService;
	
	@ModelAttribute
	public BkmHsrLib get(@RequestParam(required=false) String id) {
		BkmHsrLib entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = bkmHsrLibService.get(id);
		}
		if (entity == null){
			entity = new BkmHsrLib();
		}
		return entity;
	}
	
	@RequiresPermissions("bkm:bkmHsrLib:view")
	@RequestMapping(value = {"list", ""})
	public String list(BkmHsrLib bkmHsrLib, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<BkmHsrLib> page = bkmHsrLibService.findPage(new Page<BkmHsrLib>(request, response), bkmHsrLib); 
		model.addAttribute("page", page);
		return "modules/bkm/bkmHsrLibList";
	}

	@RequiresPermissions("bkm:bkmHsrLib:view")
	@RequestMapping(value = "form")
	public String form(BkmHsrLib bkmHsrLib, Model model) {
		model.addAttribute("bkmHsrLib", bkmHsrLib);
		return "modules/bkm/bkmHsrLibForm";
	}

	@RequiresPermissions("bkm:bkmHsrLib:edit")
	@RequestMapping(value = "save")
	public String save(BkmHsrLib bkmHsrLib, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, bkmHsrLib)){
			return form(bkmHsrLib, model);
		}
		bkmHsrLibService.save(bkmHsrLib);
		addMessage(redirectAttributes, "保存题库信息成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmHsrLib/?repage";
	}
	
	@RequiresPermissions("bkm:bkmHsrLib:edit")
	@RequestMapping(value = "delete")
	public String delete(BkmHsrLib bkmHsrLib, RedirectAttributes redirectAttributes) {
		bkmHsrLibService.delete(bkmHsrLib);
		addMessage(redirectAttributes, "删除题库信息成功");
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmHsrLib/?repage";
	}

}