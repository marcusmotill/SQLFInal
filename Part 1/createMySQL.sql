CREATE TABLE IF NOT EXISTS mvmoti01_Customer(
cid INT AUTO_INCREMENT primary key,
cname char(50),
address varchar(100),
age INT,
incomelevel INT,
username varchar(20),
password varchar(20));

CREATE TABLE IF NOT EXISTS mvmoti01_Publisher(
publisherid INT AUTO_INCREMENT primary key,
name char(50),
address varchar(100),
discount decimal(15,2));

CREATE TABLE IF NOT EXISTS mvmoti01_Books(
isbn bigint PRIMARY KEY,
title varchar(100),
author char(100),
qty_in_stock INT,
price decimal(15,2),
cost decimal(15,2),
year_published INT,
publisherid INT NOT NULL,
CONSTRAINT Books_publisherid_fkey FOREIGN KEY (publisherid) REFERENCES mvmoti01_Publisher(publisherid)
);

CREATE TABLE IF NOT EXISTS mvmoti01_Orders(
ordernum INT AUTO_INCREMENT primary key,
cid INT not null,
cardnum bigint,
cardmonth INT,
cardyear INT,
order_date date,
ship_date date,
CONSTRAINT orders_cid_fkey FOREIGN KEY(cid)
	REFERENCES mvmoti01_Customer(cid));

CREATE TABLE IF NOT EXISTS mvmoti01_OrderList(
ordernum INT not null,
isbn bigint not null,
quantity INT,
CONSTRAINT pk_Orderlist PRIMARY KEY(ordernum, isbn),
CONSTRAINT Orderlist_ordernum_fkey FOREIGN KEY(ordernum)
	REFERENCES mvmoti01_Orders(ordernum),
CONSTRAINT Orderlist_isbn_fkey FOREIGN KEY(isbn)
	REFERENCES mvmoti01_Books(isbn));

CREATE TABLE IF NOT EXISTS mvmoti01_StockManager(
isbn bigint primary key,
quantity INT,
CONSTRAINT StockManager_isbn_fkey FOREIGN KEY(isbn)
	REFERENCES mvmoti01_Books(isbn));
	
CREATE TABLE IF NOT EXISTS mvmoti01_CustomerExpense(
cid INT primary key,
total decimal(15,2),
CONSTRAINT CustomerExpense_cid_fkey FOREIGN KEY(cid)
	REFERENCES mvmoti01_Customer(cid));
	
DROP TRIGGER IF EXISTS mvmoti01_Customer_age_check;
DROP TRIGGER IF EXISTS mvmoti01_Publisher_discount_check;
DROP TRIGGER IF EXISTS mvmoti01_Orders_date_check;
DROP TRIGGER IF EXISTS mvmoti01_Books_price_check;

delimiter #
CREATE TRIGGER mvmoti01_Customer_age_check BEFORE INSERT ON mvmoti01_Customer	
FOR EACH ROW 
BEGIN 
    IF NEW.age < 18 OR  NEW.age > 100 THEN 
		signal sqlstate '45000';
    END IF;
END#

CREATE TRIGGER mvmoti01_Publisher_discount_check BEFORE INSERT ON mvmoti01_Publisher 	
FOR EACH ROW 
BEGIN 
    IF NEW.discount< 1.00 OR NEW.discount > 10.00 THEN 
  		signal sqlstate '45000';
    END IF;
END#

CREATE TRIGGER mvmoti01_Orders_date_check BEFORE INSERT ON mvmoti01_Orders 	
FOR EACH ROW 
BEGIN 
    IF NEW.ship_date < NEW.order_date THEN 
  		signal sqlstate '45000';
    END IF;
END#

CREATE TRIGGER mvmoti01_Books_price_check BEFORE INSERT ON mvmoti01_Books	
FOR EACH ROW 
BEGIN 
    IF NEW.price < NEW.cost OR New.price <= 0.00 OR New.cost <= 0.00 THEN 
  		signal sqlstate '45000';
    END IF;
END#

CREATE TRIGGER mvmoti01_Stock_management AFTER INSERT ON mvmoti01_OrderList
FOR EACH ROW
BEGIN
  DECLARE q_in_stock, in_StockManager, result INT;
  
  SELECT qty_in_stock INTO q_in_stock FROM mvmoti01_Books WHERE isbn = NEW.isbn;
  
  SET result = (q_in_stock - NEW.quantity);
  IF result <= 0 THEN
    SELECT COUNT(1) INTO in_StockManager FROM mvmoti01_StockManager WHERE isbn = NEW.isbn;
    IF in_StockManager > 0 THEN
      UPDATE mvmoti01_StockManager SET quantity = (result* -1) + quantity WHERE isbn = NEW.isbn;
    ELSE
      INSERT INTO mvmoti01_StockManager VALUES (NEW.isbn, ((result* -1)+10));
    END IF;
    UPDATE mvmoti01_Books SET qty_in_stock = 0 WHERE isbn = NEW.isbn;
  ELSE
    UPDATE mvmoti01_Books SET qty_in_stock = result WHERE isbn = NEW.isbn;
  END IF;
END#



