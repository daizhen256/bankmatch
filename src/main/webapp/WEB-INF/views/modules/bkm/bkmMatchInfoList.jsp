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
	<sys:message content="${message}"/>
	<div class="table">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>考试名称</th>
				<th>考试考试时间</th>
				<th>总题数</th>
				<th>正确率(%)</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${list}" var="bkmMatchInfo">
			<tr>
				<td><a href="${ctx}/bkm/bkmMatchInfo/form?id=${bkmMatchInfo.id}">
					${bkmMatchInfo.matchName}
				</a></td>
				<td>
					${bkmMatchInfo.matchUser.name}
				</td>
				<td>
					${bkmMatchInfo.matchStep}
				</td>
				<td>
					${bkmMatchInfo.matchRightRate}
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	</div></div>
</body>
</html>