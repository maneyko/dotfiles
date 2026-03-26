SELECT
    p.pid,
    p.phase,
    round(100.0 * p.heap_blks_scanned / nullif(p.heap_blks_total, 0), 1) AS scanned_pct,
    p.relid::regclass AS table_name,
    now() - a.xact_start AS duration,
    a.query
FROM
    pg_stat_progress_vacuum p
JOIN
    pg_stat_activity a USING (pid)
ORDER BY
    duration DESC;
