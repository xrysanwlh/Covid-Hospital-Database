CREATE TABLE patient ( 
	covid-test 	CHAR(1)  NOT NULL CHECK(covid_test IN ('Y','N')) ,
	date_of_entry	DATE NOT NULL,
	num-persons-in-contact	INTEGER NOT NULL,
	p_id	INTEGER	NOT NULL ,
	phone_number	BIGINT NOT NULL,
	date_of_birth	DATE  NOT NULL,
	name	CHAR(30)  NOT NULL,
	medicine	CHAR(15)  NOT NULL,
	FK1_sid	INTEGER,
PRIMARY KEY (p_id) );

CREATE TABLE employees ( 
	sid	INTEGER	NOT NULL,
	email	CHAR(25)  NOT NULL,
	date_of_employment	DATE  NOT NULL,
	salary	BIGINT   NOT NULL CHECK(salary > 1000),
	name	CHAR(30) NOT NULL,
	date_of_birth	DATE NOT NULL,
	phone_number	BIGINT NOT NULL,
PRIMARY KEY (sid) );

CREATE TABLE nurses ( 
	nur_id	INTEGER	NOT NULL,
UNIQUE (nur_id),
UNIQUE (sid)
) INHERITS (employees);

CREATE TABLE technical_staff ( 
	tec_id	INTEGER	NOT NULL,
UNIQUE (tec_id),
UNIQUE (sid)
) INHERITS (employees);

CREATE TABLE doctors ( 
	doc_id	INTEGER	NOT NULL,
UNIQUE (doc_id),
UNIQUE (sid)
) INHERITS (employees);

CREATE TABLE covid_dep_inside_hospital ( 
	number_of_vaccines	INTEGER  NOT NULL,
	fullness	DECIMAL(5,4)	NOT NULL,
	dep_id	INTEGER	NOT NULL,
	total_deaths	INTEGER,
PRIMARY KEY (dep_id) );

CREATE TABLE room ( 
	room_number	INTEGER	NOT NULL,
	FK1_sid	INTEGER,
	carantine_until	DATE  NOT NULL,
	FK2_p_id	INTEGER,
PRIMARY KEY (room_number) );

CREATE TABLE belongs_to ( 
	FK1_room_number	INTEGER	NOT NULL,
	FK2_dep_id	INTEGER	NOT NULL,
PRIMARY KEY (FK1_room_number, FK2_dep_id) );

CREATE TABLE work_in ( 
	FK1_sid	INTEGER	NOT NULL,
	FK2_dep_id	INTEGER	NOT NULL,
PRIMARY KEY (FK1_sid, FK2_dep_id) );

CREATE TABLE assigned ( 
	FK1_sid	INTEGER	NOT NULL,
	FK2_dep_id	INTEGER	NOT NULL,
PRIMARY KEY (FK1_sid, FK2_dep_id) );

CREATE TABLE non-covid_patients ( 
	noncovid_pid	INTEGER	NOT NULL,
UNIQUE (noncovid_pid),
UNIQUE (p_id)
) INHERITS (patient);

CREATE TABLE covid_patients ( 
	cough	CHAR(1)	NOT NULL  CHECK(cough IN ('Y','N')),
	sore_throat	CHAR(1)	NOT NULL CHECK(sore_throat IN ('Y','N')),
	fever	REAL	NOT NULL,
	fatigue	CHAR(1)	NOT NULL   CHECK(fatigue IN ('Y','N')),
	covid_pid	 INTEGER	NOT NULL,
	loss_of_taste_or_smell	CHAR(1)	NOT NULL  CHECK(loss_of_taste_or_smell IN ('Y','N')),
UNIQUE (covid_pid),
UNIQUE (p_id)
) INHERITS (patient);

CREATE TABLE reception ( 
	rec_id	INTEGER	NOT NULL,
UNIQUE (rec_id),
UNIQUE (sid)
) INHERITS (employees);

CREATE TABLE in_clinic ( 
UNIQUE (room_number)
) INHERITS (room);

CREATE TABLE in_IMCU ( 
UNIQUE (room_number)
) INHERITS (room);

ALTER TABLE patient ADD FOREIGN KEY (FK1_sid) REFERENCES doctors (sid) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE room ADD FOREIGN KEY (FK1_sid) REFERENCES nurses (sid) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE room ADD FOREIGN KEY (FK2_p_id) REFERENCES covid_patients (p_id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE belongs_to ADD FOREIGN KEY (FK1_room_number) REFERENCES room (room_number) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE belongs_to ADD FOREIGN KEY (FK2_dep_id) REFERENCES covid_dep_inside_hospital (dep_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE work_in ADD FOREIGN KEY (FK1_sid) REFERENCES doctors (sid) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE work_in ADD FOREIGN KEY (FK2_dep_id) REFERENCES covid_dep_inside_hospital (dep_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE assigned ADD FOREIGN KEY (FK1_sid) REFERENCES nurses (sid) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE assigned ADD FOREIGN KEY (FK2_dep_id) REFERENCES covid_dep_inside_hospital (dep_id) ON DELETE CASCADE ON UPDATE CASCADE;

