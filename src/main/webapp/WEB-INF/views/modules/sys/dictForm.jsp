<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#value").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
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
	<form:form id="inputForm" modelAttribute="dict" action="${ctx}/sys/dict/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">键值:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="value" htmlEscape="false" maxlength="50" class="form-control required"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">标签:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="label" htmlEscape="false" maxlength="50" class="form-control required"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">类型:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="type" htmlEscape="false" maxlength="50" class="form-control required abc"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">描述:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="description" htmlEscape="false" maxlength="50" class="form-control required"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">排序:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="sort" htmlEscape="false" maxlength="11" class="form-control required digits"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">备注:</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control input-xlarge"/>
				</div>
			</div>
		</div>
		<div class="form-actions">
			<div>
				<shiro:hasPermission name="sys:dict:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-info" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
</body>
</html>