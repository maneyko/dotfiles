\prompt 'Enter the procedure name including the schema (ex: schema.proc_name): ' arg_proc_name

SELECT n.nspname AS schema_name
  , p.proname AS proc_name
  , r.rolname AS owner
  , format('\sf %I.%I', n.nspname, p.proname) AS definition
  -- , format($$SELECT pg_get_functiondef('%I.%I'::regproc);$$, n.nspname, p.proname) AS definition
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
JOIN pg_roles     r ON r.oid = p.proowner
WHERE (:'arg_proc_name')::regproc = p.oid
ORDER BY n.nspname, p.proname
