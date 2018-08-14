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
package cn.ac.ios.iscasmc.papersprojects.backend.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Andrea Turrini
 */
public class PaperBean implements Serializable {
	private static final long serialVersionUID = -5392863658737807694L;

	private String identifier = null;
	
	private String title = null;
	private List<AuthorBean> authors = null;
	private String booktitle = null;
	private String year = null;
	private String pages = null;
	private String volume = null;
	private String number = null;
	private String crossref = null;
	private String doi = null;
	private String url = null;
	private String filepath = null;
	private String rankingCCF = null;
	private String rankingCORE = null;
	 
	private ConferenceBean conference;
	private JournalBean journal;
	
	private List<ProjectBean> projects;
	
	public void setAuthorsFromBibtex(String authors) {
		String[] split = authors.split(" and( |\n|\r)");
		this.authors = new ArrayList<>(split.length);
		for (String s : split) {
			AuthorBean ab = new AuthorBean();
			ab.setName(s.trim());
			this.authors.add(ab);
		}
	}
	
	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public List<AuthorBean> getAuthors() {
		return authors;
	}

	public void setAuthors(List<AuthorBean> authors) {
		this.authors = authors;
	}

	public String getBooktitle() {
		return booktitle;
	}

	public void setBooktitle(String booktitle) {
		this.booktitle = booktitle;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getVolume() {
		return volume;
	}

	public void setVolume(String volume) {
		this.volume = volume;
	}

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public String getPages() {
		return pages;
	}

	public void setPages(String pages) {
		this.pages = pages;
	}

	public String getCrossref() {
		return crossref;
	}

	public void setCrossref(String crossref) {
		this.crossref = crossref;
	}

	public String getDoi() {
		return doi;
	}

	public void setDoi(String doi) {
		this.doi = doi;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public ConferenceBean getConference() {
		return conference;
	}

	public String getFilepath() {
		return filepath;
	}

	public void setFilepath(String filepath) {
		this.filepath = filepath;
	}
	
	public String getRankingCCF() {
		return rankingCCF;
	}
	
	public void setRankingCCF(String ranking) {
		this.rankingCCF = ranking;
	}

	public String getRankingCORE() {
		return rankingCORE;
	}
	
	public void setRankingCORE(String ranking) {
		this.rankingCORE = ranking;
	}

	public void setConference(ConferenceBean conference) {
		this.conference = conference;
	}

	public JournalBean getJournal() {
		return journal;
	}

	public void setJournal(JournalBean journal) {
		this.journal = journal;
	}

	public List<ProjectBean> getProjects() {
		return projects;
	}

	public void setProjects(List<ProjectBean> projects) {
		this.projects = projects;
	}

}
