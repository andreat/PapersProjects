<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.Calendar"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean"
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
	ConferenceBean conference = null;
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
								<div class="content_block_column1">
									The BibTeX entries must be in the format produced by <a href="http://dblp.uni-trier.de/" target="_blank">DBLP</a>. Other formats are <strong>not</strong> supported. 
								</div>
							</div>
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
									Ranking:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${PaperConstants.RankingOption}">
										<option value="${PaperConstants.RankingNotRanked}" selected><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
										<option value="${PaperConstants.RankingA}"><%= PaperConstants.getRank(PaperConstants.RankingA) %></option>
										<option value="${PaperConstants.RankingB}"><%= PaperConstants.getRank(PaperConstants.RankingB) %></option>
										<option value="${PaperConstants.RankingC}"><%= PaperConstants.getRank(PaperConstants.RankingC) %></option>
									</select>
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
									<input type="submit" value="Create conference paper"/>
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
								<div class="content_block_column1">
									The BibTeX entry must be in the format produced by <a href="http://dblp.uni-trier.de/" target="_blank">DBLP</a>. Other formats are <strong>not</strong> supported. 
								</div>
							</div>
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
									Ranking:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${PaperConstants.RankingOption}">
										<option value="${PaperConstants.RankingNotRanked}" selected><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
										<option value="${PaperConstants.RankingA}"><%= PaperConstants.getRank(PaperConstants.RankingA) %></option>
										<option value="${PaperConstants.RankingB}"><%= PaperConstants.getRank(PaperConstants.RankingB) %></option>
										<option value="${PaperConstants.RankingC}"><%= PaperConstants.getRank(PaperConstants.RankingC) %></option>
									</select>
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
									<input type="submit" value="Create article"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="WEB-INF/jspf/footer.jsp" />
<%
			return;
		}
		case PaperConstants.ModifyPaper: {
			String paperID = request.getParameter(PaperConstants.PaperID);
			if (paperID == null) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
			} else {
				List<PaperBean> lpb = dbms.getPaperByID(paperID);
				if (lpb == null || lpb.size() == 0) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
				} else {
					PaperBean pb = lpb.get(0);
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post" enctype="multipart/form-data">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.ModifyPaper}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
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
									Ranking:
								</div>
								<div class="content_block_column2_19_right">
									<select name="${PaperConstants.RankingOption}">
										<option value="${PaperConstants.RankingNotRanked}"<%= PaperConstants.RankingNotRanked.equals(pb.getRanking()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
										<option value="${PaperConstants.RankingA}"<%= PaperConstants.RankingA.equals(pb.getRanking()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingA) %></option>
										<option value="${PaperConstants.RankingB}"<%= PaperConstants.RankingB.equals(pb.getRanking()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingB) %></option>
										<option value="${PaperConstants.RankingC}"<%= PaperConstants.RankingC.equals(pb.getRanking()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingC) %></option>
									</select>
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
					for (AuthorBean ab : authors) {
						curAuthor++;
						StringBuilder sb = new StringBuilder(ab.getName());
						if (curAuthor != nAuthors && !(curAuthor == 1 && nAuthors == 2)) {
							sb.append(",");
						}
						if (curAuthor == nAuthors - 1) {
							sb.append(" and");
						}
%>									<%= sb.toString() %>
<%
					}
%>								</div>
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
						StringBuilder sb = new StringBuilder(jb.getIdentifier());
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
					ConferenceBean cb = pb.getConference();
					if (cb != null) {
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
									<%= cb.getIdentifier() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Title:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getTitle() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Year:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getYear() %>
								</div>
							</div>
<% 
						if (cb.getSeries() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Series:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getSeries() %>
								</div>
							</div>
<% 
						}
						if (cb.getVolume() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Volume:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getVolume() %>
								</div>
							</div>
<% 
						}
						if (cb.getEditor() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Editor(s):
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getEditor() %>
								</div>
							</div>
<% 
						}
						if (cb.getPublisher() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Publisher:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getPublisher() %>
								</div>
							</div>
<% 
						}
						if (cb.getUrl() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									URL:
								</div>
								<div class="content_block_column2_19_right">
									<a href="<%= cb.getUrl() %>" target="_blank"><%= cb.getUrl() %></a>
								</div>
							</div>
<% 
						}
						if (cb.getIsbn() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									ISBN:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getIsbn() %>
								</div>
							</div>
<% 
						}
					}
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Paper file:
								</div>
								<div class="content_block_column2_19_right">
									<input name="${PaperConstants.PaperFile}" type="file"/>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left"></div>
								<div class="content_block_column2_19_right">
									<input type="submit" value="Modify this paper"/>
								</div>
							</div>
						</div>
					</form>
<%
				}
			}
