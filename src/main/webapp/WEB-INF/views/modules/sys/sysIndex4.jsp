<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="decorator" content="blank"/>
<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/main.css" />
<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/jquery.dialog.css" />
<script type="text/javascript" src="${ctxStatic}/js/global.js"></script>
<script type="text/javascript" src="${ctxStatic}/js/core.js"></script>
<script type="text/javascript" src="${ctxStatic}/js/jquery.dialog.js"></script>
<link href="${ctxStatic}/css/jquery.gritter.css" rel="stylesheet">
<script src="${ctxStatic}/js/jquery.gritter.js"></script>
<style type="text/css">
* {
  -webkit-box-sizing: content-box;
  -moz-box-sizing: content-box;
  box-sizing: content-box;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
getMsgNum();
jQuery("#bd").height($(window).height()-$("#hd").outerHeight()-26);

jQuery(window).resize(function(e) {
	jQuery("#bd").height($(window).height()-$("#hd").outerHeight()-26);

});
//绑定菜单单击事件
jQuery("#menu a.menu").click(function(){
	jQuery(".nav",document.getElementById('mainIframe').contentWindow.document).empty();
	jQuery("#menutitle",document.getElementById('mainIframe').contentWindow.document).html(this.innerText);
	// 一级菜单焦点
	jQuery("#menu li.menu").removeClass("active");
	jQuery(this).parent().addClass("active");
	// 显示二级菜单
	var menuId = "#menu-" + jQuery(this).attr("data-id");
	if (jQuery(menuId).length > 0){
		jQuery(".nav .accordion",document.getElementById('mainIframe').contentWindow.document).hide();
		jQuery(menuId,document.getElementById('mainIframe').contentWindow.document).show();
	}else{
		// 获取二级菜单数据
		jQuery.get(jQuery(this).attr("data-href"), function(data){
			if (data.indexOf("id=\"loginForm\"") != -1){
				alert('未登录或登录超时。请重新登录，谢谢！');
				top.location = "${ctx}";
				return false;
			}
			jQuery(".nav .accordion",document.getElementById('mainIframe').contentWindow.document).hide();
			jQuery(".nav",document.getElementById('mainIframe').contentWindow.document).append(data);
			// 展现三级
// 			jQuery(menuId + " .sub-menu a",document.getElementById('mainIframe').contentWindow.document).click(function(){
// 				var href = jQuery(this).attr("data-href");
// 				if(jQuery(href).length > 0){
// 					jQuery(href).toggle().parent().toggle();
// 					return false;
// 				}
// 				return addTab(jQuery(this), true); 
// 			});
			// 默认选中第一个菜单
			jQuery(menuId + " .accordion-body a:first i",document.getElementById('mainIframe').contentWindow.document).click();
			jQuery(menuId + " .accordion-body li:first li:first a:first i",document.getElementById('mainIframe').contentWindow.document).click();
		});
	}
	return false;
});
jQuery(".exitDialog").Dialog({
	title:'提示信息',
	autoOpen: false,
	width:400,
	height:200
});

jQuery(".exit").click(function(){
	jQuery(".exitDialog").Dialog('open');
});

jQuery(".exitDialog input[type=button]").click(function(e) {
	jQuery(".exitDialog").Dialog('close');
	
	if(jQuery(this).hasClass('ok')){
		window.location.href = "${ctx}/logout"	;
	}
});
jQuery('#exampleModal').on('shown.bs.modal', function (event) {
	  var button = jQuery(event.relatedTarget); // Button that triggered the modal
	  var messageContent = button.data('whatever'); // Extract info from data-* attributes
	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = jQuery(this);
	  jQuery.ajax({
	        url:'${messageContentUri}'+messageContent.id,
	        type:'get',
	        dataType:'json',
	        timeout:5000,
	        success:function(data, textStatus){
	            if(textStatus == "success"){
	            	localStorage.removeItem("messageid_"+messageContent.id);
	            	var sendDate = new Date();
	            	sendDate.setTime(messageContent.sendDate);
	            	modal.find('.modal-title').text('来自 ' + messageContent.sender.name + '的短消息');
					modal.find('.modal-body #sendDate').val(sendDate.toLocaleString());
					modal.find('.modal-body #senderid').val(messageContent.sender.id);
					modal.find('.modal-body #receiveid').val(messageContent.receiver.id);
					modal.find('.modal-body #content').val(messageContent.content);
	            }
	        },
	        error:function(XMLHttpRequest, textStatus, errorThrown){
	            if(textStatus == "timeout"){
	                //有效时间内没有响应，请求超时，重新发请求
	            	alert('超时了');
	            }else{
	                // 其他的错误，如网络错误等
	            	alert('其他的错误');
	            }
	        }
	    });
	  
	});
});
(function(){
	var totalWidth = 0, current = 1;
	
	jQuery.each($('.nav').find('li'), function(){
		totalWidth += jQuery(this).outerWidth();
	});
	
	jQuery('.nav').width(totalWidth);
	
	function currentLeft(){
		return -(current - 1) * 93;	
	}
	
	jQuery('.nav-btn a').click(function(e) {
		var tempWidth = totalWidth - ( Math.abs(jQuery('.nav').css('left').split('p')[0]) + jQuery('.nav-wrap').width() );
        if(jQuery(this).hasClass('nav-prev-btn')){
			if( parseInt($('.nav').css('left').split('p')[0])  < 0){
				current--;
				Math.abs($('.nav').css('left').split('p')[0]) > 93 ? jQuery('.nav').animate({'left': currentLeft()}, 200) : jQuery('.nav').animate({'left': 0}, 200);
			}
		}else{

			if(tempWidth  > 0)	{
				
			   	current++;
				tempWidth > 93 ? jQuery('.nav').animate({'left': currentLeft()}, 200) : jQuery('.nav').animate({'left': jQuery('.nav').css('left').split('p')[0]-tempWidth}, 200);
			}
		}
    });
	
	jQuery.extend(jQuery.gritter.options, {
      position: 'bottom-right'
  });
	
	jQuery.each(jQuery('.skin-opt li'),function(index, element){
		if((index + 1) % 3 == 0){
			jQuery(this).addClass('third');	
		}
		jQuery(this).css('background',jQuery(this).attr('attr-color'));
	});
	
	jQuery('.setting-skin').click(function(e) {
		jQuery('.skin-opt').show();
    });
	
	jQuery('.skin-opt').click(function(e) {
        if(jQuery(e.target).is('li')){
			alert($(e.target).attr('attr-color'));	
		}
    });
	
	jQuery('.hd-top .user-info .more-info').click(function(e) {
		jQuery(this).toggleClass('active'); 
       jQuery('.user-opt').toggle();
    });
	
	jQuery('.more-info').click(function(e) {
		jQuery('.user-opt').show();
    });
	
/* 	hideElement($('.user-opt'), $('.more-info'), function(current, target){
		$('.more-info').removeClass('active'); 
	}); */
})();
function getMsgNum(){
	jQuery.ajax({
        url:'${messageUri}${fns:getUser().id}',
        type:'get',
        dataType:'json',
        timeout:5000,
        success:function(data, textStatus){
            if(data && data.result){
                                    //请求成功，刷新数据
                jQuery(".unreadmessage").html(data.result.num);
                jQuery(".messageContent").remove();
                                    //这个是用来和后台数据作对比判断是否发生了改变
                var messagelist = data.result.data;
                for(var i = 0;i<messagelist.length;i++) {
                	var messagedata = JSON.stringify(messagelist[i]); 
                	var id = messagelist[i].id;
                	var avatar = messagelist[i].sender.photo;
                	var name = messagelist[i].sender.name;
                	var time = messagelist[i].sendDate;
                	var content = messagelist[i].content;
                	
                	jQuery("<li class='messageContent'> <a data-toggle='modal' data-target='#exampleModal' data-whatever='"+messagedata+"'> <span class='photo'><img src='${avatarUri}/small/"+avatar+"' width='34' height='34'></span> <span class='subject'> <span class='from'>"+name+"</span> <span class='time'>"+calctime(time)+"</span> </span> <span class='text'> "+content+"</span> </a> </li>").insertBefore(".notificationFooter");
                	if(localStorage.getItem("messageid_"+id)==null) {
                	jQuery.gritter.add({
                        // (string | mandatory) the heading of the notification
                        title: name,
                        // (string | mandatory) the text inside the notification
                        text: content,
                        // (string | optional) the image to display on the left
                        image: '${avatarUri}/small/'+avatar,
                        // (bool | optional) if you want it to fade out on its own or just sit there
                        sticky: false,
                        // (int | optional) the time you want it to be alive for before fading out
                        time: '',
                        class_name: 'gritter-light',
                        before_open: function(){
                        	localStorage.setItem("messageid_"+id,messagedata);
                        },
                    });
                	
                	}
                }
                
            } 
            if(textStatus == "success"){
                                    //成功之后，再发送请求，递归调用
                setTimeout('getMsgNum()',5000);
            }
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            if(textStatus == "timeout"){
                                    //有效时间内没有响应，请求超时，重新发请求
            	setTimeout('getMsgNum()',5000);
            }else{
                                    // 其他的错误，如网络错误等
            	setTimeout('getMsgNum()',5000);
            }
        }
    });
}
function sendmessage() {
	jQuery.ajax({
        url:jQuery("#form_data")[0].action,
        type:'post',
        dataType:'json',
        data:jQuery("#form_data").serialize(),
        timeout:5000,
        success:function(data, textStatus){
        	if(textStatus == "success"){
        		jQuery('#reply').val("");
        		jQuery('#exampleModal').modal('hide');
        	}
        },
        error:function(XMLHttpRequest, textStatus, errorThrown){
            if(textStatus == "timeout"){
                                    //有效时间内没有响应，请求超时，重新发请求
            	setTimeout('getMsgNum()',5000);
            }else{
                                    // 其他的错误，如网络错误等
            	setTimeout('getMsgNum()',5000);
            }
        }
	});
}
function calctime(date1) {
    var date2 = new Date();    //结束时间  
    var date3 = date2.getTime() - new Date(date1).getTime();   //时间差的毫秒数        
  
    //------------------------------  
  
    //计算出相差天数  
    var days=Math.floor(date3/(24*3600*1000))  
  
    //计算出小时数  
  
    var leave1=date3%(24*3600*1000)    //计算天数后剩余的毫秒数  
    var hours=Math.floor(leave1/(3600*1000))  
    //计算相差分钟数  
    var leave2=leave1%(3600*1000)        //计算小时数后剩余的毫秒数  
    var minutes=Math.floor(leave2/(60*1000))  
    //计算相差秒数  
    var leave3=leave2%(60*1000)      //计算分钟数后剩余的毫秒数  
    var seconds=Math.round(leave3/1000)
    if(days==0&&hours!=0&&minutes!=0&&seconds!=0) {
    	return hours+"小时"+minutes+"分"+seconds+"秒";
    }else if(hours==0&&minutes!=0&&seconds!=0) {
    	return minutes+"分"+seconds+"秒";
    }else if(minutes==0&&seconds!=0) {
    	return seconds+"秒";
    }else if(seconds==0) {
    	return "刚刚";
    }
    return days+"天"+hours+"小时"+minutes+"分"+seconds+"秒"; 
}
$(window).load(function() {
	// 初始化点击第一个一级菜单
	jQuery("#menu a.menu").eq(0).click();
	// 初始化点击第一个二级菜单
	/* if (!jQuery(menuId + " .accordion-body:first",document.getElementById('mainIframe').contentWindow.document).hasClass('in')){ */
		jQuery("#bd .sidebar .nav .nav-li",document.getElementById('mainIframe').contentWindow.document).eq(0).click()
	/* } */
	/* if (!jQuery(menuId + " .accordion-body li:first ul:first",document.getElementById('mainIframe').contentWindow.document).is(":visible")){
		jQuery(menuId + " .accordion-body a:first i"),document.getElementById('mainIframe').contentWindow.document.click();
	}
	// 初始化点击第一个三级菜单
	jQuery(menuId + " .accordion-body li:first li:first a:first i",document.getElementById('mainIframe').contentWindow.document).click(); */
 });

