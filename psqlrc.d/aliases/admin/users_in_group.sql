\prompt 'Enter a group name: ' arg_group_name

SELECT m.rolname AS member_role, r.rolname AS group_role
FROM pg_auth_members am
JOIN pg_roles m ON m.oid = am.member
JOIN pg_roles r ON r.oid = am.roleid
WHERE 1=1
AND r.rolname = :'arg_group_name'
ORDER BY 1
;
