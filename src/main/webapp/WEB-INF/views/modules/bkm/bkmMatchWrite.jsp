<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>考试信息管理</title>
<meta name="decorator" content="default" />
<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/css/thin-jeesite.css" type="text/css" rel="stylesheet" media="screen" />
<style>
body,html{display:flex;width:100%;height:100%;background-color:#f4f4f4;font-family:Work Sans,sans-serif;align-items:center;justify-content:center}.exp-container{box-sizing:border-box;padding:30px;width:100%;max-width:600px}.exp{position:relative;display:flex;margin-bottom:30px;width:100%;flex-direction:column-reverse;flex-wrap:wrap}.exp__label{margin-bottom:5px;transition:.3s}.exp__label:before{position:absolute;bottom:0;left:0;display:flex;width:42px;height:52px;background:0 0;color:#000;content:attr(data-icon);font-weight:400;font-size:24px;font-family:Ionicons;transition:color .3s 0s ease,transform .3s 0s ease;transform:rotateY(90deg);transform-origin:left;align-items:center;justify-content:center}.exp__input{box-sizing:border-box;padding:0 10px;width:100%;height:52px;outline:0;border:1px solid #ddd;font-weight:400;font-family:Work Sans,sans-serif;transition:.3s}.exp__input:focus{padding-left:42px;border-color:#bbb}.exp__input:focus+label:before{transform:rotateY(0)}.exp__input:valid{padding-left:42px;border-color:green}.exp__input:valid+label{color:green}.exp__input:valid+label:before{color:green;content:attr(data-icon-ok);font-size:34px;transform:rotateY(0)}.exp-title{margin-bottom:30px;text-align:center;font-weight:400;font-size:22px}.exp-title span{display:inline-block;padding:5px;background:#feffd4;font-size:22px}
.red{ border:1px solid #d00; background:#ffe9e8; color:#d00;}
</style>
<script type="text/javascript">
	var subindex = 0;
	var hsr;
	var matchStat;
	var question;
	var hsrWeisuu;
	window.onload = function() {
		$(document).keydown(function(event) {
			switch (event.keyCode) {
			case 13:
				{
					next()
				}
			}
		})
	}
	$(document).ready(function() {
		jQuery("#shengyutime").hide();
		var preStat = '${bkmMatch.bkmMatchInfoList[0].preStat}';
		matchStat = '${bkmMatch.matchStat}';
		hsr = '${bkmMatch.bkmMatchInfoList[0].matchHse}';
		hsrWeisuu = '${bkmMatch.hsrWeisuu}';
		subindex = parseInt(document.getElementById("bkmMatchInfoList0.matchStep").value);
		if (preStat == '未准备') {
			// 如果没有准备 则隐藏考试按钮 显示准备按钮
			jQuery(".exp").hide();
			jQuery("#submitForm").hide();
			jQuery("#inputForm").show()
		} else {
			// 判断考试状态
			if (matchStat == 1) {
				// 已经开始考试，显示剩余时间并开始倒计时
				jQuery("#shengyutime").show();
				leftTimer();
				// 如果是全员随机题的话 显示考题信息 显示考试按钮 隐藏准备按钮
				if (jQuery("#hsrType").val() == 0 || jQuery("#hsrType").val() == 2) {
					jQuery(".exp").show();
					jQuery("#submitForm").show();
					jQuery("#inputForm").hide();
					// 把考题信息转化成JSON格式开始循环
					hsr = JSON.parse(hsr);
					nexthsr()
				} else if (jQuery("#hsrType").val() == 1) {
					jQuery(".exp").show();
					jQuery("#submitForm").show();
					jQuery("#inputForm").hide();
					nextrandomhsr();
				}
			} else {
				jQuery(".exp").show();
				jQuery("#submitForm").hide();
				jQuery("#inputForm").hide();
				jQuery("#example").val('考试尚未开始，请等待管理员确认')
			}
		}
	});
	// 点击下一题
	function next() {
		if (jQuery("#hsrType").val() == 0||jQuery("#hsrType").val() == 2) {
			nexthsr();
		} else if (jQuery("#hsrType").val() == 1) {
			nextrandomhsr();
		}
	}
	// 下一个全员随机题
	function nexthsr() {
		// 保存考试记录
		saveStep();
		// 判断是否是最后一道题,如果是则隐藏下一题按钮
		if (subindex == hsr.length) {
			jQuery("#example2").val('您已答完所有问题，请点击交卷');
			jQuery("#btnNext").hide();
			return;
		}
		// 获取下一道题目内容到录入一
		jQuery("#example").val(hsr[subindex].question);
		// 题目索引+1
		subindex++;
		// 清空录入二
		jQuery("#example2").val('');
		// 对录入二加焦点
		jQuery("#example2").focus();
	}
	function nextrandomhsr() {
		saveStep();
		var hsrNum = jQuery("#hsrNum").val();
		if (hsrNum != '' && subindex == hsrNum) {
			jQuery("#example2").val('您已答完所有问题，请点击交卷');
			jQuery("#btnNext").hide();
			return;
		}
		if(hsrWeisuu==0) {
			hsrWeisuu = 5;
		}
		var randomquestion = randomNum(hsrWeisuu);
		jQuery("#example").val(randomquestion);
		question = question + randomquestion + ',';
		subindex++;
		jQuery("#example2").val('');
		jQuery("#example2").focus();
		
	}
	function randomNum(weisu) {
		var minNum = Math.pow(10, weisu - 1);
		var maxNum = Math.pow(10, weisu) - 1;
		return parseInt(Math.random() * (maxNum - minNum + 1) + minNum, 10) + "." + parseInt(Math.random() * 100, 10)
	}
	function leftTimer(year, month, day, hour, minute, second) {
		var leftTime = (new Date(year, month - 1, day, hour, minute, second)) - (new Date());
		var days = parseInt(leftTime/1000/60/60/24, 10);
		var hours = parseInt(leftTime/1000/60/60%24, 10);
		var minutes = parseInt(leftTime/1000/60%60, 10);
		var seconds = parseInt(leftTime/1000%60, 10);
		days = checkTime(days);
		hours = checkTime(hours);
		minutes = checkTime(minutes);
		seconds = checkTime(seconds);
		var enddate = jQuery("#matchStartDate").val();
		var year = enddate.split(" ")[0].split("-")[0];
		var month = enddate.split(" ")[0].split("-")[1];
		var day = enddate.split(" ")[0].split("-")[2];
		var hour = enddate.split(" ")[1].split(":")[0];
		var minute = enddate.split(" ")[1].split(":")[1];
		var second = enddate.split(" ")[1].split(":")[2];
		var sed = setInterval("leftTimer("+year+","+month+","+day+","+hour+","+minute+","+second+")", 1000);
		document.getElementById("timer").innerHTML = days + "天" + hours + "小时" + minutes + "分" + seconds + "秒"
		if(days==0&&hours==0&&minutes==0&&seconds==0) {
			jQuery("#shengyutime").hide();
			alert("考试结束");
			jQuery("btnNext").attr("disabled","disabled");
		}
	}
	function checkTime(i) {
		if (i < 10) {
			i = "0" + i
		}
		return i
	}
	function saveStep() {
		var step = jQuery("#step").val();
		var wrong = jQuery("#wrongnum").val();
		var answers = document.getElementById("bkmMatchInfoList0.matchAnswer").value;
		var questions = document.getElementById("bkmMatchInfoList0.matchHse").value;
		var hsrType = jQuery("#hsrType").val();
		if(step==undefined||step=="") {
			step = document.getElementById("bkmMatchInfoList0.matchStep").value;
			jQuery("#step").val(step);
			wrong = document.getElementById("bkmMatchInfoList0.wrongNum").value;
			jQuery("#wrongnum").val(wrong);
			return;
		}
		var downval = jQuery("#example2").val();
		step=parseInt(step)+1;
		jQuery("#step").val(step);
		if(answers=="") {
			answers=[{answer:downval}];
		}else{
			var ansjson = JSON.parse(answers);
			ansjson.push({answer:downval});
			answers = ansjson;
		}
		
		document.getElementById("bkmMatchInfoList0.matchAnswer").value = JSON.stringify(answers);
		var upval = jQuery("#example").val();
		if(upval == '') {
			return false;
		}
		if(questions==undefined||questions=="") {
			questions=[{question:upval}];
		}else{
			var hsrjson = JSON.parse(questions);
			hsrjson.push({question:upval});
			questions = hsrjson;
		}
		document.getElementById("bkmMatchInfoList0.matchHse").value = JSON.stringify(questions);
		var id = document.getElementById("bkmMatchInfoList0.id").value;
		var type = 0;
		if(upval!=downval) {
			type = 1;
			wrong = parseInt(wrong)+1;
			jQuery("#wrongnum").val(wrong);
			shake($("#wrongnum"),"red",3);
		}
		
		jQuery.ajax({
	        url:'${ctx}/bkm/bkmMatch/updatestep',
	        type:'post',
	        dataType:'json',
	        data: {"infoid": id, "hsrType": hsrType, "type": type, "step": step, "wrong": wrong, "answers": JSON.stringify(answers), "questions": JSON.stringify(questions)},
	        timeout:5000,
	        success:function(data, textStatus){
	            if(data && data.result){
	                
	            } 
	        }
	    });
	}
	function shake(ele,cls,times){
		var i = 0,t= false ,o =ele.attr("class")+" ",c ="",times=times||2;
		if(t) return;
		t= setInterval(function(){
		i++;
		c = i%2 ? o+cls : o;
		ele.attr("class",c);
		if(i==2*times){
		clearInterval(t);
		ele.removeClass(cls);
		}
		},200);
		};
</script>
</head>
<body>
<div class="exp-container">
  <h2 class="exp-title">${bkmMatch.matchName}</h2>       <span id="shengyutime">剩余时间：</span><div id="timer"></div> 
  <div class="exp">
    <input type="text" class="exp__input" id="example" name="test">
    <label class="exp__label" for="example">一次录入数据</label>
  </div>
  <div class="exp">
    <input type="text" class="exp__input" id="example2" name="test">
    <label class="exp__label" for="example2">二次录入数据</label>
  </div>
  <div class="exp">
    <input class="exp__input" id="step" name="test">
    <label class="exp__label" for="step">做题数</label>
  </div>
  <div class="exp">
    <input class="exp__input" id="wrongnum" name="test">
    <label class="exp__label" for="wrongnum">错题数</label>
  </div>
  	<form:form id="inputForm" modelAttribute="bkmMatch" action="${ctx}/bkm/bkmMatch/prepareok" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<div class="form-actions">
			<div style="text-align: center;">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="准备就绪"/>&nbsp;
				<input id="btnCancel" class="btn btn-info" type="button" value="还没准备好，再练习练习" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
	<form:form id="submitForm" modelAttribute="bkmMatch" action="${ctx}/bkm/bkmMatch/matchok" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="matchTime"/>
		<form:hidden path="hsrNum"/>
		<form:hidden path="hsrType"/>
		<form:hidden path="hsrWeisuu"/>
		<form:hidden path="bkmMatchInfoList[0].matchHse"/>
		<form:hidden path="bkmMatchInfoList[0].matchAnswer"/>
		<form:hidden path="bkmMatchInfoList[0].id"/>
		<form:hidden path="bkmMatchInfoList[0].matchStep"/>
		<form:hidden path="bkmMatchInfoList[0].wrongNum"/>
		<input type="hidden" id="matchStartDate" value="<fmt:formatDate value="${bkmMatch.matchStartDate}" pattern="yyyy-MM-dd HH:mm:ss"/>">
		<div class="form-actions">
			<div style="text-align: center;">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="交卷"/>&nbsp;
				<input id="btnNext" class="btn btn-info" type="button" value="下一题" onclick="next()"/>
			</div>
		</div>
	</form:form>
 </div>
</body>
</html>