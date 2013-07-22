drop database if exists reporter_development;
create database reporter_development;
drop database if exists reporter_test;
create database reporter_test;
drop database if exists reporter_production;
create database reporter_production;
GRANT ALL PRIVILEGES ON reporter_development.* TO 'dbuser'@'localhost'
	IDENTIFIED BY 'mxplay' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON reporter_test.* TO 'dbuser'@'localhost'
	IDENTIFIED BY 'mxplay' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON reporter_production.* TO 'dbuser'@'localhost'
	IDENTIFIED BY 'mxplay' WITH GRANT OPTION;