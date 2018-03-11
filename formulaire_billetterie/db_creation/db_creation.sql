-- MySQL Script generated by MySQL Workbench
-- Sun Mar 11 13:52:08 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ticketing
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ticketing
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ticketing` DEFAULT CHARACTER SET utf8 ;
USE `ticketing` ;

-- -----------------------------------------------------
-- Table `ticketing`.`events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`events` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`events` (
  `event_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NOT NULL,
  `total_quota` INT NOT NULL,
  `ticketing_start_date` DATETIME NOT NULL,
  `ticketing_end_date` DATETIME NOT NULL,
  `is_active` TINYINT NOT NULL DEFAULT 0,
  `has_guests` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`event_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`options` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`options` (
  `option_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NOT NULL,
  `is_active` TINYINT NOT NULL DEFAULT 0,
  `is_mandatory` TINYINT NOT NULL DEFAULT 0,
  `type` VARCHAR(45) NOT NULL,
  `quota` INT NULL,
  `specifications` TEXT NOT NULL COMMENT 'select => name + price + quota + is_mandatory\ncheckbox => price',
  `event_id` INT NOT NULL,
  PRIMARY KEY (`option_id`),
  INDEX `fk_options_events1_idx` (`event_id` ASC),
  CONSTRAINT `fk_options_events1`
    FOREIGN KEY (`event_id`)
    REFERENCES `ticketing`.`events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`promos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`promos` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`promos` (
  `promo_id` INT NOT NULL AUTO_INCREMENT,
  `promo_name` VARCHAR(45) NOT NULL,
  `still_student` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`promo_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`sites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`sites` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`sites` (
  `site_id` INT NOT NULL AUTO_INCREMENT,
  `site_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`site_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`promos_site_specifications`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`promos_site_specifications` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`promos_site_specifications` (
  `event_id` INT NOT NULL,
  `site_id` INT NOT NULL,
  `promo_id` INT NOT NULL,
  `price` VARCHAR(45) NOT NULL,
  `quota` VARCHAR(45) NOT NULL,
  `guest_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`event_id`, `site_id`, `promo_id`),
  INDEX `fk_promos_has_sites_sites1_idx` (`site_id` ASC),
  INDEX `fk_promos_has_sites_promos_idx` (`promo_id` ASC),
  INDEX `fk_site_specifications_idx` (`event_id` ASC),
  CONSTRAINT `fk_promos_has_sites_promos`
    FOREIGN KEY (`promo_id`)
    REFERENCES `ticketing`.`promos` (`promo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_promos_has_sites_sites1`
    FOREIGN KEY (`site_id`)
    REFERENCES `ticketing`.`sites` (`site_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_site_specifications`
    FOREIGN KEY (`event_id`)
    REFERENCES `ticketing`.`events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`participants`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`participants` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`participants` (
  `participant_id` INT NOT NULL AUTO_INCREMENT,
  `prenom` VARCHAR(45) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `is_icam` TINYINT NOT NULL,
  `price` DECIMAL NOT NULL,
  `inscription_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `payement` VARCHAR(45) NOT NULL DEFAULT 'PayIcam',
  `email` VARCHAR(255) NULL,
  `telephone` VARCHAR(45) NULL,
  `birthdate` DATE NULL,
  `sexe` TINYINT NULL,
  `event_id` INT NOT NULL,
  `site_id` INT NOT NULL,
  `promo_id` INT NOT NULL,
  PRIMARY KEY (`participant_id`),
  INDEX `fk_participants_promos_site_specifications1_idx` (`event_id` ASC, `site_id` ASC, `promo_id` ASC),
  CONSTRAINT `fk_participants_promos_site_specifications1`
    FOREIGN KEY (`event_id` , `site_id` , `promo_id`)
    REFERENCES `ticketing`.`promos_site_specifications` (`event_id` , `site_id` , `promo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`icam_has_guests`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`icam_has_guests` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`icam_has_guests` (
  `event_id` INT NOT NULL,
  `icam_id` INT NOT NULL,
  `guest_id` INT NOT NULL,
  PRIMARY KEY (`event_id`, `icam_id`, `guest_id`),
  INDEX `fk_participants_has_participants_participants2_idx` (`guest_id` ASC),
  INDEX `fk_participants_has_participants_participants1_idx` (`icam_id` ASC),
  INDEX `fk_icam_has_guests_events1_idx` (`event_id` ASC),
  CONSTRAINT `fk_participants_has_participants_participants1`
    FOREIGN KEY (`icam_id`)
    REFERENCES `ticketing`.`participants` (`participant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_participants_has_participants_participants2`
    FOREIGN KEY (`guest_id`)
    REFERENCES `ticketing`.`participants` (`participant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_icam_has_guests_events1`
    FOREIGN KEY (`event_id`)
    REFERENCES `ticketing`.`events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`promo_site_has_options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`promo_site_has_options` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`promo_site_has_options` (
  `event_id` INT NOT NULL,
  `site_id` INT NOT NULL,
  `promo_id` INT NOT NULL,
  `option_id` INT NOT NULL,
  PRIMARY KEY (`event_id`, `site_id`, `promo_id`, `option_id`),
  INDEX `fk_promos_site_specifications_has_options_options1_idx` (`option_id` ASC),
  INDEX `fk_promos_site_specifications_has_options_promos_site_speci_idx` (`event_id` ASC, `site_id` ASC, `promo_id` ASC),
  CONSTRAINT `fk_promos_site_specifications_has_options_promos_site_specifi1`
    FOREIGN KEY (`event_id` , `site_id` , `promo_id`)
    REFERENCES `ticketing`.`promos_site_specifications` (`event_id` , `site_id` , `promo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_promos_site_specifications_has_options_options1`
    FOREIGN KEY (`option_id`)
    REFERENCES `ticketing`.`options` (`option_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`participant_has_options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`participant_has_options` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`participant_has_options` (
  `event_id` INT NOT NULL,
  `participant_id` INT NOT NULL,
  `option_id` INT NOT NULL,
  `option_details` TEXT NOT NULL,
  PRIMARY KEY (`participant_id`, `option_id`, `event_id`),
  INDEX `fk_participants_has_options_options1_idx` (`option_id` ASC),
  INDEX `fk_participants_has_options_participants1_idx` (`participant_id` ASC),
  INDEX `fk_participants_has_options_events1_idx` (`event_id` ASC),
  CONSTRAINT `fk_participants_has_options_participants1`
    FOREIGN KEY (`participant_id`)
    REFERENCES `ticketing`.`participants` (`participant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_participants_has_options_options1`
    FOREIGN KEY (`option_id`)
    REFERENCES `ticketing`.`options` (`option_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_participants_has_options_events1`
    FOREIGN KEY (`event_id`)
    REFERENCES `ticketing`.`events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`arrivals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`arrivals` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`arrivals` (
  `arrival_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `participant_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`arrival_date`, `participant_id`, `event_id`),
  INDEX `fk_arrivals_participants1_idx` (`participant_id` ASC),
  INDEX `fk_arrivals_events1_idx` (`event_id` ASC),
  CONSTRAINT `fk_arrivals_participants1`
    FOREIGN KEY (`participant_id`)
    REFERENCES `ticketing`.`participants` (`participant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_arrivals_events1`
    FOREIGN KEY (`event_id`)
    REFERENCES `ticketing`.`events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ticketing`.`arrivals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticketing`.`arrivals` ;

CREATE TABLE IF NOT EXISTS `ticketing`.`arrivals` (
  `arrival_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `participant_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`arrival_date`, `participant_id`, `event_id`),
  INDEX `fk_arrivals_participants1_idx` (`participant_id` ASC),
  INDEX `fk_arrivals_events1_idx` (`event_id` ASC),
  CONSTRAINT `fk_arrivals_participants1`
    FOREIGN KEY (`participant_id`)
    REFERENCES `ticketing`.`participants` (`participant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_arrivals_events1`
    FOREIGN KEY (`event_id`)
    REFERENCES `ticketing`.`events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
