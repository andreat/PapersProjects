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

public final class PaperConstants {
	public static final String Action_CreateArticle_Form = "CreateArticleForm";
	public static final String Action_CreateArticle_Process = "CreateArticleProcess";
	public static final String Action_CreateInproceedings_Form = "CreateInproceedingsForm";
	public static final String Action_CreateInproceedings_Process = "CreateInproceedingsProcess";
	public static final String Action_DeletePaper_Form = "DeletePaperForm";
	public static final String Action_DeletePaper_Process = "DeletePaperProcess";
	public static final String Action_ModifyPaper_Form = "ModifyPaperForm";
	public static final String Action_ModifyPaper_Process = "ModifyPaperProcess";

	public static final String Action_DownloadPDF = "DownloadPDF";

	public static final String Action_GetPapersForAuthor = "GetPapersForAuthor";
	public static final String Action_GetPapersForYear = "GetPapersForYear";
	public static final String Action_GetPapersForRank = "GetPapersForRank";
	public static final String Action_GetPapersForProject = "GetPapersForProject";
	public static final String Action_GetAllPapers = "GetAllPapers";
	public static final String Action_GetFullDetailsForPaper = "GetFullDetailsForPaper";
	
	public static final String Action_LinkProjectsToPaper_Form = "LinkProjectsToPaperForm";
	public static final String Action_LinkProjectsToPaper_Process = "LinkProjectsToPaperProcess";
	public static final String Action_DelinkProjectsFromPaper_Process = "DelinkProjectsFromPaperProcess";
	
	public static final String Field_Bibtex_Inproceedings = "InproceedingsContent";
	public static final String Field_Bibtex_Proceedings = "ProceedingsContent";
	public static final String Field_Bibtex_Article = "ArticleContent";
	public static final String Field_Ranking = "Ranking";
	public static final String Field_PaperFile = "PaperFile";
	public static final String Field_RemoveLaTeXMarkers = "RemoveLaTeXMarkers";
	public static final String Field_Action= "Action";
	public static final String Field_AuthorID = "AuthorID";
	public static final String Field_PaperID = "PaperID";
	public static final String Field_ProjectID = "ProjectID";
	public static final String Field_Year = "Year";
	
	public static final String RankingA = "RankingA";
	public static final String RankingB = "RankingB";
	public static final String RankingC = "RankingC";
	public static final String RankingNotRanked = "RankingNotRanked";
	
	public static String getRank(String rank) {
		if (rank == null) {
			return "Not ranked";
		}
		switch(rank) {
		case RankingA:
			return "CCF A/Core A*";
		case RankingB:
			return "CCF B/Core A";
		case RankingC:
			return "CCF C/Core B";
		default:
			return "Not ranked";
		}
	}
	
	private PaperConstants() {}
}
