CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'mzhan'@'localhost' IDENTIFIED BY '123456789';
GRANT ALL ON wordpress.* TO 'mzhan'@'localhost';
FLUSH PRIVILEGES;
