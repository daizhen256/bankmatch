<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
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
	<form:form id="inputForm" modelAttribute="office" action="${ctx}/sys/office/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="control-group">
			<div class="col-xs-2">
				<label class="control-label">上级机构:</label>
			</div>
			<div class="col-xs-10">
				<div class="form-group">
	                <sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
						title="机构" url="/sys/office/treeData" extId="${office.id}" cssClass="" allowClear="${office.currentUser.admin}"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-xs-2">
				<label class="control-label">归属区域:</label>
			</div>
			<div class="col-xs-10">
				<div class="form-group">
                	<sys:treeselect id="area" name="area.id" value="${office.area.id}" labelName="area.name" labelValue="${office.area.name}"
						title="区域" url="/sys/area/treeData" cssClass="required"/>
				</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">机构名称:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">机构编码:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="code" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">机构类型:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:select path="type" class="input-medium" style="width:160px;">
					<form:options items="${fns:getDictList('sys_office_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">机构级别:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:select path="grade" class="input-medium" style="width:160px;">
					<form:options items="${fns:getDictList('sys_office_grade')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">是否可用:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:select path="useable" style="width:160px;">
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">主负责人:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				 <sys:treeselect id="primaryPerson" name="primaryPerson.id" value="${office.primaryPerson.id}" labelName="office.primaryPerson.name" labelValue="${office.primaryPerson.name}"
					title="用户" url="/sys/office/treeData?type=3" allowClear="true" notAllowSelectParent="true"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">副负责人:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				 <sys:treeselect id="deputyPerson" name="deputyPerson.id" value="${office.deputyPerson.id}" labelName="office.deputyPerson.name" labelValue="${office.deputyPerson.name}"
					title="用户" url="/sys/office/treeData?type=3" allowClear="true" notAllowSelectParent="true"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">联系地址:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="address" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">邮政编码:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="zipCode" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">负责人:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="master" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">电话:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="phone" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">传真:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="fax" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">邮箱:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:input path="email" htmlEscape="false" maxlength="50"/>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-xs-2">
			<label class="control-label">备注:</label>
			</div>
			<div class="col-xs-10">
			<div class="form-group">
				<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
			</div>
			</div>
		</div>
		<c:if test="${empty office.id}">
			<div class="control-group">
			<div class="col-xs-2">
				<label class="control-label">快速添加下级部门:</label>
				</div>
				<div class="col-xs-10">
				<div class="form-group">
					<form:checkboxes path="childDeptList" items="${fns:getDictList('sys_office_common')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</div>
				</div>
			</div>
		</c:if>
		<div class="form-actions">
			<shiro:hasPermission name="sys:office:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-info" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>