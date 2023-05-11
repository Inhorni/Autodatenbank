-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema autohaus
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema autohaus
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `autohaus` DEFAULT CHARACTER SET utf8 ;
USE `autohaus` ;

-- -----------------------------------------------------
-- Table `autohaus`.`kunde`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`kunde` (
  `kundenNr` INT(255) NOT NULL AUTO_INCREMENT,
  `vorname` VARCHAR(99) NOT NULL,
  `nachname` VARCHAR(99) NOT NULL,
  `adresse` VARCHAR(99) NOT NULL,
  `plz` VARCHAR(99) NOT NULL,
  `telefon` VARCHAR(99) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`kundenNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`auto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`auto` (
  `autoNr` INT(50) NOT NULL AUTO_INCREMENT,
  `kundenNr` INT(50) NOT NULL,
  `marke` VARCHAR(50) NOT NULL,
  `modell` VARCHAR(50) NOT NULL,
  `jahr` INT(20) NOT NULL,
  `kilometerstand` INT(20) NULL DEFAULT NULL,
  PRIMARY KEY (`autoNr`),
  INDEX `kundenNr` (`kundenNr` ASC),
  CONSTRAINT `auto_ibfk_1`
    FOREIGN KEY (`kundenNr`)
    REFERENCES `autohaus`.`kunde` (`kundenNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`lieferant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`lieferant` (
  `lieferantNr` INT(50) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(99) NOT NULL,
  `adresse` VARCHAR(99) NOT NULL,
  `telefon` VARCHAR(99) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`lieferantNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`rechnung`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`rechnung` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Verkauf_ID` INT(11) NOT NULL,
  `Datum` DATE NOT NULL,
  `Summe` DECIMAL(10,2) NOT NULL,
  `kunde_kundenNr` INT(255) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_rechnung_kunde1_idx` (`kunde_kundenNr` ASC),
  CONSTRAINT `fk_rechnung_kunde1`
    FOREIGN KEY (`kunde_kundenNr`)
    REFERENCES `autohaus`.`kunde` (`kundenNr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`rechnungsposition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`rechnungsposition` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Rechnung_ID` INT(11) NOT NULL,
  `Position` INT(11) NOT NULL,
  `Beschreibung` VARCHAR(255) NOT NULL,
  `Preis` DECIMAL(10,2) NOT NULL,
  `Menge` INT(11) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `Rechnung_ID` (`Rechnung_ID` ASC),
  CONSTRAINT `rechnungsposition_ibfk_1`
    FOREIGN KEY (`Rechnung_ID`)
    REFERENCES `autohaus`.`rechnung` (`ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`ersatzteil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`ersatzteil` (
  `teilNr` INT(50) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `beschreibung` VARCHAR(255) NULL DEFAULT NULL,
  `preis` DECIMAL(10,2) NOT NULL,
  `lagerbestand` INT(20) NULL DEFAULT NULL,
  `lieferantNr` INT(50) NOT NULL,
  `rechnungsposition_ID` INT(11) NOT NULL,
  PRIMARY KEY (`teilNr`),
  INDEX `lieferantNr` (`lieferantNr` ASC),
  INDEX `fk_ersatzteil_rechnungsposition1_idx` (`rechnungsposition_ID` ASC),
  CONSTRAINT `ersatzteil_ibfk_1`
    FOREIGN KEY (`lieferantNr`)
    REFERENCES `autohaus`.`lieferant` (`lieferantNr`),
  CONSTRAINT `fk_ersatzteil_rechnungsposition1`
    FOREIGN KEY (`rechnungsposition_ID`)
    REFERENCES `autohaus`.`rechnungsposition` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`mitarbeiter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`mitarbeiter` (
  `mitarbeiterNr` INT(255) NOT NULL AUTO_INCREMENT,
  `vorname` VARCHAR(99) NOT NULL,
  `nachname` VARCHAR(99) NOT NULL,
  `telefon` VARCHAR(99) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`mitarbeiterNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`reparatur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`reparatur` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Auto_ID` INT(11) NOT NULL,
  `Mitarbeiter_ID` INT(11) NOT NULL,
  `Datum` DATE NOT NULL,
  `Beschreibung` VARCHAR(255) NOT NULL,
  `Kosten` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `Auto_ID` (`Auto_ID` ASC),
  INDEX `Mitarbeiter_ID` (`Mitarbeiter_ID` ASC),
  CONSTRAINT `reparatur_ibfk_1`
    FOREIGN KEY (`Auto_ID`)
    REFERENCES `autohaus`.`auto` (`autoNr`),
  CONSTRAINT `reparatur_ibfk_2`
    FOREIGN KEY (`Mitarbeiter_ID`)
    REFERENCES `autohaus`.`mitarbeiter` (`mitarbeiterNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`reparatur_ersatzteil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`reparatur_ersatzteil` (
  `reparaturID` INT(11) NOT NULL,
  `ersatzteilID` INT(11) NOT NULL,
  `anzahl` INT(11) NOT NULL,
  PRIMARY KEY (`reparaturID`, `ersatzteilID`),
  INDEX `ersatzteilID` (`ersatzteilID` ASC),
  CONSTRAINT `reparatur_ersatzteil_ibfk_1`
    FOREIGN KEY (`reparaturID`)
    REFERENCES `autohaus`.`reparatur` (`ID`),
  CONSTRAINT `reparatur_ersatzteil_ibfk_2`
    FOREIGN KEY (`ersatzteilID`)
    REFERENCES `autohaus`.`ersatzteil` (`teilNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`termine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`termine` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `kunde_ID` INT(11) NOT NULL,
  `auto_ID` INT(11) NOT NULL,
  `datum` DATE NOT NULL,
  `beschreibung` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `kunde_ID` (`kunde_ID` ASC),
  INDEX `auto_ID` (`auto_ID` ASC),
  CONSTRAINT `termine_ibfk_1`
    FOREIGN KEY (`kunde_ID`)
    REFERENCES `autohaus`.`kunde` (`kundenNr`),
  CONSTRAINT `termine_ibfk_2`
    FOREIGN KEY (`auto_ID`)
    REFERENCES `autohaus`.`auto` (`autoNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`verkauf`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`verkauf` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Auto_ID` INT(11) NOT NULL,
  `Kunde_ID` INT(11) NOT NULL,
  `Datum` DATE NOT NULL,
  `Preis` DECIMAL(10,2) NOT NULL,
  `Zahlungsmethode` VARCHAR(20) NOT NULL,
  `Finanzierung` TINYINT(1) NOT NULL DEFAULT '0',
  `Anzahlung` DECIMAL(10,2) NULL DEFAULT NULL,
  `Restbetrag` DECIMAL(10,2) NULL DEFAULT NULL,
  `Rechnungs_ID` INT(11) NOT NULL,
  `Mitarbeiter_ID` INT(11) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `Auto_ID` (`Auto_ID` ASC),
  INDEX `Kunde_ID` (`Kunde_ID` ASC),
  INDEX `Mitarbeiter_ID` (`Mitarbeiter_ID` ASC),
  CONSTRAINT `verkauf_ibfk_1`
    FOREIGN KEY (`Auto_ID`)
    REFERENCES `autohaus`.`auto` (`autoNr`),
  CONSTRAINT `verkauf_ibfk_2`
    FOREIGN KEY (`Kunde_ID`)
    REFERENCES `autohaus`.`kunde` (`kundenNr`),
  CONSTRAINT `verkauf_ibfk_3`
    FOREIGN KEY (`Mitarbeiter_ID`)
    REFERENCES `autohaus`.`mitarbeiter` (`mitarbeiterNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `autohaus`.`verkauf_ersatzteil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autohaus`.`verkauf_ersatzteil` (
  `verkaufID` INT(11) NOT NULL,
  `ersatzteilID` INT(11) NOT NULL,
  `anzahl` INT(11) NOT NULL,
  PRIMARY KEY (`verkaufID`, `ersatzteilID`),
  INDEX `ersatzteilID` (`ersatzteilID` ASC),
  CONSTRAINT `verkauf_ersatzteil_ibfk_1`
    FOREIGN KEY (`verkaufID`)
    REFERENCES `autohaus`.`verkauf` (`ID`),
  CONSTRAINT `verkauf_ersatzteil_ibfk_2`
    FOREIGN KEY (`ersatzteilID`)
    REFERENCES `autohaus`.`ersatzteil` (`teilNr`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Mitarbeiter
-- Insert data into Mitarbeiter table
INSERT INTO Mitarbeiter (vorname, nachname, telefon, email)
VALUES ('Max', 'Mustermann', '0123456789', 'max.mustermann@example.com'),
('Anna', 'Müller', '0987654321', 'anna.mueller@example.com'),
('Peter', 'Schulze', '015555555', 'peter.schulze@example.com'),
('Sarah', 'Krause', '017777777', 'sarah.krause@example.com'),
('Hans', 'Meier', '014444444', 'hans.meier@example.com');

-- Insert data into Kunde table
INSERT INTO Kunde (vorname, nachname, adresse, plz, telefon, email)
VALUES ('Johann', 'Schneider', 'Musterstraße 1', '12345', '0123456789', 'johann.schneider@example.com'),
('Lisa', 'Fischer', 'Hauptstraße 5', '54321', '0987654321', 'lisa.fischer@example.com'),
('Sebastian', 'Weber', 'Bahnhofstraße 3', '67890', '015555555', 'sebastian.weber@example.com'),
('Julia', 'Schmidt', 'Parkstraße 9', '09876', '017777777', 'julia.schmidt@example.com'),
('Markus', 'Bauer', 'Bergstraße 12', '45678', '014444444', 'markus.bauer@example.com');

-- Insert data into Auto table
INSERT INTO Auto (kundenNr, marke, modell, jahr, kilometerstand)
VALUES (1, 'BMW', '320i', 2019, 30000),
(2, 'Mercedes', 'C220', 2018, 40000),
(3, 'Volkswagen', 'Golf', 2020, 20000),
(4, 'Audi', 'A3', 2017, 50000),
(5, 'Ford', 'Fiesta', 2021, 10000);

-- Insert data into Rechnung table
INSERT INTO autohaus.rechnung (Verkauf_ID, Datum, Summe, kunde_kundenNr)
VALUES (1, '2023-04-25', 123.45, 1);

INSERT INTO autohaus.rechnung (Verkauf_ID, Datum, Summe, kunde_kundenNr)
VALUES (2, '2023-04-26', 678.90, 2);

INSERT INTO autohaus.rechnung (Verkauf_ID, Datum, Summe, kunde_kundenNr)
VALUES (3, '2023-04-27', 234.56, 3);

INSERT INTO autohaus.rechnung (Verkauf_ID, Datum, Summe, kunde_kundenNr)
VALUES (4, '2023-04-28', 789.01, 4);

INSERT INTO autohaus.rechnung (Verkauf_ID, Datum, Summe, kunde_kundenNr)
VALUES (5, '2023-04-29', 345.67, 5);

INSERT INTO Verkauf (Auto_ID, Kunde_ID, Datum, Preis, Zahlungsmethode, Mitarbeiter_ID, Rechnungs_ID)
VALUES (1, 2, '2022-03-14', 8000.00, 'Barzahlung', 1, 1),
(2, 1, '2022-04-05', 12000.00, 'Finanzierung', 2, 2),
(3, 2, '2022-05-07', 6500.00, 'Barzahlung', 1, 3),
(4, 3, '2022-06-21', 15000.00, 'Finanzierung', 3, 4),
(5, 4, '2022-07-18', 9000.00, 'Barzahlung', 4, 5);

INSERT INTO Reparatur (Auto_ID, Mitarbeiter_ID, Datum, Beschreibung, Kosten)
VALUES (1, 2, '2022-02-14', 'Ölwechsel', 150.00),
(2, 3, '2022-03-07', 'Austausch der Bremsbeläge', 350.00),
(3, 1, '2022-04-18', 'Reparatur des Kupplungssystems', 1200.00),
(4, 2, '2022-05-21', 'Reparatur des Motors', 3500.00),
(5, 4, '2022-06-14', 'Austausch des Kühlers', 800.00);

INSERT INTO Termine (kunde_ID, auto_ID, datum, beschreibung)
VALUES (2, 1, '2022-04-01', 'Ölwechsel und Inspektion'),
(3, 4, '2022-05-15', 'Reparatur der Bremsen'),
(1, 5, '2022-06-05', 'Inspektion und Reifenwechsel'),
(4, 2, '2022-07-12', 'Austausch der Batterie'),
(2, 3, '2022-08-01', 'Inspektion und Ölwechsel');

INSERT INTO Rechnungsposition (Rechnung_ID, Position, Beschreibung, Preis, Menge)
VALUES (1, 1, 'Gebrauchtwagen', 8000.00, 1),
(2, 1, 'Finanzierung', 12000.00, 1),
(3, 1, 'Gebrauchtwagen', 6500.00, 1),
(4, 1, 'Finanzierung', 15000.00, 1),
(5, 1, 'Gebrauchtwagen', 9000.00, 1);