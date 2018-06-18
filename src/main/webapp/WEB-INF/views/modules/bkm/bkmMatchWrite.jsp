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
html,
body {
  background-color: #F4F4F4;
  display: flex;
  width: 100%;
  height: 100%;
  align-items: center;
  font-family: "Work Sans", sans-serif;
  justify-content: center;
}

.exp-container {
  width: 100%;
  padding: 30px;
  box-sizing: border-box;
  max-width: 600px;
}

.exp {
  display: flex;
  flex-direction: column-reverse;
  width: 100%;
  margin-bottom: 30px;
  position: relative;
  flex-wrap: wrap;
}

.exp__label {
  transition: 0.3s;
  margin-bottom: 5px;
}

.exp__label:before {
  content: attr(data-icon);
  font-weight: normal;
  font-family: "Ionicons";
  font-size: 24px;
  position: absolute;
  left: 0;
  transform: rotateY(90deg);
  bottom: 0;
  height: 52px;
  background: transparent;
  color: #000;
  transform-origin: left;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color .3s 0s ease, transform .3s 0s ease;
  width: 42px;
}

.exp__input {
  border: 1px solid #ddd;
  padding: 0 10px;
  width: 100%;
  height: 52px;
  transition: 0.3s;
  font-weight: normal;
  box-sizing: border-box;
  font-family: "Work Sans", sans-serif;
  outline: none;
}

.exp__input:focus {
  padding-left: 42px;
  border-color: #bbb;
}

.exp__input:focus + label:before {
  transform: rotateY(0deg);
}

.exp__input:valid {
  padding-left: 42px;
  border-color: green;
}

.exp__input:valid + label {
  color: green;
}

.exp__input:valid + label:before {
  transform: rotateY(0deg);
  color: green;
  font-size: 34px;
  content: attr(data-icon-ok);
}

.exp-title {
  text-align: center;
  font-size: 22px;
  margin-bottom: 30px;
  font-weight: normal;
}

.exp-title span {
  display: inline-block;
  padding: 5px;
  font-size: 22px;
  background: #feffd4;
}
</style>
<script type="text/javascript">
var subindex = 0;
var hsr;
var matchStat;
var answer;
window.onload=function(){
    $(document).keydown(function(event){
        switch(event.keyCode) {
                                case 13:{
                                	nexthsr();
                                }
                               }
    })
}
$(document).ready(function() {
	var preStat = '${bkmMatch.bkmMatchInfoList[0].preStat}';
	matchStat = '${bkmMatch.matchStat}';
	hsr = '${bkmMatch.bkmMatchInfoList[0].matchHse}';
	if(preStat=='未准备') {
		jQuery(".exp").hide();
		jQuery("#submitForm").hide();
		jQuery("#inputForm").show();
	}else{
		if(matchStat==1) {
			jQuery(".exp").show();
			jQuery("#submitForm").show();
			jQuery("#inputForm").hide();
			hsr = JSON.parse(hsr);
			nexthsr();
		}else{
			jQuery(".exp").show();
			jQuery("#submitForm").hide();
			jQuery("#inputForm").hide();
			jQuery("#example").val('考试尚未开始，请等待管理员确认');
		}
	}
});
function nexthsr() {
	jQuery("#example").val(hsr[subindex].question);
	answer = answer + jQuery("#example2").val() + ',';
	subindex++;
	jQuery("#example2").val('');
	jQuery("#example2").focus();
	if(subindex==hsr.length) {
		jQuery("#btnNext").hide();
		document.getElementById("bkmMatchInfoList0.matchAnswer").value = answer;
	}
}

</script>
</head>
<body>
<div class="exp-container">
  <h2 class="exp-title">${bkmMatch.matchName}</h2>
  <div class="exp">
    <input type="text" class="exp__input" id="example" name="test" placeholder="Full Name">
    <label class="exp__label" for="example">Full Name</label>
  </div>
  <div class="exp">
    <input type="email" class="exp__input" id="example2" name="test" placeholder="Email">
    <label class="exp__label" for="example2">Email</label>
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
		<form:hidden path="bkmMatchInfoList[0].matchHse"/>
		<form:hidden path="bkmMatchInfoList[0].matchAnswer"/>
		<div class="form-actions">
			<div style="text-align: center;">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="交卷"/>&nbsp;
				<input id="btnNext" class="btn btn-info" type="button" value="下一题" onclick="nexthsr()"/>
			</div>
		</div>
	</form:form>
 </div>
</body>
</html>