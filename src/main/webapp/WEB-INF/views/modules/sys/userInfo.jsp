<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>个人信息</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${ctxStatic}/css/cropper.min.css" rel="stylesheet">
	<link href="${ctxStatic}/css/sitelogo.css" rel="stylesheet">
	<script src="${ctxStatic}/js/cropper.min.js"></script>
	<script src="${ctxStatic}/js/sitelogo.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#inputForm").validate({
				submitHandler: function(form){
					var avatarUriArr = jQuery("#avatarImg")[0].src.split('/');
					form.photo.value = avatarUriArr[avatarUriArr.length-1];
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					jQuery("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
	<div class="modal fade" id="avatar-modal" aria-hidden="true" aria-labelledby="avatar-modal-label" role="dialog" tabindex="-1" style="display: none;">
		<div class="modal-dialog modal-lg">
			<div class="modal-content" style="width:860px;margin-left: -110px;">
				<form class="avatar-form" action="${ctx}/sys/user/uploadavatar" enctype="multipart/form-data" method="post">
					<div class="modal-header">
						<button class="close" data-dismiss="modal" type="button">×</button>
						<h4 class="modal-title" id="avatar-modal-label">更改头像</h4>
					</div>
					<div class="modal-body">
						<div class="avatar-body">
							<div class="avatar-upload">
								<input class="avatar-src" name="avatar_src" type="hidden">
								<input class="avatar-data" name="avatar_data" type="hidden">
								<label for="avatarInput">图片上传</label>
								<input class="avatar-input" id="avatarInput" name="avatar_file" type="file"></div>
							<div class="row">
								<div class="col-md-9">
									<div class="avatar-wrapper"></div>
								</div>
								<div class="col-md-3">
									<div class="avatar-preview preview-lg"></div>
									<div class="avatar-preview preview-md"></div>
									<div class="avatar-preview preview-sm"></div>
								</div>
							</div>
							<div class="row avatar-btns">
								<div class="col-md-9">
									<div class="btn-group">
										<button class="btn" data-method="rotate" data-option="-90" type="button" title="Rotate -90 degrees"><i class="fa fa-undo"></i> 向左旋转</button>
									</div>
									<div class="btn-group">
										<button class="btn" data-method="rotate" data-option="90" type="button" title="Rotate 90 degrees"><i class="fa fa-repeat"></i> 向右旋转</button>
									</div>
								</div>
								<div class="col-md-3">
									<button class="btn btn-success btn-block avatar-save" type="submit"><i class="fa fa-save"></i> 保存修改</button>
								</div>
							</div>
						</div>
					</div>
	  		</form>
	  	</div>
	  </div>
	</div>
	
	<div class="loading" aria-label="Loading" role="img" tabindex="-1"></div>
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/info" method="post" class="form-horizontal"><%--
		<form:hidden path="email" htmlEscape="false" maxlength="255" class="input-xlarge"/>
		<sys:ckfinder input="email" type="files" uploadPath="/mytask" selectMultiple="false"/> --%>
		<sys:message content="${message}"/>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">头像:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<form:hidden id="nameImage" path="photo" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<div class="ibox-content">
						<div class="row">
							<div id="crop-avatar" class="col-md-6">
								<div class="avatar-view" title="" data-original-title="点击此处更改头像">
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
		<div class="col-md-8">
			<div class="form-group">
				<label class="lbl">${user.company.name}</label>
			</div>
		</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">归属部门:</label>
			</div>
			<div class="col-md-8">
				<div class="form-group">
					<label class="lbl">${user.office.name}</label>
				</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">姓名:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<form:input path="name" htmlEscape="false" maxlength="50" class="required" readonly="true"/>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">邮箱:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<form:input path="email" htmlEscape="false" maxlength="50" class="email"/>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">电话:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<form:input path="phone" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">手机:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<form:input path="mobile" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">备注:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">用户类型:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<label class="lbl">${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</label>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">用户角色:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<label class="lbl">${user.roleNames}</label>
			</div>
		</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">上次登录:</label>
		</div>
		<div class="col-md-8">
			<div class="form-group">
				<label class="lbl">IP: ${user.oldLoginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.oldLoginDate}" type="both" dateStyle="full"/></label>
			</div>
		</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
		</div>
	</form:form>
</body>
</html>