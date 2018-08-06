<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page contentType="text/html" pageEncoding="UTF-8"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="java.util.Calendar"
%><jsp:include page="header.jsp" />					<form action="${pageContext.request.contextPath}/Projects" method="post">
						<input type="hidden" name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_CreateProject_Process}"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project identifier:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectIdentifier}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project title:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectTitle}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project funder:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectFunder}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project acknowledge:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.Field_ProjectAck}" size="100" />
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
		for (int yc = thisYear - 10; yc <= thisYear + 10; yc++) {
			if (yc == thisYear) {
%>										<option selected><%= yc %></option>
<%
			} else {
%>										<option><%= yc %></option>
<%
			}
		}
%>									</select>/<select name="${ProjectConstants.Field_ProjectStartDateMonth}">
										<option value="01">January</option>
										<option value="02">February</option>
										<option value="03">March</option>
										<option value="04">April</option>
										<option value="05">May</option>
										<option value="06">June</option>
										<option value="07">July</option>
										<option value="08">August</option>
										<option value="09">September</option>
										<option value="10">October</option>
										<option value="11">November</option>
										<option value="12">December</option>
									</select>/<select name="${ProjectConstants.Field_ProjectStartDateDay}">
<%
		for (int day = 1; day < 32; day++) {
%>										<option><%= day %></option>
<%
		}
%>									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project end date:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${ProjectConstants.Field_ProjectEndDateYear}">
<%
		for (int yc = thisYear - 10; yc <= thisYear + 10; yc++) {
			if (yc == thisYear) {
%>										<option selected><%= yc %></option>
<%
			} else {
%>										<option><%= yc %></option>
<%
			}
		}
%>									</select>/<select name="${ProjectConstants.Field_ProjectEndDateMonth}">
										<option value="01">January</option>
										<option value="02">February</option>
										<option value="03">March</option>
										<option value="04">April</option>
										<option value="05">May</option>
										<option value="06">June</option>
										<option value="07">July</option>
										<option value="08">August</option>
										<option value="09">September</option>
										<option value="10">October</option>
										<option value="11">November</option>
										<option value="12">December</option>
									</select>/<select name="${ProjectConstants.Field_ProjectEndDateDay}">
<%
				for (int day = 1; day < 32; day++) {
%>										<option><%= day %></option>
<%
				}
%>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit" value="Create project"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="footer.jsp" />