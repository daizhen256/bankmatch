<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>代码模板管理</title>
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
	<div class="table">
		<div class="opt ue-clear">
			<span class="sortarea">
				<span class="sort">
					<label>排序：</label>
					<span class="name">
						<i class="icon"></i>
						<span class="text">名称</span>
					</span>
				</span>
		        <i class="list"></i>
                <i class="card"></i>
       		</span>
			<shiro:hasPermission name="gen:genTemplate:edit">
				<span class="optarea">
					<a href="${ctx}/gen/genTemplate/form" class="add">
						<i class="icon"></i>
						<span class="text">添加</span>
					</a>
					<a href="javascript:;" class="delete">
						<i class="icon"></i>
						<span class="text">删除</span>
					</a>
				</span>
			</shiro:hasPermission>
		</div>
	<form:form id="searchForm" modelAttribute="genTemplate" action="${ctx}/gen/genTemplate/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>分类 ：</label><form:select path="category" class="input-medium">
			<form:option value=""></form:option>
			<form:options items="${fns:getDictList('gen_category')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
		</form:select>
		<label>名称 ：</label><form:input path="name" htmlEscape="false" maxlength="50" class="input-medium"/>
		&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
		<shiro:hasPermission name="gen:genTemplate:edit"><a class="btn btn-s-md btn-primary" href="${ctx}/gen/genTemplate/form">添加</a></shiro:hasPermission>
	</form:form>
	<div id="messageBoxError" class="alert alert-error"><button data-dismiss="alert" class="close">×</button>
		代码模板管理，已废弃！模板管理改为XML配置方式，见  /src/main/java/com/thinkgem/jeesite/modules/gen/template 文件夹
	</div>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>名称</th><th>分类</th><th>备注</th><shiro:hasPermission name="gen:genTemplate:edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="genTemplate">
			<tr>
				<td><a href="${ctx}/gen/genTemplate/form?id=${genTemplate.id}">${genTemplate.name}</a></td>
				<td>${fns:getDictLabels(genTemplate.category, 'gen_category', '')}</td>
				<td>${fns:abbr(genTemplate.remarks, 100)}</td>
				<shiro:hasPermission name="gen:genTemplate:edit"><td>
    				<a class="btn btn-sm btn-primary" href="${ctx}/gen/genTemplate/form?id=${genTemplate.id}">修改</a>
					<a class="btn btn-sm btn-warning" href="${ctx}/gen/genTemplate/delete?id=${genTemplate.id}" onclick="return confirmx('确认要删除该代码模板吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div>
	</div>
</body>
</html>
