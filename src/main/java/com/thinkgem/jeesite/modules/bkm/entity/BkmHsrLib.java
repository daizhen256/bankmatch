/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.entity;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 题库信息管理Entity
 * @author 代震
 * @version 2018-06-19
 */
public class BkmHsrLib extends DataEntity<BkmHsrLib> {
	
	private static final long serialVersionUID = 1L;
	private Long hsrLibId;		// 题目ID
	private String hsrQuestion;		// 题干
	private String hsrRightAnswer;		// 正确答案
	private String hsrUsedTime;		// 使用次数
	private String hsrRightTime;		// 正确回答次数
	
	public BkmHsrLib() {
		super();
	}

	public BkmHsrLib(String id){
		super(id);
	}

	public Long getHsrLibId() {
		return hsrLibId;
	}

	public void setHsrLibId(Long hsrLibId) {
		this.hsrLibId = hsrLibId;
	}
	
	@Length(min=0, max=255, message="题干长度必须介于 0 和 255 之间")
	public String getHsrQuestion() {
		return hsrQuestion;
	}

	public void setHsrQuestion(String hsrQuestion) {
		this.hsrQuestion = hsrQuestion;
	}
	
	@Length(min=0, max=64, message="正确答案长度必须介于 0 和 64 之间")
	public String getHsrRightAnswer() {
		return hsrRightAnswer;
	}

	public void setHsrRightAnswer(String hsrRightAnswer) {
		this.hsrRightAnswer = hsrRightAnswer;
	}
	
	@Length(min=0, max=10, message="使用次数长度必须介于 0 和 10 之间")
	public String getHsrUsedTime() {
		return hsrUsedTime;
	}

	public void setHsrUsedTime(String hsrUsedTime) {
		this.hsrUsedTime = hsrUsedTime;
	}
	
	@Length(min=0, max=10, message="正确回答次数长度必须介于 0 和 10 之间")
	public String getHsrRightTime() {
		return hsrRightTime;
	}

	public void setHsrRightTime(String hsrRightTime) {
		this.hsrRightTime = hsrRightTime;
	}
	
}