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
									<select name="${ProjectConstants.ProjectStartDateYear}"><%
		int thisYear = Calendar.getInstance().get(Calendar.YEAR);
		for (int yc = thisYear - 10; yc <= thisYear + 10; yc++) {
			if (yc == thisYear) {
%>
										<option selected><%= yc %>
										</option><%
			} else {
%>
										<option><%= yc %>
										</option><%
			}
		}
%>
									</select>/<select name="${ProjectConstants.ProjectStartDateMonth}">
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
									</select>/<select name="${ProjectConstants.ProjectStartDateDay}"><%
		for (int day = 1; day < 32; day++) {
%>
										<option><%= day %></option><%
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
									<select name="${ProjectConstants.ProjectEndDateYear}"><%
		for (int yc = thisYear - 10; yc <= thisYear + 10; yc++) {
			if (yc == thisYear) {
%>
										<option selected><%= yc %>
										</option><%
			} else {
%>
										<option><%= yc %>
										</option><%
			}
		}
%>
									</select>/<select name="${ProjectConstants.ProjectEndDateMonth}">
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
									</select>/<select name="${ProjectConstants.ProjectEndDateDay}"><%
				for (int day = 1; day < 32; day++) {
%>
										<option><%= day %></option><%
				}
%>
									</select>
								</div>
							</div>
							<div class="content_block_row">
								<div class="content_block_column2_28_left"></div>
								<div class="content_block_column2_28_right">
									<input type="submit"/>
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
									<input type="submit"/>
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
								<%= pb.getIdentifier() %>: <%= pb.getTitle() %> (<%= pb.getFunder() %>)
							</div>
							<div class="content_block_column2_37_right">
								<c:url value="/papers.jsp" var="listPapers">
									<c:param name="${PaperConstants.Action}" value="${PaperConstants.GetPapersForProject}"/>
									<c:param name="${PaperConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${listPapers}">List papers acknowledging this project</a>,
								<c:url value="/projects.jsp" var="linkPapers">
									<c:param name="${ProjectConstants.Action}" value="${ProjectConstants.LinkPapersToProject}"/>
									<c:param name="${ProjectConstants.ProjectID}" value="<%= pb.getIdentifier() %>"/>
								</c:url><a href="${linkPapers}">Link papers to this project</a>
							</div>
						</div>
<% 
			}
%>					</div>

<%
		}
	}
%><jsp:include page="WEB-INF/jspf/footer.jsp" />