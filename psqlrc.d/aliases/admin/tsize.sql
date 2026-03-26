SELECT
  table_schema,
  table_name,
  pg_size_pretty(size)       AS size,
  pg_size_pretty(total_size) AS total_size
FROM (:_rtsize) x
ORDER BY
  x.total_size DESC,
  x.size DESC,
  table_schema,
  table_name
;
