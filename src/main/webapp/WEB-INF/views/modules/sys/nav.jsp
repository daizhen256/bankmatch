<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<meta http-equiv="X-UA-Compatible" content="IE=emulateIE7" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/style.css" />
<link rel="stylesheet" href="${ctxStatic}/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" type="text/css" href="${ctxStatic}/css/skin_/nav.css" />
<script type="text/javascript" src="${ctxStatic}/js/jquery.js"></script>
<script type="text/javascript" src="${ctxStatic}/js/global.js"></script>
<title>底部内容页</title>
</head>

<body>
<div id="container">
	<div id="bd">
    	<div class="sidebar">
        	<div class="sidebar-bg"></div>
            <i class="sidebar-hide"></i>
            <h2><a href="javascript:;"><i class="h2-icon" title="切换到树型结构"></i><span id="menutitle">我的面板</span></a></h2>
            <ul class="nav">
            	<li class="subnav-li" data-id="1" href="/jeesite/a/sys/menu/inithome">
					<a data-id="1" href="/jeesite/a/sys/menu/inithome" target="mainIFrame">
						<i class="subnav-icon"></i><span class="subnav-text">首页</span>
					</a>
				</li>
            </ul>
        </div>
        <div class="main">
        	<div class="title">
                <i class="sidebar-show"></i>
                <ul class="tab ue-clear">
                   
                </ul>
                <i class="tab-more"></i>
                <i class="tab-close"></i>
            </div>
            <div class="content">
            </div>
        </div>
    </div>
</div>

</body>
<script type="text/javascript" src="${ctxStatic}/js/nav.js"></script>
<script type="text/javascript" src="${ctxStatic}/js/Menu.js"></script>
<script type="text/javascript" src="${ctxStatic}/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript">
	var menu = new Menu({
		defaultSelect: $('.nav').find('li[data-id="1"]')	
	});
	
	// 左侧树结构加载
	var setting = {
        view : {
            showIcon : false,
            fontCss : setFontCss_ztree//进行样式设置的方法
        },
        data : {
            simpleData : {
                enable : true,//是否之用简单数据
                idKey : 'id', //对应json数据中的ID
                pIdKey : 'parentId' //对应json数据中的父ID
            },
        },
        async : {
            enable : true,//是否为异步加载
            url : '${ctx}/sys/menu/userMenu',//相关的请求网址
            otherParam : {
                //"id" : list//传参数，写法和可以参考API文档
            },
        },
        callback : {//请求成功后回调
            //onClick : onclickTree,//点击相关节点触发的事件
            //onAsyncSuccess : ztreeOnAsyncSuccess,//异步加载成功后执行的方法
        },
    };

	$.fn.zTree.init($(".tree"), setting);
	
	function setFontCss_ztree(treeId, treeNode) {
	    if (treeNode.id == 0) {
	        //根节点
	        return {color: "#333", "font-weight": "bold"};
	    } else if (treeNode.isParent == false) {
	        //叶子节点
	        return (!!treeNode.highlight) ? {color: "#ff0000", "font-weight": "bold"} : {
	            color: "#660099",
	            "font-weight": "normal"
	        };
	    } else {
	        //父节点
	        return (!!treeNode.highlight) ? {color: "#ff0000", "font-weight": "bold"} : {
	            color: "#333",
	            "font-weight": "normal"
	        };
	    }
	}
	
	$('.sidebar h2').click(function(e) {
        $('.tree-list').toggleClass('outwindow');
		$('.nav').toggleClass('outwindow');
    });
	
	$(document).click(function(e) {
		if(!$(e.target).is('.tab-more')){
			 $('.tab-more').removeClass('active');
			 $('.more-bab-list').hide();
		}
    });
</script>
</html>
