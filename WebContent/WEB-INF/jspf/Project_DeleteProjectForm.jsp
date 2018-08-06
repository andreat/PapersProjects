<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
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
%>					<form action="${pageContext.request.contextPath}/Projects" method="post">
						<input type="hidden" name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_DeleteProject_Process}"/>
						<input type="hidden" name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column1">
									Do you really want to <strong>delete</strong> the following project?
									The operation can not be reverted and all papers will not acknowledge this project anymore.
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project identifier:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getIdentifier() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project title:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getTitle() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project funder:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getFunder() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project acknowledge:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getAcknowledge() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project start date:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getStartDate() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project end date:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getEndDate() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit" value="Yes, delete this project"/>
								</div>
							</div>
						</div>
					</form>
<%
		}
	}
%><jsp:include page="footer.jsp" />