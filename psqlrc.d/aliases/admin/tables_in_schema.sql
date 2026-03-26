\prompt 'Enter the name of the schema: ' arg_schema_name

SELECT n.nspname AS schema_name
  , c.relname AS table_name
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r'  -- ordinary tables
AND n.nspname = :'arg_schema_name'
ORDER BY n.nspname, c.relname
;
