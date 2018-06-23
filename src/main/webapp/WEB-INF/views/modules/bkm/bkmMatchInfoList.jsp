<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>${functionNameSimple}管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/table.css" />
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<div class="page-content">
	<form:form id="searchForm" modelAttribute="bkmMatchInfo" action="${ctx}/bkm/bkmMatchInfo/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<label>考试者：</label>
				<form:input path="matchUser" htmlEscape="false" maxlength="64" class="input-medium"/>
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
			<shiro:hasPermission name="bkm:bkmMatchInfo:edit"><a class="btn btn-s-md btn-primary" href="${ctx}/bkm/bkmMatchInfo/form">历史记录添加</a></shiro:hasPermission>
	</form:form>
	<sys:message content="${message}"/>
	<div class="table">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>考试编号</th>
				<th>考试者</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="bkmMatchInfo">
			<tr>
				<td><a href="${ctx}/bkm/bkmMatchInfo/form?id=${bkmMatchInfo.id}">
					${bkmMatchInfo.matchId}
				</a></td>
				<td>
					${bkmMatchInfo.matchUser}
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div></div>
</body>
</html>