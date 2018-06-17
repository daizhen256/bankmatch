<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>考试信息管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
	<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="bkmMatch" action="${ctx}/bkm/bkmMatch/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">考试日期：</label>
		</div>
		<div class="col-md-10">
			<div class="form-group">
				<input name="matchDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
					value="<fmt:formatDate value="${bkmMatch.matchDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">考试名称：</label>
		</div>
		<div class="col-md-10">
			<div class="form-group">
				<form:input path="matchName" htmlEscape="false" maxlength="256" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">总人数：</label>
		</div>
		<div class="col-md-10">
			<div class="form-group">
				<form:input path="matchPeopleCount" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
			</div>
		</div>
		<div class="control-group">
		<div class="col-md-2">
			<label class="control-label">平均分：</label>
		</div>
		<div class="col-md-10">
			<div class="form-group">
				<form:input path="matchAveragePoint" htmlEscape="false" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
			</div>
		</div>
			<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">考试明细表：</label>
				<input id="assignButton" class="btn btn-primary" type="button" value="分配角色"/>
				<script type="text/javascript">
					$("#assignButton").click(function(){
						top.jQuery.jBox.open("iframe:${ctx}/bkm/bkmMatch/usertomatch?id=${role.id}", "分配角色",810,$(top.document).height()-240,{
							buttons:{"确定分配":"ok", "清除已选":"clear", "关闭":true}, bottomText:"通过选择部门，然后为列出的人员分配角色。",submit:function(v, h, f){
								var pre_ids = h.find("iframe")[0].contentWindow.pre_ids;
								var ids = h.find("iframe")[0].contentWindow.ids;
								//nodes = selectedTree.getSelectedNodes();
								if (v=="ok"){
									// 删除''的元素
									if(ids[0]==''){
										ids.shift();
										pre_ids.shift();
									}
									if(pre_ids.sort().toString() == ids.sort().toString()){
										top.jQuery.jBox.tip("未给角色【${role.name}】分配新成员！", 'info');
										return false;
									};
							    	// 执行保存
							    	loading('正在提交，请稍等...');
							    	var idsArr = "";
							    	for (var i = 0; i<ids.length; i++) {
							    		idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
							    	}
							    	$('#idsArr').val(idsArr);
							    	$('#assignRoleForm').submit();
							    	return true;
								} else if (v=="clear"){
									h.find("iframe")[0].contentWindow.clearAssign();
									return false;
				                }
							}, loaded:function(h){
								jQuery(".jbox-content", top.document).css("overflow-y","hidden");
							}
						});
					});
				</script>
			</div>
				<div class="col-md-10">
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>考试者</th>
								<th>正确率</th>
								<th>考试题目</th>
								<th>创建者</th>
								<shiro:hasPermission name="bkm:bkmMatch:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="bkmMatchInfoList">
						</tbody>
						<shiro:hasPermission name="bkm:bkmMatch:edit"><tfoot>
							<tr><td colspan="6"><a href="javascript:" onclick="addRow('#bkmMatchInfoList', bkmMatchInfoRowIdx, bkmMatchInfoTpl);bkmMatchInfoRowIdx = bkmMatchInfoRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="bkmMatchInfoTpl">//<!--
						<tr id="bkmMatchInfoList{{idx}}">
							<td class="hide">
								<input id="bkmMatchInfoList{{idx}}_id" name="bkmMatchInfoList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="bkmMatchInfoList{{idx}}_delFlag" name="bkmMatchInfoList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="bkmMatchInfoList{{idx}}_matchUser" name="bkmMatchInfoList[{{idx}}].matchUser.name" type="text" value="{{row.matchUser.name}}" maxlength="64" class="input-small required"/>
								<input id="bkmMatchInfoList{{idx}}_matchUserId" name="bkmMatchInfoList[{{idx}}].matchUser.id" type="hidden" value="{{row.matchUser.id}}"/>
							</td>
							<td>
								<input id="bkmMatchInfoList{{idx}}_matchRightRate" name="bkmMatchInfoList[{{idx}}].matchRightRate" type="text" value="{{row.matchRightRate}}" class="input-small "/>
							</td>
							<td>
								<input id="bkmMatchInfoList{{idx}}_matchHse" name="bkmMatchInfoList[{{idx}}].matchHse" type="text" value="{{row.matchHse}}" maxlength="3000" class="input-small "/>
							</td>
							<td>
								<input id="bkmMatchInfoList{{idx}}_matchAnswer" name="bkmMatchInfoList[{{idx}}].matchAnswer" type="text" value="{{row.matchAnswer}}" maxlength="3000" class="input-small "/>
							</td>
							<shiro:hasPermission name="bkm:bkmMatch:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#bkmMatchInfoList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var bkmMatchInfoRowIdx = 0, bkmMatchInfoTpl = $("#bkmMatchInfoTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(bkmMatch.bkmMatchInfoList)};
							for (var i=0; i<data.length; i++){
								addRow('#bkmMatchInfoList', bkmMatchInfoRowIdx, bkmMatchInfoTpl, data[i]);
								bkmMatchInfoRowIdx = bkmMatchInfoRowIdx + 1;
							}
						});
					</script>
				</div>
				</div>
			</div>
		<div class="form-actions">
			<shiro:hasPermission name="bkm:bkmMatch:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-info" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>