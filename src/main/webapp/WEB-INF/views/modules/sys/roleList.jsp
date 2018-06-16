]<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/table.css" />
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
				<shiro:hasPermission name="sys:role:edit">
					<span class="optarea">
						<a href="${ctx}/sys/role/form" class="add">
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
				<thead><tr><th>角色名称</th><th>英文名称</th><th>归属机构</th><th>数据范围</th><shiro:hasPermission name="sys:role:edit"><th>操作</th></shiro:hasPermission></tr></thead>
				<tbody>
				<c:forEach items="${list}" var="role">
					<tr>
						<td><a href="form?id=${role.id}">${role.name}</a></td>
						<td><a href="form?id=${role.id}">${role.enname}</a></td>
						<td>${role.office.name}</td>
						<td>${fns:getDictLabel(role.dataScope, 'sys_data_scope', '无')}</td>
						<shiro:hasPermission name="sys:role:edit"><td>
							<a class="btn btn-sm btn-success" href="${ctx}/sys/role/assign?id=${role.id}">分配</a>
							<c:if test="${(role.sysData eq fns:getDictValue('是', 'yes_no', '1') && fns:getUser().admin)||!(role.sysData eq fns:getDictValue('是', 'yes_no', '1'))}">
								<a class="btn btn-sm btn-primary" href="${ctx}/sys/role/form?id=${role.id}">修改</a>
							</c:if>
							<a class="btn btn-sm btn-warning" href="${ctx}/sys/role/delete?id=${role.id}" onclick="return confirmx('确认要删除该角色吗？', this.href)">删除</a>
						</td></shiro:hasPermission>	
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>