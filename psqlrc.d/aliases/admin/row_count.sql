\prompt 'Enter the full table name (ex: my_schema.the_table): ' arg_table

WITH table_name AS (
  SELECT :'arg_table'
  -- SELECT 'enums.lenders'
  AS name
)
, class_est AS (
  SELECT c.reltuples::bigint AS row_count -- To avoid scientific notation
  FROM pg_class c
  JOIN table_name ON c.oid = table_name.name::regclass
  -- WHERE c.oid = 'sage_intacct.sage_intacct_reporting_api_request_ledger_reporting_items'::regclass
  -- WHERE c.oid = table_name.name::regclass
)
, pkey_info AS (
  SELECT a.attname AS pkey_column
  , format_type(a.atttypid, a.atttypmod) AS column_type
  FROM pg_class c
  JOIN pg_index     i ON c.oid = i.indrelid
  JOIN pg_attribute a ON c.oid = a.attrelid AND a.attnum = ANY(i.indkey)
  JOIN table_name     ON c.oid = table_name.name::regclass
  WHERE 1=1
  -- AND c.oid = table_name.name::regclass
  AND i.indisprimary
)
-- SELECT (xpath('/row/cnt/text()', query_to_xml(format('select count(*) as cnt from %I.%I', 'enums', 'lenders'), false, true, '')))[1];

, row_count AS (
  SELECT to_json(
    CASE
    WHEN class_est.row_count = -1 THEN (
      CASE WHEN pkey_info.column_type IN ('bigint', 'integer') THEN
        ('MAX - MIN', (
          xpath('/row/*/text()',
            query_to_xml(
              format('SELECT MAX(%I) - MIN(%I) + 1 FROM %s', pkey_info.pkey_column, pkey_info.pkey_column, table_name.name),
              false, true, ''
            )
          )
        )[1]::text)
      ELSE
        ('COUNT', (
          xpath('/row/*/text()',
            query_to_xml(
              format('SELECT COUNT(%I) FROM %I', pkey_info.pkey_column::text, table_name.name),
              false, true, ''
            )
          )
        )[1]::text)
      END
    )
    ELSE ('pg_class.reltuples', class_est.row_count::text)
    END
  ) AS data
  FROM class_est, pkey_info, table_name
)
SELECT table_name.name  AS table_name
, row_count.data->>'f2' AS row_count
, row_count.data->>'f1' AS method
FROM table_name, row_count
;
