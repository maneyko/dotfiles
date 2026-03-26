SELECT n.nspname AS schema_name
  , c.relname AS table_name
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_constraint pk ON pk.conrelid = c.oid AND pk.contype = 'p'
WHERE c.relkind = 'r'  -- ordinary tables
AND n.nspname NOT LIKE 'pg%'
AND n.nspname NOT LIKE 'aws%'
AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pglogical')
AND n.nspname NOT LIKE 'pg_temp_%'
AND pk.oid IS NULL
-- AND c.relpersistence = 'u'  -- only unlogged tables
-- AND c.relpersistence = 'p'  -- only permanent tables
ORDER BY 1, 2;
