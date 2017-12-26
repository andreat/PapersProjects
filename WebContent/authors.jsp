<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"%>
<jsp:include page="WEB-INF/jspf/header.jsp" />
		<table>
			<tr>
				<th>
					Author
				</th>
				<th>
					Actions
				</th>
			</tr>
<%
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	for (AuthorBean author : dbms.getAuthors()) {
%>
			<tr>
				<td>
					
				</td>
				<td>
					<c:url value="author.jsp" var="papers">
						<c:param name="action" value="list_papers"/>
						<c:param name="author" value="${author.getName()}"/>
					</c:url>
					<a href="${papers}">
						List papers
					</a>,
					<c:url value="author.jsp" var="projects">
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
%>
		</table>
<jsp:include page="WEB-INF/jspf/footer.jsp" />
