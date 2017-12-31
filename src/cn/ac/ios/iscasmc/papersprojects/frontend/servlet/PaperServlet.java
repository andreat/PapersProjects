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
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean;
import cn.ac.ios.iscasmc.papersprojects.backend.constant.InternalOperationConstants;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.article.ArticleParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.inproceedings.InproceedingsParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.proceedings.ProceedingsParser;
import cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants;
import cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants;

/**
 * Servlet implementation class PaperManager
 */
@WebServlet("/PaperManager")
@MultipartConfig
public class PaperServlet extends HttpServlet {
	private static final long serialVersionUID = 1523148436647068850L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();

		DBMS dbms = (DBMS) getServletContext().getAttribute("DBMS");

		String action = request.getParameter(PaperConstants.Action);
		if (action != null) {
			PaperBean pb = null;
			switch (action) {
			case PaperConstants.CreateInproceedings : {
				boolean removeMarkers = false;
				if (request.getParameter(PaperConstants.RemoveLaTeXMarkers) != null) {
					removeMarkers = true;
				}
				String conferenceBibtex = request.getParameter(PaperConstants.ProceedingsTextArea);
				if (conferenceBibtex != null && conferenceBibtex.length() > 10) {
					ProceedingsParser pp = new ProceedingsParser(new ByteArrayInputStream(conferenceBibtex.getBytes()));
					ConferenceBean cb = pp.parseProceedings(removeMarkers);
					if (cb == null) {
						status.put(DBMSAction.ConferenceInsert, DBMSStatus.ParserError);
					} else {
						status.putAll(dbms.storeConference(cb));
					}
				}
				DBMSStatus statusConference = status.get(DBMSAction.ConferenceInsert);
				if (statusConference == DBMSStatus.Success || statusConference == DBMSStatus.DuplicatedEntry) {
					String paperBibtex = request.getParameter(PaperConstants.InproceedingsTextArea);
					InproceedingsParser ip = new InproceedingsParser(new ByteArrayInputStream(paperBibtex.getBytes()));
					pb = ip.parseInproceedings(removeMarkers);
					if (pb == null) {
						status.put(DBMSAction.PaperInsert, DBMSStatus.ParserError);
					} else {
						manageUpload(request, pb, status);
						status.putAll(dbms.storePaper(pb));
					}
				}
				break;
			}
			case PaperConstants.CreateArticle : {
				boolean removeMarkers = false;
				if (request.getParameter(PaperConstants.RemoveLaTeXMarkers) != null) {
					removeMarkers = true;
				}
				String paperBibtex = request.getParameter(PaperConstants.ArticleTextArea);
				ArticleParser ap = new ArticleParser(new ByteArrayInputStream(paperBibtex.getBytes()));
				pb = ap.parseArticle(removeMarkers);
				if (pb == null) {
					status.put(DBMSAction.PaperInsert, DBMSStatus.ParserError);
				} else {
					manageUpload(request, pb, status);
					status.putAll(dbms.storePaper(pb));
				}
				break;
			}
			case PaperConstants.UploadPDF: {
				String paperID = request.getParameter(PaperConstants.PaperID);
				if (paperID != null) {
					List<PaperBean> lpb = dbms.getPaperByID(paperID);
					if (lpb != null && lpb.size() == 1) {
						pb = lpb.get(0);
					}
				}
				if (pb == null) {
					status.put(DBMSAction.PaperUpdate, DBMSStatus.NoSuchElement);
				} else {
					manageUpload(request, pb, status);
					status.putAll(dbms.updatePaperPDF(pb));
				}
				break;
			}
			case PaperConstants.DownloadPDF: {
				String paperID = request.getParameter(PaperConstants.PaperID);
				if (paperID != null) {
					List<PaperBean> lpb = dbms.getPaperByID(paperID);
					if (lpb != null && lpb.size() == 1) {
						pb = lpb.get(0);
					}
				}
				if (pb == null) {
					status.put(DBMSAction.PaperPDFRetrieval, DBMSStatus.NoSuchElement);
				} else {
					if (manageDownload(response, pb, status)) {
						return;
					}
				}
				break;
			}
			case PaperConstants.LinkProjectsToPaper: {
				String paperID = request.getParameter(PaperConstants.PaperID);
				if (paperID == null) {
					status.put(DBMSAction.PaperProjectLink, DBMSStatus.PaperMissingIdentifier);
					break;
				}
				String[] projectIDs = request.getParameterValues(ProjectConstants.ProjectID);
				if (projectIDs == null || projectIDs.length == 0) {
					status.put(DBMSAction.PaperProjectLink, DBMSStatus.PaperMissingProjects);
					break;
				}
				status.putAll(dbms.storeProjectsForPaper(projectIDs, paperID));
				break;
			}
			default:
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		request.getRequestDispatcher("papers.jsp").forward(request, response);
	}

	private void manageUpload(HttpServletRequest request, PaperBean pb, Map<DBMSAction, DBMSStatus> status) throws ServletException, IOException {
		Part part = request.getPart(PaperConstants.PaperFile);
		if (part != null && part.getSize() > 0) {
			InputStream fileContent = part.getInputStream();
			String filename = pb.getIdentifier().replace("/", "_").replace(":", "_");
			String basedir = (String) getServletContext().getAttribute("PDFPapersBaseDir");
			String filePath = basedir + File.separator + filename;
			String filenameuploaded = Paths.get(part.getSubmittedFileName()).getFileName().toString();
			int dotpoint = filenameuploaded.lastIndexOf(".");
			if (dotpoint > -1) {
				filePath = filePath + filenameuploaded.substring(dotpoint);
			}
			OutputStream os = null;
			try {
				os = new FileOutputStream(filePath);
				byte[] buffer = new byte[4096];
				int length;
				while ((length = fileContent.read(buffer)) > 0) {
					os.write(buffer, 0, length);
				}
			} finally {
				if (os != null) {
					os.close();
				}
			}
			pb.setFilepath(filePath);
		}
	}

	private boolean manageDownload(HttpServletResponse response, PaperBean pb, Map<DBMSAction, DBMSStatus> status) throws ServletException, IOException {
		String filepath = pb.getFilepath();
		if (filepath == null) {
			status.put(DBMSAction.PaperPDFRetrieval, DBMSStatus.PDFNotUploaded);
			return false;
		}
		File pdfFile = new File(filepath);
		if (!pdfFile.exists() || !pdfFile.isFile() || !(pdfFile.canRead())) {
			status.put(DBMSAction.PaperPDFRetrieval, DBMSStatus.PDFNotFound);
			return false;
		}
		try (
			InputStream fileContent = new FileInputStream(pdfFile);
		){
			response.setContentType("application/pdf");
			response.addHeader("Content-Disposition", "attachment; filename=" + pdfFile.getName());
			response.setContentLength((int) pdfFile.length());
			
			OutputStream os = response.getOutputStream();
			byte[] buffer = new byte[4096];
			int length;
			while ((length = fileContent.read(buffer)) > 0) {
				os.write(buffer, 0, length);
			}
		}
		return true;
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
