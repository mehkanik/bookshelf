SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `bookshelf` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `bookshelf` ;

-- -----------------------------------------------------
-- Table `bookshelf`.`users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(60) NOT NULL ,
  `pass` VARCHAR(100) NOT NULL ,
  `group_id` INT UNSIGNED NOT NULL ,
  `email` VARCHAR(450) NOT NULL ,
  `open_id` INT UNSIGNED NULL ,
  `created` TIMESTAMP NOT NULL ,
  `updated` TIMESTAMP NOT NULL ,
  `status` TINYINT(4) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) );


-- -----------------------------------------------------
-- Table `bookshelf`.`groups`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(40) NOT NULL ,
  `description` VARCHAR(2000) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookshelf`.`openid`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`openid` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `user_id` INT UNSIGNED NOT NULL ,
  `provider` VARCHAR(200) NOT NULL ,
  `url` VARCHAR(2048) NOT NULL ,
  `digest` TEXT NULL ,
  `hash` VARCHAR(60) NULL ,
  `request_token` VARCHAR(60) NULL ,
  `auth_token` VARCHAR(60) NULL ,
  `auth_pubkey` TEXT NULL ,
  `session_token` VARCHAR(60) NULL ,
  `authenticated` TINYINT(1) NOT NULL ,
  `rejected` TINYINT(1) NULL ,
  `created` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `openid_users_id_idx` (`user_id` ASC) ,
  CONSTRAINT `openid_users_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `bookshelf`.`users` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookshelf`.`posts`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(400) NOT NULL ,
  `content` LONGTEXT NOT NULL ,
  `user_id` INT UNSIGNED NULL ,
  `group_id` INT UNSIGNED NULL ,
  `cookie` VARCHAR(128) NULL ,
  `visibility` TINYINT(4) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `posts_users_id_idx` (`user_id` ASC) ,
  INDEX `posts_groups_id_idx` (`group_id` ASC) ,
  FULLTEXT INDEX `posts_title_idx` (`title` ASC) ,
  CONSTRAINT `posts_users_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `bookshelf`.`users` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `posts_groups_id`
    FOREIGN KEY (`group_id` )
    REFERENCES `bookshelf`.`groups` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookshelf`.`sessions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`sessions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `user_id` INT UNSIGNED NOT NULL ,
  `session_cookie` VARCHAR(45) NOT NULL ,
  `csrf_token` VARCHAR(45) NOT NULL COMMENT 'CSRF: Sessions last for approximately 5 minutes, and are refreshed when next used to refresh the CSRF Token + session cookie. The browser will send keepalives every minute while connected which will regenerate the CSRF tokens (GET /ajax-refresh).' ,
  `expires` TIMESTAMP NOT NULL ,
  `created` TIMESTAMP NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `sessions_users_id_idx` (`user_id` ASC) ,
  CONSTRAINT `sessions_users_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `bookshelf`.`users` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookshelf`.`user_groups`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`user_groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `user_id` INT UNSIGNED NOT NULL ,
  `group_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `user_groups_groups_id_idx` (`group_id` ASC) ,
  INDEX `user_groups_users_id_idx` (`user_id` ASC) ,
  CONSTRAINT `user_groups_groups_id`
    FOREIGN KEY (`group_id` )
    REFERENCES `bookshelf`.`groups` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `user_groups_users_id`
    FOREIGN KEY (`user_id` )
    REFERENCES `bookshelf`.`users` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookshelf`.`permission`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`permission` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL ,
  `description` TEXT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookshelf`.`permissions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `bookshelf`.`permissions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `group_id` INT UNSIGNED NOT NULL ,
  `permission_id` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `permissions_permission_id_idx` (`permission_id` ASC) ,
  INDEX `permissions_groups_id_idx` (`group_id` ASC) ,
  CONSTRAINT `permissions_groups_id`
    FOREIGN KEY (`group_id` )
    REFERENCES `bookshelf`.`groups` (`id` )
    ON DELETE CASCADE 
    ON UPDATE CASCADE ,
  CONSTRAINT `permissions_permission_id`
    FOREIGN KEY (`permission_id` )
    REFERENCES `bookshelf`.`permission` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `bookshelf` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
