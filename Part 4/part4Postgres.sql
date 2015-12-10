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