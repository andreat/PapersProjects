/*******************************************************************************
 * Copyright (C) 2017 Andrea Turrini
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
	public static final String Action= "action";
	public static final String AuthorID = "authorID";
	public static final String PaperID = "paperID";
	public static final String ProjectID = "projectID";
	public static final String Year = "year";

	public static final String CreateInproceedings = "createInproceedings";
	public static final String CreateArticle = "createArticle";
	public static final String GetPapersForAuthor = "getPapersForAuthor";
	public static final String GetPapersForYear = "getPapersForYear";
	public static final String GetPapersForRank = "getPapersForRank";
	public static final String GetPapersForProject = "getPapersForProject";
	public static final String GetPapers = "getPapers";
	public static final String GetFullDetailsForPaper = "getFullDetailsForPaper";
	public static final String ModifyPaper = "modifyPaper";
	public static final String DeletePaper = "deletePaper";
	public static final String DeletePaperConfirm = "deletePaperConfirm";

	public static final String LinkProjectsToPaper= "linkProjectsToPaper";
	public static final String DelinkProjectsFromPaper= "delinkProjectsFromPaper";

	public static final String DownloadPDF = "downloadPDF";

	public static final String InproceedingsTextArea = "InproceedingsTextArea";
	public static final String ProceedingsTextArea = "ProceedingsTextArea";
	public static final String ArticleTextArea = "ArticleTextArea";
	public static final String RankingOption = "RankingOption";
	public static final String PaperFile = "PaperFile";
	public static final String RemoveLaTeXMarkers = "RemoveLaTeXMarkers";
	
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
