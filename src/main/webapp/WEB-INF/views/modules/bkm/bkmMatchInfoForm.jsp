<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>历史记录管理</title>
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
	<form:form id="inputForm" modelAttribute="bkmMatchInfo" action="${ctx}/bkm/bkmMatchInfo/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">考试名称：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				${bkmMatch.matchName}
			</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">考试时间：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				<fmt:formatDate value="${bkmMatch.matchDate}" type="both" dateStyle="full"/>
			</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">考试者：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				${fns:getUserById(bkmMatchInfo.matchUser).name}
			</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
			<label class="control-label">正确率：</label>
			</div>
			<div class="col-md-10">
			<div class="form-group">
				<form:input path="matchRightRate" htmlEscape="false" class="input-xlarge "/>%
			</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-12">
				<div class="form-group">
						<table id="" class="table table-striped table-bordered table-condensed">
							<thead>
								<tr>
									<th>考试题目</th>
									<th>你的答案</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${qalist}" var="chengjidan">
								<tr>
									<td>
										${chengjidan.question}
									</td>
									<td>
										${chengjidan.answer}
									</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
				</div>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn btn-info" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>