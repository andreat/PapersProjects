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

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.JournalBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.ProjectBean;

/**
 *
 * @author Andrea Turrini
 */
public class DBMS {
	public static final String DBMS_ENTITY = "DBMS_ENTITY";
	
	/**
	 * The connection to the database, kept active
	 */
	private static Connection connection;
	private final String url;
	private final String username;
	private final String password;
	private final boolean initialized;
	
	/**
	 * The constructor just loads the mysql connector driver
	 * @param connectorClass the connector class to be loaded to connect to the database
	 * @param host the host name/ip address where mysql is running
	 * @param port the corresponding port
	 * @param database the database to use
	 * @param username the username for the authentication
	 * @param password the corresponding password
	 * @throws DBException in case of problems with loading the jdbc connector
	 */
	public DBMS(String connectorClass, String host, String port, String database, String username, String password) {
		this.url = "jdbc:mysql://" + host + ":" + port + "/" + database;
		this.username = username;
		this.password = password;
		connection = null;
		try {
			Class.forName(connectorClass);
		} catch (ClassNotFoundException cnfe) {
			this.initialized = false;
			return;
		}
		this.initialized = true;
	}
	
	public boolean isInitialized() {
		return initialized;
	}
	
	public void closeConnection() {
		try {
			if (connection != null) {
				connection.close();
				connection = null;
			}
		} catch (SQLException se) {}		
	}
	
	public Map<DBMSAction, DBMSStatus> storeAuthor(AuthorBean ab) {
		List <AuthorBean> list = new ArrayList<AuthorBean>(1);
		list.add(ab);
		return storeAuthors(list);		
	}
	
