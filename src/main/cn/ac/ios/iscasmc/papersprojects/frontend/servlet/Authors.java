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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.ac.ios.iscasmc.papersprojects.frontend.constant.AuthorConstants;

@WebServlet("/Authors")
public class Authors extends HttpServlet {
	private static final long serialVersionUID = -1213818237132366827L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter(AuthorConstants.Field_Action);
		if (action == null) {
			showForm(AuthorConstants.Action_GetAllAuthors, request, response);
		} else {
			switch (action) {
			case AuthorConstants.Action_GetAllAuthors:
				showForm(action, request, response);
				break;
			default:
				showDefault(request, response);
			}
		}
	}
	
	private void showDefault(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		showForm(AuthorConstants.Action_GetAllAuthors, request, response);		
	}

	private void showForm(String form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("WEB-INF/jspf/Author_" + form + ".jsp").forward(request, response);		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
