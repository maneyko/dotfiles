\if :IS_REDSHIFT
  SELECT TRIM(u.usename) AS user
  , i.pid
  , i.query
  , i.starttime AT TIME ZONE 'UTC' AS start_time
  , datediff('second', (i.starttime AT TIME ZONE 'UTC')::timetz, current_timestamp::timetz) AS duration
  , substring(r.query, 1, 80) AS query_parent
  , substring(i.text, 1, 80) AS query_string
  FROM stv_inflight i
  JOIN pg_user u ON u.usesysid = userid
  LEFT JOIN stv_recents r ON r.pid = i.pid
  ORDER BY i.starttime
  ;

\else
  SELECT pid
      , datname AS database
      , usename AS username
      , state
      , query_start
      , now() - query_start AS duration
      , application_name
      , client_addr
      -- , client_hostname
      -- , query
      , LEFT(query, 50) AS query
  FROM pg_stat_activity
  where 1=1
  and state != 'idle'
  ORDER BY
  -- pid
  query_start
  ;
\endif
