-- Remove Privileges
-- Remove Db

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'player'@'localhost';
DROP DATABASE IF EXISTS SSR_Restaurant;
