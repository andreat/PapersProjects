<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.JournalBean"
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
	List<ProjectBean> projects = null;
	ProjectBean project = null;
	AuthorBean author = null;
	boolean useFullDetails = false; 
	if (statusOperation != null || action == null) {
		papers = dbms.getPapers();
		if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
		}
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
									LaTeX markers:
								</div>
								<div class="content_block_column2_28_right">
									<label>
										<input type="checkbox" name="${PaperConstants.RemoveLaTeXMarkers}"/>
										Convert markers to plain text (experimental)
									</label>
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
									LaTeX markers:
								</div>
								<div class="content_block_column2_28_right">
									<label>
										<input type="checkbox" name="${PaperConstants.RemoveLaTeXMarkers}"/>
										Convert markers to plain text (experimental)
									</label>
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
			List<PaperBean> lpb = dbms.getPaperByID(paperID);
			PaperBean pb = null;
			if (lpb != null && lpb.size() == 1) {
				pb = lpb.get(0);
			}
			if (pb == null) {
				papers = dbms.getPapers();
				break;		
			}
			List<ProjectBean> lprojects = dbms.getProjectsNotAcknowledgedByPaper(paperID);
			if (lprojects == null) {
				papers = dbms.getPapers();
				break;		
			}
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
<% 
			for (ProjectBean cpb : lprojects) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<label>
										<input type="checkbox" name="${PaperConstants.PaperID}" value="<%= cpb.getIdentifier() %>"/>
										<%= cpb.getIdentifier() %>: <%= cpb.getTitle() %> (<%= cpb.getFunder() %>)
									</label>
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
			List<PaperBean> lpb = dbms.getPaperByID(paperID);
			PaperBean pb = null;
			if (lpb != null && lpb.size() == 1) {
				pb = lpb.get(0);
			}
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
		case PaperConstants.GetFullDetailsForPaper : {
			String paperID = request.getParameter(PaperConstants.PaperID);
			if (paperID == null) {
				papers = dbms.getPapers();
				if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
				}
				break;
			}
			papers = dbms.getPaperByID(paperID);
			if (papers == null || papers.size() == 0) {
				papers = dbms.getPapers();
				if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
				}
				break;
			}
			projects = dbms.getProjectsAcknowledgedByPaper(paperID);
			useFullDetails = true;
			break;
		}
		case PaperConstants.GetPapersForAuthor: {
			String authorID = request.getParameter(PaperConstants.AuthorID);
			if (authorID == null) {
				papers = dbms.getPapers();
				if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
				}
			} else {
				author = dbms.getAuthorByID(authorID);
				if (author != null) {
					papers = dbms.getPapersWrittenByAuthor(authorID);
				}
				if (author == null || (papers != null && papers.size() == 0)) {
%>					<div class="notification_warning">
						No paper available for the author <%= authorID %>. First create one.
					</div>
<%
				}
			}
			break;
		}
		case PaperConstants.GetPapersForYear: {
			try {
				int year = Integer.parseInt(request.getParameter(PaperConstants.Year));
				papers = dbms.getPapersPublishedInYear(year);
				if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available for the year <%= year %>. First create one.
					</div>
<%
				}
			} catch (NumberFormatException nfe) {
				papers = dbms.getPapers();
				if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
				}
			}
			break;
		}
		case PaperConstants.GetPapersForProject: {
			String projectID = request.getParameter(PaperConstants.ProjectID);
			if (projectID == null) {
				papers = dbms.getPapers();
				if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
				}
			} else {
				project = dbms.getProjectByID(projectID);
				if (project != null) {
					papers = dbms.getPapersAcknowledgingProject(projectID);
					if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper acknowledging the project. First link one.
					</div>
<%
					}
				}
			}
			break;
		}
		default:
			papers = dbms.getPapers();
			if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
			}
		}
	}
	if (papers == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the papers.
					</div>
<%
	} else {
		if (papers.size() > 0) {
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
			if (useFullDetails) {
				PaperBean pb = papers.get(0);
%>						<div class="content_block_row">
							<div class="content_block_column2_19_left">
								Authors:
							</div>
							<div class="content_block_column2_19_right">
<%
				List<AuthorBean> authors = pb.getAuthors();
				int nAuthors = authors.size();
				int curAuthor = 0;
				for (AuthorBean ab : authors) {
					curAuthor++;
					StringBuilder sb = new StringBuilder(ab.getName());
					if (curAuthor != nAuthors && !(curAuthor == 1 && nAuthors == 2)) {
						sb.append(",");
					}
					if (curAuthor == nAuthors - 1) {
						sb.append(" and");
					}
%>								<%= sb.toString() %>
<%
				}
%>							</div>
						</div>
						<div class="content_block_row">
							<div class="content_block_column2_19_left">
								Title:
							</div>
							<div class="content_block_column2_19_right">
								<%= pb.getTitle() %>
							</div>
						</div>
<%
				if (pb.getBooktitle() != null) {
%>						<div class="content_block_row">
							<div class="content_block_column2_19_left">
								Book title:
							</div>
							<div class="content_block_column2_19_right">
								<%= pb.getBooktitle() %>
							</div>
						</div>
<% 
				}
				JournalBean jb = pb.getJournal();
				if (jb != null) {
					StringBuilder sb = new StringBuilder(jb.getIdentifier());
					if (pb.getVolume() != null) {
						sb.append(" ").append(pb.getVolume());
					}
					if (pb.getNumber() != null) {
						sb.append(" (").append(pb.getNumber()).append(")");
					}
%>						<div class="content_block_row">
							<div class="content_block_column2_19_left">
								Journal:
							</div>
							<div class="content_block_column2_19_right">
								<%= sb.toString() %>
							</div>
						</div>
<% 
				}
			} else {
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
								<c:url value="/papers.jsp" var="paperfull">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.GetFullDetailsForPaper}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${paperfull}"><%= pb.getTitle() %></a>
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
%>					</div>
<%
		}
	}
%>				
<jsp:include page="WEB-INF/jspf/footer.jsp" />