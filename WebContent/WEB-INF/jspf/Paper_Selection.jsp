<%@page import="java.util.Calendar"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.constant.InternalOperationConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="java.text.MessageFormat"
%>					<div class="content_block_table">
<%
	DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
	int firstYear = dbms.getFirstYear();
	int lastYear = Calendar.getInstance().get(Calendar.YEAR);
	if (firstYear > 0) {
%>						<form action="${pageContext.request.contextPath}/Papers" method="post">
							<div class="content_block_row">
								<div class="content_block_column1">
									Year: 
									<select name="${PaperConstants.Field_Year}">
										<option value="${PaperConstants.YearAll}" selected>All years</option>
<%					
		for (int year = firstYear; year <= lastYear; year++){
%>										<option><%= year %></option>
<%			
		}
%>									</select>
								</div>
							</div>
<%			
	}
%>							<div class="content_block_row">
								<div class="content_block_column1">
									CCF Ranking: 
									<select name="${PaperConstants.Field_Ranking_CCF}">
										<option value="${PaperConstants.RankingAll}" selected><%= PaperConstants.getRank(PaperConstants.RankingAll) %></option>
										<option value="${PaperConstants.RankingCCF_A}"><%= PaperConstants.getRank(PaperConstants.RankingCCF_A) %></option>
										<option value="${PaperConstants.RankingCCF_B}"><%= PaperConstants.getRank(PaperConstants.RankingCCF_B) %></option>
										<option value="${PaperConstants.RankingCCF_C}"><%= PaperConstants.getRank(PaperConstants.RankingCCF_C) %></option>
										<option value="${PaperConstants.RankingNotRanked}"><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column1">
									CORE Ranking: 
									<select name="${PaperConstants.Field_Ranking_CORE}">
										<option value="${PaperConstants.RankingAll}" selected><%= PaperConstants.getRank(PaperConstants.RankingAll) %></option>
										<option value="${PaperConstants.RankingCORE_AStar}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_AStar) %></option>
										<option value="${PaperConstants.RankingCORE_A}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_A) %></option>
										<option value="${PaperConstants.RankingCORE_B}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_B) %></option>
										<option value="${PaperConstants.RankingCORE_C}"><%= PaperConstants.getRank(PaperConstants.RankingCORE_C) %></option>
										<option value="${PaperConstants.RankingNotRanked}"><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit" value="Show papers published in year by rank">
									<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetPapersForYearAndRank}"/>
								</div>
							</div>
						</form>
					</div>
