<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"
%><%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.constant.InternalOperationConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="java.util.Calendar"
%><%@page import="java.util.List"
%><%@page import="java.util.Map"
%><jsp:include page="WEB-INF/jspf/header.jsp" /><%
	Object statusOperation = request.getAttribute(InternalOperationConstants.StatusOperation);
	String action = request.getParameter(ProjectConstants.Action);
	DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
	List<ProjectBean> projects;
	PaperBean paper = null;
	String authorID = null;
	int year = -1;
	
	if (statusOperation != null || action == null) {
		projects = dbms.getProjects();
		if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project available. First create one.
					</div>
<%
		}
	} else {
		switch (action) {
		case ProjectConstants.CreateProject: {
%>					<form action="${pageContext.request.contextPath}/ProjectManager" method="post">
						<input type="hidden" name="${ProjectConstants.Action}" value="${ProjectConstants.CreateProject}"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project identifier:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.ProjectIdentifierTextField}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project title:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.ProjectTitleTextField}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project funder:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.ProjectFunderTextField}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project acknowledge:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.ProjectAckTextField}" size="100" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project start date:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${ProjectConstants.ProjectStartDateYear}">
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
%>									</select>/<select name="${ProjectConstants.ProjectStartDateMonth}">
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
									</select>/<select name="${ProjectConstants.ProjectStartDateDay}">
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
									<select name="${ProjectConstants.ProjectEndDateYear}">
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
%>									</select>/<select name="${ProjectConstants.ProjectEndDateMonth}">
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
									</select>/<select name="${ProjectConstants.ProjectEndDateDay}">
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
<jsp:include page="WEB-INF/jspf/footer.jsp" /><%
				return;
		}
		case ProjectConstants.ModifyProject: {
			String projectID = request.getParameter(ProjectConstants.ProjectID);
			if (projectID == null) {
				projects = dbms.getProjects();
				break;		
			}
			ProjectBean pb = dbms.getProjectByID(projectID);
			if (pb == null) {
				projects = dbms.getProjects();
				break;		
			}			
%>					<form action="${pageContext.request.contextPath}/ProjectManager" method="post">
						<input type="hidden" name="${ProjectConstants.Action}" value="${ProjectConstants.ModifyProject}"/>
						<input type="hidden" name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
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
									<input type="text" name="${ProjectConstants.ProjectTitleTextField}" size="100" value="<%= pb.getTitle() %>" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project funder:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.ProjectFunderTextField}" size="100" value="<%= pb.getFunder() %>" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project acknowledge:
								</div>
								<div class="content_block_column2_28_right">
									<input type="text" name="${ProjectConstants.ProjectAckTextField}" size="100" value="<%= pb.getAcknowledge() %>" />
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project start date:
								</div>
								<div class="content_block_column2_28_right">
									<select name="${ProjectConstants.ProjectStartDateYear}">
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
%>									</select>/<select name="${ProjectConstants.ProjectStartDateMonth}">
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
									</select>/<select name="${ProjectConstants.ProjectStartDateDay}">
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
									<select name="${ProjectConstants.ProjectEndDateYear}">
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
%>									</select>/<select name="${ProjectConstants.ProjectEndDateMonth}">
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
									</select>/<select name="${ProjectConstants.ProjectEndDateDay}">
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
<jsp:include page="WEB-INF/jspf/footer.jsp" /><%
				return;
		}
		case ProjectConstants.DeleteProjectConfirm: {
			String projectID = request.getParameter(ProjectConstants.ProjectID);
			if (projectID == null) {
				projects = dbms.getProjects();
				break;		
			}
			ProjectBean pb = dbms.getProjectByID(projectID);
			if (pb == null) {
				projects = dbms.getProjects();
				break;		
			}			
%>					<form action="${pageContext.request.contextPath}/ProjectManager" method="post">
						<input type="hidden" name="${ProjectConstants.Action}" value="${ProjectConstants.DeleteProject}"/>
						<input type="hidden" name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
							<div class="content_block_row">
								<div class="content_block_column1">
									Do you really want to <strong>delete</strong> the following project?
									The operation can not be reverted and all papers will not acknowledge this project anymore.
								</div>
							</div>
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
									<%= pb.getTitle() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project funder:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getFunder() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project acknowledge:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getAcknowledge() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project start date:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getStartDate() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left">
									Project end date:
								</div>
								<div class="content_block_column2_28_right">
									<%= pb.getEndDate() %>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit" value="Yes, delete this project"/>
								</div>
							</div>
						</div>
					</form>
<jsp:include page="WEB-INF/jspf/footer.jsp" /><%
				return;
		}
		case ProjectConstants.LinkPapersToProject: {
			String projectID = request.getParameter(ProjectConstants.ProjectID);
			if (projectID == null) {
				projects = dbms.getProjects();
				break;		
			}
			List<PaperBean> papers = dbms.getPapersNotAcknowledgingProject(projectID);
			if (papers == null) {
				projects = dbms.getProjects();
				break;		
			}
			ProjectBean pb = dbms.getProjectByID(projectID);
			if (pb == null) {
				projects = dbms.getProjects();
				break;		
			}
			if (papers.size() > 0) {
%>					<form action="${pageContext.request.contextPath}/ProjectManager" method="post">
						<input type="hidden" name="${ProjectConstants.Action}" value="${ProjectConstants.LinkPapersToProject}"/>
						<input type="hidden" name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
						<div class="content_block_table">
<% 
				for (PaperBean lpb : papers) {
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<label>
										<input type="checkbox" name="${ProjectConstants.PaperID}" value="<%= lpb.getIdentifier() %>"/>
										<%= lpb.getTitle() %>
									</label>
								</div>
							</div>
<%
				} 
%>							<div class="content_block_row">
								<div class="content_block_column1">
									<input type="submit" value="Acknowledge project"/>
								</div>
							</div>
						</div>
					</form>
<%
			} else {
%>					<div class="notification_warning">
						No paper available. First create one.
					</div>
<%
			}
%><jsp:include page="WEB-INF/jspf/footer.jsp" /><%
			return;
		}
		case ProjectConstants.GetProjectsForAuthor:
			authorID = request.getParameter(ProjectConstants.AuthorID);
			if (authorID == null) {
				projects = dbms.getProjects();
				if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project available. First create one.
					</div>
<%
				}
			} else {
				projects = dbms.getProjectsInvolvingAuthor(authorID);
				if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project acknowledged by a paper written by the author. First link one.
					</div>
<%
				}
			}
			break;
		case ProjectConstants.GetProjectsForYear:
			try {
				year = Integer.parseInt(request.getParameter(ProjectConstants.Year));
				projects = dbms.getProjectsAcknowledgedInYear(year);
				if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project acknowledged in year <%= year %>. First link one.
					</div>
<%
				}
			} catch (NumberFormatException nfe) {
				projects = dbms.getProjects();
				if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project available. First create one.
					</div>
<%
				}
			}
			break;
		case ProjectConstants.GetProjectsForPaper:
			String paperID = request.getParameter(ProjectConstants.PaperID);
			if (paperID == null) {
				projects = dbms.getProjects();
				if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project available. First create one.
					</div>
<%
				}
			} else {
				projects = dbms.getProjectsAcknowledgedByPaper(paperID);
				if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project acknowledged by the paper. First link one.
					</div>
<%
				}
				List<PaperBean> lpb = dbms.getPaperByID(paperID);
				if (lpb != null && lpb.size() == 1) {
					paper = lpb.get(0);
				}
			}
			break;
		default:
			projects = dbms.getProjects();
			if (projects != null && projects.size() == 0) {
%>					<div class="notification_warning">
						No project available. First create one.
					</div>
<%
			}
		}
	}
	if (projects == null) {
%>					<div class="notification_error">
						Error with the database during the retrieval of the projects.
					</div>
<%
	} else {
		if (projects.size() > 0) {
%>					<div class="content_block_table">
<%
			if (paper != null) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								Paper: <%= paper.getTitle() %>
							</div>
						</div>
<% 		
			}
			if (authorID != null) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								Author: <%= authorID %>
							</div>
						</div>
<% 		
			}
			if (year > 0) {
%>						<div class="content_block_row">
							<div class="content_block_column1">
								Year: <%= year %>
							</div>
						</div>
<% 		
			}
