WITH table_name AS (
  SELECT
      '"' || n.nspname || '"."' || c.relname || '"' AS name
      , n.nspname                     AS schema_name
      , c.relname                     AS table_name
      , pg_total_relation_size(c.oid) AS total_bytes
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = 'r'
    AND n.nspname NOT IN ('pg_catalog', 'information_schema')
    AND c.relpersistence != 'u'  -- ignore unlogged tables
)
, class_est AS (
  SELECT c.reltuples::bigint AS row_count -- To avoid scientific notation
  , table_name.name AS table_name
  FROM pg_class c
  JOIN table_name ON c.oid = table_name.name::regclass
)
, pkey_info AS (
  SELECT a.attname AS pkey_column
  , format_type(a.atttypid, a.atttypmod) AS column_type
  , table_name.name AS table_name
  FROM pg_class c
  JOIN pg_index     i ON c.oid = i.indrelid
  JOIN pg_attribute a ON c.oid = a.attrelid AND a.attnum = ANY(i.indkey)
  JOIN table_name     ON c.oid = table_name.name::regclass
  WHERE 1=1
  -- AND c.oid = table_name.name::regclass
  AND i.indisprimary
)
, _row_count AS (
  SELECT table_name.name AS table_name
  , to_json(
    CASE
    WHEN class_est.row_count = -1 THEN (
      CASE WHEN pkey_info.column_type IN ('bigint', 'integer') THEN
        ('MAX - MIN', (
          xpath('/row/*/text()',
            query_to_xml(
              format('SELECT COALESCE(MAX(%I) - MIN(%I) + 1, 0) FROM %I.%I', pkey_info.pkey_column, pkey_info.pkey_column, table_name.schema_name, table_name.table_name),
              false, true, ''
            )
          )
        )[1]::text)
      ELSE
        ('COUNT', (
          xpath('/row/*/text()',
            query_to_xml(
              format('SELECT COUNT(%I) FROM %I.%I', pkey_info.pkey_column::text, table_name.schema_name, table_name.table_name),
              false, true, ''
            )
          )
        )[1]::text)
      END
    )
    ELSE ('pg_class.reltuples', class_est.row_count::text)
    END
  ) AS data
  FROM table_name
  JOIN class_est ON table_name.name::regclass = class_est.table_name::regclass
  JOIN pkey_info ON table_name.name::regclass = pkey_info.table_name::regclass
)
, row_count AS (
  SELECT table_name.name AS table_name
  , (_row_count.data->>'f2')::integer AS count
  , _row_count.data->>'f1' AS method
  FROM _row_count
  JOIN table_name ON _row_count.table_name::regclass = table_name.name::regclass
)
SELECT REPLACE(table_name.name, '"', '') AS table_name
, table_name.total_bytes
, row_count.count AS num_rows
, CASE WHEN row_count.count > 0
  THEN table_name.total_bytes / row_count.count
  ELSE -1
  END AS avg_row_bytes
, row_count.method
FROM table_name
JOIN row_count ON row_count.table_name::regclass = table_name.name::regclass
-- WHERE row_count.count > 100
-- ORDER BY avg_row_bytes
ORDER BY num_rows
  DESC NULLS LAST
;
