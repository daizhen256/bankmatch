package com.thinkgem.jeesite.modules.sys.entity;

import com.alibaba.fastjson.JSONObject;
/**
 * 用于简单业务AJAX处理的JSON类
 * 
 * status  : 0是成功,其他异常
 * message : 返回的信息
 * result  : 默认结果级，可以不使用 
 * 
 * @author 微信攻略组 2014-01-20
 * @version 3.0
 * 
 */
public class JsonPackage extends JSONObject {

	private static final long serialVersionUID = 4755035452111551675L;

	/**
	 * 构造方法
	 * 
	 * @param status
	 * @param message
	 * @param result
	 * @return
	 */	
	public JsonPackage() {
		this.put("status", 0);
		this.put("message", "成功");
	}
	
	public JsonPackage(Integer status, String message) {
		this.put("status", status);
		this.put("message", message);
	}
	
	public JsonPackage(Integer status, String message, Object result) {
		this.put("status", status);
		this.put("message", message);
		this.put("result", result);
	}

	/**
	 * GET AND SET METHODS
	 */
	public Integer getStatus() {
		return this.getInteger("status");
	}

	public void setStatus(Integer status) {
		this.put("status", status);
	}

	public String getMessage() {
		return this.getString("message");
	}

	public void setMessage(String message) {
		this.put("message", message);
	}

	public Object getResult() {
		return this.get("result");
	}

	public void setResult(Object result) {
		this.put("result", result);
	}

}
