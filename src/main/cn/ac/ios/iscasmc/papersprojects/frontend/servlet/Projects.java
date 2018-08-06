/*******************************************************************************
 * Copyright (C) 2017-2018 Andrea Turrini
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/

package cn.ac.ios.iscasmc.papersprojects.frontend.servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean;
import cn.ac.ios.iscasmc.papersprojects.backend.constant.InternalOperationConstants;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus;
import cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants;

@WebServlet("/Projects")
public class Projects extends HttpServlet {
	private static final long serialVersionUID = -10161426744533460L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter(ProjectConstants.Field_Action);
		if (action == null) {
			showForm(ProjectConstants.Action_GetAllProjects, request, response);
		} else {
			switch (action) {
			case ProjectConstants.Action_CreateProject_Form:
			case ProjectConstants.Action_DeleteProject_Form:
			case ProjectConstants.Action_ModifyProject_Form:
			case ProjectConstants.Action_LinkPapersToProject_Form:
			case ProjectConstants.Action_GetAllProjects:
			case ProjectConstants.Action_GetFullDetailsForProject:
			case ProjectConstants.Action_GetProjectsForAuthor:
			case ProjectConstants.Action_GetProjectsForPaper:
			case ProjectConstants.Action_GetProjectsForYear:
				showForm(action, request, response);
				break;
			case ProjectConstants.Action_CreateProject_Process:
				manageCreateProjectProcess(request, response);
				break;
			case ProjectConstants.Action_DeleteProject_Process:
				manageDeleteProjectProcess(request, response);
				break;
			case ProjectConstants.Action_ModifyProject_Process:
				manageModifyProjectProcess(request, response);
				break;
			case ProjectConstants.Action_LinkPapersToProject_Process:
				manageLinkPapersToProjectProcess(request, response);
				break;
			case ProjectConstants.Action_DelinkPapersFromProject_Process:
				manageDelinkPapersFromProjectProcess(request, response);
				break;
			default: 
				showDefault(request, response);
			}
		}
	}
	
	private void manageCreateProjectProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		String projectIdentifier = request.getParameter(ProjectConstants.Field_ProjectIdentifier);
		if (projectIdentifier == null) {
			status.put(DBMSAction.ProjectInsert, DBMSStatus.ProjectMissingIdentifier);
		} else {
			String projectTitle = request.getParameter(ProjectConstants.Field_ProjectTitle);
			String projectFunder = request.getParameter(ProjectConstants.Field_ProjectFunder);
			if (projectFunder == null) {
				status.put(DBMSAction.ProjectInsert, DBMSStatus.ProjectMissingFunder);
			} else {
				String projectAck = request.getParameter(ProjectConstants.Field_ProjectAck);
				if (projectAck == null) {
					status.put(DBMSAction.ProjectInsert, DBMSStatus.ProjectMissingAck);
				} else {
					Date startDate = null;
					Date endDate = null;
					boolean allOK = false;
					try {
						startDate = Date.valueOf(
								request.getParameter(ProjectConstants.Field_ProjectStartDateYear) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectStartDateMonth) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectStartDateDay)
								);
						endDate = Date.valueOf(
								request.getParameter(ProjectConstants.Field_ProjectEndDateYear) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectEndDateMonth) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectEndDateDay)
								);
						allOK = true;
					} catch (IllegalArgumentException iae) {
						status.put(DBMSAction.ProjectInsert, DBMSStatus.IllegalArgument);
					}
					if (allOK) {
						ProjectBean pb = new ProjectBean();
						pb.setIdentifier(projectIdentifier);
						pb.setTitle(projectTitle);
						pb.setFunder(projectFunder);
						pb.setAcknowledge(projectAck);
						pb.setStartDate(startDate);
						pb.setEndDate(endDate);
						status.putAll(dbms.storeProject(pb));
					}
				}
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageDeleteProjectProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);

		String projectIdentifier = request.getParameter(ProjectConstants.Field_ProjectID);
		if (projectIdentifier == null) {
			status.put(DBMSAction.ProjectDelete, DBMSStatus.ProjectMissingIdentifier);
		} else {
			status.putAll(dbms.removeProject(projectIdentifier));
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageModifyProjectProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		String projectIdentifier = request.getParameter(ProjectConstants.Field_ProjectID);
		if (projectIdentifier == null) {
			status.put(DBMSAction.ProjectUpdate, DBMSStatus.ProjectMissingIdentifier);
		} else {
			String projectTitle = request.getParameter(ProjectConstants.Field_ProjectTitle);
			String projectFunder = request.getParameter(ProjectConstants.Field_ProjectFunder);
			if (projectFunder == null) {
				status.put(DBMSAction.ProjectUpdate, DBMSStatus.ProjectMissingFunder);
			} else {
				String projectAck = request.getParameter(ProjectConstants.Field_ProjectAck);
				if (projectAck == null) {
					status.put(DBMSAction.ProjectUpdate, DBMSStatus.ProjectMissingAck);
				} else {
					Date startDate = null;
					Date endDate = null;
					boolean allOK = false;
					try {
						startDate = Date.valueOf(
								request.getParameter(ProjectConstants.Field_ProjectStartDateYear) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectStartDateMonth) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectStartDateDay)
								);
						endDate = Date.valueOf(
								request.getParameter(ProjectConstants.Field_ProjectEndDateYear) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectEndDateMonth) 
								+ "-" 
								+ request.getParameter(ProjectConstants.Field_ProjectEndDateDay)
								);
						allOK = true;
					} catch (IllegalArgumentException iae) {
						status.put(DBMSAction.ProjectUpdate, DBMSStatus.IllegalArgument);
					}
					if (allOK) {
						ProjectBean pb = new ProjectBean();
						pb.setIdentifier(projectIdentifier);
						pb.setTitle(projectTitle);
						pb.setFunder(projectFunder);
						pb.setAcknowledge(projectAck);
						pb.setStartDate(startDate);
						pb.setEndDate(endDate);
						status.putAll(dbms.updateProject(pb));
					}
				}
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageLinkPapersToProjectProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);

		String projectID = request.getParameter(ProjectConstants.Field_ProjectID);
		if (projectID == null) {
			status.put(DBMSAction.ProjectPaperLink, DBMSStatus.ProjectMissingIdentifier);
		} else {
			String[] paperIDs = request.getParameterValues(ProjectConstants.Field_PaperID);
			if (paperIDs == null || paperIDs.length == 0) {
				status.put(DBMSAction.ProjectPaperLink, DBMSStatus.ProjectMissingPapers);
			} else {
				status.putAll(dbms.storePapersForProject(paperIDs, projectID));
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageDelinkPapersFromProjectProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);

		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void showDefault(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		showForm(ProjectConstants.Action_GetAllProjects, request, response);		
	}

	private void showForm(String form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("WEB-INF/jspf/Project_" + form + ".jsp").forward(request, response);		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
