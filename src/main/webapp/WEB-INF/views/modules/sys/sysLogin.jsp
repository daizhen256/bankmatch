<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>${fns:getConfig('productName')} 登录</title>
    <meta name="decorator" content="blank"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/login.css" />
    <style type="text/css">
    	.footer{position:absolute;} .footer, .footer a{color:#779ACA}
    </style>
	<script type="text/javascript">
		$(document).ready(function() {
			var height = $(window).height() > 445 ? $(window).height() : 445;
			$("#container").height(height);
			var bdheight = ($(window).height() - $('#bd').height()) / 2 - 20;
			$('#bd').css('padding-top', bdheight);
			$(window).resize(function(e) {
		        var height = $(window).height() > 445 ? $(window).height() : 445;
				$("#container").height(height);
				var bdheight = ($(window).height() - $('#bd').height()) / 2 - 20;
				$('#bd').css('padding-top', bdheight);
		    });
			$("#loginForm").validate({
				rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},password: {required: "请填写密码."},
					validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
				},
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#loginError").parent());
				} 
			});
		});
		// 如果在框架或在对话框中，则弹出提示并跳转到首页
		if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
			alert('未登录或登录超时。请重新登录，谢谢！');
			top.location = "${ctx}";
		}
	</script>
</head>
  <body>
	<div id="container">
		<div id="messageBox" class="alert alert-block alert-danger fade in ${empty message ? 'hide' : ''}"><button data-dismiss="alert" class="close">×</button>
					<label id="loginError" class="error">${message}</label>
				</div>
	    <div id="bd">
	    	<div id="main">
				
	        	<div class="login-box">
	                <div id="logo"></div>
	                <h1></h1>
	                <form id="loginForm" method="post" action="${ctx}/login" class="no-margin"> 
		                <div class="input username" id="username">
		                    <label for="userName">用户名</label>
		                    <span></span>
		                    <input type="text" id="username" name="username" value="${username}" />
		                </div>
		                <div class="input psw" id="psw">
		                    <label for="password">密&nbsp;&nbsp;&nbsp;&nbsp;码</label>
		                    <span></span>
		                    <input type="password" id="password" name="password" />
		                </div>
						<c:if test="${isValidateCodeLogin}">
							<div class="input validate" id="validate">
								<label for="valiDate">验证码</label>
								<sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;" imageDivCssStyle="margin-left: 210px;margin-top: -35px;" imageCssStyle="position:absolute;z-index:999999;margin-top:5px;" buttonCssStyle="display:none"/>
							</div>
						 </c:if>
		                <div id="btn" class="loginButton">
		                	<input type="submit" style="button" value="登录"/> 
		                </div>
	                </form>
	            </div>
	        </div>
	        <div id="ft">Copyright &copy; 2012-${fns:getConfig('copyrightYear')} <a href="${pageContext.request.contextPath}${fns:getFrontPath()}">${fns:getConfig('productName')}</a> - Powered By <a href="http://jeesite.com" target="_blank">JeeSite</a> ${fns:getConfig('version')}</div>
	    </div>
	   
	</div>
</body>
</html>