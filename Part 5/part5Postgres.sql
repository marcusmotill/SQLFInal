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