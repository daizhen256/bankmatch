package com.thinkgem.jeesite.common.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.thinkgem.jeesite.modules.bkm.service.BkmMatchInfoService;

@Service
@Lazy(false)
public class HsrLibInfoCollector {

	@Autowired
	private BkmMatchInfoService bkmMatchInfoService;
	
	@Scheduled(cron="0/30 * * * * ? ")
	public void test() {
		System.out.println("定时任务开始啦，哈哈哈");
//		bkmMatchInfoService.
        System.out.println("<<<---------结束执行HR数据同步任务--------->>>"); 
	}
	
}
