Objective: Identify slow queries and optimize them using indexes.

Before Optimization
 - operation : Clustered Indexx Scan
 - Cost : 100%
 - Reason : No index, all rows matched filter
After Optimization
- Operation : Index Seek on IX_StudentPerformance_Department_Semester
- Cost : Reduced
- Logical Reads : Lower
- Benefit : Faster query, efficient resource usage

Screenshot Summary
-[] Clustered Index Scan (before)
-[] Index Seek (After)
-[] Statistics IO comparison
