
================================================================
-create views=====================================

-menuitemsview============================
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `meta_user`@`%` 
    SQL SECURITY DEFINER
VIEW `littlelemondm`.`menuitemsview` AS
    SELECT 
        `littlelemondm`.`menus`.`MenuName` AS `MenuName`
    FROM
        `littlelemondm`.`menus`
    WHERE
        `littlelemondm`.`menus`.`MenuItemsID` IN (SELECT 
                `littlelemondm`.`menuitems`.`MenuItemsID`
            FROM
                `littlelemondm`.`menuitems`
            WHERE
                (`littlelemondm`.`menuitems`.`MenuItemsID` > 2))

========================================
-ordersview=============================
subquery 


CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `meta_user`@`%` 
    SQL SECURITY DEFINER
VIEW `littlelemondm`.`ordersview` AS
    SELECT 
        `littlelemondm`.`orders`.`OrderID` AS `OrderID`,
        `littlelemondm`.`orders`.`Quantity` AS `Quantity`,
        `littlelemondm`.`orders`.`Cost` AS `Cost`
    FROM
        `littlelemondm`.`orders`
    WHERE
        (`littlelemondm`.`orders`.`Cost` > 2.0)

==============================================
-Joinstatment=================================

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `meta_user`@`%` 
    SQL SECURITY DEFINER
VIEW `littlelemondm`.`joinview` AS
    SELECT 
        `c`.`CustomerID` AS `CustomerID`,
        `c`.`FullName` AS `FullName`,
        `o`.`OrderID` AS `OrderID`,
        `o`.`Cost` AS `Cost`,
        `m`.`MenuID` AS `MenuID`,
        `m`.`MenuItemsID` AS `MenuItemsID`,
        `m`.`MenuName` AS `MenuName`,
        `m`.`Cuisine` AS `Cuisine`,
        `i`.`CourseName` AS `CourseName`,
        `i`.`StarterName` AS `StarterName`,
        `i`.`DessertName` AS `DessertName`,
        `i`.`DrinkName` AS `DrinkName`
    FROM
        (((`littlelemondm`.`customer` `c`
        JOIN `littlelemondm`.`orders` `o` ON ((`c`.`CustomerID` = `o`.`CustomerID`)))
        JOIN `littlelemondm`.`menus` `m` ON ((`o`.`MenuID` = `m`.`MenuID`)))
        JOIN `littlelemondm`.`menuitems` `i` ON ((`m`.`MenuItemsID` = `i`.`MenuItemsID`)))
    WHERE
        (`o`.`Cost` > 150.0)

======================================================================
-stored procedures==================================================
cancel order 

CREATE DEFINER=`meta_user`@`%` PROCEDURE `CancelOrder`(in p_OrderID int)
BEGIN
delete from Orders 
where OrderID=p_OrderID;
select concat('Order',p_OrderID ,'is cancelled') as confirmation;
END
=======================================================
get max==============================================

CREATE DEFINER=`meta_user`@`%` PROCEDURE `GetMaxQuantity`()
BEGIN
select max(Quantity)
from Orders;
END
===========================================================
-prepare statment=========================================

prepare GetOrderDetail from 'select OrderID, Quantity ,Cost from Orders where CustomerID= ?';
set @id=1;
execute GetOrderDetail using @id;

=========================================================
1-insert bookings========================================

insert into Bookings(BookingID,BookingDate,TableNumber,CustomerID) 
values (1,'2022-10-10',5,1) ,(2,'2022-11-12',3,3) ,(3,'2022-10-11',2,2) ,(4,'2022-10-13',2,1);

=================================================
2-stored procedure: CheckBooking=============

CREATE DEFINER=`meta_user`@`%` PROCEDURE `CheckBooking`(p_BookingDate DATE, p_TableNumber int)
BEGIN
select BookingDate, TableNumber
from Bookings
where p_BookingDate=BookingDate and p_TableNumber=TableNumber;
select concat('Table ',p_TableNumber,' is already booking') as BookingStatus;
END

=============================================
3-AddValidBooking========================

CREATE DEFINER=`meta_user`@`%` PROCEDURE `AddValidBooking`(in p_BookingDate DATE ,in p_TableNumber int)
BEGIN
declare table_count int ;
start transaction ;
select count(*) into table_count from Bookings 
where p_BookingDate=BookingDate and p_TableNumber=TableNumber;
if 
table_count>0 then
rollback;
select concat('Booking decline table', p_TableNumber ,'is already booked') Booking_status;
else 
insert into Bookings(BookingID,BookingDate,TableNumber,CustomerID) 
values ((select ifnull(max(BookingID),0)+1 from Bookings),
 p_BookingDate ,p_TableNumber,1);
 commit;
 select concat('Booking confirmed table', p_TableNumber, 'is booked now') Booking_status;
 end if;
END

======================================================
-1 AddBooking=========================================

CREATE DEFINER=`meta_user`@`%` PROCEDURE `AddBooking`
(p_BookingID int , p_CustomerID int ,p_BookingDate DATE, p_TableNumber int)
BEGIN
insert into Bookings(BookingID,CustomerID,BookingDate,TableNumber)
values(p_BookingID, p_CustomerID ,p_BookingDate, p_TableNumber);
select concat('Booking',p_BookingID,'is added') confirmation;
END

=========================================================
-2 UpdateBooking==========================================

CREATE DEFINER=`meta_user`@`%` PROCEDURE `UpdateBooking`(p_BookingID int , p_BookingDate DATE)
BEGIN
update Bookings set BookingDate=p_BookingDate
where p_BookingID=BookingID;
select concat('Booking',p_BookingID,'is updated') confirmation;
END

=======================================================
-3 CancelBooking=======================================

CREATE DEFINER=`meta_user`@`%` PROCEDURE `CancelBooking`(p_BookingID int)
BEGIN
delete from Bookings where p_BookingID=BookingID;
select concat('the Booking ' , p_BookingID, 'is canceled') confirmation;
END