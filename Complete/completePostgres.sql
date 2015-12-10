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
	REFERENCES mvmoti01_Books(isbn) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION);

CREATE TABLE mvmoti01_CustomerExpense(
cid integer primary key,
total money,
CONSTRAINT CustomerExpense_cid_fkey FOREIGN KEY(cid)
	REFERENCES mvmoti01_Customer(cid) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION);

CREATE OR REPLACE FUNCTION mvmoti01_trig_stock_system() RETURNS TRIGGER AS $_$
DECLARE	
	in_stock INT;
	in_StockManager INT;
	result INT;
BEGIN
	SELECT qty_in_stock INTO in_stock FROM mvmoti01_Books WHERE isbn = NEW.isbn;
	
	result := in_stock - NEW.quantity;
	IF result <= 0 THEN
		SELECT COUNT(1) INTO in_StockManager FROM mvmoti01_Stockmanager WHERE isbn = NEW.isbn;
		IF in_StockManager > 0 THEN
			UPDATE mvmoti01_StockManager SET quantity = (result* -1) + quantity WHERE isbn = NEW.isbn;
		ELSE
			INSERT INTO mvmoti01_Stockmanager VALUES (NEW.isbn, ((result* -1)+10));
		END IF;
		UPDATE mvmoti01_Books SET qty_in_stock = 0 WHERE isbn = NEW.isbn;
	ELSE
		UPDATE mvmoti01_Books SET qty_in_stock = result WHERE isbn = NEW.isbn;
	END IF;
	RETURN NEW;
END $_$
LANGUAGE plpgsql;

CREATE TRIGGER mvmoti01_Stock_Managment AFTER INSERT ON mvmoti01_Orderlist
FOR EACH ROW 
EXECUTE PROCEDURE mvmoti01_trig_stock_system();

INSERT INTO mvmoti01_CustomerExpense(cid, total)
SELECT cid, SUM(olist.quantity * b.price)
FROM mvmoti01_Orders ord INNER JOIN mvmoti01_OrderList olist ON
 ord.ordernum = olist.ordernum INNER JOIN mvmoti01_Books b ON
 olist.isbn = b.isbn
WHERE ord.cid = cid
Group By cid;

INSERT INTO mvmoti01_CustomerExpense(cid, total)
SELECT cid, SUM(olist.quantity * b.price)
FROM mvmoti01_Orders ord INNER JOIN mvmoti01_OrderList olist ON
 ord.ordernum = olist.ordernum INNER JOIN mvmoti01_Books b ON
 olist.isbn = b.isbn
WHERE ord.cid = cid
Group By cid;

CREATE OR REPLACE FUNCTION mvmoti01_trig_Customer_Expense() RETURNS TRIGGER AS $_$
DECLARE	
	customer INT;
	in_CustomerExpense INT;
	totalMoney money;
BEGIN
		Select cid INTO customer
		FROM mvmoti01_Orders ord 
		WHERE ord.ordernum = NEW.ordernum;
		
		totalMoney := (NEW.quantity * (SELECT price FROM mvmoti01_Books WHERE isbn = NEW.isbn));
		SELECT COUNT(1) INTO in_CustomerExpense FROM mvmoti01_CustomerExpense WHERE cid = customer;
		IF in_CustomerExpense > 0 THEN
			UPDATE mvmoti01_CustomerExpense SET total = (totalMoney + total) WHERE cid = customer;
		ELSE
			INSERT INTO mvmoti01_CustomerExpense  VALUES (customer, totalMoney);
		END IF;
	RETURN NEW;
END $_$
LANGUAGE plpgsql;

CREATE TRIGGER mvmoti01_Customer_Expense_Trigger BEFORE INSERT ON mvmoti01_OrderList
FOR EACH ROW
EXECUTE PROCEDURE mvmoti01_trig_Customer_Expense();

INSERT INTO mvmoti01_Customer VALUES (DEFAULT,'Marcus Motill', '1718 South 4th Street', 21, 100000, 'mvmoti01', 'mvmmm');
INSERT INTO mvmoti01_Customer VALUES (DEFAULT,'John Smith', '123 street', 40, 80000, 'jsmith01','jsm');
INSERT INTO mvmoti01_Customer VALUES (DEFAULT,'Jane Smith', '123 street', 30, 15000, 'jsmith02','jsm02');
INSERT INTO mvmoti01_Customer VALUES (DEFAULT,'Gabe French','318 Prince Road', 24, 20000, 'gfrench01', 'baby1');
INSERT INTO mvmoti01_Customer VALUES (DEFAULT,'Robyn Berg', '45 Love Street', 21, 38000, 'rberg2','dancedance');

INSERT INTO mvmoti01_Publisher VALUES (DEFAULT,'We are Books','101 Book Road','6.78');
INSERT INTO mvmoti01_Publisher VALUES (DEFAULT,'We are not Books','100 CD Road','1.01');
INSERT INTO mvmoti01_Publisher VALUES (DEFAULT,'Books R Us','900 GetAJob Road','1.00');
INSERT INTO mvmoti01_Publisher VALUES (DEFAULT,'Bucca de Booko','250 GetYaBooks Drive','1.99');
INSERT INTO mvmoti01_Publisher VALUES (DEFAULT,'Dank Books','1000 RedditMemes','9.99');

INSERT INTO mvmoti01_Books VALUES (8493727482,'Rogue Lawyer','John Grisham',15,'25.00','17.00',2015,1);
INSERT INTO mvmoti01_Books VALUES (2312409402,'See Me','Nicholas Sparks',90,'27.00','16.20',2001,3);
INSERT INTO mvmoti01_Books VALUES (6574893829,'Depraved Heart: A Scarpetta Novel','Patricia Cornwell',11,'13.99','9.00',1999,5);
INSERT INTO mvmoti01_Books VALUES (8892912394,'The Survivor','Vince Flynn',17,'18.99','9.50',1977,2);
INSERT INTO mvmoti01_Books VALUES (1028364627,'Career of Evil','Robert Galbraith',20,'49.99','35.00',2015,4);

INSERT INTO mvmoti01_Orders VALUES (DEFAULT,4,8394812034981203,02,2019,'05/18/15','05/20/15');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,3,9930293012391040,03,2018,'04/28/15','04/30/15');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,1,4567823812331233,08,2017,'07/02/15','07/27/15');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,1,1092131874828392,12,2016,'05/01/15','05/04/15');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,5,1000039382348399,11,2015,'05/26/15','06/01/15');

INSERT INTO mvmoti01_OrderList VALUES (1,8892912394,9);
INSERT INTO mvmoti01_OrderList VALUES (2,6574893829,8);
INSERT INTO mvmoti01_OrderList VALUES (3,1028364627,7);
INSERT INTO mvmoti01_OrderList VALUES (4,8493727482,6);
INSERT INTO mvmoti01_OrderList VALUES (5,2312409402,5);

INSERT INTO mvmoti01_StockManager VALUES (8892912394,4);
INSERT INTO mvmoti01_StockManager VALUES (6574893829,3);
INSERT INTO mvmoti01_StockManager VALUES (1028364627,2);
INSERT INTO mvmoti01_StockManager VALUES (2312409402,1);
INSERT INTO mvmoti01_StockManager VALUES (8493727482,0);