</script>
<title>${fns:getConfig('productName')}</title>
</head>

<body>
<div class="modal fade" id="NoPermissionModal">  
    <div class="modal-dialog" >  
        <div class="modal-content">  
            <div class="modal-header">  
                <%-- <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>--%>  
                <button type="button" class="close" onclick="window.history.go(-1);">×</button>  
                <h4 class="modal-title" id="NoPermissionModalLabel">系统消息</h4>  
            </div>  
            <div class="modal-body">  
                <iframe id="NoPermissioniframe" width="100%" height="50%" frameborder="0"></iframe>  
            </div>  
            <div class="modal-footer">  
                <button class="btn btn-default"  type="button" onclick="window.history.go(-1);" >    关  闭    </button>  
            </div>  
        </div>  
    </div>  
</div>
<div class="modal fade" id="passwordmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin: 21.8%;background-color: white;">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
    	</div>
    </div>
</div>
<div class="modal fade" id="inputmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin: 3%;background-color: white;">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
    	</div>
    </div>
</div>
<div class="modal fade" id="listmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin: 3%;background-color: white;">
	<div class="modal-dialog" role="document">
    	<div class="modal-content">
    	</div>
    </div>
</div>
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">短消息</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form id="form_data" action="${ctx}/sys/contact/sysContact/savequick" method="post">
      <div class="modal-body">
        <form>
          <div class="form-group">
            <label for="message-text" class="form-control-label">发送时间:</label>
            <input id="sendDate" style="width:95%" type="text" readonly="readonly" class="form-control"/>
          </div>
          <div class="form-group">
          	<input type="hidden" class="form-control" id="senderid" name="receiver">
          	<input type="hidden" class="form-control" id="receiveid" name="sender">
            <label for="recipient-name" class="form-control-label">消息内容:</label>
            <textarea class="form-control" style="width:95%" id="content" readonly="readonly"></textarea>
          </div>
          <div class="form-group">
            <label for="message-text" class="form-control-label">回复:</label>
            <textarea class="form-control" style="width:95%" name="content" id="reply"></textarea>
          </div>
        </form>
      </div>
      </form>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" onclick="sendmessage()">发送回复</button>
      </div>
    </div>
  </div>
