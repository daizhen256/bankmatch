<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>字典管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/table.css" />
	<script type="text/javascript">
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
	<form:form id="searchForm" modelAttribute="dict" action="${ctx}/sys/dict/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>类型：</label><form:select id="type" style="width:150px;" path="type" class="input-medium"><form:option value="" label=""/><form:options items="${typeList}" htmlEscape="false"/></form:select>
		&nbsp;&nbsp;<label>描述 ：</label><form:input path="description" htmlEscape="false" maxlength="50"/>
		&nbsp;<input id="btnSubmit" class="btn btn-s-md btn-primary" type="submit" value="查询"/>
	</form:form>
	<sys:message content="${message}"/>
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
			<shiro:hasPermission name="sys:dict:edit">
				<span class="optarea">
					<a href="${ctx}/sys/dict/form?sort=10" class="add">
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
		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead><tr><th>键值</th><th>标签</th><th>类型</th><th class="hidden-xs">描述</th><th class="hidden-xs">排序</th><shiro:hasPermission name="sys:dict:edit"><th>操作</th></shiro:hasPermission></tr></thead>
			<tbody>
			<c:forEach items="${page.list}" var="dict">
				<tr>
					<td>${dict.value}</td>
					<td><a href="${ctx}/sys/dict/form?id=${dict.id}">${dict.label}</a></td>
					<td><a href="javascript:" onclick="$('#type').val('${dict.type}');$('#searchForm').submit();return false;">${dict.type}</a></td>
					<td class="hidden-xs">${dict.description}</td>
					<td class="hidden-xs">${dict.sort}</td>
					<shiro:hasPermission name="sys:dict:edit"><td>
	    				<a class="btn btn-sm btn-primary" href="${ctx}/sys/dict/form?id=${dict.id}">修改</a>
						<a class="btn btn-sm btn-warning" href="${ctx}/sys/dict/delete?id=${dict.id}&type=${dict.type}" onclick="return confirmx('确认要删除该字典吗？', this.href)">删除</a>
	    				<a class="btn btn-sm btn-success" href="<c:url value='${fns:getAdminPath()}/sys/dict/form?type=${dict.type}&sort=${dict.sort+10}'><c:param name='description' value='${dict.description}'/></c:url>">添加键值</a>
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