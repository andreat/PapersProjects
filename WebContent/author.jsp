<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"%>
<%
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	String action = request.getParameter("action");
	String author = request.getParameter("author");
	if (action == null) {
		pageContext.forward("authors.jsp");
		return;
	}
	if (action.equals("list_papers")) {
		List<PaperBean> papers = dbms.getPapersFromAuthor(author);
	}
%>
<jsp:include page="WEB-INF/jspf/header.jsp" />
<jsp:include page="WEB-INF/jspf/footer.jsp" />
