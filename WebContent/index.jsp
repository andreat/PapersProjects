<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/jspf/header.jsp" />
				<c:url value="author.jsp" var="papers">
					<c:param name="action" value="list_papers"/>
					<c:param name="author" value="bbb"/>
					<c:param name="test" value="vvv"/>
				</c:url>
				<a href="${papers}">
					List papers
				</a>,

</body>
</html>