%>						<div class="content_block_row">
							<div class="content_block_column2_37_left content_block_cell_header">
								Project
							</div>
							<div class="content_block_column2_37_right content_block_cell_header">
								Actions
							</div>
						</div>
<%
			for (ProjectBean pb : projects) {
%>						<div class="content_block_row">
							<div class="content_block_column2_37_left">
								<c:url value="/projects.jsp" var="projectfull">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.GetFullDetailsForProject}"/>
									<c:param name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${projectfull}"><%= pb.getIdentifier() %>: <%= pb.getTitle() %> (<%= pb.getFunder() %>)</a>
							</div>
							<div class="content_block_column2_37_right">
								<c:url value="/papers.jsp" var="listPapers">
									<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_GetPapersForProject}"/>
									<c:param name="${PaperConstants.Field_ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${listPapers}">List acknowledging papers</a>,
								<c:url value="/projects.jsp" var="linkPapers">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.LinkPapersToProject}"/>
									<c:param name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${linkPapers}">Add acknowledging papers</a>,
								<c:url value="/projects.jsp" var="modifyProject">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.ModifyProject}"/>
									<c:param name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${modifyProject}">Modify project</a>,
								<c:url value="/projects.jsp" var="deleteProject">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.DeleteProjectConfirm}"/>
									<c:param name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${deleteProject}">Delete project</a>
							</div>
						</div>
<% 
			}
%>					</div>

<%
		}
	}
%><jsp:include page="WEB-INF/jspf/footer.jsp" />