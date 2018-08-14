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
	public static final String PAPER_LIST_ENTITY = "PaperListEntity";
	
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
	public static final String Action_GetPapersForYearAndRank = "GetPapersForYearAndRank";
	public static final String Action_GetPapersForProject = "GetPapersForProject";
	public static final String Action_GetAllPapers = "GetAllPapers";
	public static final String Action_GetFullDetailsForPaper = "GetFullDetailsForPaper";
	
	public static final String Action_LinkProjectsToPaper_Form = "LinkProjectsToPaperForm";
	public static final String Action_LinkProjectsToPaper_Process = "LinkProjectsToPaperProcess";
	public static final String Action_DelinkProjectsFromPaper_Process = "DelinkProjectsFromPaperProcess";
	
	public static final String Field_Bibtex_Inproceedings = "InproceedingsContent";
	public static final String Field_Bibtex_Proceedings = "ProceedingsContent";
	public static final String Field_Bibtex_Article = "ArticleContent";
	public static final String Field_Ranking_CCF = "RankingCCF";
	public static final String Field_Ranking_CORE = "RankingCORE";
	public static final String Field_PaperFile = "PaperFile";
	public static final String Field_RemoveLaTeXMarkers = "RemoveLaTeXMarkers";
	public static final String Field_Action= "Action";
	public static final String Field_AuthorID = "AuthorID";
	public static final String Field_PaperID = "PaperID";
	public static final String Field_ProjectID = "ProjectID";
	public static final String Field_Year = "Year";
	
	public static final String YearAll = "YearAll";
	public static final String RankingAll = "RankingAll";
	
	public static final String RankingCCF_A = "RankingCCF_A";
	public static final String RankingCCF_B = "RankingCCF_B";
	public static final String RankingCCF_C = "RankingCCF_C";
	public static final String RankingCORE_AStar = "RankingCORE_AStar";
	public static final String RankingCORE_A = "RankingCORE_A";
	public static final String RankingCORE_B = "RankingCORE_B";
	public static final String RankingCORE_C = "RankingCORE_C";
	public static final String RankingNotRanked = "RankingNotRanked";
	
	public static String getRank(String rank) {
		if (rank == null) {
			return "Not ranked";
		}
		switch(rank) {
		case RankingAll:
			return "All ranks";
		case RankingCCF_A:
			return "CCF A";
		case RankingCCF_B:
			return "CCF B";
		case RankingCCF_C:
			return "CCF C";
		case RankingCORE_AStar:
			return "Core A*";
		case RankingCORE_A:
			return "Core A";
		case RankingCORE_B:
			return "Core B";
		case RankingCORE_C:
			return "Core C";
		default:
			return "Not ranked";
		}
	}
	
	private PaperConstants() {}
}
