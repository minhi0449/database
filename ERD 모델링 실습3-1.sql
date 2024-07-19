-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema shopping
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `shopping` DEFAULT CHARACTER SET utf8 ;
USE `shopping` ;

-- -----------------------------------------------------
-- Table `shopping`.`Sellers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Sellers` (
  `sellerNo` INT NOT NULL,
  `sellerBizName` VARCHAR(45) NOT NULL,
  `sellerPhone` VARCHAR(20) NOT NULL,
  `sellerManager` VARCHAR(20) NOT NULL,
  `sellerAddr` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`sellerNo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`Categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Categories` (
  `cateNo` INT NOT NULL,
  `cateName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cateNo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Products` (
  `prodNo` INT NOT NULL,
  `cateNo` INT NOT NULL,
  `prodName` VARCHAR(20) NOT NULL,
  `prodPrice` INT NOT NULL,
  `prodStock` INT NOT NULL DEFAULT 0,
  `prodSold` INT NULL DEFAULT 0,
  `prodDiscount` TINYINT NULL DEFAULT 0,
  `sellerNo` INT NOT NULL,
  PRIMARY KEY (`prodNo`, `cateNo`),
  INDEX `fk_Products_Sellers1_idx` (`sellerNo` ASC) VISIBLE,
  INDEX `fk_Products_Categories1_idx` (`cateNo` ASC) VISIBLE,
  UNIQUE INDEX `prodNo_UNIQUE` (`prodNo` ASC) VISIBLE,
  CONSTRAINT `fk_Products_Sellers1`
    FOREIGN KEY (`sellerNo`)
    REFERENCES `shopping`.`Sellers` (`sellerNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Products_Categories1`
    FOREIGN KEY (`cateNo`)
    REFERENCES `shopping`.`Categories` (`cateNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Users` (
  `userId` VARCHAR(20) NOT NULL,
  `userName` VARCHAR(20) NOT NULL,
  `userBirth` CHAR(10) NOT NULL,
  `userGender` CHAR(1) NOT NULL,
  `userHp` CHAR(13) NOT NULL,
  `userEmail` VARCHAR(45) NULL,
  `userPoint` INT NULL DEFAULT 0,
  `userLevel` TINYINT NULL DEFAULT 1,
  `userAddr` VARCHAR(100) NULL,
  `userRegDate` DATETIME NULL,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `userEmail_UNIQUE` (`userEmail` ASC) VISIBLE,
  UNIQUE INDEX `userHp_UNIQUE` (`userHp` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Orders` (
  `orderNo` CHAR(11) NOT NULL,
  `userId` VARCHAR(20) NOT NULL,
  `orderTotalPrice` INT NOT NULL,
  `orderAddr` VARCHAR(255) NOT NULL,
  `orderStatus` TINYINT NULL DEFAULT 0,
  `orderDate` DATETIME NOT NULL,
  PRIMARY KEY (`orderNo`, `userId`),
  INDEX `fk_Orders_Users_idx` (`userId` ASC) VISIBLE,
  UNIQUE INDEX `orderNo_UNIQUE` (`orderNo` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Users`
    FOREIGN KEY (`userId`)
    REFERENCES `shopping`.`Users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`Carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Carts` (
  `cartNo` INT NOT NULL AUTO_INCREMENT,
  `userId` VARCHAR(20) NOT NULL,
  `prodNo` INT NOT NULL,
  `cartProdCount` INT NULL DEFAULT 1,
  `cartProdDate` DATETIME NULL,
  PRIMARY KEY (`cartNo`, `userId`, `prodNo`),
  INDEX `fk_Carts_Users1_idx` (`userId` ASC) VISIBLE,
  INDEX `fk_Carts_Products1_idx` (`prodNo` ASC) VISIBLE,
  CONSTRAINT `fk_Carts_Users1`
    FOREIGN KEY (`userId`)
    REFERENCES `shopping`.`Users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carts_Products1`
    FOREIGN KEY (`prodNo`)
    REFERENCES `shopping`.`Products` (`prodNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`Points`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`Points` (
  `pointNo` INT NOT NULL AUTO_INCREMENT,
  `userId` VARCHAR(20) NOT NULL,
  `point` INT NOT NULL,
  `pointDesc` VARCHAR(45) NOT NULL,
  `pointDate` DATETIME NOT NULL,
  PRIMARY KEY (`pointNo`, `userId`),
  INDEX `fk_Points_Users1_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `fk_Points_Users1`
    FOREIGN KEY (`userId`)
    REFERENCES `shopping`.`Users` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `shopping`.`OrderItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `shopping`.`OrderItems` (
  `itemNo` INT NOT NULL AUTO_INCREMENT,
  `orderNo` CHAR(11) NOT NULL,
  `prodNo` INT NOT NULL,
  `itemPrice` INT NOT NULL,
  `itemDiscount` TINYINT NOT NULL,
  `itemCount` INT NULL DEFAULT 1,
  PRIMARY KEY (`itemNo`, `orderNo`, `prodNo`),
  INDEX `fk_OrderItems_Orders1_idx` (`orderNo` ASC) VISIBLE,
  INDEX `fk_OrderItems_Products1_idx` (`prodNo` ASC) VISIBLE,
  CONSTRAINT `fk_OrderItems_Orders1`
    FOREIGN KEY (`orderNo`)
    REFERENCES `shopping`.`Orders` (`orderNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrderItems_Products1`
    FOREIGN KEY (`prodNo`)
    REFERENCES `shopping`.`Products` (`prodNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;