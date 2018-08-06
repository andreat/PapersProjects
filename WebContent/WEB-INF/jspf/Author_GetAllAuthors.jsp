<%@page contentType="text/html" pageEncoding="UTF-8"
%><%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="java.util.List"
%><jsp:include page="header.jsp" /><%
	DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
	List<AuthorBean> authors = dbms.getAuthors();
	if (authors == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the authors.
					</div>
<%
	} else {
		if (authors.size() == 0) {
%>					<div class="notification_warning">
						No author available. First create a paper.
					</div>
<%
		} else {
%>					<div class="content_block_table">
						<div class="content_block_row">
							<div class="content_block_column2_28_left content_block_cell_header">
								Author
							</div>
							<div class="content_block_column2_28_right content_block_cell_header">
								Actions
							</div>
						</div>
<%
			for (AuthorBean ab : authors) {
%>						<div class="content_block_row">
							<div class="content_block_column2_28_left">
								<%= ab.getName() %>
							</div>
							<div class="content_block_column2_28_right">
								<c:url value="/Papers" var="papers">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetPapersForAuthor}"/>
									<c:param name="${PaperConstants.Field_AuthorID}" value="<%= ab.getName() %>"/>
								</c:url><a href="${papers}">List papers</a>,
								<c:url value="/Projects" var="projects">
									<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_GetProjectsForAuthor}"/>
									<c:param name="${ProjectConstants.Field_AuthorID}" value="<%= ab.getName() %>"/>
								</c:url><a href="${projects}">List projects</a>
							</div>
						</div>
<%
			}
%>					</div>
<%
		}
	}
%><jsp:include page="footer.jsp" />