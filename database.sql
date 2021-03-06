CREATE TABLE author (
	identifier VARCHAR(100) NOT NULL,
	PRIMARY KEY(identifier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE conference (
	identifier VARCHAR(100) NOT NULL,
	title TEXT NOT NULL,
	year VARCHAR(10) NOT NULL,
	series TEXT DEFAULT NULL,
	volume VARCHAR(20) DEFAULT NULL,
	editor TEXT DEFAULT NULL,
	publisher TEXT DEFAULT NULL,
	url TEXT DEFAULT NULL,
	isbn TEXT DEFAULT NULL,

	PRIMARY KEY(identifier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE paper (
	identifier VARCHAR(100) NOT NULL,
	title TEXT NOT NULL,
	booktitle TEXT DEFAULT NULL,
	year VARCHAR(10),
	pages VARCHAR(20) DEFAULT NULL,
	volume VARCHAR(20) DEFAULT NULL,
	number VARCHAR(20) DEFAULT NULL,
	crossref VARCHAR(100) DEFAULT NULL,
	journal TEXT DEFAULT NULL,
	doi TEXT DEFAULT NULL,
	url TEXT DEFAULT NULL,
	filepath TEXT DEFAULT NULL,
	ranking_ccf VARCHAR(20) NOT NULL,
	ranking_core VARCHAR(20) NOT NULL,

	PRIMARY KEY(identifier),
	FOREIGN KEY(crossref) REFERENCES conference(identifier) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE paperAuthor (
	paperIdentifier VARCHAR(100) NOT NULL,
	authorIdentifier VARCHAR(100) NOT NULL,
	authorOrder INT,
	isCorresponding BOOLEAN DEFAULT FALSE,

	PRIMARY KEY(paperIdentifier,authorIdentifier),
	UNIQUE (paperIdentifier, authorOrder),
	FOREIGN KEY(paperIdentifier) REFERENCES paper(identifier) ON DELETE CASCADE,
	FOREIGN KEY(authorIdentifier) REFERENCES author(identifier) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE project (
	identifier VARCHAR(100) NOT NULL,
	funder VARCHAR(200) NOT NULL,
	title TEXT DEFAULT NULL,
	acknowledge TEXT NOT NULL,
	startDate DATE NOT NULL,
	endDate DATE NOT NULL,
	
	PRIMARY KEY(identifier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE projectPaper (
	projectIdentifier VARCHAR(100) NOT NULL,
	paperIdentifier VARCHAR(100) NOT NULL,

	PRIMARY KEY(projectIdentifier,paperIdentifier),
	FOREIGN KEY(paperIdentifier) REFERENCES paper(identifier) ON DELETE CASCADE,
	FOREIGN KEY(projectIdentifier) REFERENCES project(identifier) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

