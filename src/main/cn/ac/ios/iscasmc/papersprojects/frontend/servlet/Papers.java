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

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
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
import cn.ac.ios.iscasmc.papersprojects.backend.parser.bibtex.BibtexParser;
import cn.ac.ios.iscasmc.papersprojects.frontend.constant.PaperConstants;
import cn.ac.ios.iscasmc.papersprojects.frontend.constant.ProjectConstants;

@WebServlet("/Papers")
@MultipartConfig
public class Papers extends HttpServlet {
	private static final long serialVersionUID = 7609707217755694013L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter(PaperConstants.Field_Action);
		if (action == null) {
			DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
			List<PaperBean> papers = dbms.getPapers();
			request.setAttribute(PaperConstants.PAPER_LIST_ENTITY, papers);
			showForm(PaperConstants.Action_GetAllPapers, request, response);
		} else {
			switch (action) {
			case PaperConstants.Action_ModifyPaper_Form:
			case PaperConstants.Action_CreatePaper_Form:
			case PaperConstants.Action_DeletePaper_Form:
			case PaperConstants.Action_LinkProjectsToPaper_Form:
			case PaperConstants.Action_GetPapersForAuthor:
			case PaperConstants.Action_GetPapersForProject:
			case PaperConstants.Action_GetFullDetailsForPaper:
				showForm(action, request, response);
				break;
			case PaperConstants.Action_GetAllPapers:
				DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
				List<PaperBean> papers = dbms.getPapers();
				request.setAttribute(PaperConstants.PAPER_LIST_ENTITY, papers);
				showForm(action, request, response);
				break;
			case PaperConstants.Action_GetPapersForYearAndRank:
				manageGetPapersForYearAndRank(request, response);
				break;
			case PaperConstants.Action_CreatePaper_Process:
				manageCreatePaperProcess(request, response);
				break;
			case PaperConstants.Action_DeletePaper_Process:
				manageDeletePaperProcess(request, response);
				break;
			case PaperConstants.Action_ModifyPaper_Process:
				manageModifyPaperProcess(request, response);
				break;
			case PaperConstants.Action_DownloadPDF:
				manageDownloadPDF(request, response);
				break;
			case PaperConstants.Action_LinkProjectsToPaper_Process:
				manageLinkProjectsToPaperProcess(request, response);
				break;
			case PaperConstants.Action_DelinkProjectsFromPaper_Process:
				manageDelinkProjectsFromPaperProcess(request, response);
				break;
			default:
				showDefault(request, response);
			}
		}
	}
	
	private void manageGetPapersForYearAndRank(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String year_str = request.getParameter(PaperConstants.Field_Year);
		String rank_ccf = request.getParameter(PaperConstants.Field_Ranking_CCF);
		String rank_core = request.getParameter(PaperConstants.Field_Ranking_CORE);
		int year = 0;
		
		int choice = 0;
		if (year_str == null || year_str.equals(PaperConstants.YearAll)) {
			choice += 1;
		} else {
	        try {
                year = Integer.parseInt(year_str);
	        } catch (NumberFormatException nfe) {
                choice +=1;
	        }			
		}
		if (rank_ccf == null || rank_ccf.equals(PaperConstants.RankingAll)) {
			choice += 2;
		}
		if (rank_core == null || rank_core.equals(PaperConstants.RankingAll)) {
			choice += 4;
		}
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		List<PaperBean> papers;
		switch (choice) {
		case 0 :
            papers = dbms.getPapersPublishedInYearWithCCFandCORE(year, rank_ccf, rank_core);
			break;
		case 1 :
            papers = dbms.getPapersPublishedWithCCFandCORE(rank_ccf, rank_core);
			break;
		case 2 :
            papers = dbms.getPapersPublishedInYearWithCORE(year, rank_core);
			break;
		case 3 :
            papers = dbms.getPapersPublishedWithCORE(rank_core);
			break;
		case 4 :
            papers = dbms.getPapersPublishedInYearWithCCF(year, rank_ccf);
			break;
		case 5 :
            papers = dbms.getPapersPublishedWithCCF(rank_ccf);
			break;
		case 6 :
            papers = dbms.getPapersPublishedInYear(year);
			break;
		default:
			papers = dbms.getPapers();
			break;
		}
		request.setAttribute(PaperConstants.PAPER_LIST_ENTITY, papers);
		showForm(PaperConstants.Action_GetAllPapers, request, response);		
	}

	private void manageCreatePaperProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		boolean removeMarkers = false;
		if (request.getParameter(PaperConstants.Field_RemoveLaTeXMarkers) != null) {
			removeMarkers = true;
		}
		String conferenceBibtex = request.getParameter(PaperConstants.Field_Bibtex_Content);
		PaperBean pb = null;
		if (conferenceBibtex != null && conferenceBibtex.length() > 10) {
			BibtexParser bp = new BibtexParser(new ByteArrayInputStream(conferenceBibtex.getBytes()));
			pb = bp.parseBibTeX(removeMarkers);
			if (pb == null) {
				status.put(DBMSAction.PaperInsert, DBMSStatus.ParserError);
			} else {
				if (bp.isInproceedings()) {
					ConferenceBean cb = bp.getConference();
					if (cb == null) {
						status.put(DBMSAction.ConferenceInsert, DBMSStatus.ParserError);
					} else {
						status.putAll(dbms.storeConference(cb));
					}
				}
				pb.setRankingCCF(request.getParameter(PaperConstants.Field_Ranking_CCF));
				pb.setRankingCORE(request.getParameter(PaperConstants.Field_Ranking_CORE));
				manageUpload(request, pb, status);
				status.putAll(dbms.storePaper(pb));
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		if (DBMSStatus.Success.equals(status.get(DBMSAction.PaperInsert))) {
			request.setAttribute(PaperConstants.Field_PaperID, pb.getIdentifier());
			showForm(PaperConstants.Action_ModifyPaper_Form, request, response);
		} else {
			showDefault(request, response);
		}
	}

	private void manageDeletePaperProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		String paperID = request.getParameter(PaperConstants.Field_PaperID);
		if (paperID == null) {
			status.put(DBMSAction.PaperDelete, DBMSStatus.PaperMissingIdentifier);
		} else {
			status.putAll(dbms.removePaper(paperID));
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageModifyPaperProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		PaperBean pb = null;
		String paperID = request.getParameter(PaperConstants.Field_PaperID);
		if (paperID != null) {
			List<PaperBean> lpb = dbms.getPaperByID(paperID);
			if (lpb != null && lpb.size() == 1) {
				pb = lpb.get(0);
			}
		}
		if (pb == null) {
			status.put(DBMSAction.PaperUpdate, DBMSStatus.NoSuchElement);
		} else {
			String ranking_ccf = request.getParameter(PaperConstants.Field_Ranking_CCF);
			String ranking_core = request.getParameter(PaperConstants.Field_Ranking_CORE);
			String[] authorIDs = request.getParameterValues(PaperConstants.Field_AuthorID);
			if (ranking_ccf != null && ranking_core != null && authorIDs != null) {
				pb.setRankingCCF(ranking_ccf);
				pb.setRankingCORE(ranking_core);
				manageUpload(request, pb, status);
				status.putAll(dbms.updatePaper(pb, new HashSet<>(Arrays.asList(authorIDs))));
			} else {
				status.put(DBMSAction.PaperUpdate, DBMSStatus.IllegalArgument);
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageDownloadPDF(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		PaperBean pb = null;
		String paperID = request.getParameter(PaperConstants.Field_PaperID);
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
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageLinkProjectsToPaperProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		String paperID = request.getParameter(PaperConstants.Field_PaperID);
		if (paperID == null) {
			status.put(DBMSAction.PaperProjectLink, DBMSStatus.PaperMissingIdentifier);
		} else {
			String[] projectIDs = request.getParameterValues(PaperConstants.Field_ProjectID);
			if (projectIDs == null || projectIDs.length == 0) {
				status.put(DBMSAction.PaperProjectLink, DBMSStatus.PaperMissingProjects);
			} else {
				status.putAll(dbms.storeProjectsForPaper(projectIDs, paperID));
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void manageDelinkProjectsFromPaperProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<DBMSAction, DBMSStatus> status = new HashMap<>();
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		
		String paperID = request.getParameter(PaperConstants.Field_PaperID);
		if (paperID == null) {
			status.put(DBMSAction.PaperProjectLink, DBMSStatus.PaperMissingIdentifier);
		} else {
		String[] projectIDs = request.getParameterValues(ProjectConstants.Field_ProjectID);
			if (projectIDs == null || projectIDs.length == 0) {
				status.put(DBMSAction.PaperProjectDelink, DBMSStatus.PaperMissingProjects);
			} else {
				status.putAll(dbms.removeProjectsFromPaper(projectIDs, paperID));
			}
		}
		request.setAttribute(InternalOperationConstants.StatusOperation, status);
		showDefault(request, response);
	}

	private void showDefault(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		DBMS dbms = (DBMS) getServletContext().getAttribute(DBMS.DBMS_ENTITY);
		List<PaperBean> papers = dbms.getPapers();
		request.setAttribute(PaperConstants.PAPER_LIST_ENTITY, papers);
		showForm(PaperConstants.Action_GetAllPapers, request, response);		
	}

	private void showForm(String form, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("WEB-INF/jspf/Paper_" + form + ".jsp").forward(request, response);		
	}

	private void manageUpload(HttpServletRequest request, PaperBean pb, Map<DBMSAction, DBMSStatus> status) throws ServletException, IOException {
		Part part = request.getPart(PaperConstants.Field_PaperFile);
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

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
