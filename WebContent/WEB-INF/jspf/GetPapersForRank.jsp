<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><jsp:include page="header.jsp" /><% 
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	String rank = request.getParameter(PaperConstants.Field_Ranking);
	if (rank == null) {
%>					<div class="notification_error">
						Undefined ranking.
					</div>
<%
	} else {
		List<PaperBean> papers = null;
		papers = dbms.getPapersByRank(rank);
		if (papers == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the papers.
					</div>
<%
		} else { 
			if (papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available with rank <strong><%= PaperConstants.getRank(rank) %></strong>.
					</div>
<%
			} else {
%><jsp:include page="paperSelection.jsp" /> 
					<div class="content_block_table">
						<div class="content_block_row">
							<div class="content_block_column2_64_left content_block_cell_header">
								Paper
							</div>
							<div class="content_block_column2_64_right content_block_cell_header">
								Actions
							</div>
						</div>
<%
				for (PaperBean pb : papers) {
%>						<div class="content_block_row">
							<div class="content_block_column2_64_left">
								<c:url value="/Papers" var="paperfull">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetFullDetailsForPaper}"/>
									<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${paperfull}"><%= pb.getTitle() %></a> (<%= pb.getYear() %>, <%= PaperConstants.getRank(pb.getRanking()) %><% 
					if (pb.getFilepath() != null) {
						%><c:url value="/Papers" var="paperpdf">
							<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_DownloadPDF}"/>
							<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
						</c:url>, <a href="${paperpdf}">PDF</a><%
					}
								%>)
							</div>
							<div class="content_block_column2_64_right">
								<c:url value="/projects.jsp" var="listProjects">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetProjectsForPaper}"/>
									<c:param name="${ProjectConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${listProjects}">List acknowledged projects</a>,
								<c:url value="/Papers" var="linkProjects">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_LinkProjectsToPaper_Form}"/>
									<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${linkProjects}">Acknowledge projects</a>,
								<c:url value="/Papers" var="modifypaper">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_ModifyPaper_Form}"/>
									<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${modifypaper}">Update paper</a>,
								<c:url value="/Papers" var="deletepaper">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_DeletePaper_Form}"/>
									<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${deletepaper}">Delete paper</a>
							</div>
						</div>
<%
				}
%>					</div>
<%		
			}
		}
	}
%><jsp:include page="footer.jsp" />