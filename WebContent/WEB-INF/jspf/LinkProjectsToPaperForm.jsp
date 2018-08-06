<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.Calendar"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><jsp:include page="header.jsp" /><% 
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	List<PaperBean> papers = null;
	String paperID = request.getParameter(PaperConstants.Field_PaperID);
	if (paperID == null) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
	} else {
		List<PaperBean> lpb = dbms.getPaperByID(paperID);
		PaperBean pb = null;
		if (lpb != null && lpb.size() == 1) {
			pb = lpb.get(0);
		}
		if (pb == null) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
		} else {
			List<ProjectBean> lprojects = dbms.getProjectsNotAcknowledgedByPaper(paperID);
			if (lprojects == null || lprojects.size() == 0) {
%>					<div class="notification_warning">
						No project available to be acknowledged. First create one.
					</div>
<%				
			} else {
%>					<form action="${pageContext.request.contextPath}/Papers" method="post">
						<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_LinkProjectsToPaper_Process}"/>
						<input type="hidden" name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_bloc_column1">
									Paper: <%= pb.getTitle() %>
								</div>
							</div>
<% 
				for (ProjectBean cpb : lprojects) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<label>
										<input type="checkbox" name="${PaperConstants.Field_ProjectID}" value="<%= cpb.getIdentifier() %>"/>
										<%= cpb.getIdentifier() %>: <%= cpb.getTitle() %> (<%= cpb.getFunder() %>)
									</label>
								</div>
							</div>
<%
				} 
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit" value="Acknowledge selected projects"/>
								</div>
							</div>
						</div>
					</form>
<%
			}
		}
	}
%><jsp:include page="footer.jsp" />