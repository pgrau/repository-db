SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema repository
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `repository` ;

-- -----------------------------------------------------
-- Schema repository
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `repository` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `repository` ;

-- -----------------------------------------------------
-- Table `repository`.`project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `repository`.`project` ;

CREATE TABLE IF NOT EXISTS `repository`.`project` (
    `url_git` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `parent` VARCHAR(255) NULL,
    PRIMARY KEY (`url_git`),
    INDEX `fk_project_url` (`url_git` ASC) VISIBLE,
    UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
    INDEX `fk_project_project1_idx` (`parent` ASC) VISIBLE,
    CONSTRAINT `fk_project_project1`
    FOREIGN KEY (`parent`)
    REFERENCES `repository`.`project` (`url_git`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `repository`.`pipeline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `repository`.`pipeline` ;

CREATE TABLE IF NOT EXISTS `repository`.`pipeline` (
    `id` VARCHAR(36) NOT NULL,
    `status` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_pipeline_status` (`status` ASC) VISIBLE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `repository`.`project_has_version`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `repository`.`project_has_version` ;

CREATE TABLE IF NOT EXISTS `repository`.`project_has_version` (
    `version` VARCHAR(255) NOT NULL,
    `project_url_git` VARCHAR(255) NOT NULL,
    `pipeline_id` VARCHAR(36) NULL,
    INDEX `fk_version_project1_idx` (`project_url_git` ASC) VISIBLE,
    PRIMARY KEY (`project_url_git`, `version`),
    INDEX `fk_project_has_version_pipeline1_idx` (`pipeline_id` ASC) VISIBLE,
    CONSTRAINT `fk_version_project1`
    FOREIGN KEY (`project_url_git`)
    REFERENCES `repository`.`project` (`url_git`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_project_has_version_pipeline1`
    FOREIGN KEY (`pipeline_id`)
    REFERENCES `repository`.`pipeline` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `repository`.`commit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `repository`.`commit` ;

CREATE TABLE IF NOT EXISTS `repository`.`commit` (
    `reference` VARCHAR(40) NOT NULL,
    `url_git` VARCHAR(255) NOT NULL,
    `version` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`reference`),
    INDEX `fk_commit_version1_idx` (`url_git` ASC, `version` ASC) VISIBLE,
    CONSTRAINT `fk_commit_version1`
    FOREIGN KEY (`url_git` , `version`)
    REFERENCES `repository`.`project_has_version` (`project_url_git` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `repository`.`project_has_package`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `repository`.`project_has_package` ;

CREATE TABLE IF NOT EXISTS `repository`.`project_has_package` (
    `project_url_git` VARCHAR(255) NOT NULL,
    `package_url_git` VARCHAR(255) NOT NULL,
    `package_version` VARCHAR(255) NOT NULL,
    INDEX `fk_project_has_package_project1_idx` (`project_url_git` ASC) VISIBLE,
    INDEX `fk_project_has_package_project_has_version1_idx` (`package_url_git` ASC, `package_version` ASC) VISIBLE,
    PRIMARY KEY (`project_url_git`, `package_url_git`, `package_version`),
    CONSTRAINT `fk_project_has_package_project1`
    FOREIGN KEY (`project_url_git`)
    REFERENCES `repository`.`project` (`url_git`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_project_has_package_project_has_version1`
    FOREIGN KEY (`package_url_git` , `package_version`)
    REFERENCES `repository`.`project_has_version` (`project_url_git` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
