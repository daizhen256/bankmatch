/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.bkm.entity;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import java.util.List;
import com.google.common.collect.Lists;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 考试管理Entity
 * @author 代震
 * @version 2018-06-17
 */
public class BkmMatch extends DataEntity<BkmMatch> {
	
	private static final long serialVersionUID = 1L;
	private Date matchDate;		// 考试日期
	private String matchName;		// 考试名称
	private int matchPeopleCount;		// 总人数
	private double matchAveragePoint;		// 平均分
	private String matchStat;			// 考试状态
	private List<BkmMatchInfo> bkmMatchInfoList = Lists.newArrayList();		// 子表列表
	
	public BkmMatch() {
		super();
	}

	public BkmMatch(String id){
		super(id);
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@NotNull(message="考试日期不能为空")
	public Date getMatchDate() {
		return matchDate;
	}

	public void setMatchDate(Date matchDate) {
		this.matchDate = matchDate;
	}
	
	@Length(min=1, max=256, message="考试名称长度必须介于 1 和 256 之间")
	public String getMatchName() {
		return matchName;
	}

	public void setMatchName(String matchName) {
		this.matchName = matchName;
	}
	
	public int getMatchPeopleCount() {
		return matchPeopleCount;
	}

	public void setMatchPeopleCount(int matchPeopleCount) {
		this.matchPeopleCount = matchPeopleCount;
	}
	
	public double getMatchAveragePoint() {
		return matchAveragePoint;
	}

	public void setMatchAveragePoint(double matchAveragePoint) {
		this.matchAveragePoint = matchAveragePoint;
	}
	
	public List<BkmMatchInfo> getBkmMatchInfoList() {
		return bkmMatchInfoList;
	}

	public void setBkmMatchInfoList(List<BkmMatchInfo> bkmMatchInfoList) {
		this.bkmMatchInfoList = bkmMatchInfoList;
	}

	public String getMatchStat() {
		return matchStat;
	}

	public void setMatchStat(String matchStat) {
		this.matchStat = matchStat;
	}
	
}