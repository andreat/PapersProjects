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
package cn.ac.ios.iscasmc.papersprojects.backend.database;

/**
 * Enumeration for representing the errors generated when working with the database
 *
 * @author Andrea Turrini
 */
public enum DBMSStatus {
	
	Success,
	
	DuplicatedEntry,
	
	IllegalArgument,
	
	ParserError,
	
	PDFNotUploaded,
	PDFNotFound,

	PaperMissingProjects,
	PaperMissingIdentifier,

	ProjectMissingIdentifier,
	ProjectMissingFunder,
	ProjectMissingAck,
	ProjectMissingPapers,
	
	/**
	 * Used to represent the request of usage of a DMBS class that is unknown
	 *//**
	 * Used to represent the request of usage of a DMBS class that is unknown
	 */
	UnknownDBMS,

	/**
	 * Used in case the mysql jdbc driver can not be loaded
	 */
	MissingBackend,

	/**
	 * Used in case it is not possible to connect to the database
	 */
	ConnectionFailed,

	/**
	 * Used in case a database action is tried even if the connection has not been established
	 */
	NoConnection,

	/**
	 * Used in case an SQL query is failed 
	 */
	SQLFailed,

	/**
	 * Used in case the required item is not in the database
	 */
	NoSuchElement
}
