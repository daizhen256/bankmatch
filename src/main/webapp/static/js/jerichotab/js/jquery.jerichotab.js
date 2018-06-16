﻿/// <reference path="jquery.js"/>
/*
 * jerichotab
 * version: release-2.0.1 (05/13/2009) 
 * @ jQuery v1.3.*
 *
 * Licensed under the GPL:
 *   http://gplv3.fsf.org
 *
 * Copyright 2008, 2009 Jericho [ thisnamemeansnothing[at]gmail.com ] 
	========================================
	#example:
		
	========================================
	========================================
	#API:
		#jQuery.fn.initJerichoTab(Function):
				*renderTo(String): the tab render to('#sample')
				*uniqueId(String): the tab's id(It must be unique)
				*tabs(Array): the tabs will be initialized, whose items will be formated as follows:
					{
					**title(String): the tab title text
					**iconImg(String): the tab icon that displayed from title text,
					**closeable(Boolean): the switch that controls whether the tab can be closed (true as default)
					}
				*activeTabIndex(Int): the tab you'd like to select after loading(0 as default)
				*contentHeight(Int): height of the content div tag
				*contentCss(Object): the same as style sheet
				*loadOnce(Boolean): the switch controls if load tab content at the first time(true as default)
				*tabWidth(Int): width of each tab(150 as default)
		#jQuery.fn.jerichoTab.addTab(Function):
				*tabId(String); the unique tab Id(Unused, private)
				*tabFirer(JQuery Object): the object that makes tab shown in a special way
				*title(String): the tab title text
				*data(Object): the tab data to load,including:
							**dataType:type of data,
							**dataLink:data link
								#example(must use as suited):
								##formtag:
									*dataType:'formtag', 
									//***use the html tags in this page
									*dataLink:'#example' 
									//***id of the tag you'd like to display in this tab
								##iframe:
									*dataType:'iframe', 
									//***use the iframe to load another page
									*dataLink:''
									//***such as 'iframetemplates/iframe.htm' 
									//***the relative url of the page you'd like to display in this tab,
									//***and jerichoTab will use an iframe to load it
								###html:
									*dataType:'html',
									//*** load data from html url
									*dataLink:''
									// *** the relative url of your html page
								##ajax:
								*dataType:'ajax',
								//***use ajax to load data with asynchronous operations
								*dataLink:''
								//*** yes,u can write down your ajax handler url and then jerichotab'll make a callback,
								//*** so the responseText will be displayed in the content holder(u can use html tags in your server callback datas)
				*onLoadCompleted(Function): fired after the data has been loaded
				*iconImg(String): the tab icon that displayed below title text(relative to...),
				*closeable(Boolean): set whether the tab can be closed(true as default)
	========================================
*/

