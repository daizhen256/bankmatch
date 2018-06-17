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
	<form:form id="searchForm" modelAttribute="bkmMatch" action="${ctx}/bkm/bkmMatch/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<label>考试日期：</label>
				<input name="matchDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${bkmMatch.matchDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			<label>考试名称：</label>
				<form:input path="matchName" htmlEscape="false" maxlength="256" class="input-medium"/>
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
			<shiro:hasPermission name="bkm:bkmMatch:edit"><a class="btn btn-s-md btn-primary" href="${ctx}/bkm/bkmMatch/form">考试信息添加</a></shiro:hasPermission>
	</form:form>
	<sys:message content="${message}"/>
	<div class="table">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>考试日期</th>
				<th>考试名称</th>
				<th>总人数</th>
				<th>平均分</th>
				<shiro:hasPermission name="bkm:bkmMatch:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="bkmMatch">
			<tr>
				<td><a href="${ctx}/bkm/bkmMatch/form?id=${bkmMatch.id}">
					<fmt:formatDate value="${bkmMatch.matchDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</a></td>
				<td>
					${bkmMatch.matchName}
				</td>
				<td>
					${bkmMatch.matchPeopleCount}
				</td>
				<td>
					${bkmMatch.matchAveragePoint}
				</td>
				<shiro:hasPermission name="bkm:bkmMatch:edit"><td>
    				<a class="btn btn-sm btn-primary" href="${ctx}/bkm/bkmMatch/form?id=${bkmMatch.id}">修改</a>
					<a class="btn btn-sm btn-warning" href="${ctx}/bkm/bkmMatch/delete?id=${bkmMatch.id}" onclick="return confirmx('确认要删除该考试信息吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div></div>
</body>
</html>