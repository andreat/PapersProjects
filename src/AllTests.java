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
import java.io.ByteArrayInputStream;
import java.io.InputStream;

import org.junit.Ignore;
import org.junit.Test;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.article.ArticleParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.inproceedings.InproceedingsParser;
import cn.ac.ios.iscasmc.papersprojects.backend.parser.proceedings.ProceedingsParser;

public class AllTests {

	@Test
	public void testProceedingsParser() {
		String proceedings = "@proceedings{DBLP:conf/concur/2017,\n" + 
				"  editor    = {Roland Meyer and\n" + 
				"               Uwe Nestmann},\n" + 
				"  title     = {28th International Conference on Concurrency Theory, {CONCUR} 2017,\n" + 
				"               September 5-8, 2017, Berlin, Germany},\n" + 
				"  series    = {LIPIcs},\n" + 
				"  volume    = {85},\n" + 
				"  publisher = {Schloss Dagstuhl - Leibniz-Zentrum fuer Informatik},\n" + 
				"  year      = {2017},\n" + 
				"  url       = {http://www.dagstuhl.de/dagpub/978-3-95977-048-4},\n" + 
				"  isbn      = {978-3-95977-048-4},\n" + 
				"  timestamp = {Wed, 27 Sep 2017 13:49:17 +0200},\n" + 
				"  biburl    = {http://dblp.org/rec/bib/conf/concur/2017},\n" + 
				"  bibsource = {dblp computer science bibliography, http://dblp.org}\n" + 
				"}";
		InputStream stream = new ByteArrayInputStream(proceedings.getBytes());
		ProceedingsParser pp = new ProceedingsParser(stream);
		ConferenceBean cb = pp.parseProceedings();
		int i = 0;
	}
	
	@Test
	public void testInproceedingsParser() {
		String inproceedings = "@inproceedings{DBLP:conf/concur/FengHTY17,\n" + 
				"  author    = {Yuan Feng and\n" + 
				"               Ernst Moritz Hahn and\n" + 
				"               Andrea Turrini and\n" + 
				"               Shenggang Ying},\n" + 
				"  title     = {Model Checking Omega-regular Properties for Quantum Markov Chains},\n" + 
				"  booktitle = {28th International Conference on Concurrency Theory, {CONCUR} 2017,\n" + 
				"               September 5-8, 2017, Berlin, Germany},\n" + 
				"  pages     = {35:1--35:16},\n" + 
				"  year      = {2017},\n" + 
				"  crossref  = {DBLP:conf/concur/2017},\n" + 
				"  url       = {https://doi.org/10.4230/LIPIcs.CONCUR.2017.35},\n" + 
				"  doi       = {10.4230/LIPIcs.CONCUR.2017.35},\n" + 
				"  timestamp = {Thu, 28 Sep 2017 13:37:47 +0200},\n" + 
				"  biburl    = {http://dblp.org/rec/bib/conf/concur/FengHTY17},\n" + 
				"  bibsource = {dblp computer science bibliography, http://dblp.org}\n" + 
				"}";
		InputStream stream = new ByteArrayInputStream(inproceedings.getBytes());
		InproceedingsParser pp = new InproceedingsParser(stream);
		PaperBean pb = pp.parseInproceedings();
		int i = 0;
	}
	
	@Test
	public void testArticleParser() {
		String article = "@article{DBLP:journals/fac/FioritiHHT16,\n" + 
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
		InputStream stream = new ByteArrayInputStream(article.getBytes());
		ArticleParser ap = new ArticleParser(stream);
		PaperBean pb = ap.parseArticle();
		int i = 0;
	}
}
