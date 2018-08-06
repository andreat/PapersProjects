<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="java.util.List"
%><jsp:include page="header.jsp" /><% 
	String year_str = request.getParameter(ProjectConstants.Field_Year);
	DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
	List<ProjectBean> projects = null;
	boolean thrownException = false;
	try {
		int year = Integer.parseInt(year_str);
		projects = dbms.getProjectsAcknowledgedInYear(year);
	} catch (NumberFormatException nfe) {
		thrownException = true;
	}
	if (projects == null) {
		if (thrownException) {
%>					<div class="notification_warning">
						Illegal year <strong><%= year_str %></strong>.
					</div>
<%
		} else {
%>					<div class="notification_error">
						Error with the database during the retrieval of the projects.
					</div>
<%
		}
	} else {
		if (projects.size() == 0) {
%>					<div class="notification_warning">
						No project acknowledged by a paper written by the author.
					</div>
<%
		} else {
%>					<div class="content_block_table">
						<div class="content_block_row">
							<div class="content_block_column2_37_left content_block_cell_header">
								Project
							</div>
							<div class="content_block_column2_37_right content_block_cell_header">
								Actions
							</div>
						</div>
<%
			for (ProjectBean pb : projects) {
%>						<div class="content_block_row">
							<div class="content_block_column2_37_left">
								<c:url value="/Projects" var="projectfull">
									<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_GetFullDetailsForProject}"/>
									<c:param name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${projectfull}"><%= pb.getIdentifier() %>: <%= pb.getTitle() %> (<%= pb.getFunder() %>)</a>
							</div>
							<div class="content_block_column2_37_right">
								<c:url value="/Papers" var="listPapers">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetPapersForProject}"/>
									<c:param name="${PaperConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${listPapers}">List acknowledging papers</a>,
								<c:url value="/Projects" var="linkPapers">
									<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_LinkPapersToProject_Form}"/>
									<c:param name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${linkPapers}">Add acknowledging papers</a>,
								<c:url value="/Projects" var="modifyProject">
									<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_ModifyProject_Form}"/>
									<c:param name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${modifyProject}">Modify project</a>,
								<c:url value="/Projects" var="deleteProject">
									<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_DeleteProject_Form}"/>
									<c:param name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${deleteProject}">Delete project</a>
							</div>
						</div>
<% 
			}
%>					</div>
<%
		}
	}
%><jsp:include page="footer.jsp" />