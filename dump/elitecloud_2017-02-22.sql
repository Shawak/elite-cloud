-- --------------------------------------------------------
-- Host:                         localhost
-- Server Version:               5.5.54-0ubuntu0.14.04.1 - (Ubuntu)
-- Server Betriebssystem:        debian-linux-gnu
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Exportiere Datenbank Struktur für elitecloud
CREATE DATABASE IF NOT EXISTS `elitecloud` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `elitecloud`;

-- Exportiere Struktur von Tabelle elitecloud.auth_token
CREATE TABLE IF NOT EXISTS `auth_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `selector` char(12) NOT NULL,
  `token` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `selector` (`selector`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.auth_token: ~0 rows (ungefähr)
DELETE FROM `auth_token`;
/*!40000 ALTER TABLE `auth_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_token` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.roles: ~3 rows (ungefähr)
DELETE FROM `roles`;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`id`, `name`) VALUES
	(1, 'Admin'),
	(2, 'Moderator'),
	(3, 'Supporter');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `authKey` varchar(255) NOT NULL,
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.user: ~1 rows (ungefähr)
DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `name`, `password`, `email`, `banned`, `authKey`, `registered`) VALUES
	(1, 'Admin', '$2y$10$fRhTdVtBQ56FdtJMaXGAfOUSixOo7/R1i3p54vkT9JV9Xa5r4EVPa', '', NULL, 'devsome', '2017-02-18 03:48:52');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.userscript
CREATE TABLE IF NOT EXISTS `userscript` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `script` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.userscript: ~1 rows (ungefähr)
DELETE FROM `userscript`;
/*!40000 ALTER TABLE `userscript` DISABLE KEYS */;
INSERT INTO `userscript` (`id`, `author`, `name`, `description`, `script`) VALUES
	(1, 1, 'ConsoleLog', 'VGhpcyBpcyBqdXN0IGZvciB0aGUgY29uc29sZSBsb2c=', 'dmFyIG1lID0gZG9jdW1lbnQuY3VycmVudFNjcmlwdDsKbGV0IHNldHRpbmdzID0gZWxpdGVfY2xvdWQubG9hZFNldHRpbmdzKHsKICAibmFtZSI6ICJEZXZzb21lIiwKICAiYm9keSI6ICJCb2R5IHVuZCBzbyIKfSwgbWUuZ2V0QXR0cmlidXRlKCdkYXRhLWF0dHJpYnV0ZScpKTsKCgovLyBTY3JpcHQgc3RhcnRzIGhlcmUKY29uc29sZS5sb2coIk1laW4gU2NyaXB0IHd1cmRlIGdlc3RhcnRldCIpOwpjb25zb2xlLmxvZyhzZXR0aW5ncyk7CgpmdW5jdGlvbiBnZXROYW1lKCkgewogIGNvbnNvbGUubG9nKHNldHRpbmdzWyduYW1lJ10pOwp9CgpmdW5jdGlvbiBjaGFuZ2VTZXR0aW5ncygpIHsKICBjb25zb2xlLmxvZygnQ2hhbmdlU2V0dGluZ3M6ICcgKyBtZS5nZXRBdHRyaWJ1dGUoJ2RhdGEtYXR0cmlidXRlJykpOwogIHNldHRpbmdzWyduYW1lJ10gPSAicXFkZXYiOwogIHNldHRpbmdzWydib2R5J10gPSAiSGF0IG5vY2ggbmllbWFuZGVuIGdlc2NhbW10IDprZXBwbzoiOwogIGVsaXRlX2Nsb3VkLnNldFNldHRpbmdzKHNldHRpbmdzLCBtZS5nZXRBdHRyaWJ1dGUoJ2RhdGEtYXR0cmlidXRlJykpOwp9Cg==');
/*!40000 ALTER TABLE `userscript` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.user_roles
CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.user_roles: ~0 rows (ungefähr)
DELETE FROM `user_roles`;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.user_userscript
CREATE TABLE IF NOT EXISTS `user_userscript` (
  `user_id` int(11) NOT NULL,
  `userscript_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`userscript_id`),
  CONSTRAINT `user_userscript_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.user_userscript: ~1 rows (ungefähr)
DELETE FROM `user_userscript`;
/*!40000 ALTER TABLE `user_userscript` DISABLE KEYS */;
INSERT INTO `user_userscript` (`user_id`, `userscript_id`) VALUES
	(1, 1);
/*!40000 ALTER TABLE `user_userscript` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.user_userscripts_settings
CREATE TABLE IF NOT EXISTS `user_userscripts_settings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `userscript_id` int(11) NOT NULL,
  `settings` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_user_userscript_settings_userscript` (`userscript_id`),
  KEY `FK_user_userscripts_settings_user` (`user_id`),
  CONSTRAINT `FK_user_userscripts_settings_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FK_user_userscript_settings_userscript` FOREIGN KEY (`userscript_id`) REFERENCES `userscript` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.user_userscripts_settings: ~0 rows (ungefähr)
DELETE FROM `user_userscripts_settings`;
/*!40000 ALTER TABLE `user_userscripts_settings` DISABLE KEYS */;
INSERT INTO `user_userscripts_settings` (`id`, `user_id`, `userscript_id`, `settings`) VALUES
	(0, 1, 1, '{"name":"qqdev","body":"Hat noch niemanden gescammt :keppo:"}');
/*!40000 ALTER TABLE `user_userscripts_settings` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
