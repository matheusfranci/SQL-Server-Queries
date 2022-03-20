SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio],
cpu_count/hyperthread_ratio AS [Physical CPU Count] 
FROM sys.dm_os_sys_info OPTION (RECOMPILE);