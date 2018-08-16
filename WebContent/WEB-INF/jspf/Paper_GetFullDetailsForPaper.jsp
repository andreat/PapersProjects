<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.List"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.JournalBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><jsp:include page="header.jsp" /><% 
	DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
	String paperID = request.getParameter(PaperConstants.Field_PaperID);
	if (paperID == null) {
%>					<div class="notification_error">
						No paper identifier provided.
					</div>
<%				
	} else {
		List<PaperBean> papers = dbms.getPaperByID(paperID);
		if (papers == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the papers.
					</div>
<%
		} else {
			if (papers.size() == 0) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
			} else {
				PaperBean pb = papers.get(0);
				ConferenceBean conference = null;
				if (pb.getCrossref() != null) {
					List<ConferenceBean> conferences = dbms.getConferenceByID(pb.getCrossref());
					if (conferences != null && conferences.size() == 1) {
						conference = conferences.get(0);
					} else {
%>					<div class="notification_error">
						Unexpected error in fetching the conference for the paper.
					</div>
<%
					}
				}
				List<ProjectBean> projects = dbms.getProjectsAcknowledgedByPaper(paperID);
%>					<form action="${pageContext.request.contextPath}/Papers" method="post">
						<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_DelinkProjectsFromPaper_Process}"/>
						<input type="hidden" name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column1 content_block_cell_header">
									Paper details
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Identifier:
								</div>
								<div class="content_block_column2_19_right">
									<%= pb.getIdentifier() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									CCF Ranking:
								</div>
								<div class="content_block_column2_19_right">
									<%= PaperConstants.getRank(pb.getRankingCCF()) %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									CORE Ranking:
								</div>
								<div class="content_block_column2_19_right">
									<%= PaperConstants.getRank(pb.getRankingCORE()) %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Authors:
								</div>
								<div class="content_block_column2_19_right">
<%
	List<AuthorBean> authors = pb.getAuthors();
		int nAuthors = authors.size();
		int curAuthor = 0;
		StringBuilder sb = new StringBuilder();
		for (AuthorBean ab : authors) {
			curAuthor++;
			sb.append(ab.getIdentifier());
			if (curAuthor != nAuthors && !(curAuthor == 1 && nAuthors == 2)) {
				sb.append(", ");
			}
			if (curAuthor == nAuthors - 1) {
				sb.append(" and ");
			}
		}
%>									<%=sb.toString()%>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Corresponding:
								</div>
								<div class="content_block_column2_19_right">
<%
	curAuthor = 0;
		sb = new StringBuilder();
		for (AuthorBean ab : authors) {
			if (ab.isCorresponding()) {
				if (curAuthor > 0) {
					sb.append(", ");
				}
				sb.append(ab.getIdentifier());
				curAuthor++;
			}
		}
		if (curAuthor == 0) {
			sb.append("No corresponding author");
		}
%>									<%= sb.toString() %>
								</div>
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
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Book title:
								</div>
								<div class="content_block_column2_19_right">
									<%= pb.getBooktitle() %>
								</div>
							</div>
<% 
				}
				if (pb.getYear() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Year:
								</div>
								<div class="content_block_column2_19_right">
									<%= pb.getYear() %>
								</div>
							</div>
<% 
				}
				JournalBean jb = pb.getJournal();
				if (jb != null) {
					sb = new StringBuilder(jb.getIdentifier());
					if (pb.getVolume() != null) {
						sb.append(" ").append(pb.getVolume());
					}
					if (pb.getNumber() != null) {
						sb.append(" (").append(pb.getNumber()).append(")");
					}
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Journal:
								</div>
								<div class="content_block_column2_19_right">
									<%= sb.toString() %>
								</div>
							</div>
<% 
				}
				if (pb.getCrossref() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Crossref:
								</div>
								<div class="content_block_column2_19_right">
									<%= pb.getCrossref() %>
								</div>
							</div>
<% 
				}
				if (pb.getPages() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Pages:
								</div>
								<div class="content_block_column2_19_right">
									<%= pb.getPages() %>
								</div>
							</div>
<% 
				}
				if (pb.getDoi() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									DOI:
								</div>
								<div class="content_block_column2_19_right">
									<%= pb.getDoi() %>
								</div>
							</div>
<% 
				}
				if (pb.getUrl() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									URL:
								</div>
								<div class="content_block_column2_19_right">
									<a href="<%= pb.getUrl() %>" target="_blank"><%= pb.getUrl() %></a>
								</div>
							</div>
<% 
				}
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Actions:
								</div>
								<div class="content_block_column2_19_right">
									<c:url value="/Projects" var="listProjects">
										<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_GetProjectsForPaper}"/>
										<c:param name="${ProjectConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${listProjects}">List acknowledged projects</a>,
									<c:url value="/Paper" var="linkProjects">
										<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_LinkProjectsToPaper_Form}"/>
										<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${linkProjects}">Link projects</a>,
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
				if (conference != null) {
%>							<div class="content_block_row">
								<div class="content_block_column1 content_block_cell_header">
									Conference details
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Identifier:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getIdentifier() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Title:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getTitle() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Year:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getYear() %>
								</div>
							</div>
<% 
					if (conference.getSeries() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Series:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getSeries() %>
								</div>
							</div>
<% 
					}
					if (conference.getVolume() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Volume:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getVolume() %>
								</div>
							</div>
<% 
					}
					if (conference.getEditor() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Editor(s):
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getEditor() %>
								</div>
							</div>
<% 
					}
					if (conference.getPublisher() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Publisher:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getPublisher() %>
								</div>
							</div>
<% 
					}
					if (conference.getUrl() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									URL:
								</div>
								<div class="content_block_column2_19_right">
									<a href="<%= conference.getUrl() %>" target="_blank"><%= conference.getUrl() %></a>
								</div>
							</div>
<% 
					}
					if (conference.getIsbn() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									ISBN:
								</div>
								<div class="content_block_column2_19_right">
									<%= conference.getIsbn() %>
								</div>
							</div>
<% 
					}
				}
				if (pb.getFilepath() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Paper:
								</div>
								<div class="content_block_column2_19_right">
									<c:url value="/Papers" var="paperpdf">
										<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_DownloadPDF}"/>
										<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${paperpdf}">PDF</a>
								</div>
							</div>
