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
	<form:form id="searchForm" modelAttribute="sysContact" action="${ctx}/sys/contact/sysContact/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table>
			<tr>
				<td style="display:flex">
					<label>发送者：</label>
						<sys:treeselect id="sender" name="sender" value="${sysContact.sender}" labelName="" labelValue="${sysContact.sender}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
				</td>
				<td>
					<label>发送时间：</label>
					<input name="sendDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
						value="<fmt:formatDate value="${sysContact.sendDate}" pattern="yyyy-MM-dd"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td style="display:flex">
					<label>接收者：</label>
						<sys:treeselect id="receiver" name="receiver" value="${sysContact.receiver}" labelName="" labelValue="${sysContact.receiver}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
				</td>
				<td>
					<label>消息内容：</label>
					<form:input path="content" htmlEscape="false" class="input-medium"/>
				</td>
				<td>
					<label>已读标记：</label>
					<form:select path="readFlag" class="input-xlarge" style="width:60px">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('sys_contact_readflag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
					<shiro:hasPermission name="sys:contact:sysContact:edit"><a class="btn btn-s-md btn-primary" href="${ctx}/sys/contact/sysContact/form">写新站内信</a></shiro:hasPermission>
				</td>
			</tr>
		</table>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>发送者</th>
				<th>接收者</th>
				<th>发送时间</th>
				<th>消息内容</th>
				<th>已读标记</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="sys:contact:sysContact:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysContact">
			<tr>
				<td><a href="${ctx}/sys/contact/sysContact/form?id=${sysContact.id}">
					${sysContact.sender.name}
				</a></td>
				<td>
					${sysContact.receiver.name}
				</td>
				<td>
					<fmt:formatDate value="${sysContact.sendDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${sysContact.content}
				</td>
				<td>
					${fns:getDictLabel(sysContact.readFlag, 'sys_contact_readflag', '')}
				</td>
				<td>
					<fmt:formatDate value="${sysContact.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${sysContact.remarks}
				</td>
				<shiro:hasPermission name="sys:contact:sysContact:edit"><td>
    				<a class="btn btn-sm btn-primary" href="${ctx}/sys/contact/sysContact/form?id=${sysContact.id}">修改</a>
					<a class="btn btn-sm btn-warning" href="${ctx}/sys/contact/sysContact/delete?id=${sysContact.id}" onclick="return confirmx('确认要删除该联络事项吗？', this.href)">删除</a>
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