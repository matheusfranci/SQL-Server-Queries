WITH    cte1 

          AS ( SELECT [dopc].[object_name] ,
                    [dopc].[instance_name] ,
                    [dopc].[counter_name] ,
                    [dopc].[cntr_value] ,
                    [dopc].[cntr_type] ,
					
                    ROW_NUMBER() OVER ( PARTITION BY [dopc].[object_name], [dopc].[instance_name] ORDER BY [dopc].[counter_name] ) AS r_n 
                FROM [sys].[dm_os_performance_counters] AS dopc
			
                WHERE [dopc].[counter_name] LIKE '%Cache Hit Ratio%'
                    AND ( [dopc].[object_name] LIKE '%Plan Cache%'
                          OR [dopc].[object_name] LIKE '%Buffer Cache%'
                        )
                    AND [dopc].[instance_name] LIKE '%_Total%'
             )
    SELECT
		GETDATE() as [Data],
	 CONVERT(DECIMAL(16, 2), ( [c].[cntr_value] * 1.0 / [c1].[cntr_value] ) * 100.0) AS [hit_pct]
    
	    FROM [cte1] AS c 
            INNER JOIN [cte1] AS c1
                ON c.[object_name] = c1.[object_name]
                   AND c.[instance_name] = c1.[instance_name]
        WHERE [c].[r_n] = 1
            AND [c1].[r_n] = 2;