%><jsp:include page="WEB-INF/jspf/footer.jsp" /><%
			return;
			
		}
		case PaperConstants.DeletePaperConfirm: {
			String paperID = request.getParameter(PaperConstants.PaperID);
			if (paperID == null) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
			} else {
				List<PaperBean> lpb = dbms.getPaperByID(paperID);
				if (lpb == null || lpb.size() == 0) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
				} else {
					PaperBean pb = lpb.get(0);
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.DeletePaper}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column1">
									Do you really want to <strong>delete</strong> the following paper?
									The operation can not be reverted.
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
									Ranking:
								</div>
								<div class="content_block_column2_19_right">
									<%= PaperConstants.getRank(pb.getRanking()) %>
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
					for (AuthorBean ab : authors) {
						curAuthor++;
						StringBuilder sb = new StringBuilder(ab.getName());
						if (curAuthor != nAuthors && !(curAuthor == 1 && nAuthors == 2)) {
							sb.append(",");
						}
						if (curAuthor == nAuthors - 1) {
							sb.append(" and");
						}
%>									<%= sb.toString() %>
<%
					}
%>								</div>
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
						StringBuilder sb = new StringBuilder(jb.getIdentifier());
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
					ConferenceBean cb = pb.getConference();
					if (cb != null) {
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
									<%= cb.getIdentifier() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Title:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getTitle() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Year:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getYear() %>
								</div>
							</div>
<% 
						if (cb.getSeries() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Series:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getSeries() %>
								</div>
							</div>
<% 
						}
						if (cb.getVolume() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Volume:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getVolume() %>
								</div>
							</div>
<% 
						}
						if (cb.getEditor() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Editor(s):
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getEditor() %>
								</div>
							</div>
<% 
						}
						if (cb.getPublisher() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									Publisher:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getPublisher() %>
								</div>
							</div>
<% 
						}
						if (cb.getUrl() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									URL:
								</div>
								<div class="content_block_column2_19_right">
									<a href="<%= cb.getUrl() %>" target="_blank"><%= cb.getUrl() %></a>
								</div>
							</div>
<% 
						}
						if (cb.getIsbn() != null) {
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left">
									ISBN:
								</div>
								<div class="content_block_column2_19_right">
									<%= cb.getIsbn() %>
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
									<c:url value="/PaperManager" var="paperpdf">
										<c:param name="${PaperConstants.Action}" value="${PaperConstants.DownloadPDF}"/>
										<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${paperpdf}">PDF</a>
								</div>
							</div>
<%
					}
%>							<div class="content_block_row">
								<div class="content_block_column2_19_left"></div>
								<div class="content_block_column2_19_right">
									<input type="submit" value="Yes, delete this paper"/>
								</div>
							</div>
						</div>
					</form>
<%
				}
			}
%><jsp:include page="WEB-INF/jspf/footer.jsp" /><%
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
			if (lprojects.size() == 0) {
%>					<div class="notification_warning">
						No project available to be acknowledged. First create one.
					</div>
<%				
			} else {
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_bloc_column1">
									Paper: <%= pb.getTitle() %>
								</div>
							</div>
<% 
				for (ProjectBean cpb : lprojects) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<label>
										<input type="checkbox" name="${PaperConstants.ProjectID}" value="<%= cpb.getIdentifier() %>"/>
										<%= cpb.getIdentifier() %>: <%= cpb.getTitle() %> (<%= cpb.getFunder() %>)
									</label>
								</div>
							</div>
<%
				} 
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit" value="Acknowledge selected projects"/>
								</div>
							</div>
						</div>
					</form>
<%
			}
%><jsp:include page="WEB-INF/jspf/footer.jsp" /><%
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
			PaperBean pb = papers.get(0);
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
						No paper available for year <strong><%= year %></strong>. First create one.
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
		case PaperConstants.GetPapersForRank: {
			String rank = request.getParameter(PaperConstants.RankingOption);
			papers = dbms.getPapersByRank(rank);
			if (papers != null && papers.size() == 0) {
%>					<div class="notification_warning">
						No paper available with rank <strong><%= PaperConstants.getRank(rank) %></strong>. First create one.
					</div>
<%
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
						<c:url value="/projects.jsp" var="linkPapers">
							<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.LinkPapersToProject}"/>
							<c:param name="${ProjectConstants.ProjectID}" value="<%= project.getIdentifier() %>"/>
						</c:url>No paper acknowledging the project. First <a href="${linkPapers}">link one</a>.
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
%>					<div class="content_block_table">
<%
		int firstYear = dbms.getFirstYear();
		int lastYear = Calendar.getInstance().get(Calendar.YEAR);
		if (firstYear > 0) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								<form action="${pageContext.request.contextPath}/papers.jsp" method="post">
									<input type="submit" value="Show papers published in year:">
									<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.GetPapersForYear}"/>
									<select name="${PaperConstants.Year}">
<%					
			for (int year = firstYear; year <= lastYear; year++){
%>										<option><%= year %></option>
<%			
			}
%>									</select>
								</form>
							</div>
						</div>