</div>
<div id="container">
	<div id="hd">
    	<div class="hd-top">
            <h1 class="logo"></h1>
            <div class="user-info">
                <a href="javascript:;" class="user-avatar" style="border-radius:100%;background:url(${avatarUri}/small/${fns:getUser().photo})"><span><i class="info-num unreadmessage"></i></span></a>
                <span class="user-name">${fns:getUser().name}</span>
            </div>
            <div class="setting ue-clear">
            	<div class="setting-skin">
            		<a href="#" class="dropdown-toggle" data-toggle="dropdown">您有<span class="unreadmessage"></span>条未读消息 <b class="caret"></b></a>
                	<ul class="dropdown-menu subnav modalLink" style="font-size:10px;width:275px">
          				<li class="notificationFooter" style="text-align:center"> <a href="${ctx}/sys/contact/sysContact" data-toggle="modal" data-target="#listmodal">查看所有消息</a> </li>
                    </ul>
                </div>
                <ul class="setting-main ue-clear subnav modalLink">
                	<li id="userinfo" class="subnav-li"><a href="${ctx}/sys/user/info" data-toggle="modal" data-target="#inputmodal">个人信息</a></li>
                    <li class="subnav-li"><a href="${ctx}/sys/user/modifyPwd" data-toggle="modal" data-target="#passwordmodal">修改密码</a></li>
                    <li><a href="javascript:;" data-toggle="modal" data-target="#mymodal">帮助</a></li>
                    <li><a href="javascript:;" class="close-btn exit"></a></li>
                </ul>
            </div>
        </div>
        <div class="hd-bottom">
        	<i class="home"><a href="${ctx}"></a></i>
        	<div id="menu" class="nav-wrap">
                <ul class="nav ue-clear">
                <c:set var="firstMenu" value="true"/>
					<c:forEach items="${fns:getMenuList()}" var="menu" varStatus="idxStatus">
						<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
						<c:if test="${empty menu.href}">
							<li><a class="menu" href="javascript:" data-href="${ctx}/sys/menu/tree?parentId=${menu.id}" data-id="${menu.id}">
								${menu.name}
							</a></li>
						</c:if>
						<c:if test="${not empty menu.href}">
							<li><a href="${fn:indexOf(menu.href, '://') eq -1 ? ctx : ''}${menu.href}" data-id="${menu.id}" data-toggle="modal" data-target="#inputmodal">
								${menu.name}
							</a></li>
						</c:if>
					<c:if test="${firstMenu}">
						<c:set var="firstMenuId" value="${menu.id}"/>
					</c:if>
					<c:set var="firstMenu" value="false"/>
					</c:if>
				</c:forEach>
                </ul>
            </div>
            <div class="nav-btn">
            	<a href="javascript:;" class="nav-prev-btn"></a>
                <a href="javascript:;" class="nav-next-btn"></a>
            </div>
        </div>
    </div>
    <div id="bd">
        <iframe width="100%" height="100%" id="mainIframe" name="mainIframe" src="${ctx}/sys/menu/initnav" frameborder="0"></iframe>
    </div>
    
    <div id="ft" class="ue-clear">
    	<div class="ft1 ue-clear">
        	<i class="ft-icon1"></i>
            <span>${fns:getConfig('productName')}</span>
            <em>Copyright &copy; 2012-${fns:getConfig('copyrightYear')}</em>
        </div>
        <div class="ft2 ue-clear">
        	<span>Powered By <a href="http://jeesite.com" target="_blank">JeeSite</a></span>
            <em>${fns:getConfig('version')}</em>
            <i class="ft-icon2"></i>
        </div>
    </div>
</div>

<div class="exitDialog">
	<div class="content">
    	<div class="ui-dialog-icon"></div>
        <div class="ui-dialog-text">
        	<p class="dialog-content">你确定要退出系统？</p>
            <p class="tips">如果是请点击“确定”，否则点“取消”</p>
            
            <div class="buttons">
                <input type="button" class="button long2 ok" value="确定" />
                <input type="button" class="button long2 normal" value="取消" />
            </div>
        </div>
        
    </div>
</div>

<div class="opt-panel user-opt" style="top:52px;left:330px;">
	<ul>
    	<li><a class="text">用户资料</a></li>
        <li><a class="text">短消息<span class="num">(2)</span></a></li>
        <li><a class="text">资料信息</a></li>
        <li><a class="text">注销</a></li>
        <li><a class="text">自定义</a></li>
    </ul>
    <div class="opt-panel-tl"></div>
    <div class="opt-panel-tc"></div>
    <div class="opt-panel-tr"></div>
    <div class="opt-panel-ml"></div>
    <div class="opt-panel-mr"></div>
    <div class="opt-panel-bl"></div>
    <div class="opt-panel-bc"></div>
    <div class="opt-panel-br"></div>
    <div class="opt-panel-arrow"></div>
</div>
</body>
</html>