<%
				}
				if (projects == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the projects.
					</div>
<%
				} else {
%>							<div class="content_block_row">
								<div class="content_block_column1 content_block_cell_header">
									Project details
								</div>
							</div>
<%
					if (projects.size() == 0) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<c:url value="/Papers" var="linkProjects">
										<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_LinkProjectsToPaper_Form}"/>
										<c:param name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url>No project linked to this paper. <a href="${linkProjects}">Link projects to this paper</a>
								</div>
							</div>
<% 
					} else {
						for (ProjectBean pjb : projects) {
%>							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									<label>
										<input type="checkbox" name="${PaperConstants.Field_ProjectID}" value="<%= pjb.getIdentifier() %>"/>
										<%= pjb.getIdentifier() %>
									</label>
								</div>
								<div class="content_block_column2_28_right">
									<div class="content_block_table">
<%
							if (pjb.getTitle() != null) {
%>										<div class="content_block_row">
											<div class="content_block_column2_28_left">
												Title:
											</div>
											<div class="content_block_column2_28_right">
												<%= pjb.getTitle() %>
											</div>
										</div>
<% 
							}
%>										<div class="content_block_row">
											<div class="content_block_column2_28_left">
												Funder:
											</div>
											<div class="content_block_column2_28_right">
												<%= pjb.getFunder() %>
											</div>
										</div>
										<div class="content_block_row">
											<div class="content_block_column2_28_left">
												Acknowledge:
											</div>
											<div class="content_block_column2_28_right">
												<%= pjb.getAcknowledge() %>
											</div>
										</div>
										<div class="content_block_row">
											<div class="content_block_column2_28_left">
												Start date:
											</div>
											<div class="content_block_column2_28_right">
												<%= pjb.getStartDate() %>
											</div>
										</div>
										<div class="content_block_row">
											<div class="content_block_column2_28_left">
												End date:
											</div>
											<div class="content_block_column2_28_right">
												<%= pjb.getEndDate() %>
											</div>
										</div>
									</div>
								</div>
							</div>
<% 
						}
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit" value="De-acknowledge selected projects"/>
								</div>
							</div>
<%
					}
				}
%>						</div>
					</form>
<%
			}
		}
	}
%><jsp:include page="footer.jsp" />