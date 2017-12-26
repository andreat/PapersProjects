<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.action.PaperAction"%>
<%@page import="java.util.List"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus"%>
<jsp:include page="WEB-INF/jspf/header.jsp" />
<%
	DBMSStatus statusPaper = (DBMSStatus) request.getAttribute("paperStatus");
	if (statusPaper != null) {
		switch (statusPaper) {
		case Success:
%>		
		<div class="notification_success">
			Paper stored correctly.
		</div>	
<%
			break;
		case DuplicatedEntry:
%>		
		<div class="notification_error">
			Paper already present in the database.
		</div>	
<%
			break;
		case SQLFailed:
%>		
		<div class="notification_success">
			Error with the database during the insertion of the paper.
		</div>	
<%
			break;
		default:
		}
	}
	DBMSStatus statusConference = (DBMSStatus) request.getAttribute("paperConference");
	if (statusConference != null) {
		switch (statusConference) {
		case Success:
%>		
		<div class="notification_success">
			Conference stored correctly.
		</div>	
<%
			break;
		case DuplicatedEntry:
%>		
		<div class="notification_error">
			Conference already present in the database.
		</div>	
<%
			break;
		case SQLFailed:
%>		
		<div class="notification_success">
			Error with the database during the insertion of the conference.
		</div>	
<%
			break;
		default:
		}
	}
	String action = request.getParameter("action");
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	List<PaperBean> papers;
	if (action == null) {
		papers = dbms.getPapers();
	} else {
		switch (action) {
		case PaperAction.getPapersForAuthor:
			String author = request.getParameter("author");
			papers = dbms.getPapersFromAuthor(author);
			break;
		case PaperAction.getPapersForYear:
			int year = Integer.parseInt(request.getParameter("year"));
			papers = dbms.getPapersFromYear(year);
			break;
		case PaperAction.getPapersForProject:
			String project = request.getParameter("project");
			papers = dbms.getPapersFromProject(project);
			break;
		default:
			papers = dbms.getPapers();
		}
	}
	if (papers == null) {
		%>		
		<div class="notification_success">
			Error with the database during the retrieval of the papers.
		</div>	
<%
	} else {
%>
		<div class="global_command">
			<div class="global_command_entry">
				<c:url value="author.jsp" var="papers">
					<c:param name="action" value="list_papers"/>
					<c:param name="author" value="bbb"/>
				</c:url>
				<a href="${papers}">
					List papers
				</a>,
				<a href="paper.jsp?action=<%= PaperAction.createInproceedings %>">
					Add conference paper
				</a>
			</div>
			<div class="global_command_entry">
				<a href="paper.jsp?action=<%= PaperAction.createArticle %>">
					Add journal paper
				</a>
			</div>
		</div>
		<table>
			<tr>
				<th>
					Paper
				</th>
				<th>
					Actions
				</th>
			</tr>
<%
		for (PaperBean paper : papers) {
%>
			<tr>
				<td>
					
				</td>
				<td>
					<c:url value="paper.jsp" var="papers">
						<c:param name="action" value="list_papers"/>
						<c:param name="author" value="${author.getName()}"/>
					</c:url>
					<a href="${papers}">
						List papers
					</a>,
					<c:url value="paper.jsp" var="projects">
						<c:param name="action" value="list_projects"/>
						<c:param name="author" value="${author.getName()}"/>
					</c:url>
					<a href="${projecs}">
						List projects
					</a>
				</td>
			</tr>
<%
		}
	}
%>
		</table>
<jsp:include page="WEB-INF/jspf/footer.jsp" />
