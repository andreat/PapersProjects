<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="java.util.List"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.JournalBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><jsp:include page="header.jsp" /><% 
	String paperID = request.getParameter(PaperConstants.Field_PaperID);
	if (paperID == null) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
	} else {
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		List<PaperBean> lpb = dbms.getPaperByID(paperID);
		if (lpb == null || lpb.size() == 0) {
%>					<div class="notification_error">
						No paper available for the given identifier.
					</div>
<%				
		} else {
			PaperBean pb = lpb.get(0);
%>					<form action="${pageContext.request.contextPath}/Papers" method="post" enctype="multipart/form-data">
						<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_ModifyPaper_Process}"/>
						<input type="hidden" name="${PaperConstants.Field_PaperID}" value="<%= pb.getIdentifier() %>"/>
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
								<div class="content_block_column1">
									CCF Ranking: 
									<select name="${PaperConstants.Field_Ranking_CCF}">
										<option value="${PaperConstants.RankingCCF_A}"<%= PaperConstants.RankingCCF_A.equals(pb.getRankingCCF()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCCF_A) %></option>
										<option value="${PaperConstants.RankingCCF_B}"<%= PaperConstants.RankingCCF_B.equals(pb.getRankingCCF()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCCF_B) %></option>
										<option value="${PaperConstants.RankingCCF_C}"<%= PaperConstants.RankingCCF_C.equals(pb.getRankingCCF()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCCF_C) %></option>
										<option value="${PaperConstants.RankingNotRanked}"<%= PaperConstants.RankingNotRanked.equals(pb.getRankingCCF()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column1">
									CORE Ranking: 
									<select name="${PaperConstants.Field_Ranking_CORE}">
										<option value="${PaperConstants.RankingCORE_AStar}"<%= PaperConstants.RankingCORE_AStar.equals(pb.getRankingCORE()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCORE_AStar) %></option>
										<option value="${PaperConstants.RankingCORE_A}"<%= PaperConstants.RankingCORE_A.equals(pb.getRankingCORE()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCORE_A) %></option>
										<option value="${PaperConstants.RankingCORE_B}"<%= PaperConstants.RankingCORE_C.equals(pb.getRankingCORE()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCORE_B) %></option>
										<option value="${PaperConstants.RankingCORE_C}"<%= PaperConstants.RankingCORE_C.equals(pb.getRankingCORE()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingCORE_C) %></option>
										<option value="${PaperConstants.RankingNotRanked}"<%= PaperConstants.RankingNotRanked.equals(pb.getRankingCORE()) ? " selected" : "" %>><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
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
									<input name="${PaperConstants.Field_PaperFile}" type="file"/>
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
%><jsp:include page="footer.jsp" />