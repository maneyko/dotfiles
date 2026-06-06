\prompt 'Enter the procedure name including the schema (ex: schema.proc_name): ' arg_proc_name

SELECT n.nspname AS schema_name
  , p.proname AS proc_name
  , r.rolname AS owner
  , format('\sf %I.%I', n.nspname, p.proname) AS definition
  -- , format($$SELECT pg_get_functiondef('%I.%I'::regproc);$$, n.nspname, p.proname) AS definition
  -- , pg_get_functiondef(p.oid) AS definition
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
JOIN pg_roles     r ON r.oid = p.proowner
WHERE 1=1
-- AND (:'arg_proc_name')::regproc = p.oid
AND (:'arg_proc_name') = format('%I.%I', n.nspname, p.proname)
ORDER BY n.nspname, p.proname
