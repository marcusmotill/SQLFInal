INSERT INTO mvmoti01_CustomerExpense(cid, total)
SELECT cid, SUM(ol.quantity * b.price)
FROM mvmoti01_Orders o INNER JOIN mvmoti01_OrderList ol ON
 o.ordernum = ol.ordernum INNER JOIN mvmoti01_Books b ON
 ol.isbn = b.isbn
WHERE o.cid = cid
Group By cid;

delimiter #
CREATE TRIGGER mvmoti01_Customer_Expense_Update BEFORE INSERT ON mvmoti01_OrderList
FOR EACH ROW
BEGIN
	DECLARE	customer, in_CustomerExpense INT;
	DECLARE result Decimal(15,2);
	
		
		Select cid INTO customer
		FROM mvmoti01_Orders o 
		WHERE o.ordernum = NEW.ordernum;
		
		SET result = (NEW.quantity * (SELECT price FROM mvmoti01_Books WHERE isbn = NEW.isbn));
	
		SELECT COUNT(1) INTO in_CustomerExpense FROM mvmoti01_CustomerExpense WHERE cid = customer;
		IF in_CustomerExpense > 0 THEN
			UPDATE mvmoti01_CustomerExpense SET total = (result + total) WHERE cid = customer;
		ELSE
			INSERT INTO mvmoti01_CustomerExpense  VALUES (customer, result);
		END IF;
END#
