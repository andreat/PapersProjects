<%@page import="java.util.Map"
%><%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.constant.InternalOperationConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants"
%><%@page import="cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants"
%><%@page import="java.text.MessageFormat"
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Papers and Projects management system</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/papersprojects.css"/>
    </head>
    <body>
    	<div class="maincontainer">
    		<div class="container">
    			<div class="header">
    				<div class="content_head_center">
        				<h1 class="system">Papers and Projects management system</h1>
       				</div>
					<div class="wrapper">
						<a href="${pageContext.request.contextPath}/authors.jsp"><span class="btn_main">Authors</span></a>
						<a href="${pageContext.request.contextPath}/Papers"><span class="btn_main">Papers</span></a>
						<a href="${pageContext.request.contextPath}/Projects"><span class="btn_main">Projects</span></a>
					</div>
					<div class="wrapper">
						<c:url value="/Papers" var="ccp">
							<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_CreateInproceedings_Form}"/>
						</c:url><a href="${ccp}"><span class="btn_secondary">Create conference paper</span></a>
						<c:url value="/Papers" var="cjp">
							<c:param name="${PaperConstants.Field_Action}" value="${PaperConstants.Action_CreateArticle_Form}"/>
						</c:url><a href="${cjp}"><span class="btn_secondary">Create journal paper</span></a>
						<c:url value="/Projects" var="cp">
							<c:param name="${ProjectConstants.Field_Action}" value="${ProjectConstants.Action_CreateProject}"/>
						</c:url><a href="${cp}"><span class="btn_secondary">Create project</span></a>
					</div>
				</div>
				<div class="container_content">
<% 	
	@SuppressWarnings("unchecked")
	Map<DBMSAction, DBMSStatus> statusMapHeader = (Map<DBMSAction, DBMSStatus>) request.getAttribute(InternalOperationConstants.StatusOperation);
	if (statusMapHeader != null) {
		for (Map.Entry<DBMSAction, DBMSStatus> entry : statusMapHeader.entrySet()) {
			String component = null;
			
			switch (entry.getKey()) {
			case AuthorInsert:
				component = "Authors";
				break;
			case ConferenceInsert:
				component = "Conference";
				break;
			case ConnectDatabase:
				component = "Database";
				break;
			case PaperAuthorLink:
				component = "Authors for paper";
				break;
			case PaperInsert:
			case PaperPDFRetrieval:
			case PaperUpdate:
				component = "Paper";
				break;
			case PaperDelete:
				component = "Removal of the paper";
				break;
			case ProjectInsert:
			case ProjectUpdate:
				component = "Project";
				break;
			case ProjectDelete:
				component = "Removal of the project";
				break;
			case PaperProjectLink:
				component = "Projects acknowledged by the paper";
				break;
			case PaperProjectDelink:
				component = "Removal of acknowledges for the paper";
				break;
			case ProjectPaperLink:
				component = "Papers acknowledging the project";
				break;
			case ProjectPaperDelink:
				component = "Removal of acknowledges for the project";
				break;
			}
			
			String message = null;
			boolean isSuccess = false;
			
			switch (entry.getValue()) {
			case ConnectionFailed:
			case MissingBackend:
			case NoConnection:
			case SQLFailed: 
			case UnknownDBMS:
				message = "Error during the interaction with the database";
				break;
			case DuplicatedEntry:
				message = "{0} already present in the database.";
				break;
			case NoSuchElement:
				message = "{0} not found in the database.";
				break;
			case IllegalArgument:
				message = "Illegal argument provided for the {0}.";
				component = component.toLowerCase();
				break;
			case PaperMissingIdentifier:
			case ProjectMissingIdentifier:
				message = "No identifier provided for {0}";
				component = component.toLowerCase();
				break;
			case ParserError:
				message = "Failed parsing entry {0}.";
				component = component.toLowerCase();
				break;
			case PaperMissingProjects:
				message = "No projects selected to be connected to the {0}.";
				component = component.toLowerCase();
				break;
			case ProjectMissingPapers:
				message = "No papers selected to be connected to the {0}.";
				component = component.toLowerCase();
				break;
			case PDFNotFound:
				message = "The PDF file associated with the required {0} is not available.";
				component = component.toLowerCase();
				break;
			case PDFNotUploaded:
				message = "No PDF file associated with the required {0}.";
				component = component.toLowerCase();
				break;
			case ProjectMissingAck:
				message = "No mandatory acknowledgement provided for the {0}.";
				component = component.toLowerCase();
				break;
			case ProjectMissingFunder:
				message = "No mandatory funder provided for the {0}.";
				component = component.toLowerCase();
				break;
			case Success:
				message = "{0} stored correctly.";
				isSuccess = true;
				break;
			}
%>					<div class="notification_<%= isSuccess ? "success" : "error" %>">
						<%= MessageFormat.format(message, new Object[]{component}) %>
					</div>
<%			
		}
	}
%>