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

import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.article.ArticleParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.inproceedings.InproceedingsParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.proceedings.ProceedingsParser;
import cn.ac.ios.iscasmc.papersprojects.frontend.action.PaperAction;

/**
 * Servlet implementation class PaperManager
 */
@WebServlet("/PaperManager")
public class PaperServlet extends HttpServlet {
	private static final long serialVersionUID = 1523148436647068850L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		DBMSStatus statusConference = null;
		DBMSStatus statusPaper = null;

		DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");
		String action = request.getParameter("action");
		if (action != null) {
			switch (action) {
			case PaperAction.createInproceedings :
				String conferenceBibtex = request.getParameter("conferenceBibtex");
				if (conferenceBibtex != null && conferenceBibtex.length() > 10) {
					ProceedingsParser pp = new ProceedingsParser(new ByteArrayInputStream(conferenceBibtex.getBytes()));
					ConferenceBean cb = pp.parseProceedings();
					statusConference = dbms.storeConference(cb);
				}
				if (statusConference == DBMSStatus.Success || statusConference == DBMSStatus.DuplicatedEntry) {
					String paperBibtex = request.getParameter("paperBibtex");
					InproceedingsParser ip = new InproceedingsParser(new ByteArrayInputStream(paperBibtex.getBytes()));
					PaperBean pb = ip.parseInproceedings();
					statusPaper = dbms.storePaper(pb);
				}
				break;
			case PaperAction.createArticle :
				String paperBibtex = request.getParameter("paperBibtex");
				ArticleParser ap = new ArticleParser(new ByteArrayInputStream(paperBibtex.getBytes()));
				PaperBean pb = ap.parseArticle();
				statusPaper = dbms.storePaper(pb);
				break;
			default:
			}
		}
		request.setAttribute("statusPaper", statusPaper);
		request.setAttribute("statusConference", statusConference);
		request.getRequestDispatcher("papers.jsp").include(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
