<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.action.PaperAction"%>
<%@page import="java.util.List"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"%>
<%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"%>
<%
	String action = request.getParameter("action");
	if (action == null) {
		pageContext.forward("papers.jsp");
		return;		
	}
	switch (action) {
	case PaperAction.createInproceedings:
		break;
	case PaperAction.createArticle:
		break;
	default:
		pageContext.forward("papers.jsp");
		return;		
	}
%>
<jsp:include page="WEB-INF/jspf/header.jsp" />
<jsp:include page="WEB-INF/jspf/footer.jsp" />
