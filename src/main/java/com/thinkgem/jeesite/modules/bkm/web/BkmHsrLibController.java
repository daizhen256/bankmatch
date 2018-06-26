/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.beanvalidator.BeanValidators;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ExportExcel;
import com.thinkgem.jeesite.common.utils.excel.ImportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.bkm.entity.BkmHsrLib;
import com.thinkgem.jeesite.modules.bkm.service.BkmHsrLibService;
import com.thinkgem.jeesite.modules.sys.entity.User;

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
	
	/**
	 * 下载导入用户数据模板
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("bkm:bkmHsrLib:view")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "题库数据导入模板.xlsx";
    		List<BkmHsrLib> list = Lists.newArrayList();;
    		new ExportExcel("题库数据", BkmHsrLib.class, 2).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmHsrLib/?repage";
    }
	
	/**
	 * 导入用户数据
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("bkm:bkmHsrLib:edit")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<BkmHsrLib> list = ei.getDataList(BkmHsrLib.class);
			for (BkmHsrLib bkmHsrLib : list){
				try{
					BeanValidators.validateWithException(validator, bkmHsrLib);
					bkmHsrLibService.save(bkmHsrLib);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureMsg.append("<br/>题目 "+bkmHsrLib.getHsrQuestion()+" 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList){
						failureMsg.append(message+"; ");
						failureNum++;
					}
				}catch (Exception ex) {
					failureMsg.append("<br/>题目 "+bkmHsrLib.getHsrQuestion()+" 导入失败："+ex.getMessage());
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条题目，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条题目"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入题库失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmHsrLib/?repage";
    }
	
	/**
	 * 导出用户数据
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("bkm:bkmHsrLib:view")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(BkmHsrLib bkmHsrLib, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "题库数据"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<BkmHsrLib> page = bkmHsrLibService.findPage(new Page<BkmHsrLib>(request, response, -1), bkmHsrLib);
    		new ExportExcel("题库数据", BkmHsrLib.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出用户失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/bkm/bkmHsrLib/?repage";
    }

}