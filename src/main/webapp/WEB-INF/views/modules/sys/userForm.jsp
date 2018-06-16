<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>用户管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css"
	rel="stylesheet" media="screen" />
<link href="${ctxStatic}/css/cropper.min.css" rel="stylesheet">
<link href="${ctxStatic}/css/sitelogo.css" rel="stylesheet">
<script src="${ctxStatic}/js/cropper.min.js"></script>
<script src="${ctxStatic}/js/sitelogo.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("#no").focus();
						$("#inputForm")
								.validate(
										{
											rules : {
												loginName : {
													remote : "${ctx}/sys/user/checkLoginName?oldLoginName="
															+ encodeURIComponent('${user.loginName}')
												}
											},
											messages : {
												loginName : {
													remote : "用户登录名已存在"
												},
												confirmNewPassword : {
													equalTo : "输入与上面相同的密码"
												}
											},
											submitHandler : function(form) {
												var avatarUriArr = jQuery("#avatarImg")[0].src.split('/');
												form.photo.value = avatarUriArr[avatarUriArr.length-1];
												loading('正在提交，请稍等...');
												form.submit();
											},
											errorContainer : "#messageBox",
											errorPlacement : function(error,
													element) {
												$("#messageBox").text(
														"输入有误，请先更正。");
												if (element.is(":checkbox")
														|| element.is(":radio")
														|| element
																.parent()
																.is(
																		".input-append")) {
													error.appendTo(element
															.parent().parent());
												} else {
													error.insertAfter(element);
												}
											}
										});
					});
</script>
</head>
<body>
	<div class="modal fade" id="avatar-modal" aria-hidden="true"
		aria-labelledby="avatar-modal-label" role="dialog" tabindex="-1"
		style="display: none;">
		<div class="modal-dialog modal-lg" style="width: 840px;margin-top: -15px;">
			<div class="modal-content">
				<form class="avatar-form" action="${ctx}/sys/user/uploadavatar"
					enctype="multipart/form-data" method="post">
					<div class="modal-header">
						<button class="close" data-dismiss="modal" type="button">×</button>
						<h4 class="modal-title" id="avatar-modal-label">更改头像</h4>
					</div>
					<div class="modal-body">
						<div class="avatar-body">
							<div class="avatar-upload">
								<input class="avatar-src" name="avatar_src" type="hidden">
								<input class="avatar-data" name="avatar_data" type="hidden">
								<label for="avatarInput">图片上传</label> <input
									class="avatar-input" id="avatarInput" name="avatar_file"
									type="file">
							</div>
							<div class="row">
								<div class="col-xs-9">
									<div class="avatar-wrapper"></div>
								</div>
								<div class="col-xs-3">
									<div class="avatar-preview preview-lg"></div>
									<div class="avatar-preview preview-md"></div>
									<div class="avatar-preview preview-sm"></div>
								</div>
							</div>
							<div class="row avatar-btns">
								<div class="col-xs-9">
									<div class="btn-group">
										<button class="btn" data-method="rotate" data-option="-90"
											type="button" title="Rotate -90 degrees">
											<i class="fa fa-undo"></i> 向左旋转
										</button>
									</div>
									<div class="btn-group">
										<button class="btn" data-method="rotate" data-option="90"
											type="button" title="Rotate 90 degrees">
											<i class="fa fa-repeat"></i> 向右旋转
										</button>
									</div>
								</div>
								<div class="col-xs-3">
									<button class="btn btn-success btn-block avatar-save"
										type="submit">
										<i class="fa fa-save"></i> 保存修改
									</button>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<form:form id="inputForm" modelAttribute="user"
		action="${ctx}/sys/user/save" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">头像:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:hidden id="nameImage" path="photo" htmlEscape="false"
						maxlength="255" class="input-xlarge" />
					<div class="ibox-content">
						<div class="row">
							<div id="crop-avatar" class="col-xs-6">
								<div class="avatar-view" title=""
									data-original-title="Change Logo Picture">
									<img id="avatarImg" src="${avatarUri}/large/${user.photo}" alt="头像">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">归属公司:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<sys:treeselect id="company" name="company.id"
						value="${user.company.id}" labelName="company.name"
						labelValue="${user.company.name}" title="公司"
						url="/sys/office/treeData?type=1" cssClass="required" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">归属部门:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<sys:treeselect id="office" name="office.id"
						value="${user.office.id}" labelName="office.name"
						labelValue="${user.office.name}" title="部门"
						url="/sys/office/treeData?type=2" cssClass="required"
						notAllowSelectParent="true" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">工号:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="no" htmlEscape="false" maxlength="50"
						class="required" />
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">姓名:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="name" htmlEscape="false" maxlength="50"
						class="required" />
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">登录名:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<input id="oldLoginName" name="oldLoginName" type="hidden"
						value="${user.loginName}">
					<form:input path="loginName" htmlEscape="false" maxlength="50"
						class="required userName" />
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">密码:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<input id="newPassword" name="newPassword" type="password" value=""
						maxlength="50" minlength="3"
						class="${empty user.id?'required':''}" />
					<c:if test="${empty user.id}">
						<span class="help-inline"><font color="red">*</font> </span>
					</c:if>
					<c:if test="${not empty user.id}">
						<span class="help-inline">若不修改密码，请留空。</span>
					</c:if>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">确认密码:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<input id="confirmNewPassword" name="confirmNewPassword"
						type="password" value="" maxlength="50" minlength="3"
						equalTo="#newPassword" />
					<c:if test="${empty user.id}">
						<span class="help-inline"><font color="red">*</font> </span>
					</c:if>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">邮箱:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="email" htmlEscape="false" maxlength="100"
						class="email" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">电话:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="phone" htmlEscape="false" maxlength="100" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">手机:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="mobile" htmlEscape="false" maxlength="100" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">是否允许登录:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:select path="loginFlag">
						<form:options items="${fns:getDictList('yes_no')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
					<span class="help-inline"><font color="red">*</font>
						“是”代表此账号允许登录，“否”则表示此账号不允许登录</span>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">用户类型:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:select path="userType" class="input-xlarge">
						<form:option value="" label="请选择" />
						<form:options items="${fns:getDictList('sys_user_type')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">用户角色:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:checkboxes path="roleIdList" items="${allRoles}"
						itemLabel="name" itemValue="id" htmlEscape="false"
						class="required" />
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">备注:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:textarea path="remarks" htmlEscape="false" rows="3"
						maxlength="200" class="input-xlarge" />
				</div>
			</div>
		</div>
		<c:if test="${not empty user.id}">
			<div class="control-group">
				<div class="col-md-2">
					<label class="control-label">创建时间:</label>
				</div>
				<div class="col-md-10">
					<div class="form-group">
						<label class="lbl"><fmt:formatDate
								value="${user.createDate}" type="both" dateStyle="full" /></label>
					</div>
				</div>
			</div>
			<div class="control-group">
				<div class="col-md-2">
					<label class="control-label">最后登陆:</label>
				</div>
				<div class="col-md-10">
					<div class="form-group">
						<label class="lbl">IP:
							${user.loginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate
								value="${user.loginDate}" type="both" dateStyle="full" />
						</label>
					</div>
				</div>
			</div>
		</c:if>
		<div class="form-actions">
			<shiro:hasPermission name="sys:user:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-info" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>