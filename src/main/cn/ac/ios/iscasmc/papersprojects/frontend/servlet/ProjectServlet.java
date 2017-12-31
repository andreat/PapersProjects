/*******************************************************************************
 * Copyright (C) ${year} Andrea Turrini
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

/**
 * Servlet implementation class ProjectServlet
 */
@WebServlet("/ProjectManager")
public class ProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 2606114623069431679L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();

		DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");

		String action = request.getParameter(ProjectConstants.Action);
		if (action != null) {
			ProjectBean pb = new ProjectBean();
			switch (action) {
			case ProjectConstants.CreateProject : {
				String projectIdentifier = request.getParameter(ProjectConstants.ProjectIdentifierTextField);
				if (projectIdentifier == null) {
					status.put(DBMSAction.ProjectInsert, DBMSStatus.ProjectMissingIdentifier);
					break;
				}
				String projectTitle = request.getParameter(ProjectConstants.ProjectTitleTextField);
				String projectFunder = request.getParameter(ProjectConstants.ProjectFunderTextField);
				if (projectFunder == null) {
					status.put(DBMSAction.ProjectInsert, DBMSStatus.ProjectMissingFunder);
					break;
				}
				String projectAck = request.getParameter(ProjectConstants.ProjectAckTextField);
				if (projectAck == null) {
					status.put(DBMSAction.ProjectInsert, DBMSStatus.ProjectMissingAck);
					break;
				}
				Date startDate;
				Date endDate;
				try {
					startDate = Date.valueOf(
							request.getParameter(ProjectConstants.ProjectStartDateYear) 
							+ "-" 
							+ request.getParameter(ProjectConstants.ProjectStartDateMonth) 
							+ "-" 
							+ request.getParameter(ProjectConstants.ProjectStartDateDay)
							);
					endDate = Date.valueOf(
							request.getParameter(ProjectConstants.ProjectEndDateYear) 
							+ "-" 
							+ request.getParameter(ProjectConstants.ProjectEndDateMonth) 
							+ "-" 
							+ request.getParameter(ProjectConstants.ProjectEndDateDay)
							);
				} catch (IllegalArgumentException iae) {
					status.put(DBMSAction.ProjectInsert, DBMSStatus.IllegalArgument);
					break;
				}
				pb.setIdentifier(projectIdentifier);
				pb.setTitle(projectTitle);
				pb.setFunder(projectFunder);
				pb.setAcknowledge(projectAck);
				pb.setStartDate(startDate);
				pb.setEndDate(endDate);
				status.putAll(dbms.storeProject(pb));
				break;
			}
			case ProjectConstants.LinkPapersToProject: {
				String projectID = request.getParameter(ProjectConstants.ProjectID);
				if (projectID == null) {
					status.put(DBMSAction.ProjectPaperLink, DBMSStatus.ProjectMissingIdentifier);
					break;
				}
				String[] paperIDs = request.getParameterValues(ProjectConstants.PaperID);
				if (paperIDs == null || paperIDs.length == 0) {
					status.put(DBMSAction.ProjectPaperLink, DBMSStatus.ProjectMissingPapers);
					break;
				}
				status.putAll(dbms.storePapersForProject(paperIDs, projectID));
				break;
			}
			default:
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		request.getRequestDispatcher("projects.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
