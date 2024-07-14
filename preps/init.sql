-- Init Database
-- Define user access 
-- Define user roles

CREATE DATABASE IF NOT EXISTS SSR_Restaurant;

GRANT ALL PRIVILEGES ON SSR_Restaurant.* TO 'player'@'%';

-- Don't forget to change .env in the main app
