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
