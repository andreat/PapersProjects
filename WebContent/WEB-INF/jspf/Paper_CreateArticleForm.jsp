<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><jsp:include page="header.jsp" />					<form action="${pageContext.request.contextPath}/Papers" method="post" enctype="multipart/form-data">
						<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_CreateArticle_Process}"/>
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
									<textarea name="${PaperConstants.Field_Bibtex_Article}" rows="10" cols="100"></textarea>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									LaTeX markers:
								</div>
								<div class="content_block_column2_28_right">
									<label>
										<input type="checkbox" name="${PaperConstants.Field_RemoveLaTeXMarkers}"/>
										Convert markers to plain text (experimental)
									</label>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									CCF Ranking:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${PaperConstants.Field_Ranking_CCF}">
										<option value="${PaperConstants.RankingCCF_A}"><%= PaperConstants.getRank(PaperConstants.RankingCCF_A) %></option>
										<option value="${PaperConstants.RankingCCF_B}"><%= PaperConstants.getRank(PaperConstants.RankingCCF_B) %></option>
										<option value="${PaperConstants.RankingCCF_C}"><%= PaperConstants.getRank(PaperConstants.RankingCCF_C) %></option>
										<option value="${PaperConstants.RankingNotRanked}" selected><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									CORE Ranking:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${PaperConstants.Field_Ranking_CORE}">
										<option value="${PaperConstants.RankingCORE_AStar}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_AStar) %></option>
										<option value="${PaperConstants.RankingCORE_A}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_A) %></option>
										<option value="${PaperConstants.RankingCORE_B}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_B) %></option>
										<option value="${PaperConstants.RankingCORE_C}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_C) %></option>
										<option value="${PaperConstants.RankingNotRanked}" selected><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Paper file:
								</div>
								<div class="content_block_column2_28_right">
									<input name="${PaperConstants.Field_PaperFile}" type="file"/>
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
<jsp:include page="footer.jsp" />