<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
	<c:set var="menuList" value="${fns:getMenuList()}" />
	<c:set var="firstMenu" value="true" />
	<div id="menu-${param.parentId}">
	<c:forEach items="${menuList}" var="menu" varStatus="idxStatus">
		<c:if
			test="${menu.parent.id eq (not empty param.parentId ? param.parentId:1)&&menu.isShow eq '1'}">
			<li class="nav-li">			
					<a href="#collapse-${menu.id}"
						title="${menu.remarks}"><i class="nav-ivon ${menu.icon}"></i><span class="nav-text">${menu.name}</span></a><ul class="subnav">
							<c:forEach items="${menuList}" var="menu2">
								<c:if test="${menu2.parent.id eq menu.id&&menu2.isShow eq '1'}">
									<li class="subnav-li" data-id=".menu3-${menu2.id}"
											href="${fn:indexOf(menu2.href, '://') eq -1 ? ctx : ''}${not empty menu2.href ? menu2.href : '/404'}">
										<a data-id=".menu3-${menu2.id}"
											href="${fn:indexOf(menu2.href, '://') eq -1 ? ctx : ''}${not empty menu2.href ? menu2.href : '/404'}"
											target="${not empty menu2.target ? menu2.target : 'mainIframe'}">
											<i class="subnav-icon"></i><span class="subnav-text">${menu2.name}</span>
										</a>
									</li>
									<c:set var="firstMenu" value="false" />
								</c:if>
							</c:forEach>
						</ul>
			</li>
		</c:if>
	</c:forEach>
	</div>