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

package cn.ac.ios.iscasmc.papersprojects.frontend.listeners;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import cn.ac.ios.iscasmc.papersprojects.backend.database.DBMS;

@WebListener
public class AppContextListener implements ServletContextListener {
	public void contextInitialized(ServletContextEvent servletContextEvent) {
    	ServletContext ctx = servletContextEvent.getServletContext();
    	
    	//initialize DB Connection
    	String connectorClass = ctx.getInitParameter("dbConnectorClass"); 
    	String user = ctx.getInitParameter("dbUser");
    	String pwd = ctx.getInitParameter("dbPassword");
    	String host = ctx.getInitParameter("dbHost");
    	String port = ctx.getInitParameter("dbPort");
    	String database = ctx.getInitParameter("dbDatabase");
    	
		DBMS connectionManager = new DBMS(connectorClass, host, port, database, user, pwd);
		if (connectionManager.isInitialized()) {
			ctx.setAttribute(DBMS.DBMS_ENTITY, connectionManager);
		} else {
			System.err.println("Error in initializing the DBMS backend");
		}
		
		ctx.setAttribute("PDFPapersBaseDir", ctx.getInitParameter("PDFPapersBaseDir"));
	}
	
	public void contextDestroyed(ServletContextEvent servletContextEvent) {
    	DBMS dbms = (DBMS) servletContextEvent.getServletContext().getAttribute(DBMS.DBMS_ENTITY);
    	if (dbms != null) {
    		dbms.closeConnection();
    	}
    }
}