<%			
		}
%>						<div class="content_block_row">
							<div class="content_block_column1">
								<form action="${pageContext.request.contextPath}/papers.jsp" method="post">
									<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.GetPapersForRank}"/>
									<input type="submit" value="Show papers ranked as:">
									<select name="${PaperConstants.RankingOption}">
										<option value="${PaperConstants.RankingNotRanked}" selected><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
										<option value="${PaperConstants.RankingA}"><%= PaperConstants.getRank(PaperConstants.RankingA) %></option>
										<option value="${PaperConstants.RankingB}"><%= PaperConstants.getRank(PaperConstants.RankingB) %></option>
										<option value="${PaperConstants.RankingC}"><%= PaperConstants.getRank(PaperConstants.RankingC) %></option>
									</select>
								</form>
							</div>
						</div>
					</div>
<%			
		if (useFullDetails) {
			PaperBean pb = papers.get(0);
%>					<form action="${pageContext.request.contextPath}/PaperManager" method="post">
						<input type="hidden" name="${PaperConstants.Action}" value="${PaperConstants.DelinkProjectsFromPaper}"/>
						<input type="hidden" name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
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
									Ranking:
								</div>
								<div class="content_block_column2_19_right">
									<%= PaperConstants.getRank(pb.getRanking()) %>
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
%>								</div>
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
				StringBuilder sb = new StringBuilder(jb.getIdentifier());
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
									<c:url value="/projects.jsp" var="listProjects">
										<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetProjectsForPaper}"/>
										<c:param name="${ProjectConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${listProjects}">List acknowledged projects</a>,
									<c:url value="/papers.jsp" var="linkProjects">
										<c:param name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
										<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${linkProjects}">Link projects</a>,
									<c:url value="/papers.jsp" var="modifypaper">
										<c:param name="${PaperConstants.Action}" value="${PaperConstants.ModifyPaper}"/>
										<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${modifypaper}">Update paper</a>,
									<c:url value="/papers.jsp" var="deletepaper">
										<c:param name="${PaperConstants.Action}" value="${PaperConstants.DeletePaperConfirm}"/>
										<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
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
									<c:url value="/PaperManager" var="paperpdf">
										<c:param name="${PaperConstants.Action}" value="${PaperConstants.DownloadPDF}"/>
										<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url><a href="${paperpdf}">PDF</a>
								</div>
							</div>
<%
			}
			if (projects != null) {
%>							<div class="content_block_row">
								<div class="content_block_column1 content_block_cell_header">
									Project details
								</div>
							</div>
<%
				if (projects.size() == 0) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<c:url value="/papers.jsp" var="linkProjects">
										<c:param name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
										<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
									</c:url>No project linked to this paper. <a href="${linkProjects}">Link projects to this paper</a>
								</div>
							</div>
<% 
				} else {
					for (ProjectBean pjb : projects) {
%>							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									<label>
										<input type="checkbox" name="${PaperConstants.ProjectID}" value="<%= pjb.getIdentifier() %>"/>
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
		} else {
			if (papers.size() > 0) {
%>					<div class="content_block_table">
<%
			if (project != null) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								<c:url value="/projects.jsp" var="projectfull">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetFullDetailsForProject}"/>
									<c:param name="${ProjectConstants.ProjectID}" value="<%= project.getIdentifier() %>"/>
								</c:url><a href="${projectfull}">Project: <%= project.getIdentifier() %>: <%= project.getTitle() %> (<%= project.getFunder() %>)</a>
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
								<c:url value="/papers.jsp" var="paperfull">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.GetFullDetailsForPaper}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${paperfull}"><%= pb.getTitle() %></a> (<%= pb.getYear() %>, <%= PaperConstants.getRank(pb.getRanking()) %><% 
					if (pb.getFilepath() != null) {
						%><c:url value="/PaperManager" var="paperpdf">
							<c:param name="${PaperConstants.Action}" value="${PaperConstants.DownloadPDF}"/>
							<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
						</c:url>, <a href="${paperpdf}">PDF</a><%
					}
								%>)
							</div>
							<div class="content_block_column2_64_right">
								<c:url value="/projects.jsp" var="listProjects">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetProjectsForPaper}"/>
									<c:param name="${ProjectConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${listProjects}">List acknowledged projects</a>,
								<c:url value="/papers.jsp" var="linkProjects">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.LinkProjectsToPaper}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${linkProjects}">Acknowledge projects</a>,
								<c:url value="/papers.jsp" var="modifypaper">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.ModifyPaper}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${modifypaper}">Update paper</a>,
								<c:url value="/papers.jsp" var="deletepaper">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.DeletePaperConfirm}"/>
									<c:param name="${PaperConstants.PaperID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${deletepaper}">Delete paper</a>
							</div>
						</div>
<%
				}
			}
%>					</div>
<%			
		}
	}
%><jsp:include page="WEB-INF/jspf/footer.jsp" />