SELECT      sys.databases.name AS [Database Name], 
 GETDATE() AS [Data],
        CONVERT(VARCHAR,SUM(size)*8/1024) AS [SizeMB]  
     FROM        sys.databases   
     JOIN        sys.master_files  
     ON          sys.databases.database_id=sys.master_files.database_id  
     GROUP BY    sys.databases.name  
     ORDER BY    sys.databases.name