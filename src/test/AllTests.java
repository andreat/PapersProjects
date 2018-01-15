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
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.sql.Date;
import java.util.Map;

import org.junit.Ignore;
import org.junit.Test;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSAction;
import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMSStatus;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.article.ArticleParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.inproceedings.InproceedingsParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.marker.MarkersParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.proceedings.ProceedingsParser;

public class AllTests {
	
	private final String proceedings = "@proceedings{DBLP:journals/corr/BertrandB14,\n" + 
			"  editor    = {Nathalie Bertrand and\n" + 
			"               Luca Bortolussi},\n" + 
			"  title     = {Proceedings Twelfth International Workshop on Quantitative Aspects\n" + 
			"               of Programming Languages and Systems, {QAPL} 2014, Grenoble, France,\n" + 
			"               12-13 April 2014},\n" + 
			"  series    = {{EPTCS}},\n" + 
			"  volume    = {154},\n" + 
			"  year      = {2014},\n" + 
			"  url       = {https://doi.org/10.4204/EPTCS.154},\n" + 
			"  doi       = {10.4204/EPTCS.154},\n" + 
			"  timestamp = {Wed, 03 May 2017 14:47:56 +0200},\n" + 
			"  biburl    = {http://dblp.org/rec/bib/journals/corr/BertrandB14},\n" + 
			"  bibsource = {dblp computer science bibliography, http://dblp.org}\n" + 
			"}";

	private final String inproceedings = "@inproceedings{DBLP:journals/corr/abs-1111-4385,\n" + 
			"  author    = {David Spieler and\n" + 
			"               Ernst Moritz Hahn and\n" + 
			"               Lijun Zhang},\n" + 
			"  title     = {Model Checking {CSL} for Markov Population Models},\n" + 
			"  booktitle = {Proceedings Twelfth International Workshop on Quantitative Aspects\n" + 
			"               of Programming Languages and Systems, {QAPL} 2014, Grenoble, France,\n" + 
			"               12-13 April 2014.},\n" + 
			"  pages     = {93--107},\n" + 
			"  year      = {2014},\n" + 
			"  crossref  = {DBLP:journals/corr/BertrandB14},\n" + 
			"  url       = {https://doi.org/10.4204/EPTCS.154.7},\n" + 
			"  doi       = {10.4204/EPTCS.154.7},\n" + 
			"  timestamp = {Wed, 03 May 2017 14:47:56 +0200},\n" + 
			"  biburl    = {http://dblp.org/rec/bib/journals/corr/abs-1111-4385},\n" + 
			"  bibsource = {dblp computer science bibliography, http://dblp.org}\n" + 
			"}";

	private final String article = "@article{DBLP:journals/fac/FioritiHHT16,\n" + 
			"  author    = {Luis Mar{\\'{\\i}}a Ferrer Fioriti and\n" + 
			"               Vahid Hashemi and\n" + 
			"               Holger Hermanns and\n" + 
			"               Andrea Turrini},\n" + 
			"  title     = {Deciding probabilistic automata weak bisimulation: theory and practice},\n" + 
			"  journal   = {Formal Asp. Comput.},\n" + 
			"  volume    = {28},\n" + 
			"  number    = {1},\n" + 
			"  pages     = {109--143},\n" + 
			"  year      = {2016},\n" + 
			"  url       = {https://doi.org/10.1007/s00165-016-0356-4},\n" + 
			"  doi       = {10.1007/s00165-016-0356-4},\n" + 
			"  timestamp = {Wed, 17 May 2017 14:25:34 +0200},\n" + 
			"  biburl    = {http://dblp.org/rec/bib/journals/fac/FioritiHHT16},\n" + 
			"  bibsource = {dblp computer science bibliography, http://dblp.org}\n" + 
			"}";

	private final String markers = "Mar{\\'{\\i}}a";
	private final String markersOut = "Marı́a";

	@Test 
	public void testMarkerParser() {
		InputStream stream = new ByteArrayInputStream(markers.getBytes());
		MarkersParser mp = new MarkersParser(stream);
		String parsed = mp.parseMarkers();
		assertEquals(parsed, markersOut);
	}
	
	@Test
	public void testProceedingsParser() {
		InputStream stream = new ByteArrayInputStream(proceedings.getBytes());
		ProceedingsParser pp = new ProceedingsParser(stream);
		ConferenceBean cb = pp.parseProceedings(true);
		int i = 0;
	}
	
	@Test
	public void testInproceedingsParser() {
		InputStream stream = new ByteArrayInputStream(inproceedings.getBytes());
		InproceedingsParser pp = new InproceedingsParser(stream);
		PaperBean pb = pp.parseInproceedings(true);
		int i = 0;
	}
	
	@Test
	public void testArticleParser() {
		InputStream stream = new ByteArrayInputStream(article.getBytes());
		ArticleParser ap = new ArticleParser(stream);
		PaperBean pb = ap.parseArticle(true);
		int i = 0;
	}
	
	
	@Test
	public void insertConference() {
		InputStream stream = new ByteArrayInputStream(proceedings.getBytes());
		ProceedingsParser pp = new ProceedingsParser(stream);
		ConferenceBean cb = pp.parseProceedings(false);
		
		DBMS dbms = new DBMS("com.mysql.jdbc.Driver", "localhost", "3306", "papersprojects", "ppuser", "pppassword");
		Map<DBMSAction, DBMSStatus> statusMap = dbms.storeConference(cb);
		assertEquals(DBMSStatus.Success, statusMap.get(DBMSAction.ConferenceInsert));
	}

	@Test
	public void insertInproceedings() {
		InputStream stream = new ByteArrayInputStream(inproceedings.getBytes());
		InproceedingsParser ip = new InproceedingsParser(stream);
		PaperBean pb = ip.parseInproceedings(false);
		
		DBMS dbms = new DBMS("com.mysql.jdbc.Driver", "localhost", "3306", "papersprojects", "ppuser", "pppassword");
		Map<DBMSAction, DBMSStatus> statusMap = dbms.storePaper(pb);
		assertEquals(DBMSStatus.Success, statusMap.get(DBMSAction.PaperInsert));
	}

	@Test
	public void insertArticle() {
		InputStream stream = new ByteArrayInputStream(article.getBytes());
		ArticleParser ap = new ArticleParser(stream);
		PaperBean pb = ap.parseArticle(false);
		
		DBMS dbms = new DBMS("com.mysql.jdbc.Driver", "localhost", "3306", "papersprojects", "ppuser", "pppassword");
		Map<DBMSAction, DBMSStatus> statusMap = dbms.storePaper(pb);
		assertEquals(DBMSStatus.Success, statusMap.get(DBMSAction.PaperInsert));
	}
	
	@Test
	public void insertProject() {
		ProjectBean pb = new ProjectBean();
		pb.setIdentifier("project1");
		pb.setFunder("funder1");
		pb.setTitle("title1");
		pb.setAcknowledge("ack1");
		pb.setStartDate(Date.valueOf("2017-12-29"));
		pb.setEndDate(Date.valueOf("2018-12-29"));
		
		DBMS dbms = new DBMS("com.mysql.jdbc.Driver", "localhost", "3306", "papersprojects", "ppuser", "pppassword");
		Map<DBMSAction, DBMSStatus> statusMap = dbms.storeProject(pb);
		assertEquals(DBMSStatus.Success, statusMap.get(DBMSAction.ProjectInsert));
	}
}
