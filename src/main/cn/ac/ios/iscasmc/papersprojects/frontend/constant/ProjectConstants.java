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

package cn.ac.ios.iscasmc.papersprojects.frontend.constant;

public final class ProjectConstants {
	
	public static final String Action_CreateProject_Form = "CreateProjectForm";
	public static final String Action_CreateProject_Process = "CreateProjectProcess";
	public static final String Action_ModifyProject_Form = "ModifyProjectForm";
	public static final String Action_ModifyProject_Process = "ModifyProjectProcess";
	public static final String Action_DeleteProject_Form = "DeleteProjectForm";
	public static final String Action_DeleteProject_Process = "DeleteProjectProcess";
	public static final String Action_LinkPapersToProject_Form = "LinkPapersToProjectForm";
	public static final String Action_LinkPapersToProject_Process = "LinkPapersToProjectProcess";
	public static final String Action_DelinkPapersFromProject = "DelinkPapersFromProject";
	public static final String Action_GetProjectsForAuthor = "GetProjectsForAuthor";
	public static final String Action_GetProjectsForYear = "GetProjectsForYear";
	public static final String Action_GetProjectsForPaper = "GetProjectsForPaper";
	public static final String Action_GetAllProjects = "GetAllProjects";
	public static final String Action_GetFullDetailsForProject = "GetFullDetailsForProject";

	public static final String Field_Action= "Action";
	public static final String Field_Year = "Year";

	public static final String Field_AuthorID = "AuthorID";
	public static final String Field_PaperID = "PaperID";
	public static final String Field_ProjectID = "ProjectID";
	
	public static final String Field_ProjectIdentifier = "ProjectIdentifier";
	public static final String Field_ProjectTitle = "ProjectTitle";
	public static final String Field_ProjectFunder = "ProjectFunder";
	public static final String Field_ProjectAck = "ProjectAck";
	public static final String Field_ProjectStartDateYear = "ProjectStartDateYear";
	public static final String Field_ProjectStartDateMonth = "ProjectStartDateMonth";
	public static final String Field_ProjectStartDateDay = "ProjectStartDateDay";
	public static final String Field_ProjectEndDateYear = "ProjectEndDateYear";
	public static final String Field_ProjectEndDateMonth = "ProjectEndDateMonth";
	public static final String Field_ProjectEndDateDay = "ProjectEndDateDay";
	
	
	private ProjectConstants() {};
}
