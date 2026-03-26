\prompt 'Enter the sequence name (without the schema): ' arg_sequence_name

SELECT n.nspname AS table_schema
  , t.table_name
  , t.column_name
  , s.relname AS sequence_name
  , seq.sequenceowner
  , seq.data_type
  , seq.start_value
  , seq.min_value
  , seq.max_value
  , seq.last_value
  , s.oid as pg_sequence_oid
FROM pg_class s -- sequence
LEFT JOIN (
  SELECT t.relname AS table_name, a.attname AS column_name, d.objid AS dep_objid
  FROM pg_depend d
  JOIN pg_class     t ON t.oid = d.refobjid -- table
  JOIN pg_attribute a ON t.oid = a.attrelid AND a.attnum = d.refobjsubid
) AS t ON s.oid = t.dep_objid
JOIN pg_namespace n ON n.oid = s.relnamespace
JOIN pg_sequences seq ON seq.schemaname = n.nspname AND seq.sequencename = s.relname
WHERE s.relkind = 'S'
AND s.relname = :'arg_sequence_name'
ORDER BY 1, 2
;
