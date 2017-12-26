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
import java.util.List;

import cn.ac.ios.iscasmc.papersprojects.backend.bean.AuthorBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.ConferenceBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.JournalBean;
import cn.ac.ios.iscasmc.papersprojects.backend.bean.PaperBean;

/**
 *
 * @author Andrea Turrini
 */
public class DBMS {
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
	 * @param host the host name/ip address where mysql is running
	 * @param port the corresponding port
	 * @param database the database to use
	 * @param username the username for the authentication
	 * @param password the corresponding password
	 * @throws DBException in case of problems with loading the mysql jdbc connector
	 */
	public DBMS(String host, String port, String database, String username, String password) {
		this.url = "jdbc:mysql://" + host + ":" + port + "/" + database;
		this.username = username;
		this.password = password;
		connection = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
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
	
	public DBMSStatus storeAuthor(AuthorBean ab) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return status;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select name from Author where name = ?;");
			ps.setString(1, ab.getName());
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
				status = DBMSStatus.DuplicatedEntry;
			} else {
				ps = connection.prepareStatement("insert into Author values(?)");
				ps.setString(1, ab.getName());
				ps.executeUpdate();
				connection.commit();
				status = DBMSStatus.Success;
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			status = DBMSStatus.SQLFailed;
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
		return status;
	}
	
	public DBMSStatus storeConference(ConferenceBean cb) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return status;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from Conference where identifier = ?;");
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
				return DBMSStatus.DuplicatedEntry;
			} else {
				ps = connection.prepareStatement("insert into Conference values(?,?,?,?,?,?,?,?,?)");
				ps.setString(1, cb.getIdentifier());
				ps.setString(2, cb.getTitle());
				ps.setInt(3, cb.getYear());
				ps.setString(4, cb.getSeries());
				ps.setInt(5, cb.getVolume());
				ps.setString(6, cb.getEditor());
				ps.setString(7, cb.getPublisher());
				ps.setString(8, cb.getUrl());
				ps.setString(9, cb.getIsbn());
				ps.executeUpdate();
				connection.commit();
				status = DBMSStatus.Success;
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			status = DBMSStatus.SQLFailed;
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
		return status;
	}
	
	public DBMSStatus storePaper(PaperBean pb) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return status;
		}
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select identifier from Paper where identifier = ?;");
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
				status = DBMSStatus.DuplicatedEntry;
			} else {
				ps = connection.prepareStatement("insert into Paper values(?,?,?,?,?,?,?,?,?,?,?,?)");
				ps.setString(1, pb.getIdentifier());
				ps.setString(2, pb.getTitle());
				ps.setString(3, pb.getBooktitle());
				ps.setInt(4, pb.getYear());
				ps.setString(5, pb.getPages());
				ps.setInt(6, pb.getVolume());
				ps.setInt(7, pb.getNumber());
				ps.setString(8, pb.getCrossref());
				ps.setString(9, pb.getJournal().getIdentifier());
				ps.setString(10, pb.getDoi());
				ps.setString(11, pb.getUrl());
				ps.setString(12, pb.getFilepath());
				ps.executeUpdate();
				connection.commit();
				status = DBMSStatus.Success;
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			status = DBMSStatus.SQLFailed;
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
		return status;
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
			connection.setAutoCommit(false);
			st = connection.createStatement();
			rs = st.executeQuery("select * from Paper;");
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			papers = null;
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
					if (st != null) {
						st.close();
					}
				} catch (SQLException se) {}
			}
		}
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersFromAuthor(String author) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select * from Paper inner join PaperAuthor on Paper.identifier = PaperAuthor.paperIdentifier where authorName = ?;");
			ps.setString(1, author);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			papers = null;
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
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersFromProject(String project) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select * from Paper inner join ProjectPaper on Paper.identifier = ProjectPaper.paperIdentifier where projectIdentifier = ?;");
			ps.setString(1, project);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			papers = null;
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
		fillAuthors(papers);
		return papers;
	}
	
	/**
	 * 
	 * @return <null> if some SQL error occurred
	 */
	public List<PaperBean> getPapersFromYear(int year) {
		DBMSStatus status = establishConnection();
		if (status != DBMSStatus.Success) {
			return null;
		}

		List<PaperBean> papers;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			ps = connection.prepareStatement("select * from Paper where year = ?;");
			ps.setInt(1, year);
			rs = ps.executeQuery();
			papers = generatePapers(rs);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			papers = null;
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
		fillAuthors(papers);
		return papers;
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
			connection.setAutoCommit(false);
			st = connection.createStatement();
			rs = st.executeQuery("select * from Author;");
			authors = generateAuthors(rs);
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			authors = null;
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
					if (st != null) {
						st.close();
					}
				} catch (SQLException se) {}
			}
		}
		return authors;
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
		
		List<ConferenceBean> conferences = new ArrayList<>();
		Statement st = null;
		ResultSet rs = null;
		try {
			connection.setAutoCommit(false);
			st = connection.createStatement();
			rs = st.executeQuery("select * from Conference;");
			while (rs.next()) {
				ConferenceBean cb = new ConferenceBean();
				cb.setIdentifier(rs.getString("identifier"));
				cb.setTitle(rs.getString("title"));
				cb.setYear(rs.getInt("year"));
				cb.setSeries(rs.getString("series"));
				cb.setVolume(rs.getInt("volume"));
				cb.setEditor(rs.getString("editor"));
				cb.setPublisher(rs.getString("publisher"));
				cb.setUrl(rs.getString("url"));
				cb.setIsbn(rs.getString("isbn"));
				conferences.add(cb);
			}
		} catch (SQLException sqle) {
			try {
				connection.rollback();
			} catch (SQLException se) {}
			conferences = null;
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
					if (st != null) {
						st.close();
					}
				} catch (SQLException se) {}
			}
		}
		return conferences;
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
	
	private List<PaperBean> generatePapers(ResultSet rs) throws SQLException {
		List<PaperBean> papers = new ArrayList<>();
		while (rs.next()) {
			PaperBean pb = new PaperBean();
			pb.setIdentifier(rs.getString("identifier"));
			pb.setTitle(rs.getString("title"));
			pb.setBooktitle(rs.getString("booktitle"));
			pb.setYear(rs.getInt("year"));
			pb.setPages(rs.getString("pages"));
			pb.setVolume(rs.getInt("volume"));
			pb.setNumber(rs.getInt("number"));
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
			papers.add(pb);
		}
		return papers;
	}
	
	private List<AuthorBean> generateAuthors(ResultSet rs) throws SQLException {
		List<AuthorBean> authors = new ArrayList<>();
		while (rs.next()) {
			AuthorBean ab = new AuthorBean();
			ab.setName(rs.getString("Author"));
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
				connection.setAutoCommit(false);
				ps = connection.prepareStatement("select * from PaperAuthor where paperIdentifier = ?;");
				ps.setString(1, pb.getIdentifier());
				rs = ps.executeQuery();
				pb.setAuthors(generateAuthors(rs));
			} catch (SQLException sqle) {
				try {
					connection.rollback();
				} catch (SQLException se) {}
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
		}
	}
	
}
