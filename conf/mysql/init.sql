CREATE DATABASE IF NOT EXISTS mysite_db;
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON mysite_db.* TO wp_user@'%';
CREATE USER 'ro_user'@'%' IDENTIFIED BY 'password321';
GRANT SELECT ON mysite_db.* TO ro_user@'%';
FLUSH PRIVILEGES;
