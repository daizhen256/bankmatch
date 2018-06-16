/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.service.contact;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.entity.contact.SysContact;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.dao.contact.SysContactDao;

/**
 * 联络事项增删改查Service
 * @author 代震
 * @version 2018-01-04
 */
@Service
@Transactional(readOnly = true)
public class SysContactService extends CrudService<SysContactDao, SysContact> {

	public SysContact get(String id) {
		return super.get(id);
	}
	
	public List<SysContact> findList(SysContact sysContact) {
		return super.findList(sysContact);
	}
	
	public Page<SysContact> findPage(Page<SysContact> page, SysContact sysContact) {
		return super.findPage(page, sysContact);
	}
	
	@Transactional(readOnly = false)
	public void save(SysContact sysContact) {
		sysContact.setSendDate(new Date());
		if(sysContact.getReadFlag()==null) {
			sysContact.setReadFlag(DictUtils.getDictValue("未读", "sys_contact_readflag", "0"));
		}
		if(sysContact.getSender()==null) {
			sysContact.setSender(sysContact.getCurrentUser());
		}
		super.save(sysContact);
	}
	
	@Transactional(readOnly = false)
	public void delete(SysContact sysContact) {
		super.delete(sysContact);
	}
	
	public List<SysContact> getUserContact(String userid) {
		SysContact sysContact = new SysContact();
		User recever = new User();
		recever.setId(userid);
		sysContact.setReceiver(recever);
		sysContact.setReadFlag(DictUtils.getDictValue("未读", "sys_contact_readflag", "0"));
		return super.findList(sysContact);
	}
	
}