-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDM
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDM` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDM` ;

-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Customer` (
  `CustomerID` INT NOT NULL,
  `FullName` VARCHAR(255) NOT NULL,
  `ContactNumber` VARCHAR(255) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Bookings` (
  `BookingID` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  `TableNumber` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `custid_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `custid`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDM`.`Customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`MenuItems` (
  `MenuItemsID` INT NOT NULL,
  `CourseName` VARCHAR(255) NOT NULL,
  `StarterName` VARCHAR(255) NOT NULL,
  `DessertName` VARCHAR(255) NOT NULL,
  `DrinkName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuItemsID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Menus` (
  `MenuID` INT NOT NULL,
  `MenuItemsID` INT NOT NULL,
  `MenuName` VARCHAR(235) NOT NULL,
  `Cuisine` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `menu_idx` (`MenuItemsID` ASC) VISIBLE,
  CONSTRAINT `menuid`
    FOREIGN KEY (`MenuItemsID`)
    REFERENCES `LittleLemonDM`.`MenuItems` (`MenuItemsID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Orders` (
  `OrderID` INT NOT NULL,
  `Quantity` INT NOT NULL,
  `Cost` DECIMAL(10,2) NOT NULL,
  `CustomerID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `orders_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `Menu_idx` (`MenuID` ASC) VISIBLE,
  CONSTRAINT `orders`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDM`.`Customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Menus`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonDM`.`Menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`OrderDeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`OrderDeliveryStatus` (
  `DeliveryID` VARCHAR(45) NOT NULL,
  `Delivery Date` DATE NOT NULL,
  `Status` VARCHAR(255) NOT NULL,
  `OrderID` INT NOT NULL,
  PRIMARY KEY (`DeliveryID`),
  INDEX `order_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `orderidddd`
    FOREIGN KEY (`OrderID`)
    REFERENCES `LittleLemonDM`.`Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`StaffInformation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`StaffInformation` (
  `StaffID` INT NOT NULL,
  `Role` VARCHAR(255) NOT NULL,
  `Salary` INT NOT NULL,
  `StaffName` VARCHAR(255) NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
