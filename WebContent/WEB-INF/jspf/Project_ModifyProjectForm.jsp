<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="java.util.Calendar"
%><jsp:include page="header.jsp" />
<% 
	String projectID = request.getParameter(ProjectConstants.Field_ProjectID);
	if (projectID == null) {
%>					<div class="notification_error">
						No project available for the given identifier.
					</div>
<%				
	} else {
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		ProjectBean pb = dbms.getProjectByID(projectID);
		if (pb == null) {
%>					<div class="notification_error">
						No project available for the given identifier.
					</div>
<%				
		} else {
%>					<form action="${pageContext.request.contextPath}/Projects" method="post">
						<input type="hidden" name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_ModifyProject_Process}"/>
						<input type="hidden" name="${ProjectConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project identifier:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getIdentifier() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project title:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectTitle}" size="100" value="<%= pb.getTitle() %>" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project funder:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectFunder}" size="100" value="<%= pb.getFunder() %>" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project acknowledge:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectAck}" size="100" value="<%= pb.getAcknowledge() %>" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project start date:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${ProjectConstants.Field_ProjectStartDateYear}">
<%
			int thisYear = Calendar.getInstance().get(Calendar.YEAR);
			Calendar cal = Calendar.getInstance();
			cal.setTime(pb.getStartDate());
			int projectStartYear = cal.get(Calendar.YEAR);
			int projectStartMonth = cal.get(Calendar.MONTH) + 1;
			int projectStartDay = cal.get(Calendar.DAY_OF_MONTH);
			for (int yc = thisYear - 10; yc <= thisYear + 10; yc++) {
				if (yc == projectStartYear) {
%>										<option selected><%= yc %></option>
<%
				} else {
%>										<option><%= yc %></option>
<%
				}
			}
%>									</select>/<select name="${ProjectConstants.Field_ProjectStartDateMonth}">
										<option value="01"<%= projectStartMonth == 1 ? " selected" : "" %>>January</option>
										<option value="02"<%= projectStartMonth == 2 ? " selected" : "" %>>February</option>
										<option value="03"<%= projectStartMonth == 3 ? " selected" : "" %>>March</option>
										<option value="04"<%= projectStartMonth == 4 ? " selected" : "" %>>April</option>
										<option value="05"<%= projectStartMonth == 5 ? " selected" : "" %>>May</option>
										<option value="06"<%= projectStartMonth == 6 ? " selected" : "" %>>June</option>
										<option value="07"<%= projectStartMonth == 7 ? " selected" : "" %>>July</option>
										<option value="08"<%= projectStartMonth == 8 ? " selected" : "" %>>August</option>
										<option value="09"<%= projectStartMonth == 9 ? " selected" : "" %>>September</option>
										<option value="10"<%= projectStartMonth == 10 ? " selected" : "" %>>October</option>
										<option value="11"<%= projectStartMonth == 11 ? " selected" : "" %>>November</option>
										<option value="12"<%= projectStartMonth == 12 ? " selected" : "" %>>December</option>
									</select>/<select name="${ProjectConstants.Field_ProjectStartDateDay}">
<%
			for (int day = 1; day < 32; day++) {
				if (day == projectStartDay) {
%>										<option selected><%= day %></option>
<%
				} else {
%>										<option><%= day %></option>
<%
				}
			}
%>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project end date:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${ProjectConstants.Field_ProjectEndDateYear}">
<%
			cal.setTime(pb.getEndDate());
			int projectEndYear = cal.get(Calendar.YEAR);
			int projectEndMonth = cal.get(Calendar.MONTH) + 1;
			int projectEndDay = cal.get(Calendar.DAY_OF_MONTH);
			for (int yc = thisYear - 10; yc <= thisYear + 10; yc++) {
				if (yc == projectEndYear) {
%>										<option selected><%= yc %></option>
<%
				} else {
%>										<option><%= yc %></option>
<%
				}
			}
%>									</select>/<select name="${ProjectConstants.Field_ProjectEndDateMonth}">
										<option value="01"<%= projectEndMonth == 1 ? " selected" : "" %>>January</option>
										<option value="02"<%= projectEndMonth == 2 ? " selected" : "" %>>February</option>
										<option value="03"<%= projectEndMonth == 3 ? " selected" : "" %>>March</option>
										<option value="04"<%= projectEndMonth == 4 ? " selected" : "" %>>April</option>
										<option value="05"<%= projectEndMonth == 5 ? " selected" : "" %>>May</option>
										<option value="06"<%= projectEndMonth == 6 ? " selected" : "" %>>June</option>
										<option value="07"<%= projectEndMonth == 7 ? " selected" : "" %>>July</option>
										<option value="08"<%= projectEndMonth == 8 ? " selected" : "" %>>August</option>
										<option value="09"<%= projectEndMonth == 9 ? " selected" : "" %>>September</option>
										<option value="10"<%= projectEndMonth == 10 ? " selected" : "" %>>October</option>
										<option value="11"<%= projectEndMonth == 11 ? " selected" : "" %>>November</option>
										<option value="12"<%= projectEndMonth == 12 ? " selected" : "" %>>December</option>
									</select>/<select name="${ProjectConstants.Field_ProjectEndDateDay}">
<%
			for (int day = 1; day < 32; day++) {
				if (day == projectEndDay) {
%>										<option selected><%= day %></option>
<%
				} else {
%>										<option><%= day %></option>
<%
				}
			}
%>									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit" value="Update project"/>
								</div>
							</div>
						</div>
					</form>
<%
		}
	}
%><jsp:include page="footer.jsp" />