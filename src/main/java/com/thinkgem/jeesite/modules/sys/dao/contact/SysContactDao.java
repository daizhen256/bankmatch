/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.dao.contact;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.sys.entity.contact.SysContact;

/**
 * 联络事项增删改查DAO接口
 * @author 代震
 * @version 2018-01-04
 */
@MyBatisDao
public interface SysContactDao extends CrudDao<SysContact> {
	
}