//; (function(jQuery) {
jQuery.extend(jQuery.fn, {
    initJerichoTab: function(setting) {
        var opts = jQuery.fn.extend({
            //the container of jerichotab(is required,  a jQuery format selector String as '.container' or '#container')
            renderTo: null,
            //the unique id of jerichotab(is required and unique, not null)
            uniqueId: null,
            //format your tab data like this: [{title:'',iconImg:'',closeable:true},{title:'',iconImg:'',closeable:true}]
            //it's an Array...
            tabs: [],
            //when the jerichotab has been loaded, the tab you'ld like to display first(start at 0, and 0 as default)
            activeTabIndex: 0,
            //the style sheet of tab content
            contentCss: {
                'height': '500px'
            },
            //if you set this property as true, the data'll be loaded only at the first time when users click the tab
            //in other times jerichotab only swich it's css(display property) from 'none' to 'block'
            loadOnce: true,
            //the tab width (150 as default)
            tabWidth: 110,
            //set an ajaxload effect, jerichotab has provided two choices: 'usebg' | 'righttag'
            //'usebg': control if set a big loading gif in the contentholder
            //'righttag': this will set a small loading gif in the right top of contentholder
            loader: 'righttag',
            //两边滑块宽度
            slidersWidth: 19,
            //标题高度
            titleHeight: 26
        }, setting);
        //initialize the jerichotab
        function createJerichoTab() {
            //make sure that a container and uniqueId were provided
            if (opts.renderTo == null) { alert('you must set the \'renderTo\' property\r\t--JeirchoTab'); return; }
            if (opts.uniqueId == null) { alert('you must set the \'uniqueId\' property\r\t--JeirchoTab'); return; }
            if (jQuery('#' + opts.uniqueId).length > 0) { alert('you must set the \'uniqueId\' property as unique\r\t--JeirchoTab'); return; }
            //the jerichotab html tree:
            /* <div class="jericho_tab">
            <div class="tab_pages" >
            <div class="tabs">
            <ul /> ###tabpages here
            </div>
            </div>
            <div class="tab_content">
            <div id="jerichotab_contentholder" class="content" /> ###tabcontents here
            </div>
            </div>
            */
            var jerichotab = jQuery('<div id="'+opts.uniqueId+'" class="jericho_tab"><div class="tab_pages" ><div class="tabs"><ul /></div></div><div class="tab_content"><div id="jerichotab_contentholder" class="content" /></div></div>')
                                            .appendTo(jQuery(opts.renderTo));
            
            //apply contentcss to the contentholder
            jQuery('.tab_content>.content', jerichotab).css(opts.contentCss);
            
            //fill data
            jQuery.fn.jerichoTab = {
                master: jerichotab,
                tabWidth: opts.tabWidth,
                tabPageWidth: jQuery('.tab_pages', jerichotab).width(),
                slidersWidth: opts.slidersWidth,
                loader: opts.loader,
                loadOnce: opts.loadOnce,
                tabpage: jQuery('.tab_pages>.tabs>ul', jerichotab),
                addTab: function(tabsetting) {
                    //set as the unique tab id and tabFirer tag
                    tagGuid = (typeof tagGuid == 'undefined' ? 0 : tagGuid + 1);
                    var curIndex = tagGuid;
                    //this function will be open to all users for them to add tab at any time
                    var ps = jQuery.fn.extend({
                        //if there is a DOM that cause the tab to be added to tabpages,
                        //you should pass it to jerichotab, in which way tab'll only be activated when
                        //user click the DOM next time
                        tabFirer: null,
                        title: '新增页签'+(curIndex+1),
                        //the dataType and dataLink were suited as:
                        //1.formtag:
                        //   dataType:'formtag', 
                        //                  --use the html tags in this page
                        //   dataLink:'#example' 
                        //                  --id of the tag you'ld like to display in this tab
                        //2.iframe:
                        //   dataType:'iframe', 
                        //                  --use the iframe to load another page
                        //   dataLink:''
                        //                  --such as 'iframetemplates/iframe.htm', set 
                        //                  --the relative url of the page u'ld like to display in this tab,
                        //                  --and jerichoTab will use an iframe to load it
                        //3.html:
                        //   dataType:'html',
                        //                  --load html tags from a url
                        //   dataLink:''
                        //                  --the relative url of your html page
                        //4.ajax:
                        //   dataType:'ajax',
                        //                  --use the ajax to load datas with asynchronous operations
                        //    dataLink:''
                        //                  --yes,u can write down your ajax handler url and jerichotab'll make a callback,
                        //                  --so the responseText will be displayed in the content holder(u can use html tags in your server callback datas)
                        data: { dataType: '', dataLink: '' },
                        //set the tab icon of each(relative to...)
                        iconImg: '',
                        //whether this tab can be closed(ture as default)
                        closeable: true,
                        //this function will be fired after all data has been loaded
                        onLoadCompleted: null,
                        // the tab's name
                        name:''
                    }, tabsetting);
                    //window.console && console.log('%o', tabsetting);
                    //check whether the tabFirer exists or not, and that it has an attribute['jerichotabindex'], then set the tab that tabFirer was connected activated
                    //otherwise attach the jerichotabindex' attribute
                    if (ps.tabFirer != null) {
                        var jerichotabindex = ps.tabFirer.attr('jerichotabindex');
                        if (typeof jerichotabindex != 'undefined' && jQuery('#jerichotab_' + jerichotabindex).length > 0)
                            return jQuery.fn.setTabActive(jerichotabindex).adaptSlider().loadData();
                        ps.tabFirer.attr('jerichotabindex', curIndex);
                    }
                    // set name
                    if(ps.name == ''){
                    	ps.name = ps.title;
                    }
                    //newTab html tree:
                    /*
                    <li>
                    <div class="tab_left" >
                    <div class="tab_icon" />
                    <div class="tab_text" >JerichoTab</div>
                    <div class="tab_close">
                    <a href="javascript:void(0)" title="Close">&nbsp;</a>
                    </div>
                    </div>
                    <div class="tab_right">&nbsp;</div>
                    </li>
                    */
                    /*var newTab = jQuery('<li class="jericho_tabs tab_selected" style="width:0px"  id="jerichotab_' + curIndex + '" dataType="' + ps.data.dataType + '" dataLink="' + ps.data.dataLink + '">' +
	                                    '<div class="tab_left"  style="width:' + (opts.tabWidth - 5) + 'px"  >' +
	                                        (ps.iconImg == '' ? '' : '<div class="tab_icon" style="' + 'background-image:url(' + ps.iconImg + ')' + '">&nbsp;</div>') +
	                                        '<div class="tab_text" title="' + ps.title + '"  style="width:' + (opts.tabWidth - 45 + (ps.iconImg == '' ? 25 : 0)) + 'px"  >' + ps.title.cut(opts.tabWidth / 10 - 1) + '</div>  ' +
	                                        '<div class="tab_close">' + (ps.closeable ? '<a href="javascript:" title="关闭">&nbsp;</a>' : '') + '</div>' +
	                                    '</div>' +
	                                    '<div class="tab_right">&nbsp;</div>' +
	                                '</li>')*/
                    var newTab = jQuery('<li name="'+ps.name+'" class="jericho_tabs tab_selected" style="width:0px"  id="jerichotab_' + curIndex + '" dataType="' + ps.data.dataType + '" dataLink="' + ps.data.dataLink + '">' +
                            '<div class="tab_left"  style="width:' + (opts.tabWidth - 5) + 'px"  >' +
                                (ps.iconImg == '' ? '' : '<div class="tab_icon" style="' + 'background-image:url(' + ps.iconImg + ')' + '">&nbsp;</div>') +
                                '<div class="tab_text" title="' + ps.title + '"  style="width:' + (opts.tabWidth - 45 + (ps.iconImg == '' ? 25 : 0)) + 'px"  >' + ps.title.cut(opts.tabWidth / 10 - 1) + '</div>  ' +
                                '<div class="tab_close">' + (ps.closeable ? '<a href="javascript:" title="关闭">&nbsp;</a>' : '') + '</div>' +
                            '</div>' +
                            '<div class="tab_right">&nbsp;</div>' +
                        '</li>').appendTo(jQuery.fn.jerichoTab.tabpage).css('opacity', '0').applyHover()
	                          .applyCloseEvent().animate({ 'opacity': '1', width: opts.tabWidth }, 100, function() {
	                        	  jQuery.fn.setTabActive(curIndex);
	                });
                    //use an Array named "tabHash" to restore the tab information
                    tabHash = (typeof tabHash == 'undefined' ? [] : tabHash);
                    tabHash.push({
                        index: curIndex,
                        tabFirer: ps.tabFirer,
                        tabId: 'jerichotab_' + curIndex,
                        holderId: 'jerichotabholder_' + curIndex,
                        iframeId: 'jerichotabiframe_' + curIndex,
                        onCompleted: ps.onLoadCompleted
                    });
                    return newTab.applySlider();
                },
                closeCurrentTab: function(tabsetting) {
                	jQuery('.tab_selected .tab_close>a').click();
                    /*var ps = jQuery.fn.extend({
                        name:'',
                        activeTabName:'',
                        isReaload: false
                    }, tabsetting);
                    
                    jQuery.fn.jerichoTab.tabpage.children('li[name='+ps.name+']').remove();
                    
                    var isLoad = 0;
                    if(ps.activeTabName != ''){
                    	var lis = jQuery.fn.jerichoTab.tabpage.children('li');
                    	for(var i=0;i<lis.size();i++){
                    		if(lis.eq(i).attr('name')==ps.activeTabName){
                    			jQuery.fn.setTabActive(i).loadData(ps.isReaload);
                    			isLoad = 1;
                    			break;
                    		}
                    	}
                    }
                    if(isLoad==0){
                    	jQuery.fn.setTabActive(0).loadData(ps.isReaload);
                    }*/
                    
                },
            };
            jQuery.each(opts.tabs, function(i, n) {
            	jQuery.fn.jerichoTab.addTab(n);
            });
            try{
                if (tabHash.length == 0)
                    jerichotab.css({ 'display': 'none' });
            }catch(e){ }
        }
        createJerichoTab();
        jQuery.fn.setTabActive(opts.activeTabIndex).loadData();
        jQuery.fn.jerichoTab.resize = function() {
        	jQuery.fn.jerichoTab.tabPageWidth = jQuery(".tab_pages", jQuery.fn.jerichoTab.master).width() - ((jQuery(".jericho_slider").length > 0) ? (jQuery.fn.jerichoTab.slidersWidth * 2) : 0);
        	jQuery(".tabs", jQuery.fn.jerichoTab.master).width(jQuery.fn.jerichoTab.tabPageWidth).applySlider().adaptSlider();
            var fixHeight = -2;
            //if (Metronic.isIE8()){
            //	fixHeight = 25;
            //}
            jQuery('#jerichotab_contentholder').height(window.innerHeight - jQuery('.container').height() - jQuery('.footer').height() - whatisthis - opts.titleHeight - 5 - fixHeight);
            jQuery(".jericho_tab iframe").height(window.innerHeight - jQuery('.container').height() - jQuery('.footer').height() - whatisthis - opts.titleHeight - fixHeight);
        };
        jQuery(window).resize(function() {
        	jQuery.fn.jerichoTab.resize();
        })
        //window.console && console.log('width :' + jQuery.fn.jerichoTab.tabpage.width());
    },
    //activate the tag(orderkey is the tab order, start at 1)
    setTabActiveByOrder: function(orderKey) {
        var lastTab = jQuery.fn.jerichoTab.tabpage.children('li').filter('.tab_selected');
        if (lastTab.length > 0) lastTab.swapTabEnable();
        return jQuery('#jericho_tabs').filter(':nth-child(' + orderKey + ')').swapTabEnable();
    },
    //activate the tag(orderKey is the tagGuid of each tab)
    setTabActive: function(orderKey) {
        var lastTab = jQuery.fn.jerichoTab.tabpage.children('li').filter('.tab_selected');
        if (lastTab.length > 0) lastTab.swapTabEnable();
        return jQuery('#jerichotab_' + orderKey).swapTabEnable();
    },
    addEvent: function(e, h) {
        var target = this.get(0);
        if (target.addEventListener) {
            target.addEventListener(e, h, false);
        } else if (target.attachEvent) {
            target.attachEvent('on' + e, h);
        }
    },
    //create an iframe in the contentholder to load pages
    buildIFrame: function(src) {
        return this.each(function() {
            var onComleted = null, jerichotabiframe = '';
            for (var tab in tabHash) {
                if (tabHash[tab].holderId == jQuery(this).attr('id')) {
                    onComleted = tabHash[tab].onCompleted;
                    jerichotabiframe = tabHash[tab].iframeId;
                    break;
                }
            }
            src += (src.indexOf('?') == -1 ? '?' : '&') + 'tabPageId=' + jerichotabiframe;
            var iframe = jQuery('<iframe id="' + jerichotabiframe + '" name="' + jerichotabiframe + '" src="' + src + '" frameborder="0" scrolling="auto" />')
							.css({ width: '100%', height: jQuery(this).parent().height(), border: 0 }).appendTo(jQuery(this));
            //add a listener to the load event
            jQuery('#' + jerichotabiframe).addEvent('load', function() {
                //if onComlete(Function) is not null, then release it
                !!onComleted ? onComleted(arguments[1]) : true;
                jQuery.fn.removeLoader();
            });
        });
    },
    //load data from dataLink
    //use the following function after each tab was activated
    loadData: function(flag) {
        return this.each(function() {
        	jQuery('.jericho_tab .tab_selected').css('background-color', jQuery('body').css('background-color'));
            //show ajaxloader first
            jQuery('#jerichotab_contentholder').showLoader();
            var onComleted = null, holderId = '', tabId = '';
            //search information in tabHash
            for (var tab in tabHash) {
                if (tabHash[tab].tabId == jQuery(this).attr('id')) {
                    onComleted = tabHash[tab].onCompleted;
                    holderId = '#' + tabHash[tab].holderId;
                    tabId = '#' + tabHash[tab].tabId;
                    break;
                }
            }
            var dataType = jQuery(this).attr('dataType');
            var dataLink = jQuery(this).attr('dataLink');
            //if dataType was undefined, nothing will be done
            if (typeof dataType == 'undefined' || dataType == '' || dataType == 'undefined') { removeLoading(); return; }
            //hide the rest contentholders
            jQuery('#jerichotab_contentholder').children('div[class=curholder]').attr('class', 'holder').css({ 'display': 'none' });
            var holder = jQuery(holderId);
            if (holder.length == 0) {
                //if contentholder DOM hasn't been created, create it immediately
                holder = jQuery('<div class="curholder" id="' + holderId.replace('#', '') + '" />').appendTo(jQuery('#jerichotab_contentholder'));
                //load data into holder
                load(holder);
            }
            else {
                holder.attr('class', 'curholder').css({ 'display': 'block' });
                if (jQuery.fn.jerichoTab.loadOnce && !flag){
                    removeLoading();
                } else {
                    holder.html('');
                    load(holder);
                }
            }

            function load(c) {
                switch (dataType) {
                    case 'formtag':
                        //clone html DOM elements in the page
                        jQuery(dataLink).css('display', 'none');
                        var clone = jQuery(dataLink).clone(true).appendTo(c).css('display', 'block');
                        removeLoading(holder);
                        break;
                    case 'html':
                        //load HTML from page
                        holder.load(dataLink + '?t=' + Math.floor(Math.random()), function() {
                            removeLoading(holder);
                        });
                        break;
                    case 'iframe':
                        //use iframe to load a website
                        holder.buildIFrame(dataLink, holder);
                        break;
                    case 'ajax':
                        //load a remote page using an HTTP request
                        jQuery.ajax({
                            url: dataLink,
                            data: { t: Math.floor(Math.random()) },
                            error: function(r) {
                                holder.html('数据加载失败！');
                                removeLoading(holder);
                            },
                            success: function(r) {
                                holder.html(r);
                                removeLoading(holder);
                            }
                        });
                        break;
                }
            }
            function removeLoading(h) {
                !!onComleted ? onComleted(h) : true;
                jQuery.fn.removeLoader();
            }
        });
    },
    //attach the slider event to every tab,
    //so users can slide the tabs when there are too much tabs
    attachSliderEvent: function() {
        return this.each(function() {
            var me = this;
            jQuery(me).hover(function() {
                jQuery(me).swapClass('jericho_slider' + jQuery(me).attr('pos') + '_enable', 'jericho_slider' + jQuery(me).attr('pos') + '_hover');
            }, function() {
                jQuery(me).swapClass('jericho_slider' + jQuery(me).attr('pos') + '_hover', 'jericho_slider' + jQuery(me).attr('pos') + '_enable');
            }).mouseup(function() {
                //filter the sliders in order to prevent users from sliding`
                if (jQuery(me).is('[slide=no]')) return;
                //get the css(left) of tabpage(ul elements)
                var offLeft = parseInt(jQuery.fn.jerichoTab.tabpage.css('left'));
                //the max css(left) of tabpage
                var maxLeft = tabHash.length * jQuery.fn.jerichoTab.tabWidth - jQuery.fn.jerichoTab.tabPageWidth + (jQuery.fn.jerichoTab.slidersWidth * 2);
                switch (jQuery(me).attr('pos')) {
                    case 'left':
                        //slide to the left side
                        if (offLeft + jQuery.fn.jerichoTab.tabWidth < 0)
                            jQuery.fn.jerichoTab.tabpage.animate({ left: offLeft + jQuery.fn.jerichoTab.tabWidth }, 100);
                        else
                            jQuery.fn.jerichoTab.tabpage.animate({ left: 0 }, 100, function() {
                                jQuery(me).attr({ 'slide': 'no', 'class': 'jericho_sliders jericho_sliderleft_disable' });
                            });
                        jQuery('.jericho_sliders[pos=right]').attr({ 'slide': 'yes', 'class': 'jericho_sliders jericho_sliderright_enable' });
                        break;
                    case 'right':
                        //slide to the right side
                        if (offLeft - jQuery.fn.jerichoTab.tabWidth > -maxLeft)
                            jQuery.fn.jerichoTab.tabpage.animate({ left: offLeft - jQuery.fn.jerichoTab.tabWidth }, 100);
                        else
                            jQuery.fn.jerichoTab.tabpage.animate({ left: -maxLeft }, 100, function() {
                                jQuery(me).attr({ 'slide': 'no', 'class': 'jericho_sliders jericho_sliderright_disable' });
                            });
                        jQuery('.jericho_sliders[pos=left]').attr({ 'slide': 'yes', 'class': 'jericho_sliders jericho_sliderleft_enable' });
                        break;
                }
            });
        });
    },
    //create or activate the slider to tabpage
    applySlider: function() {
        return this.each(function() {
            if (typeof tabHash == 'undefined' || tabHash.length == 0) return;
            //get the offwidth of tabpage
            var offWidth = tabHash.length * jQuery.fn.jerichoTab.tabWidth - jQuery.fn.jerichoTab.tabPageWidth + (jQuery.fn.jerichoTab.slidersWidth * 2);
            if (tabHash.length > 0 && offWidth > 0) {
                //make sure that the parent Div of tabpage was fixed(position:relative)
                //so jerichotab can control the display position of tabpage by using 'left'
                jQuery.fn.jerichoTab.tabpage.parent().css({ width: jQuery.fn.jerichoTab.tabPageWidth - (jQuery.fn.jerichoTab.slidersWidth * 2) });
                //auto grow the tabpage(ul) width and reset 'left'
                jQuery.fn.jerichoTab.tabpage.css({ width: offWidth + jQuery.fn.jerichoTab.tabPageWidth - (jQuery.fn.jerichoTab.slidersWidth * 2) })
                		.animate({ left: -offWidth }, 0, function() {
                    //append 'jerichosliders' to the tabpageholder if 'jerichoslider' has't been added
                    if (jQuery('.jericho_sliders').length <= 0) {
                    	var s = 'onclick="if(document.selection && document.selection.empty) {document.selection.empty();}else if(window.getSelection) {var sel = window.getSelection();sel.removeAllRanges();}"';
                        jQuery.fn.jerichoTab.tabpage.parent()
                            .before(jQuery('<div class="jericho_sliders jericho_sliderleft_enable" slide="yes" pos="left" '+s+'></div>'));
                        jQuery.fn.jerichoTab.tabpage.parent()
                            .after(jQuery('<div class="jericho_sliders jericho_sliderright_disable" pos="right" slide="yes" '+s+'></div>'));
                        jQuery('.jericho_sliders').attachSliderEvent();
                    }
                    //jQuery('.jericho_sliders').adaptSlider();
                });
            }
            else if (tabHash.length > 0 && offWidth <= 0) {
                //remove 'jerichosliders' whether the tabs were not go beyond the capacity of tabpageholder
                jQuery('.jericho_sliders').remove();
                jQuery.fn.jerichoTab.tabpage.parent().css({ width: jQuery.fn.jerichoTab.tabPageWidth });
                jQuery.fn.jerichoTab.tabpage.css({ width: -offWidth + jQuery.fn.jerichoTab.tabPageWidth })
                	.animate({ left: 0 }, 0);
            }
        });
    },
    //make sure that the slider will be adjusted quickly to the tabpage after tab 'clicking' or tab 'initializing'
    adaptSlider: function() {
        return this.each(function() {
            if (jQuery('.jericho_sliders').length > 0) {
                var offLeft = parseInt(jQuery.fn.jerichoTab.tabpage.css('left'));
                var curtag = '#', index = 0;
                for (var t in tabHash) {
                    if (tabHash[t].tabId == jQuery(this).attr('id')) {
                        curtag += tabHash[t].tabId;
                        index = parseInt(t);
                        break;
                    }
                }
                //set the tabpage width
                var tabWidth = jQuery.fn.jerichoTab.tabPageWidth - (jQuery.fn.jerichoTab.slidersWidth * 2);
                //calculate the distance from the left side of tabpage
                var space_l = jQuery.fn.jerichoTab.tabWidth * index + offLeft;
                //calculate the distance from the right side of tabpage
                var space_r = jQuery.fn.jerichoTab.tabWidth * (index + 1) + offLeft;
                //window.console && console.log(space_l + '||' + space_r);
                function setSlider(pos, enable) {
                    jQuery('.jericho_sliders[pos=' + pos + ']').attr({ 'slide': (enable ? 'yes' : 'no'), 'class': 'jericho_sliders jericho_slider' + pos + '_' + (enable ? 'enable' : 'disable') });
                }
                //slider to right to check whether it's a tab nearby left slider
                if ((space_l < 0 && space_l > -jQuery.fn.jerichoTab.tabWidth) && (space_r > 0 && space_r < jQuery.fn.jerichoTab.tabWidth)) {
                    //left
                    jQuery.fn.jerichoTab.tabpage.animate({ left: -jQuery.fn.jerichoTab.tabWidth * index }, 0, function() {
                        if (index == 0) setSlider('left', false);
                        else setSlider('left', true);
                        setSlider('right', true);
                    });
                }
                //slider to left to check whether it's a tab nearby right slider
                if ((space_l < tabWidth && space_l > tabWidth - jQuery.fn.jerichoTab.tabWidth) && (space_r > tabWidth && space_r < tabWidth + jQuery.fn.jerichoTab.tabWidth)) {
                    //right
                    jQuery.fn.jerichoTab.tabpage.animate({ left: -jQuery.fn.jerichoTab.tabWidth * (index + 1) + tabWidth }, 0, function() {
                        if (index == tabHash.length - 1) setSlider('right', false);
                        else setSlider('left', true);
                        setSlider('left', true);
                    });
                }
            }
        });
    },
    //apply event to the close anchor
    applyCloseEvent: function() {
        return this.each(function() {
            var me = this;
            jQuery('.tab_close>a', this).click(function(e) {
                //prevents further propagation of the current event. 
                e.stopPropagation();
                if (jQuery(this).length == 0) return;
                //remove tab from tabpageholder
                jQuery(me).animate({ 'opacity': '0', width: '0px' }, 100, function() {
                    //make the previous tab selected whether the removed tab was selected
                    var lastTab = jQuery.fn.jerichoTab.tabpage.children('li').filter('.tab_selected');
                    if (lastTab.attr('id') == jQuery(this).attr('id')) {
                    	if(jQuery(this).prev().text() != ''){
                            jQuery(this).prev().swapTabEnable().loadData();
                    	}else{
                    		jQuery(this).next().swapTabEnable().loadData();
                    	}
                    }
                    //clear the information of the removed tab from tabHash
                    for (var t in tabHash) {
                        if (tabHash[t].tabId == jQuery(me).attr('id')) {
                            if (tabHash[t].tabFirer != null)
                                tabHash[t].tabFirer.removeAttr('jerichotabindex');
                            tabHash.splice(t, 1);
                        }
                    }
                    //adapt slider
                    jQuery(me).applySlider().remove();
                    //remove contentholder
                    jQuery('#jerichotabholder_' + jQuery(me).attr('id').replace('jerichotab_', '')).remove();
                })
            });
            jQuery(this).RightMenu('jerichotabmenu',{menuList:[
                {menuName:"刷新当前",clickEvent:"jQuery('.tab_selected').loadData(true);"},
                {menuName:"关闭其它",clickEvent:"jQuery('.tab_unselect .tab_close>a').click();"
                	+"setTimeout('jQuery.fn.jerichoTab.resize();setTimeout(\\\'jQuery.fn.jerichoTab.resize();"
                	+"setTimeout(\\\\\\'jQuery.fn.jerichoTab.resize();\\\\\\',1000);\\\',500);',500);"}
        	]});
        });
    },
    //apply the "hover" effect and "onSelect" event
    applyHover: function() {
        return this.each(function() {
            jQuery(this).hover(function() {
                if (jQuery(this).hasClass('tab_unselect')) jQuery(this).addClass('tab_unselect_h');
            }, function() {
                if (jQuery(this).hasClass('tab_unselect_h')) jQuery(this).removeClass('tab_unselect_h');
            }).mouseup(function() {
                if (jQuery(this).hasClass('tab_selected')) return;
                //select this tab and hide the last selected tab
                var lastTab = jQuery.fn.jerichoTab.tabpage.children('li').filter('.tab_selected');
                lastTab.attr('class', 'jericho_tabs tab_unselect');
                jQuery('#jerichotabholder_' + lastTab.attr('id').replace('jerichotab_', '')).css({ 'display': 'none' });
                jQuery(this).attr('class', 'jericho_tabs tab_selected').loadData().adaptSlider();
            });
        });
    },
    //switch the tab between the selected mode and the unselected mode, or v.v...
    swapTabEnable: function() {
        return this.each(function() {
            if (jQuery(this).hasClass('tab_selected'))
                jQuery(this).swapClass('tab_selected', 'tab_unselect');
            else if (jQuery(this).hasClass('tab_unselect'))
                jQuery(this).swapClass('tab_unselect', 'tab_selected');
        });
    },
    //change class from css1 to css2 of DOM
    swapClass: function(css1, css2) {
        return this.each(function() {
            jQuery(this).removeClass(css1).addClass(css2);
        })
    },
    //if it takes a long time to load the data, show a loader to ui
    showLoader: function() {
        return this.each(function() {
            switch (jQuery.fn.jerichoTab.loader) {
                case 'usebg':
                    //add a circular loading gif picture to the background of contentholder
                    jQuery(this).addClass('loading');
                    break;
                case 'righttag':
                    //add a small loading gif picture and a banner to the right top corner of contentholder
                    if (jQuery('#jerichotab_contentholder>.righttag').length == 0)
                        jQuery('<div class="righttag">正在加载...</div>').appendTo(jQuery(this));
                    else
                        jQuery('#jerichotab_contentholder>.righttag').css({ display: 'block' });
                    break;
            }
        });
    },
    //remove the loader
    removeLoader: function() {
        switch (jQuery.fn.jerichoTab.loader) {
            case 'usebg':
                jQuery('#jerichotab_contentholder').removeClass('loading');
                break;
            case 'righttag':
                jQuery('#jerichotab_contentholder>.righttag').css({ display: 'none' });
                break;
        }
    }
});
//})(jQuery);

