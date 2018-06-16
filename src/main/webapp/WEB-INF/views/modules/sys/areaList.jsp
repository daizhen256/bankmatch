<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>区域管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/table.css" />
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = jQuery("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "0";
			addRow("#treeTableList", tpl, data, rootId, true);
			jQuery("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					jQuery(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_area_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
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
			<shiro:hasPermission name="sys:area:edit">
				<span class="optarea">
					<a href="${ctx}/sys/area/form" class="add">
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
		<table id="treeTable" class="table table-striped table-bordered table-condensed">
			<thead><tr><th>区域名称</th><th>区域编码</th><th>区域类型</th><th>备注</th><shiro:hasPermission name="sys:area:edit"><th>操作</th></shiro:hasPermission></tr></thead>
			<tbody id="treeTableList"></tbody>
		</table>
		</div>
		<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="${ctx}/sys/area/form?id={{row.id}}">{{row.name}}</a></td>
			<td>{{row.code}}</td>
			<td>{{dict.type}}</td>
			<td>{{row.remarks}}</td>
			<shiro:hasPermission name="sys:area:edit"><td>
				<a class="btn btn-sm btn-primary" href="${ctx}/sys/area/form?id={{row.id}}">修改</a>
				<a class="btn btn-sm btn-warning" href="${ctx}/sys/area/delete?id={{row.id}}" onclick="return confirmx('要删除该区域及所有子区域项吗？', this.href)">删除</a>
				<a class="btn btn-sm btn-success" href="${ctx}/sys/area/form?parent.id={{row.id}}">添加下级区域</a> 
			</td></shiro:hasPermission>
		</tr>
	</script>
	</div>
</body>
</html>