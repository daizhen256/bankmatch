<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/table.css" />
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#treeTable").treeTable({expandLevel : 3}).show();
		});
    	function updateSort() {
			loading('正在提交，请稍等...');
	    	$("#listForm").attr("action", "${ctx}/sys/menu/updateSort");
	    	$("#listForm").submit();
    	}
	</script>
</head>
<body>
	<div class="page-content">
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
			<shiro:hasPermission name="sys:menu:edit">
				<span class="optarea">
					<a href="${ctx}/sys/menu/form" class="add">
						<i class="icon"></i>
						<span class="text">添加</span>
					</a>
					<a href="javascript:updateSort();" class="config">
						<i class="icon"></i>
						<span class="text">保存排序</span>
					</a>
					<a href="javascript:;" class="delete">
						<i class="icon"></i>
						<span class="text">删除</span>
					</a>
				</span>
			</shiro:hasPermission>
		</div>
	<form id="listForm" method="post">
		<table id="treeTable" class="table table-striped table-bordered table-condensed">
			<thead><tr><th>名称</th><th>链接</th><th style="text-align:center;">排序</th><th style="text-align:center;">可见</th><th>权限标识</th><shiro:hasPermission name="sys:menu:edit"><th>操作</th></shiro:hasPermission></tr></thead>
			<tbody><c:forEach items="${list}" var="menu">
				<tr id="${menu.id}" pId="${menu.parent.id ne '1'?menu.parent.id:'0'}">
					<td nowrap><i class="icon-${not empty menu.icon?menu.icon:' hide'}"></i><a href="${ctx}/sys/menu/form?id=${menu.id}">${menu.name}</a></td>
					<td title="${menu.href}">${fns:abbr(menu.href,30)}</td>
					<td style="text-align:center;">
						<shiro:hasPermission name="sys:menu:edit">
							<input type="hidden" name="ids" value="${menu.id}"/>
							<input name="sorts" type="text" value="${menu.sort}" style="width:50px;margin:0;padding:0;text-align:center;">
						</shiro:hasPermission><shiro:lacksPermission name="sys:menu:edit">
							${menu.sort}
						</shiro:lacksPermission>
					</td>
					<td style="text-align:center;">${menu.isShow eq '1'?'<span class="label label-success">显示</span>':'<span class="label label-danger">隐藏</span>'}</td>
					<td title="${menu.permission}">${fns:abbr(menu.permission,30)}</td>
					<shiro:hasPermission name="sys:menu:edit"><td nowrap>
						<a class="btn btn-sm btn-primary" href="${ctx}/sys/menu/form?id=${menu.id}">修改</a>
						<a class="btn btn-sm btn-warning" href="${ctx}/sys/menu/delete?id=${menu.id}" onclick="return confirmx('要删除该菜单及所有子菜单项吗？', this.href)">删除</a>
						<a class="btn btn-sm btn-success" href="${ctx}/sys/menu/form?parent.id=${menu.id}">添加下级菜单</a> 
					</td></shiro:hasPermission>
				</tr>
			</c:forEach></tbody>
		</table>
	 </form>
	 </div>
	 </div>
</body>
</html>