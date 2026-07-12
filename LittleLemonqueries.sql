
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

get max

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