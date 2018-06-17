/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.User;

/**
 * 考试管理Entity
 * @author 代震
 * @version 2018-06-17
 */
public class BkmMatchInfo extends DataEntity<BkmMatchInfo> {
	
	private static final long serialVersionUID = 1L;
	private String matchId;		// 考试编号 父类
	private User matchUser;		// 考试者
	private String matchRightRate;		// 正确率
	private String matchHse;		// 考试题目
	private String matchAnswer;		// 创建者
	
	public BkmMatchInfo() {
		super();
	}

	public BkmMatchInfo(String id){
		super(id);
	}

	@Length(min=1, max=64, message="考试编号长度必须介于 1 和 64 之间")
	public String getMatchId() {
		return matchId;
	}

	public void setMatchId(String matchId) {
		this.matchId = matchId;
	}
	
	public User getMatchUser() {
		return matchUser;
	}

	public void setMatchUser(User matchUser) {
		this.matchUser = matchUser;
	}
	
	public String getMatchRightRate() {
		return matchRightRate;
	}

	public void setMatchRightRate(String matchRightRate) {
		this.matchRightRate = matchRightRate;
	}
	
	@Length(min=0, max=3000, message="考试题目长度必须介于 0 和 3000 之间")
	public String getMatchHse() {
		return matchHse;
	}

	public void setMatchHse(String matchHse) {
		this.matchHse = matchHse;
	}
	
	@Length(min=0, max=3000, message="创建者长度必须介于 0 和 3000 之间")
	public String getMatchAnswer() {
		return matchAnswer;
	}

	public void setMatchAnswer(String matchAnswer) {
		this.matchAnswer = matchAnswer;
	}
	
}