<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>考试信息管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet"
	media="screen">
<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet"
	media="screen">
<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css"
	rel="stylesheet" media="screen" />
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
			$(obj).parent().parent().remove();
			if(jQuery("#bkmMatchInfoPreList").children().size()==0) {
				jQuery("#preButton").hide();
			}
		}
		function addPreRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			/* $(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			}); */
		}
		function getPreInfo(){
			jQuery.ajax({
		        url:'${ctx}/bkm/bkmMatch/getmatchpre?id='+jQuery("#id").val(),
		        type:'get',
		        dataType:'json',
		        timeout:5000,
		        success:function(data, textStatus){
		            if(data && data.result){
		                 //这个是用来和后台数据作对比判断是否发生了改变
		                var messagelist = data.result.data;
		                var tablerow = jQuery("#bkmMatchInfoList").children();
		                for(var i = 0;i<messagelist.length;i++) {
		                	for(var j = 0;j<tablerow.size();j++) {
		                		if(tablerow[j].children[1].children[1].value==messagelist[i].matchUser.id) {
		                			if(messagelist[i].preStat=="0") {
		                				tablerow[j].children[2].innerText = "未准备";
		                			} else if(messagelist[i].preStat=="1") {
		                				tablerow[j].children[2].innerText = "准备就绪";
		                			}else{
		                				tablerow[j].children[2].innerText = "考试完毕";
		                			}
		                			continue;
		                		}
		                	}
		                }
		                
		            } 
		            if(textStatus == "success"){
		                                    //成功之后，再发送请求，递归调用
		                setTimeout('getPreInfo()',1000);
		            }
		        },
		        error:function(XMLHttpRequest, textStatus, errorThrown){
		            if(textStatus == "timeout"){
		                                    //有效时间内没有响应，请求超时，重新发请求
		            	setTimeout('getPreInfo()',1000);
		            }else{
		                                    // 其他的错误，如网络错误等
		            	setTimeout('getPreInfo()',1000);
		            }
		        }
		    });
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="bkmMatch"
		action="${ctx}/bkm/bkmMatch/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="matchDate" />
		<form:hidden path="matchPeopleCount" />
		<form:hidden path="matchAveragePoint" />
		<form:hidden path="matchStat" />
		<sys:message content="${message}" />
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">考试名称：</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="matchName" htmlEscape="false" maxlength="256"
						class="input-xlarge required" />
					<span class="help-inline"><font color="red">*</font> </span>
					<input id="assignButton" class="btn btn-primary" type="button"
						value="选择考试人员" />
					<input id="preButton" class="btn btn-primary" type="button"
						value="确定考试" />
					<input id="startButton" class="btn btn-primary" type="button"
						value="开始考试" />
					<input id="stopButton" class="btn btn-primary" type="button"
						value="结束考试" />	
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">开始时间：</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<input name="matchStartDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${bkmMatch.matchStartDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">题目数量：</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="hsrNum" htmlEscape="false" maxlength="256"
						class="input-xlarge required" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">考试时间：</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:input path="matchTime" htmlEscape="false" maxlength="256"
						class="input-xlarge required" />
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="col-md-2">
				<label class="control-label">考题类型：</label>
			</div>
			<div class="col-md-10">
				<div class="form-group">
					<form:radiobuttons path="hsrType" items="${fns:getDictList('hsr_type')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
		</div>
		<div class="control-group" id="preInfo">
			<div class="col-md-2">
				<label class="control-label">考试准备情况：</label>
			</div>
			<div class="col-md-10">
				<div class="controls">
					<table id="contentTable"
						class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>考试者</th>
								<th width="10">&nbsp;</th>
							</tr>
						</thead>
						<tbody id="bkmMatchInfoPreList">
						</tbody>
					</table>
					<script type="text/template" id="bkmMatchInfoPreTpl">//<!--
						<tr id="bkmMatchInfoPreList{{idx}}">
							<td class="hide">
								<input id="bkmMatchInfoPreList{{idx}}_id" name="bkmMatchInfoList[{{idx}}].id" type="hidden" value="0"/>
								<input id="bkmMatchInfoPreList{{idx}}_delFlag" name="bkmMatchInfoList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="bkmMatchInfoPreList{{idx}}_matchUser" name="bkmMatchInfoList[{{idx}}].matchUser.name" type="text" value="{{row.name}}" maxlength="64" class="input-small required"/>
								<input id="bkmMatchInfoPreList{{idx}}_matchUserId" name="bkmMatchInfoList[{{idx}}].matchUser.id" type="hidden" value="{{row.id}}"/>
							</td>
							<td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#bkmMatchInfoPreList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var bkmMatchInfoPreRowIdx = 0, bkmMatchInfoPreTpl = $("#bkmMatchInfoPreTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
					</script>
				</div>
			</div>
		</div>
		<div class="control-group" id="matchInfo">
			<div class="col-md-2">
				<label class="control-label">考试明细表：</label>
			</div>
			<div class="col-md-10">
				<div class="controls">
					<table id="contentTable"
						class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>考试者</th>
								<th>准备情况</th>
								<th>正确率</th>
							</tr>
						</thead>
						<tbody id="bkmMatchInfoList">
						</tbody>
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
							<td align="center">
								{{row.preStat}}
							</td>
							<td>
								<input id="bkmMatchInfoList{{idx}}_matchRightRate" name="bkmMatchInfoList[{{idx}}].matchRightRate" type="text" value="{{row.matchRightRate}}" style="text-align: right" class="input-small "/>%
							</td>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var bkmMatchInfoRowIdx = 0, bkmMatchInfoTpl = $("#bkmMatchInfoTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var matchStat = jQuery("#matchStat").val();
							if(matchStat=="") {
								jQuery("#preInfo").show();
								jQuery("#matchInfo").hide();
								jQuery("#assignButton").show();
								jQuery("#preButton").hide();
								jQuery("#startButton").hide();
								jQuery("#stopButton").hide();
							}else if(matchStat=="0") {
								jQuery("#preInfo").hide();
								jQuery("#matchInfo").show();
								jQuery("#assignButton").hide();
								jQuery("#preButton").hide();
								jQuery("#startButton").show();
								jQuery("#stopButton").hide();
								getPreInfo();
							}else if(matchStat=="1") {
								jQuery("#preInfo").hide();
								jQuery("#matchInfo").show();
								jQuery("#assignButton").hide();
								jQuery("#preButton").hide();
								jQuery("#startButton").hide();
								jQuery("#stopButton").show();
								getPreInfo();
							}else{
								jQuery("#preInfo").hide();
								jQuery("#matchInfo").show();
								jQuery("#assignButton").hide();
								jQuery("#preButton").hide();
								jQuery("#startButton").hide();
								jQuery("#stopButton").hide();
							}
							var data = ${fns:toJson(bkmMatch.bkmMatchInfoList)};
							for (var i=0; i<data.length; i++){
								addRow('#bkmMatchInfoList', bkmMatchInfoRowIdx, bkmMatchInfoTpl, data[i]);
								bkmMatchInfoRowIdx = bkmMatchInfoRowIdx + 1;
							}
							$("#assignButton").click(function(){
								top.jQuery.jBox.open("iframe:${ctx}/bkm/bkmMatch/usertomatch?id=${bkmMatch.id}", "选择考试人员",810,$(top.document).height()-240,{
									buttons:{"确定选择":"ok", "清除已选":"clear", "关闭":true}, bottomText:"通过选择部门，然后选择列出的人员参加考试。",submit:function(v, h, f){
										var pre_ids = h.find("iframe")[0].contentWindow.pre_ids;
										var ids = h.find("iframe")[0].contentWindow.ids;
										var pre_names = h.find("iframe")[0].contentWindow.pre_names;
										var names = h.find("iframe")[0].contentWindow.names;
										//nodes = selectedTree.getSelectedNodes();
										if (v=="ok"){
											 $("#bkmMatchInfoPreList tbody").html("");
											// 删除''的元素
											if(ids[0]==''){
												ids.shift();
												pre_ids.shift();
											}
											if(pre_ids.sort().toString() == ids.sort().toString()){
												top.jQuery.jBox.tip("添加失败！", 'info');
												return false;
											};
									    	var idsArr = "";
									    	for (var i = 0; i<ids.length; i++) {
									    		var row = new Object();
									    		row.id = ids[i];
									    		row.name = names[i+1];
									    		row.preStat = 0;
									    		addPreRow('#bkmMatchInfoPreList', bkmMatchInfoPreRowIdx, bkmMatchInfoPreTpl, row);
									    		jQuery("#preButton").show();
									    		idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
									    	}
									    	$('#idsArr').val(idsArr);
									    	
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
							// 准备考试
							$("#preButton").click(function(){
								$("#inputForm").submit();
							});
							// 开始考试
							$("#startButton").click(function(){
								jQuery.ajax({
							        url:'${ctx}/bkm/bkmMatch/startmatch',
							        type:'post',
							        dataType:'json',
							        data:jQuery("#inputForm").serialize(),
							        timeout:5000,
							        success:function(data, textStatus){
							        	if(textStatus == "success"){
							        		jQuery("#startButton").hide();
											jQuery("#stopButton").show();
							        	}
							        },
							        error:function(XMLHttpRequest, textStatus, errorThrown){
							        	if(textStatus == "timeout"){
		                                    //有效时间内没有响应，请求超时，重新发请求
							        		alert("网络超时，请稍后重试！");
							            }else{
							                // 其他的错误，如网络错误等
							            	alert("系统错误，请稍后重试！");
							            }
							        }
								});							
							});
							
							// 结束考试
							$("#stopButton").click(function(){
								jQuery.ajax({
							        url:'${ctx}/bkm/bkmMatch/stopmatch',
							        type:'post',
							        dataType:'json',
							        data:jQuery("#inputForm").serialize(),
							        timeout:5000,
							        success:function(data, textStatus){
							        	if(textStatus == "success"){
							        		jQuery("#startButton").hide();
											jQuery("#stopButton").hide();
							        	}
							        },
							        error:function(XMLHttpRequest, textStatus, errorThrown){
							        	if(textStatus == "timeout"){
		                                    //有效时间内没有响应，请求超时，重新发请求
							        		alert("网络超时，请稍后重试！");
							            }else{
							                // 其他的错误，如网络错误等
							            	alert("系统错误，请稍后重试！");
							            }
							        }
								});
							});
						});
					</script>
				</div>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn btn-info" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>