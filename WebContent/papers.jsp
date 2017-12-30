<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.constant.InternalOperationConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><jsp:include page="WEB-INF/jspf/header.jsp" /><% 
	Object statusOperation = request.getAttribute(InternalOperationConstants.StatusOperation);
	String action = request.getParameter(PaperConstants.Action);
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	List<PaperBean> papers = null;
	ProjectBean project = null;
	AuthorBean author = null;
	if (statusOperation != null || action == null) {
		papers = dbms.getPapers();
	} else {
		switch (action) {
		case PaperConstants.CreateInproceedings: {
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post" enctype="multipart/form-data">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.CreateInproceedings}"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper (inproceedings) entry:
								</div>
								<div class="content_block_column2_28_right">
									<textarea name="${PaperConstants.InproceedingsTextArea}" rows="10" cols="100"></textarea>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Conference (proceedings) entry:
								</div>
								<div class="content_block_column2_28_right">
									<textarea name="${PaperConstants.ProceedingsTextArea}" rows="10" cols="100"></textarea>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper file:
								</div>
								<div class="content_block_column2_28_right">
									<input name="${PaperConstants.PaperFile}" type="file"/>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="WEB-INF/jspf/footer.jsp" />
<% 		
			return;
		}
		case PaperConstants.CreateArticle: {
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post" enctype="multipart/form-data">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.CreateArticle}"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper (article) entry:
								</div>
								<div class="content_block_column2_28_right">
									<textarea name="${PaperConstants.ArticleTextArea}" rows="10" cols="100"></textarea>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper file:
								</div>
								<div class="content_block_column2_28_right">
									<input name="${PaperConstants.PaperFile}" type="file"/>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="WEB-INF/jspf/footer.jsp" />
<%
			return;
		}
		case PaperConstants.LinkProjectsToPaper: {
			String paperID = request.getParameter(PaperConstants.PaperID);
			if (paperID == null) {
				papers = dbms.getPapers();
				break;		
			}
			PaperBean pb = dbms.getPaperByID(paperID);
			if (pb == null) {
				papers = dbms.getPapers();
				break;		
			}
			List<ProjectBean> projects = dbms.getProjectsNotAcknowledgedByPaper(paperID);
			if (projects == null) {
				papers = dbms.getPapers();
				break;		
			}
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
<% 
			for (ProjectBean lpb : projects) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="checkbox" name="${PaperConstants.PaperID}" value="<%= lpb.getIdentifier() %>"/>
									<%= lpb.getIdentifier() %>: <%= lpb.getTitle() %> (<%= lpb.getFunder() %>)
								</div>
							</div>
<%
			} 
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="WEB-INF/jspf/footer.jsp" /><%
			return;
		}
		case PaperConstants.UploadPDF: {
			String paperID = request.getParameter(PaperConstants.PaperID);
			if (paperID == null) {
				papers = dbms.getPapers();
				break;		
			}
			PaperBean pb = dbms.getPaperByID(paperID);
			if (pb == null) {
				papers = dbms.getPapers();
				break;		
			}
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post" enctype="multipart/form-data">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.UploadPDF}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getTitle() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper file:
								</div>
								<div class="content_block_column2_28_right">
									<input name="${PaperConstants.PaperFile}" type="file"/>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="WEB-INF/jspf/footer.jsp" />
<% 		
					return;
				}
		case PaperConstants.GetPapersForAuthor:
			String authorID = request.getParameter(PaperConstants.Author);
			if (authorID == null) {
				papers = dbms.getPapers();
			} else {
				author = dbms.getAuthorByID(authorID);
				if (author != null) {
					papers = dbms.getPapersWrittenByAuthor(authorID);
				}
			}
			break;
		case PaperConstants.GetPapersForYear:
			try {
				int year = Integer.parseInt(request.getParameter(PaperConstants.Year));
				papers = dbms.getPapersPublishedInYear(year);
			} catch (NumberFormatException nfe) {
				papers = dbms.getPapers();
			}
			break;
		case PaperConstants.GetPapersForProject:
			String projectID = request.getParameter(PaperConstants.ProjectID);
			if (projectID == null) {
				papers = dbms.getPapers();
			} else {
				project = dbms.getProjectByID(projectID);
				if (project != null) {
					papers = dbms.getPapersAcknowledgingProject(projectID);
				}
			}
			break;
		default:
			papers = dbms.getPapers();
		}
	}
	if (papers == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the papers.
					</div>
<%
	} else {
%>					<div class="content_block_table">
<%
		if (project != null) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								Project: <%= project.getIdentifier() %>: <%= project.getTitle() %> (<%= project.getFunder() %>)
							</div>
						</div>
<% 		
		}
		if (author != null) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								Author: <%= author.getName() %>
							</div>
						</div>
<% 		
		}
%>						<div class="content_block_row">
							<div class="content_block_column2_73_left">
								Paper
							</div>
							<div class="content_block_column2_73_right">
								Actions
							</div>
						</div>
<%
		for (PaperBean pb : papers) {
%>						<div class="content_block_row">
							<div class="content_block_column2_73_left">
								<%= pb.getTitle() %>
							</div>
							<div class="content_block_column2_73_right">
<%
			if (pb.getFilepath() != null) {
%>								<c:url value="/PaperManager" var="paperpdf">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.DownloadPDF}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${paperpdf}">Download PDF</a>,
<%
			} else {
%>								<c:url value="/papers.jsp" var="paperupload">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.UploadPDF}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${paperupload}">Upload PDF</a>,
<%
			}
%>								<c:url value="/projects.jsp" var="listProjects">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetProjectsForPaper}"/>
									<c:param name="${ProjectConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${listProjects}">List projects</a>,
								<c:url value="/papers.jsp" var="linkProjects">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${linkProjects}">Link projects to this paper</a>
							</div>
						</div>
<%
		}
	}
	%>				</div>
<jsp:include page="WEB-INF/jspf/footer.jsp" />