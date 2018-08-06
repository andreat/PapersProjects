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
	DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
	String year_str = request.getParameter(PaperConstants.Field_Year);
	String rank = request.getParameter(PaperConstants.Field_Ranking);
	List<PaperBean> papers = null;
	boolean thrownException = false;
	try {
		int year = Integer.parseInt(year_str);
		papers = dbms.getPapersPublishedInYearWithRank(year, rank);
	} catch (NumberFormatException nfe) {
		thrownException = true;
	}
	if (papers == null) {
		if (thrownException) {
%>					<div class="notification_warning">
						Illegal year <strong><%= year_str %></strong>.
					</div>
<%
		} else {
%>					<div class="notification_error">
						Error with the database during the retrieval of the papers.
					</div>
<%
		}
	} else {
%><jsp:include page="Paper_Selection.jsp" /> 
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
								<c:url value="/Projects" var="listProjects">
									<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_GetProjectsForPaper}"/>
									<c:param name="${ProjectConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
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
%><jsp:include page="footer.jsp" />