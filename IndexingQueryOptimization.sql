-- Top 5 longest-running queries
SELECT TOP 5
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
    qs.execution_count,
    qs.total_elapsed_time,
    SUBSTRING(qt.text, qs.statement_start_offset / 2,
              (CASE WHEN qs.statement_end_offset = -1
                    THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                    ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY avg_elapsed_time DESC;

CREATE DATABASE StudentAnalytics;
GO

USE StudentAnalytics;
GO

CREATE TABLE StudentPerformance (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100),
    Department NVARCHAR(50),
    Semester INT,
    Marks INT
);
--inserting sample data
INSERT INTO StudentPerformance (StudentID, StudentName, Department, Semester, Marks)
VALUES
(1, 'Aarav', 'CSE', 6, 85),
(2, 'Diya', 'ECE', 6, 78),
(3, 'Rohan', 'CSE', 6, 92),
(4, 'Sneha', 'MECH', 5, 67),
(5, 'Karthik', 'CSE', 6, 88),
(6, 'Meera', 'EEE', 6, 74),
(7, 'Vikram', 'CSE', 5, 81),
(8, 'Anjali', 'CSE', 6, 90),
(9, 'Rahul', 'CSE', 6, 76),
(10, 'Priya', 'CSE', 6, 83);

INSERT INTO StudentPerformance (StudentID, StudentName, Department, Semester, Marks)
VALUES
(11, 'Neha', 'ECE', 5, 72),
(12, 'Arjun', 'MECH', 6, 65),
(13, 'Divya', 'EEE', 5, 80),
(14, 'Siddharth', 'CSE', 4, 91),
(15, 'Lakshmi', 'CSE', 3, 77);


--original query
SELECT StudentName, Marks
FROM StudentPerformance
WHERE Department = 'CSE' AND Semester = 6;


--creating index
CREATE NONCLUSTERED INDEX IX_StudentPerformance_Department_Semester
ON StudentPerformance (Department, Semester);

--clear query plan cache
DBCC FREEPROCCACHE;

--Force index testing
SELECT StudentName, Marks
FROM StudentPerformance WITH (INDEX(IX_StudentPerformance_Department_Semester))
WHERE Department = 'CSE' AND Semester = 6;

DROP INDEX IX_StudentPerformance_Department_Semester ON StudentPerformance;

--trying a composite index with include columns
CREATE NONCLUSTERED INDEX IX_StudentPerf_Dept_Sem_Include
ON StudentPerformance (Department, Semester)
INCLUDE (StudentName, Marks);



SET STATISTICS IO ON;
GO

SELECT StudentName, Marks
FROM StudentPerformance
WHERE Department = 'CSE' AND Semester = 6;

--index exists
SELECT name, type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID('StudentPerformance');

--Data is selective enough
SELECT COUNT(*) FROM StudentPerformance WHERE Department = 'CSE' AND Semester = 6;
SELECT COUNT(*) FROM StudentPerformance;




