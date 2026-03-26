\prompt 'Enter the index name including the schema (ex: my_schema.column_idx): ' arg_index_name

SELECT schemaname
  , i.tablename
  , i.indexname
  , r.rolname AS owner
  , i.indexdef
FROM pg_indexes   i
JOIN pg_class     c ON c.relname = i.tablename
JOIN pg_namespace n ON c.relnamespace = n.oid AND i.schemaname = n.nspname
JOIN pg_roles     r ON r.oid  = c.relowner
WHERE 1=1
AND (i.schemaname || '.' || i.indexname) = :'arg_index_name'
ORDER BY 1, 2
;
