CREATE TABLE mvmoti01_Customer(
cid serial primary key,
cname char(20),
address varchar(100),
age integer CHECK(age > 18 AND age <100),
incomelevel integer,
username varchar(20),
password varchar(20));

CREATE TABLE mvmoti01_Publisher(
publisherid serial primary key,
name char(50),
address varchar(100),
discount money CHECK(discount >= '1.00' AND discount <= '10.00'));

CREATE TABLE mvmoti01_Books(
isbn bigint PRIMARY KEY,
title varchar(100),
author char(100),
qty_in_stock integer,
price money,
cost money,
year_published integer,
publisherid integer NOT NULL,
CONSTRAINT books_publisherid_fkey FOREIGN KEY(publisherid)
	REFERENCES mvmoti01_Publisher(publisherid) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION,
CHECK(price > cost AND price > '0.00' AND cost > '0.00'));

CREATE TABLE mvmoti01_Orders(
ordernum serial PRIMARY KEY,
cid integer not null,
cardnum bigint,
cardmonth integer,
cardyear integer,
order_date date,
ship_date date,
CONSTRAINT orders_cid_fkey FOREIGN KEY(cid)
	REFERENCES mvmoti01_Customer(cid) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION,
CHECK(ship_date > order_date));

CREATE TABLE mvmoti01_OrderList(
ordernum integer not null,
isbn bigint not null,
quantity integer,
PRIMARY KEY(ordernum, isbn),
CONSTRAINT Orderlist_ordernum_fkey FOREIGN KEY(ordernum)
	REFERENCES mvmoti01_Orders(ordernum) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION,
CONSTRAINT Orderlist_isbn_fkey FOREIGN KEY(isbn)
	REFERENCES mvmoti01_Books(isbn) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION);

CREATE TABLE mvmoti01_StockManager(
isbn bigint primary key,
quantity integer,
CONSTRAINT StockManager_isbn_fkey FOREIGN KEY(isbn)
	REFERENCES Books(isbn) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION);

CREATE TABLE mvmoti01_CustomerExpense(
cid integer primary key,
total money,
CONSTRAINT CustomerExpense_cid_fkey FOREIGN KEY(cid)
	REFERENCES mvmoti01_Customer(cid) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION);