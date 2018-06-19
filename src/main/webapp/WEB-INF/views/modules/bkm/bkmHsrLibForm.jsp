<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>题库信息管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
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
	<form:form id="inputForm" modelAttribute="bkmHsrLib" action="${ctx}/bkm/bkmHsrLib/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">题干：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				<form:input path="hsrQuestion" htmlEscape="false" maxlength="255" class="input-xlarge "/>
			</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">正确答案：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				<form:input path="hsrRightAnswer" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">备注信息：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="bkm:bkmHsrLib:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-info" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>