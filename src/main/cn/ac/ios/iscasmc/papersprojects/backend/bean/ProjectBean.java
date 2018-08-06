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
import java.sql.Date;

/**
 *
 * @author Andrea Turrini
 */
public class ProjectBean implements Serializable {
	private static final long serialVersionUID = 4910297251001464051L;
	private String identifier;
	private String funder;
	private String title;
	private String acknowledge;
	
	private Date startDate;
	private Date endDate;

	/**
	 * @return the identifier
	 */
	public String getIdentifier() {
		return identifier;
	}

	/**
	 * @param identifier the identifier to set
	 */
	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	/**
	 * @return the funder
	 */
	public String getFunder() {
		return funder;
	}

	/**
	 * @param funder the funder to set
	 */
	public void setFunder(String funder) {
		this.funder = funder;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * @return the ack
	 */
	public String getAcknowledge() {
		return acknowledge;
	}

	/**
	 * @param acknowledge the acknowledge to set
	 */
	public void setAcknowledge(String acknowledge) {
		this.acknowledge = acknowledge;
	}

	/**
	 * @return the start date
	 */
	public Date getStartDate() {
		return startDate;
	}

	/**
	 * @param startDate the start to set
	 */
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	/**
	 * @return the end date
	 */
	public Date getEndDate() {
		return endDate;
	}

	/**
	 * @param endDate the end to set
	 */
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	
}
