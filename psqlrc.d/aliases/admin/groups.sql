\prompt 'Enter a username: ' arg_username

SELECT m.rolname AS member_role, r.rolname AS group_role
FROM pg_auth_members am
JOIN pg_roles m ON m.oid = am.member
JOIN pg_roles r ON r.oid = am.roleid
WHERE 1=1
AND m.rolname = :'arg_username'
ORDER BY 1
;
