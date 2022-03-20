SELECT
      backup_type =
            CASE f.[type]
                WHEN 'D' THEN 'Full'
                WHEN 'L' THEN 'Log'
                WHEN 'I' THEN 'Diff'
            END
    , f.database_name
    , f.backup_start_date
    , f.backup_finish_date
    , duration = CAST(f.backup_finish_date - f.backup_start_date AS TIME)
    , f.backup_size
    , b.physical_device_name
FROM (
    SELECT
          s.media_set_id
        , s.[type]
        , s.database_name
        , s.backup_start_date
        , s.backup_finish_date
        , backup_size =
            CASE WHEN s.backup_size = s.compressed_backup_size
                THEN s.backup_size
                ELSE s.compressed_backup_size
            END / 1048576.
        , RowNum = ROW_NUMBER() OVER (PARTITION BY s.database_name, s.[type] ORDER BY s.backup_finish_date DESC)
    FROM msdb.dbo.backupset s
    --WHERE s.database_name = DB_NAME()
) f
JOIN msdb.dbo.backupmediafamily b ON f.media_set_id = b.media_set_id
WHERE f.RowNum = 1
ORDER BY f.backup_finish_date DESC