<%@page contentType="text/html" pageEncoding="UTF-8"
%><%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><jsp:include page="WEB-INF/jspf/header.jsp" /><%
%>					<div class="content_block_table">
						<div class="content_block_row">
							<div class="content_block_column2_28_left">
								Author
							</div>
							<div class="content_block_column2_28_right">
								Actions
							</div>
						</div>
<%
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	for (AuthorBean ab : dbms.getAuthors()) {
%>						<div class="content_block_row">
							<div class="content_block_column2_28_left">
								<%= ab.getName() %>
							</div>
							<div class="content_block_column2_28_right">
								<c:url value="/papers.jsp" var="papers">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.GetPapersForAuthor}"/>
									<c:param name="${PaperConstants.Author}" value="<%= ab.getName() %>"/>
								</c:url><a href="${papers}">List papers</a>,
								<c:url value="/projects.jsp" var="projects">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetProjectsForAuthor}"/>
									<c:param name="${ProjectConstants.Author}" value="<%= ab.getName() %>"/>
								</c:url><a href="${projects}">List projects</a>
							</div>
						</div>
<%
	}
%>					</div>
<jsp:include page="WEB-INF/jspf/footer.jsp" />