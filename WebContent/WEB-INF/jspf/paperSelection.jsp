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
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	int firstYear = dbms.getFirstYear();
	int lastYear = Calendar.getInstance().get(Calendar.YEAR);
	if (firstYear > 0) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								<form action="${pageContext.request.contextPath}/Papers" method="post">
									<input type="submit" value="Show papers published in year:">
									<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetPapersForYear}"/>
									<select name="${PaperConstants.Field_Year}">
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
								<form action="${pageContext.request.contextPath}/Papers" method="post">
									<input type="hidden" name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetPapersForRank}"/>
									<input type="submit" value="Show papers ranked as:">
									<select name="${PaperConstants.Field_Ranking}">
										<option value="${PaperConstants.RankingNotRanked}" selected><%= PaperConstants.getRank(PaperConstants.RankingNotRanked) %></option>
										<option value="${PaperConstants.RankingA}"><%= PaperConstants.getRank(PaperConstants.RankingA) %></option>
										<option value="${PaperConstants.RankingB}"><%= PaperConstants.getRank(PaperConstants.RankingB) %></option>
										<option value="${PaperConstants.RankingC}"><%= PaperConstants.getRank(PaperConstants.RankingC) %></option>
									</select>
								</form>
							</div>
						</div>
					</div>