	public Map<DBMSAction, DBMSStatus> storeConference(ConferenceBean cb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from conference where identifier = ?;");
			ps.setString(1, cb.getIdentifier());
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (isPresent) {
				statusMap.put(DBMSAction.ConferenceInsert, DBMSStatus.DuplicatedEntry);
			} else {
				ps = connection.prepareStatement("insert into conference values(?,?,?,?,?,?,?,?,?)");
				ps.setString(1, cb.getIdentifier());
				ps.setString(2, cb.getTitle());
				ps.setString(3, cb.getYear());
				ps.setString(4, cb.getSeries());
				ps.setString(5, cb.getVolume());
				ps.setString(6, cb.getEditor());
				ps.setString(7, cb.getPublisher());
				ps.setString(8, cb.getUrl());
				ps.setString(9, cb.getIsbn());
				ps.executeUpdate();
				connection.commit();
				statusMap.put(DBMSAction.ConferenceInsert, DBMSStatus.Success);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.ConferenceInsert, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> storeAuthors(List<AuthorBean> listAuthors) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("insert ignore into author values(?)");
			for (AuthorBean ab : listAuthors) {
				ps.setString(1, ab.getName());
				ps.addBatch();
			}
			ps.executeBatch();
			connection.commit();
			statusMap.put(DBMSAction.AuthorInsert, DBMSStatus.Success);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.AuthorInsert, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> storePaper(PaperBean pb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from paper where identifier = ?;");
			ps.setString(1, pb.getIdentifier());
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (isPresent) {
				statusMap.put(DBMSAction.PaperInsert, DBMSStatus.DuplicatedEntry);
			} else {
				ps = connection.prepareStatement("insert into paper values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
				ps.setString(1, pb.getIdentifier());
				ps.setString(2, pb.getTitle());
				ps.setString(3, pb.getBooktitle());
				ps.setString(4, pb.getYear());
				ps.setString(5, pb.getPages());
				ps.setString(6, pb.getVolume());
				ps.setString(7, pb.getNumber());
				ps.setString(8, pb.getCrossref());
				JournalBean jb = pb.getJournal();
				if (jb == null) {
					ps.setString(9, null);
				} else {
					ps.setString(9, jb.getIdentifier());
				}
				ps.setString(10, pb.getDoi());
				ps.setString(11, pb.getUrl());
				ps.setString(12, pb.getFilepath());
				ps.setString(13, pb.getRanking());
				ps.executeUpdate();
				connection.commit();
				statusMap.put(DBMSAction.PaperInsert, DBMSStatus.Success);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperInsert, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		statusMap.putAll(storeAuthors(pb.getAuthors()));
		statusMap.putAll(storeAuthorsForPaper(pb));
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> removePaper(String paperID) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("delete from paper where identifier = ?");
			ps.setString(1, paperID);
			int updates = ps.executeUpdate();
			connection.commit();
			if (updates > 0) {
				statusMap.put(DBMSAction.PaperDelete, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.PaperDelete, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperDelete, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> updatePaper(PaperBean pb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement psr = null;
		PreparedStatement psf = null;
		try {
			connection.setAutoCommit(false);
			psr = connection.prepareStatement("update paper set ranking = ? where identifier = ?");
			psr.setString(1, pb.getRanking());
			psr.setString(2, pb.getIdentifier());
			int updates = psr.executeUpdate();
			if (pb.getFilepath() != null) {
				psf = connection.prepareStatement("update paper set filepath = ? where identifier = ?");
				psf.setString(1, pb.getFilepath());
				psf.setString(2, pb.getIdentifier());
				updates += psf.executeUpdate();
			}
			connection.commit();
			if (updates > 0) {
				statusMap.put(DBMSAction.PaperUpdate, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.PaperUpdate, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperUpdate, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (psr != null) {
						psr.close();
					}
				} catch (SQLException se) {}
				try {
					if (psf != null) {
						psf.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> updatePaperPDF(PaperBean pb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("update paper set filepath = ? where identifier = ?");
			ps.setString(1, pb.getFilepath());
			ps.setString(2, pb.getIdentifier());
			int updates = ps.executeUpdate();
			connection.commit();
			if (updates > 0) {
				statusMap.put(DBMSAction.PaperUpdate, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.PaperUpdate, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperInsert, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> storeAuthorsForPaper(PaperBean pb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from paper where identifier = ?;");
			ps.setString(1, pb.getIdentifier());
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (isPresent) {
				ps = connection.prepareStatement("insert ignore into paperAuthor values(?,?,?)");
				int order = 1;
				for (AuthorBean ab : pb.getAuthors()) {
					ps.setString(1, pb.getIdentifier());
					ps.setString(2, ab.getName());
					ps.setInt(3, order++);
					ps.addBatch();
				}
				ps.executeBatch();
				connection.commit();
				statusMap.put(DBMSAction.PaperAuthorLink, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.PaperAuthorLink, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperAuthorLink, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> storeProject(ProjectBean pb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from project where identifier = ?;");
			ps.setString(1, pb.getIdentifier());
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (isPresent) {
				statusMap.put(DBMSAction.ProjectInsert, DBMSStatus.DuplicatedEntry);
			} else {
				ps = connection.prepareStatement("insert into project values(?,?,?,?,?,?)");
				ps.setString(1, pb.getIdentifier());
				ps.setString(2, pb.getFunder());
				ps.setString(3, pb.getTitle());
				ps.setString(4, pb.getAcknowledge());
				ps.setDate(5, pb.getStartDate());
				ps.setDate(6, pb.getEndDate());
				ps.executeUpdate();
				connection.commit();
				statusMap.put(DBMSAction.ProjectInsert, DBMSStatus.Success);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.ProjectInsert, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> updateProject(ProjectBean pb) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from project where identifier = ?;");
			ps.setString(1, pb.getIdentifier());
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (!isPresent) {
				statusMap.put(DBMSAction.ProjectUpdate, DBMSStatus.ProjectMissingIdentifier);
			} else {
				ps = connection.prepareStatement("update project set funder = ?, title = ?, acknowledge = ?, startDate = ?, endDate = ? where identifier = ?;");
				ps.setString(6, pb.getIdentifier());
				ps.setString(1, pb.getFunder());
				ps.setString(2, pb.getTitle());
				ps.setString(3, pb.getAcknowledge());
				ps.setDate(4, pb.getStartDate());
				ps.setDate(5, pb.getEndDate());
				ps.executeUpdate();
				connection.commit();
				statusMap.put(DBMSAction.ProjectUpdate, DBMSStatus.Success);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.ProjectUpdate, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> removeProject(String projectID) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("delete from project where identifier = ?");
			ps.setString(1, projectID);
			int updates = ps.executeUpdate();
			connection.commit();
			if (updates > 0) {
				statusMap.put(DBMSAction.ProjectDelete, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.ProjectDelete, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.ProjectDelete, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}
	
	public Map<DBMSAction, DBMSStatus> storePapersForProject(String[] paperIDs, String projectID) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from project where identifier = ?;");
			ps.setString(1, projectID);
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (isPresent) {
				ps = connection.prepareStatement("insert ignore into projectPaper values(?,?)");
				for (String paperID : paperIDs) {
					ps.setString(1, projectID);
					ps.setString(2, paperID);
					ps.addBatch();
				}
				ps.executeBatch();
				connection.commit();
				statusMap.put(DBMSAction.ProjectPaperLink, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.ProjectPaperLink, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.ProjectPaperLink, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}

	public Map<DBMSAction, DBMSStatus> removePapersFromProject(String[] paperIDs, String projectID) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("delete from projectPaper where projectIdentifier = ? and paperIdentifier = ?;");
			for (String paperID : paperIDs) {
				ps.setString(1, projectID);
				ps.setString(2, paperID);
				ps.addBatch();
			}
			ps.executeBatch();
			connection.commit();
			statusMap.put(DBMSAction.ProjectPaperDelink, DBMSStatus.Success);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.ProjectPaperDelink, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}

	public Map<DBMSAction, DBMSStatus> storeProjectsForPaper(String[] projectIDs, String paperID) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from paper where identifier = ?;");
			ps.setString(1, paperID);
			rs = ps.executeQuery();
			boolean isPresent = rs.next();
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
					ps = null;
				}
			} catch (SQLException se) {}
			if (isPresent) {
				ps = connection.prepareStatement("insert ignore into projectPaper values(?,?)");
				for (String projectID : projectIDs) {
					ps.setString(1, projectID);
					ps.setString(2, paperID);
					ps.addBatch();
				}
				ps.executeBatch();
				connection.commit();
				statusMap.put(DBMSAction.PaperProjectLink, DBMSStatus.Success);
			} else {
				statusMap.put(DBMSAction.PaperProjectLink, DBMSStatus.NoSuchElement);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperProjectLink, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}

	public Map<DBMSAction, DBMSStatus> removeProjectsFromPaper(String[] projectIDs, String paperID) {
		Map<DBMSAction, DBMSStatus> statusMap = new HashMap<>();
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			statusMap.put(DBMSAction.ConnectDatabase, status);
			return statusMap;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("delete from projectPaper where projectIdentifier = ? and paperIdentifier = ?;");
			for (String projectID : projectIDs) {
				ps.setString(1, projectID);
				ps.setString(2, paperID);
				ps.addBatch();
			}
			ps.executeBatch();
			connection.commit();
			statusMap.put(DBMSAction.PaperProjectDelink, DBMSStatus.Success);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			statusMap.put(DBMSAction.PaperProjectDelink, DBMSStatus.SQLFailed);
		} finally {
			try {
				connection.setAutoCommit(true);
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
		return statusMap;
	}

	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapers() {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		Statement st = null;
		ResultSet rs = null;
		try {
			st = connection.createStatement();
			rs = st.executeQuery("select * from paper;");
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (st != null) {
					st.close();
				}
			} catch (SQLException se) {}
		}
		if (papers != null) {
			fillAuthors(papers);
		}
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred or the paper is not found
	 */
	public List<PaperBean> getPaperByID(String paperID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select * from paper where identifier = ?;");
			ps.setString(1, paperID);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		if (papers != null && papers.size() == 1) {
			fillAuthors(papers);
			return papers;
		} else {
			return null;
		}
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersWrittenByAuthor(String authorID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(
					"select * from paper "
					+ "inner join paperAuthor on paper.identifier = paperAuthor.paperIdentifier "
					+ "where authorName = ?;"
					);
			ps.setString(1, authorID);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersAcknowledgingProject(String projectID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(
					"select * from paper "
					+ "inner join projectPaper on paper.identifier = projectPaper.paperIdentifier "
					+ "where projectIdentifier = ?;"
					);
			ps.setString(1, projectID);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersNotAcknowledgingProject(String projectID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(
					"select * from paper "
					+ "where identifier not in ("
					+ "select distinct paperIdentifier from projectPaper "
					+ "where projectIdentifier = ?"
					+ ");"
					);
			ps.setString(1, projectID);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersPublishedInYear(int year) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select * from paper where year = ?;");
			ps.setInt(1, year);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersByRank(String rank) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select * from paper where ranking = ?;");
			ps.setString(1, rank);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			papers = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ProjectBean> getProjects() {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<ProjectBean> projects;
		Statement st = null;
		ResultSet rs = null;
		try {
			st = connection.createStatement();
			rs = st.executeQuery("select * from project;");
			projects = generateProjects(rs);
		} catch (SQLException sqle) {
			projects = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (st != null) {
					st.close();
				}
			} catch (SQLException se) {}
		}
		return projects;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred or the paper is not found
	 */
	public ProjectBean getProjectByID(String projectID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<ProjectBean> projects;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select * from project where identifier = ?;");
			ps.setString(1, projectID);
			rs = ps.executeQuery();
			projects = generateProjects(rs);
		} catch (SQLException sqle) {
			projects = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		if (projects != null && projects.size() == 1) {
			return projects.get(0);
		} else {
			return null;
		}
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ProjectBean> getProjectsInvolvingAuthor(String authorID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<ProjectBean> projects;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(
					"select * from project "
					+ "inner join projectPaper on project.identifier = projectPaper.projectIdentifier "
					+ "inner join paperAuthor on projectPaper.paperIdentifier = paperAuthor.paperIdentifier "
					+ "where authorName = ? "
					+ "group by project.identifier;");
			ps.setString(1, authorID);
			rs = ps.executeQuery();
			projects = generateProjects(rs);
		} catch (SQLException sqle) {
			projects = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		return projects;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ProjectBean> getProjectsAcknowledgedInYear(int year) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<ProjectBean> projects;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select distinct * from project "
					+ "inner join projectPaper on project.identifier = projectPaper.projectIdentifier "
					+ "where year = ?;");
			ps.setInt(1, year);
			rs = ps.executeQuery();
			projects = generateProjects(rs);
		} catch (SQLException sqle) {
			projects = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		return projects;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ProjectBean> getProjectsAcknowledgedByPaper(String paperID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<ProjectBean> projects;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(
					"select * from project "
					+ "inner join projectPaper on project.identifier = projectPaper.projectIdentifier "
					+ "where paperIdentifier = ?;");
			ps.setString(1, paperID);
			rs = ps.executeQuery();
			projects = generateProjects(rs);
		} catch (SQLException sqle) {
			projects = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		return projects;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ProjectBean> getProjectsNotAcknowledgedByPaper(String paperID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<ProjectBean> projects;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(
					"select * from project "
					+ "where identifier not in ( "
					+ "select distinct projectIdentifier from projectPaper "
					+ "where paperIdentifier = ? "
					+ ");");
			ps.setString(1, paperID);
			rs = ps.executeQuery();
			projects = generateProjects(rs);
		} catch (SQLException sqle) {
			projects = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		return projects;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<AuthorBean> getAuthors() {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}
		
		List<AuthorBean> authors;
		Statement st = null;
		ResultSet rs = null;
		try {
			st = connection.createStatement();
			rs = st.executeQuery("select * from author;");
			authors = generateAuthors(rs);
		} catch (SQLException sqle) {
			authors = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (st != null) {
					st.close();
				}
			} catch (SQLException se) {}
		}
		return authors;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public AuthorBean getAuthorByID(String authorID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}
		
		List<AuthorBean> authors;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select * from author where name = ?;");
			ps.setString(1, authorID);
			rs = ps.executeQuery();
			authors = generateAuthors(rs);
		} catch (SQLException sqle) {
			authors = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		if (authors != null && authors.size() == 1) {
			return authors.get(0);
		} else {
			return null;
		}
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ConferenceBean> getConferences() {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}
		
		List<ConferenceBean> conferences;
		Statement st = null;
		ResultSet rs = null;
		try {
			st = connection.createStatement();
			rs = st.executeQuery("select * from conference;");
			conferences = generateConferences(rs);
		} catch (SQLException sqle) {
			conferences = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (st != null) {
					st.close();
				}
			} catch (SQLException se) {}
		}
		return conferences;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<ConferenceBean> getConferenceByID(String conferenceID) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}
		
		List<ConferenceBean> conferences;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement("select * from conference where identifier = ?;");
			ps.setString(1, conferenceID);
			rs = ps.executeQuery();
			conferences = generateConferences(rs);
		} catch (SQLException sqle) {
			conferences = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException se) {}
		}
		return conferences;
	}
	
	public int getFirstYear() {
		int year = -1;
		
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return year;
		}
		
		Statement st = null;
		ResultSet rs = null;
		try {
			st = connection.createStatement();
			rs = st.executeQuery("select min(year) as minYear from paper;");
			if (rs.next()) {
				year = rs.getInt("minYear");
			}
		} catch (SQLException sqle) {
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException se) {}
			try {
				if (st != null) {
					st.close();
				}
			} catch (SQLException se) {}
		}
		return year;
	}
	
	private DBMSStatus establishConnection() {
		boolean isValid = true;
		if (connection != null){
			Statement st = null;
			ResultSet rs = null;
			try {
				st = connection.createStatement();
				rs = st.executeQuery("select 1;");
				connection.setAutoCommit(true);
			} catch (SQLException se) {
				isValid = false;
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (st != null) {
						st.close();
					}
				} catch (SQLException se) {}
			}
			if (isValid) {
				return DBMSStatus.Success;
			}
		}
		try {
			connection = DriverManager.getConnection(url, username, password);
		} catch (SQLException sqle) {
			try {
				if (connection != null) {
					connection.close();
					connection = null;
				}
			} catch (SQLException se) {}
			return DBMSStatus.ConnectionFailed;
		}
		return DBMSStatus.Success;
	}
	
	@Override
	protected void finalize() throws Throwable {
		if (connection != null) {
			connection.close();
		}
		super.finalize();
	}
	
	private List<ConferenceBean> generateConferences(ResultSet rs) throws SQLException {
		List<ConferenceBean> conferences = new ArrayList<>();
		while (rs.next()) {
			ConferenceBean cb = new ConferenceBean();
			cb.setIdentifier(rs.getString("identifier"));
			cb.setTitle(rs.getString("title"));
			cb.setYear(rs.getString("year"));
			cb.setSeries(rs.getString("series"));
			cb.setVolume(rs.getString("volume"));
			cb.setEditor(rs.getString("editor"));
			cb.setPublisher(rs.getString("publisher"));
			cb.setUrl(rs.getString("url"));
			cb.setIsbn(rs.getString("isbn"));
			conferences.add(cb);
		}
		return conferences;
	}
	
	private List<PaperBean> generatePapers(ResultSet rs) throws SQLException {
		List<PaperBean> papers = new ArrayList<>();
		while (rs.next()) {
			PaperBean pb = new PaperBean();
			pb.setIdentifier(rs.getString("identifier"));
			pb.setTitle(rs.getString("title"));
			pb.setBooktitle(rs.getString("booktitle"));
			pb.setYear(rs.getString("year"));
			pb.setPages(rs.getString("pages"));
			pb.setVolume(rs.getString("volume"));
			pb.setNumber(rs.getString("number"));
			pb.setCrossref(rs.getString("crossref"));
			String journal = rs.getString("journal");
			if (journal != null) {
				JournalBean jb = new JournalBean();
				jb.setIdentifier(journal);
				pb.setJournal(jb);
			}
			pb.setDoi(rs.getString("doi"));
			pb.setUrl(rs.getString("url"));
			pb.setFilepath(rs.getString("filepath"));
			pb.setRanking(rs.getString("ranking"));
			papers.add(pb);
		}
		return papers;
	}
	
	private List<ProjectBean> generateProjects(ResultSet rs) throws SQLException {
		List<ProjectBean> projects = new ArrayList<>();
		while (rs.next()) {
			ProjectBean pb = new ProjectBean();
			pb.setIdentifier(rs.getString("identifier"));
			pb.setTitle(rs.getString("title"));
			pb.setFunder(rs.getString("funder"));
			pb.setAcknowledge(rs.getString("acknowledge"));
			pb.setStartDate(rs.getDate("startDate"));
			pb.setEndDate(rs.getDate("endDate"));
			projects.add(pb);
		}
		return projects;
	}
	
	private List<AuthorBean> generateAuthors(ResultSet rs) throws SQLException {
		List<AuthorBean> authors = new ArrayList<>();
		while (rs.next()) {
			AuthorBean ab = new AuthorBean();
			ab.setName(rs.getString("name"));
			authors.add(ab);
		}
		return authors;
	}

	public void fillAuthors(List<PaperBean> papers) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return;
		}

		for (PaperBean pb : papers) {
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				ps = connection.prepareStatement("select authorName as name from paperAuthor where paperIdentifier = ? order by authorOrder;");
				ps.setString(1, pb.getIdentifier());
				rs = ps.executeQuery();
				pb.setAuthors(generateAuthors(rs));
			} catch (SQLException sqle) {
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
				} catch (SQLException se) {}
				try {
					if (ps != null) {
						ps.close();
					}
				} catch (SQLException se) {}
			}
		}
	}
}
