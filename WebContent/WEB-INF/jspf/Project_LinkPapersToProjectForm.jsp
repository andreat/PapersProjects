<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="java.util.List"
%><jsp:include page="header.jsp" />
<% 
	String projectID = request.getParameter(ProjectConstants.Field_ProjectID);
	if (projectID == null) {
%>					<div class="notification_error">
						No project available for the given identifier.
					</div>
<%				
	} else {
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		ProjectBean pb = dbms.getProjectByID(projectID);
		if (pb == null) {
%>					<div class="notification_error">
						No project available for the given identifier.
					</div>
<%				
		} else {
			List<PaperBean> papers = dbms.getPapersNotAcknowledgingProject(projectID);
			if (papers == null) {
%>					<div class="notification_warning">
						No paper available to link to the given project.
					</div>
<%				
			} else {
%>					<form action="${pageContext.request.contextPath}/Projects" method="post">
						<input type="hidden" name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_LinkPapersToProject_Process}"/>
						<input type="hidden" name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
<% 
				for (PaperBean lpb : papers) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<label>
										<input type="checkbox" name="${ProjectConstants.Field_PaperID}" value="<%= lpb.getIdentifier() %>"/>
										<%= lpb.getTitle() %>
									</label>
								</div>
							</div>
<%
				} 
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit" value="Acknowledge project"/>
								</div>
							</div>
						</div>
					</form>
<%
			}
		}
	}
%><jsp:include page="footer.jsp" />