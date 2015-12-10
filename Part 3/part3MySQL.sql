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

INSERT INTO mvmoti01_Orders VALUES (DEFAULT,4,8394812034981203,02,2019,'2015/05/18','2015/05/20');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,3,9930293012391040,03,2018,'2015/04/28','2015/04/30');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,1,4567823812331233,08,2017,'2015/07/02','2015/07/27');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,1,1092131874828392,12,2016,'2015/05/01','2015/05/04');
INSERT INTO mvmoti01_Orders VALUES (DEFAULT,5,1000039382348399,11,2015,'2015/05/26','2015/06/01');

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
