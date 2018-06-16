/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.web.contact;

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
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.sys.entity.JsonPackage;
import com.thinkgem.jeesite.modules.sys.entity.contact.SysContact;
import com.thinkgem.jeesite.modules.sys.service.contact.SysContactService;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

/**
 * 联络事项增删改查Controller
 * @author 代震
 * @version 2018-01-04
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/contact/sysContact")
public class SysContactController extends BaseController {

	@Autowired
	private SysContactService sysContactService;
	
	@ModelAttribute
	public SysContact get(@RequestParam(required=false) String id) {
		SysContact entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = sysContactService.get(id);
		}
		if (entity == null){
			entity = new SysContact();
		}
		return entity;
	}
	
	@RequiresPermissions("sys:contact:sysContact:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysContact sysContact, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysContact> page = sysContactService.findPage(new Page<SysContact>(request, response), sysContact); 
		model.addAttribute("page", page);
		return "modules/sys/contact/sysContactList";
	}

	@RequiresPermissions("sys:contact:sysContact:view")
	@RequestMapping(value = "form")
	public String form(SysContact sysContact, Model model) {
		model.addAttribute("sysContact", sysContact);
		return "modules/sys/contact/sysContactForm";
	}

	@RequiresPermissions("sys:contact:sysContact:edit")
	@RequestMapping(value = "save")
	public String save(SysContact sysContact, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysContact)){
			return form(sysContact, model);
		}
		sysContactService.save(sysContact);
		addMessage(redirectAttributes, "保存联络事项成功");
		return "redirect:"+Global.getAdminPath()+"/sys/contact/sysContact/?repage";
	}
	
	@RequiresPermissions("sys:contact:sysContact:edit")
	@RequestMapping(value = "delete")
	public String delete(SysContact sysContact, RedirectAttributes redirectAttributes) {
		sysContactService.delete(sysContact);
		addMessage(redirectAttributes, "删除联络事项成功");
		return "redirect:"+Global.getAdminPath()+"/sys/contact/sysContact/?repage";
	}
	
	@ResponseBody
    @RequestMapping(value = "getusercontact", method=RequestMethod.GET)
	public JsonPackage getUserContact(String userid) {
		JsonPackage json = new JsonPackage();
		JSONObject result = new JSONObject();
		List<SysContact> userContact = sysContactService.getUserContact(userid);
		result.put("data", userContact);
		result.put("num", userContact.size());
		json.setResult(result);
		return json;
	}
	
	@ResponseBody
    @RequestMapping(value = "getcontact", method=RequestMethod.GET)
	public JsonPackage getcontact(String contactid) {
		JsonPackage json = new JsonPackage();
		SysContact contact = sysContactService.get(contactid);
		contact.setReadFlag(DictUtils.getDictValue("已读", "sys_contact_readflag", "1"));
		sysContactService.save(contact);
		json.setResult(contact);
		return json;
	}
	
	@ResponseBody
	@RequestMapping(value = "savequick")
	public JsonPackage savequick(SysContact sysContact) {
		JsonPackage json = new JsonPackage();
		sysContactService.save(sysContact);
		return json;
	}

}