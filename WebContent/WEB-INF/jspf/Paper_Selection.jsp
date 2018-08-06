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
									Ranking: 
									<select name="${PaperConstants.Field_Ranking}">
										<option value="${PaperConstants.RankingAll}" selected><%= PaperConstants.getRank(PaperConstants.RankingAll) %></option>
										<option value="${PaperConstants.RankingNotRanked}"><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
										<option value="${PaperConstants.RankingA}"><%= PaperConstants.getRank(PaperConstants.RankingA) %></option>
										<option value="${PaperConstants.RankingB}"><%= PaperConstants.getRank(PaperConstants.RankingB) %></option>
										<option value="${PaperConstants.RankingC}"><%= PaperConstants.getRank(PaperConstants.RankingC) %></option>
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