String.prototype.cut = function(len) {
    var position = 0;
    var result = [];
    var tale = '';
    for (var i = 0; i < this.length; i++) {
        if (position >= len) {
            tale = '...';
            break;
        }
        if (this.charCodeAt(i) > 255) {
            position += 2;
            result.push(this.substr(i, 1));
        }
        else {
            position++;
            result.push(this.substr(i, 1));
        }
    }
    return result.join("") + tale;
}

/*
 * 右键菜单，示例：jQuery(this).RightMenu('myMenu2',{menuList:[{menuName:"菜单1",menuclass:"1",clickEvent:"divClick(1)"}]});
 */
jQuery(function(){
	document.oncontextmenu=function(){return false;}//屏蔽右键
	document.onmousemove=mouseMove;//记录鼠标位置
});
var mx=0,my=0;
function mouseMove(ev){Ev=ev||window.event;var mousePos=mouseCoords(Ev);mx=mousePos.x;my=mousePos.y;} 
function mouseCoords(ev){
	if(ev.pageX||ev.pageY){return{x:ev.pageX,y:ev.pageY};}
	return{x:ev.clientX,y:ev.clientY+jQuery(document).scrollTop()};
}
jQuery.fn.extend({RightMenu: function(id,options){
	options = jQuery.extend({menuList:[]},options);
	var menuCount=options.menuList.length;
	if (!jQuery("#"+id)[0]){
		var divMenuList="<div id=\""+id+"\" class=\"div_RightMenu\"><div><ul class='ico'>";
		for(var i=0;i<menuCount;i++){
			divMenuList+="<li class=\""+options.menuList[i].menuclass+"\" onclick=\""+options.menuList[i].clickEvent+"\">"+options.menuList[i].menuName+"</li>";
		}
		divMenuList += "</ul></div><div>";
		jQuery("body").append(divMenuList).find("#"+id).hide().find("li")
				.bind("mouseover",function(){jQuery(this).addClass("RM_mouseover");})
				.bind("mouseout",function(){jQuery(this).removeClass("RM_mouseover");});
		jQuery(document).click(function(){jQuery("#"+id).hide();});
	}
	return this.each(function(){
		this.oncontextmenu=function(){
			var mw=jQuery('body').width(),mhh=jQuery('html').height(),mbh=jQuery('body').height(),
				w=jQuery('#'+id).width(),h=jQuery('#'+id).height(),
				mh=(mhh>mbh)?mhh:mbh;//最大高度 比较html与body的高度
			if(mh<h+my){my=mh-h;}//超 高
			if(mw<w+mx){mx=mw-w;}//超 宽
			jQuery("#"+id).hide().css({top:my,left:mx}).show();
			jQuery.fn.jerichoTab.resize(); // 修正弹出菜单时tab滚动被挤下去的问题
		}
	});
}});