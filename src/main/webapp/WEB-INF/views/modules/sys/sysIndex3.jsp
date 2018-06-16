<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>${fns:getConfig('productName')}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="decorator" content="blank"/>
<link rel="Stylesheet" href="${ctxStatic}/js/jerichotab/css/jquery.jerichotab.css" />
<!-- Bootstrap -->
<link href="${ctxStatic}/css/bootstrap.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/css/thin-admin.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/css/font-awesome.css" rel="stylesheet" media="screen">
<link href="${ctxStatic}/style/style.css" rel="stylesheet">
<link href="${ctxStatic}/style/dashboard.css" rel="stylesheet">
<link href="${ctxStatic}/css/jquery.gritter.css" rel="stylesheet">
<link href="${ctxStatic}/assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen"/>
<script type="text/javascript">
		var tabTitleHeight = 33; // 页签的高度
		var whatisthis = 21; // 神奇的高度差
		$(document).ready(function() {
			getMsgNum();
			jQuery('.demo_changer .demo-icon').trigger("click");
			
			jQuery.fn.initJerichoTab({
                renderTo: '#right', uniqueId: 'jerichotab',
                contentCss: { 'height': window.innerHeight - jQuery('.container').height() - jQuery('.footer').height() - whatisthis - tabTitleHeight },
                tabs: [], loadOnce: true, tabWidth: 110, titleHeight: tabTitleHeight
            });
			// 绑定菜单单击事件
			jQuery("#menu a.menu").click(function(){
				jQuery("#nav").empty();
				// 一级菜单焦点
				jQuery("#menu li.menu").removeClass("active");
				jQuery(this).parent().addClass("active");
				// 左侧区域隐藏
				if (jQuery(this).attr("target") == "mainFrame"){
					jQuery("#nav,#openClose").hide();
					jQuery("#mainFrame").show();
					return true;
				}
				// 显示二级菜单
				var menuId = "#menu-" + jQuery(this).attr("data-id");
				if (jQuery(menuId).length > 0){
					jQuery("#nav .accordion").hide();
					jQuery(menuId).show();
					// 初始化点击第一个二级菜单
					if (!jQuery(menuId + " .accordion-body:first").hasClass('in')){
						jQuery(menuId + " .accordion-heading:first a").click();
					}
					if (!jQuery(menuId + " .accordion-body li:first ul:first").is(":visible")){
						jQuery(menuId + " .accordion-body a:first i").click();
					}
					// 初始化点击第一个三级菜单
					jQuery(menuId + " .accordion-body li:first li:first a:first i").click();
				}else{
					// 获取二级菜单数据
					jQuery.get(jQuery(this).attr("data-href"), function(data){
						if (data.indexOf("id=\"loginForm\"") != -1){
							alert('未登录或登录超时。请重新登录，谢谢！');
							top.location = "${ctx}";
							return false;
						}
						jQuery("#nav .accordion").hide();
						jQuery("#nav").append(data);
						activeMenu();
						// 展现三级
						jQuery(menuId + " .sub-menu a").click(function(){
							var href = jQuery(this).attr("data-href");
							if(jQuery(href).length > 0){
								jQuery(href).toggle().parent().toggle();
								return false;
							}
							return addTab(jQuery(this), true); 
						});
						// 默认选中第一个菜单
						jQuery(menuId + " .accordion-body a:first i").click();
						jQuery(menuId + " .accordion-body li:first li:first a:first i").click();
					});
				}
				return false;
			});
			// 初始化点击第一个一级菜单
			jQuery("#menu a.menu:first span").click();
			jQuery(".user .dropdown-menu a").mouseup(function(){
				return addTab(jQuery(this), true, true);
			});
			jQuery(".notificationFooter a").mouseup(function(){
				return addTab(jQuery(this), true, true);
			});
			jQuery(".brand a").click(function(){
				return addTab(jQuery(this), false, true);
			});
			jQuery(".brand a").click();
			jQuery('#exampleModal').on('show.bs.modal', function (event) {
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
			jQuery.extend(jQuery.gritter.options, {
                position: 'bottom-right'
            });
		});
		function addTab($this, closeable, refresh){
			jQuery(".jericho_tab").show();
			jQuery("#mainFrame").hide();
			jQuery.fn.jerichoTab.addTab({
                tabFirer: $this,
                title: $this.text()==''?'主页':$this.text(),
                closeable: closeable,
                data: {
                    dataType: 'iframe',
                    dataLink: $this.attr('href')
                }
            }).loadData(refresh);
			return false;
		}
		function activeMenu() {
			jQuery('#nav li').on('click', function(e) {
				  jQuerythis = jQuery(this);
				  e.stopPropagation(); 

				  if(jQuerythis.has('ul').length) {
					e.preventDefault();
					var visibleUL = jQuery('#nav').find('ul:visible').length; 
					var ele_class = jQuery('ul', this).attr("class");
					if(ele_class != 'sub-menu opened')
					{
						jQuery('#nav').find('ul:visible').slideToggle("normal");
						jQuery('#nav').find('ul:visible').removeClass("opened");
						jQuery('.icon-angle-down').addClass("closing");
						jQuery('.closing').removeClass("icon-angle-down");
						jQuery('.closing').addClass("icon-angle-left");
						jQuery('.icon-angle-left').removeClass("closing");
					}
					jQuery('ul', this).slideToggle("normal");
					if(ele_class == 'sub-menu opened')
					{
						jQuery('ul', this).removeClass("opened");
						jQuery('.arrow', this).removeClass("icon-angle-down");
						jQuery('.arrow', this).addClass("icon-angle-left");
					}
					else
					{
						jQuery('ul', this).addClass("opened");
						jQuery('.arrow', this).removeClass("icon-angle-left");
						jQuery('.arrow', this).addClass("icon-angle-down");
					}
				  } 

			});
		}
		function openCloseClickCallBack(b){
			jQuery.fn.jerichoTab.resize();
		}
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
		                	
		                	jQuery("<li class='messageContent'> <a data-toggle='modal' data-target='#exampleModal' data-whatever='"+messagedata+"'> <span class='photo'><img src='${avatarUri}/small/"+avatar+"' width='34' height='34'></span> <span class='subject'> <span class='from'>"+name+"</span> <span class='time'>"+calctime(time)+"</span> </span> <span class='text'> "+content+"</span> </a> </li>").insertAfter(".title");
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
	</script>
</head>
<body>
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
            <input id="sendDate" type="text" readonly="readonly" class="form-control"/>
          </div>
          <div class="form-group">
          	<input type="hidden" class="form-control" id="senderid" name="receiver">
          	<input type="hidden" class="form-control" id="receiveid" name="sender">
            <label for="recipient-name" class="form-control-label">消息内容:</label>
            <textarea class="form-control" id="content" readonly="readonly"></textarea>
          </div>
          <div class="form-group">
            <label for="message-text" class="form-control-label">回复:</label>
            <textarea class="form-control" name="content" id="reply"></textarea>
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

<div id="main">
<div class="container">
  <div class="top-navbar header b-b"> <a data-original-title="Toggle navigation" class="toggle-side-nav pull-left" href="#"><i class="icon-reorder"></i> </a>
    <div class="brand pull-left"> <a href="${ctx}/sys/user/mainpage" target="mainFrame"><img src="${ctxStatic}/images/logo.png" width="147" height="33"></a></div>
    <div id="menu" class="shortcuts pull-left">
		<c:set var="firstMenu" value="true"/>
			<c:forEach items="${fns:getMenuList()}" var="menu" varStatus="idxStatus">
				<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
				<c:if test="${empty menu.href}">
					<a class="menu shortcut" href="javascript:" data-href="${ctx}/sys/menu/tree?parentId=${menu.id}" data-id="${menu.id}">
							<i class="shortcut-icon ${menu.icon}">
					        </i>
					        <span class="shortcut-label">
					            ${menu.name}
					        </span>
					</a>
				</c:if>
				<c:if test="${not empty menu.href}">
					<a class="menu shortcut" href="${fn:indexOf(menu.href, '://') eq -1 ? ctx : ''}${menu.href}" data-id="${menu.id}" target="mainFrame">
							<i class="shortcut-icon ${menu.icon}">
					        </i>
					        <span class="shortcut-label">
					            ${menu.name}
					        </span>
					</a>
				</c:if>
			<c:if test="${firstMenu}">
				<c:set var="firstMenuId" value="${menu.id}"/>
			</c:if>
			<c:set var="firstMenu" value="false"/>
			</c:if>
		</c:forEach>
    </div>
    <ul class="nav navbar-nav navbar-right hidden-xs">
      <li class="dropdown"> <a data-toggle="dropdown" class="dropdown-toggle" href="#"> <i class="icon-envelope"></i> <span class="badge unreadmessage"></span> </a>
        <ul class="dropdown-menu extended notification">
          <li class="title">
            <p>您有<span class="unreadmessage"></span>条未读消息</p>
          </li>
          
          <li class="notificationFooter"> <a href="${ctx}/sys/contact/sysContact" target="mainFrame">查看所有消息</a> </li>
        </ul>
      </li>
      <li class="dropdown user hidden-xs"> <a data-toggle="dropdown" class="dropdown-toggle" href="#" title="个人信息"> <img alt="" src="${avatarUri}/small/${fns:getUser().photo}" /> <span class="username">您好, ${fns:getUser().name}&nbsp;</span> <i class="icon-caret-down small"></i> </a>
        <ul class="dropdown-menu">
          <li><a href="${ctx}/sys/user/info" target="mainFrame"><i class="icon-user"></i>&nbsp; 个人信息</a></li>
          <li><a href="${ctx}/sys/user/modifyPwd" target="mainFrame"><i class="icon-calendar"></i>&nbsp;  修改密码</a></li>
          <li class="divider"></li>
          <li><a href="${ctx}/logout" title="退出登录"><i class="icon-key"></i> 退出</a></li>
        </ul>
      </li>
    </ul>
  </div>
</div>
<div class="wrapper">
  <div class="left-nav">
    <div id="side-nav">
      <ul id="nav">
        
      </ul>
    </div>
  </div>
  <div class="page-content">
  			<div id="content" class="row-fluid">
				<div id="left">
				</div>
				<div id="right">
					<iframe id="mainFrame" name="mainFrame" src="" style="overflow:visible;" scrolling="yes" frameborder="no" width="100%" height="600"></iframe>
				</div>
			</div>
  </div>
</div>
<div class="bottom-nav footer">Copyright &copy; 2012-${fns:getConfig('copyrightYear')} ${fns:getConfig('productName')} - Powered By <a href="http://jeesite.com" target="_blank">JeeSite</a> ${fns:getConfig('version')}</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) --> 
<script type="text/javascript" src="${ctxStatic}/js/smooth-sliding-menu.js"></script> 
<script class="include" type="text/javascript" src="${ctxStatic}/javascript/jquery.jqplot.min.js"></script> 
<script src="${ctxStatic}/js/jquery.gritter.js"></script>
<!--switcher html start-->
    <div class="demo_changer active" style="right: 0px;">
      <div class="demo-icon"></div>
      <div class="form_holder">
        <div class="predefined_styles">
          <a class="styleswitch" rel="a" href="">
            <img alt="" src="${ctxStatic}/images/a.jpg"></a>
          <a class="styleswitch" rel="b" href="">
            <img alt="" src="${ctxStatic}/images/b.jpg"></a>
          <a class="styleswitch" rel="c" href="">
            <img alt="" src="${ctxStatic}/images/c.jpg"></a>
          <a class="styleswitch" rel="d" href="">
            <img alt="" src="${ctxStatic}/images/d.jpg"></a>
          <a class="styleswitch" rel="e" href="">
            <img alt="" src="${ctxStatic}/images/e.jpg"></a>
          <a class="styleswitch" rel="f" href="">
            <img alt="" src="${ctxStatic}/images/f.jpg"></a>
          <a class="styleswitch" rel="g" href="">
            <img alt="" src="${ctxStatic}/images/g.jpg"></a>
          <a class="styleswitch" rel="h" href="">
            <img alt="" src="${ctxStatic}/images/h.jpg"></a>
          <a class="styleswitch" rel="i" href="">
            <img alt="" src="${ctxStatic}/images/i.jpg"></a>
          <a class="styleswitch" rel="j" href="">
            <img alt="" src="${ctxStatic}/images/j.jpg"></a>
        </div>
      </div>
    </div>

<!--switcher html end--> 
<script src="${ctxStatic}/assets/switcher/switcher.js"></script> 
<script src="${ctxStatic}/assets/switcher/moderziner.custom.js"></script>
<link href="${ctxStatic}/assets/switcher/switcher.css" rel="stylesheet">
<link href="${ctxStatic}/assets/switcher/switcher-defult.css" rel="stylesheet">

<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/a.css" title="a" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/b.css" title="b" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/c.css" title="c" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/d.css" title="d" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/e.css" title="e" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/f.css" title="f" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/g.css" title="g" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/h.css" title="h" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/i.css" title="i" media="all" />
<link rel="alternate stylesheet" type="text/css" href="${ctxStatic}/assets/switcher/j.css" title="j" media="all" />
</div>


</body>
</html>
