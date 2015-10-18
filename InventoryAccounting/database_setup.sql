drop database if exists inventory_accounting;
delete from mysql.user where User = 'inventory_manipulator';
create database inventory_accounting;
use inventory_accounting;
create table stocks (id int primary key, name varchar(15), count int);
grant all on inventory_accounting.* to 'inventory_manipulator'@'localhost' identified by 'inventory_manipulator';
