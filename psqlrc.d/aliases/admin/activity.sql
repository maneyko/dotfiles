SELECT pid
    , datname AS database
    , usename AS username
    , state
    , query_start
    , now() - query_start AS duration
    , application_name
    , client_addr
    , client_hostname
    , LEFT(query, 10) AS query
FROM pg_stat_activity
ORDER BY pid
;
