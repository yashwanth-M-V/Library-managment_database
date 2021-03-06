CREATE DATABASE LIBRARY_DATA_MANAGMENT;

USE LIBRARY_DATA_MANAGMENT;

CREATE TABLE BOOK_RECORDS(
	BOOK_CODE INT,
	NAME_OF_THE_BOOK NVARCHAR(50),
	AUTHOR VARCHAR(50),
	YEAR_OF_PUBLISH CHAR(4),
	PUBLISHER VARCHAR(50),
	GENRE VARCHAR(50)
);

SELECT * FROM BOOK_RECORDS;

BULK INSERT BOOK_RECORDS
FROM '  '
WITH(
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW =2
);

ALTER TABLE BOOK_RECORDS
ADD CONSTRAINT PK_BID PRIMARY KEY (BOOK_CODE);

ALTER TABLE BOOK_RECORDS
ADD CONSTRAINT U_NAME UNIQUE (NAME_OF_THE_BOOK);

SELECT * FROM BOOK_RECORDS;






CREATE TABLE STOCK_RECORD(
		BOOK_CODE INT,
		NAME_OF_THE_BOOK VARCHAR(50),
		STOCK INT
);

BULK INSERT STOCK_RECORD
FROM '  '
WITH(
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW =2
);

ALTER TABLE STOCK_RECORD
ADD CONSTRAINT FK_BCODE FOREIGN KEY (BOOK_CODE) REFERENCES BOOK_RECORDS(BOOK_CODE);

ALTER TABLE STOCK_RECORD
ADD CONSTRAINT C_STOCK CHECK (STOCK >= 0);





CREATE TABLE STUDENTS_DETAILS(
		STUDENT_ID CHAR(50),
		STUDENT_NAME VARCHAR(50),
		YEAR_OF_STUDY INT,
		STREAM VARCHAR(20)
);
 
BULK INSERT STUDENTS_DETAILS
FROM ''
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
 );

SELECT * FROM STUDENTS_DETAILS;

ALTER TABLE STUDENTS_DETAILS
ADD CONSTRAINT PK_SID PRIMARY KEY (STUDENT_ID);

ALTER TABLE STUDENTS_DETAILS
ALTER COLUMN STUDENT_NAME VARCHAR(50) NOT NULL;


CREATE TABLE RECORD_BOOK(
		STUDENT_ID nvarchar(50) REFERENCES STUDENTS_DETAILS(STUDENT_ID),
		BOOK_NAME VARCHAR(50),
		ISSUE_DATE DATE,
		RETURN_DATE DATE
);

ALTER TABLE RECORD_BOOK
ADD CONSTRAINT C_ISSUE CHECK (ISSUE_DATE = GETDATE());

SELECT * FROM RECORD_BOOK;



CREATE PROCEDURE CHECKING
@STUDENT_ID VARCHAR(50),
@BOOK_NAME VARCHAR(50)
AS
BEGIN
			DECLARE @ISSUE_DATE DATE
			SET @ISSUE_DATE = GETDATE()

            DECLARE @RETURN_DATE DATE
			SET @RETURN_DATE = DATEADD(D,10,GETDATE())


			INSERT INTO RECORD_BOOK
			VALUES ( @STUDENT_ID, @BOOK_NAME, @ISSUE_DATE, @RETURN_DATE );

			UPDATE STOCK_RECORD
			SET STOCK = STOCK-1
			WHERE NAME_OF_THE_BOOK = NAME_OF_THE_BOOK;

			SELECT RECORD_BOOK.STUDENT_ID, RECORD_BOOK.BOOK_NAME, ISSUE_DATE, 
			RETURN_DATE, STOCK-1 AS 'STOCK LEFT'
			FROM RECORD_BOOK
			LEFT JOIN STOCK_RECORD
			ON RECORD_BOOK.BOOK_NAME = STOCK_RECORD.NAME_OF_THE_BOOK;

END;

DROP PROCEDURE CHECKING;

SELECT * FROM STUDENTS_DETAILS;

select * from STOCK_RECORD;

EXECUTE CHECKING '136A0', 'Twilight'

EXECUTE CHECKING '136A5', 'Twilight'
