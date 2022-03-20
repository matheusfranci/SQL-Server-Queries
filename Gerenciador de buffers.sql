DECLARE
    @value VARCHAR(64),
    @key VARCHAR(512) = 'SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes'
SELECT GETDATE() as [Data],
* FROM sys.dm_os_performance_counters

WHERE object_name LIKE '%Buffer Manager%';