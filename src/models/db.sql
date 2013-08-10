CREATE TABLE `groups` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(30),
	PRIMARY KEY (`id`)
) Engine=InnoDB;

CREATE TABLE `openid` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`provider` VARCHAR(200) NOT NULL,
	`url` TEXT NOT NULL,
	`digest` TEXT NOT NULL,
	`hash` TEXT NOT NULL,
	`request_token` TEXT,
	`session_key` TEXT
	`authenticated` TINYINT(1),
	`rejected` TINYINT(1),
	`created` TIMESTAMP
) Engine=InnoDB;


CREATE TABLE `users` (
	`id` INT NOT NULL AUTO_INCREMENT, -- primary key
	`name` VARCHAR(60) NOT NULL, -- username
	`pass` VARCHAR(65), -- hashed password, can be null if openid
	`group` INT NOT NULL DEFAULT 1,
	`email` VARCHAR(200), -- can be NULL (unregistered)
	`openid` INT, -- optional openID auth

	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- hello logs
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY (`id`),

	FOREIGN KEY (`group`) REFERENCES `groups`(`id`)
		ON UPDATE CASCADE
		ON DELETE CASCADE,

	FOREIGN KEY (`openid`) REFERENCES `openid`(`id`)
		ON UPDATE CASCADE
		ON DELETE CASCADE

) Engine=MyISAM;


CREATE TABLE `posts` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(150),
	`content` TEXT NOT NULL,
	`owner` INT, -- null = anon
	`group` INT, -- if not null, a group owns this.
	`cookie` VARCHAR(26),
	`last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	PRIMARY KEY (`id`),

	FOREIGN KEY (`owner`) REFERENCES `users`(`id`)
		ON UPDATE CASCADE

) Engine=MyISAM;