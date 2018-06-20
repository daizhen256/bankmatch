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
			$("#btnExport").click(function(){
				top.jQuery.jBox.confirm("确认要导出用户数据吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/sys/user/export");
						$("#searchForm").submit();
					}
				},{buttonsFocus:1});
				top.jQuery('.jbox-body .jbox-icon').css('top','55px');
			});
			$("#btnImport").click(function(){
				jQuery.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true}, 
					bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});
			});
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
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/sys/user/import" method="post" enctype="multipart/form-data"
			class="form-search" style="padding-left:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
			<a href="${ctx}/sys/user/import/template">下载模板</a>
		</form>
	</div>
	<div class="page-content">
	<form:form id="searchForm" modelAttribute="bkmHsrLib" action="${ctx}/bkm/bkmHsrLib/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<label>题干：</label>
				<form:input path="hsrQuestion" htmlEscape="false" maxlength="255" class="input-medium"/>
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
			<shiro:hasPermission name="bkm:bkmHsrLib:edit">
				<a class="btn btn-s-md btn-primary" href="${ctx}/bkm/bkmHsrLib/form">题库信息添加</a>
				<input id="btnExport" class="btn btn-s-md btn-primary" type="button" value="导出"/>
				<input id="btnImport" class="btn btn-s-md btn-primary" type="button" value="导入"/>
			</shiro:hasPermission>
	</form:form>
	<sys:message content="${message}"/>
	<div class="table">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>题目ID</th>
				<th>题干</th>
				<th>正确答案</th>
				<th>使用次数</th>
				<th>正确回答次数</th>
				<shiro:hasPermission name="bkm:bkmHsrLib:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="bkmHsrLib">
			<tr>
				<td><a href="${ctx}/bkm/bkmHsrLib/form?id=${bkmHsrLib.id}">
					${bkmHsrLib.hsrLibId}
				</a></td>
				<td>
					${bkmHsrLib.hsrQuestion}
				</td>
				<td>
					${bkmHsrLib.hsrRightAnswer}
				</td>
				<td>
					${bkmHsrLib.hsrUsedTime}
				</td>
				<td>
					${bkmHsrLib.hsrRightTime}
				</td>
				<shiro:hasPermission name="bkm:bkmHsrLib:edit"><td>
    				<a class="btn btn-sm btn-primary" href="${ctx}/bkm/bkmHsrLib/form?id=${bkmHsrLib.id}">修改</a>
					<a class="btn btn-sm btn-warning" href="${ctx}/bkm/bkmHsrLib/delete?id=${bkmHsrLib.id}" onclick="return confirmx('确认要删除该题库信息吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div></div>
</body>
</html>