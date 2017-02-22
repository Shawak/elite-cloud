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
	(1, 'Admin', '$2y$10$/8d603Aec1g5BAIbdhNJeOqYRrkPTk0PuNJI0Nfw1PmTULIKG3W9a', '', NULL, 'devsome', '2017-02-18 03:48:52');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.userscript
CREATE TABLE IF NOT EXISTS `userscript` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `key_name` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `script` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `key` (`key_name`),
  KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.userscript: ~2 rows (ungefähr)
DELETE FROM `userscript`;
/*!40000 ALTER TABLE `userscript` DISABLE KEYS */;
INSERT INTO `userscript` (`id`, `author`, `name`, `key_name`, `description`, `script`) VALUES
	(1, 1, 'Instant Delete', 'instant_delete', 'VGhpcyBzY3JpcHQgYWxsb3dzIHlvdSB0byBpbnN0YW50IGRlbGV0ZSBwb3N0IHlvdSBjYW4gZGVsZXRlLgpBbHNvIHlvdSBjYW4gc2VlIHRoZSBvbGQgZGVsZXRlZCB0ZXh0IGluIGEgc3BvaWxlci4=', 'Ly8gRnJvbSBlbGl0ZS1DbG91ZAoKLyoqCiAqIEB2YXIgZWxpdGVfY2xvdWRfc2NyaXB0X2lkCiAqIEByZXR1cm4gR2l2ZXMgeW91IHRoZSBjdXJyZW50IHNjcmlwdCBJRAogKiovCgovKioKICogQHZhciBzZXR0aW5ncwogKiBAcmV0dXJuIExvYWQgY2FjaGVkIHNldHRpbmdzICwgaWYgbm90IHVzZSBkZWZhdWx0CiAqKi8KdmFyIG15S2V5ID0gZG9jdW1lbnQuY3VycmVudFNjcmlwdC5nZXRBdHRyaWJ1dGUoJ2lkJyk7CnZhciBzZXR0aW5ncyA9IGVsaXRlX2Nsb3VkLmxvYWRTZXR0aW5ncyh7CiAgInJlYXNvbiI6ICJUaGlzIHBvc3QgaXMgd3JvbmcuIgp9LCBteUtleSApOwoKLy8gTWFpbiBzY3JpcHQgc3RhcnRzIGhlcmUKZnVuY3Rpb24gaW5zdGFudERlbGV0ZUNoYW5nZVNldHRpbmdzKHJlYXNvbikgewogIHNldHRpbmdzWydyZWFzb24nXSA9IHJlYXNvbjsKICBlbGl0ZV9jbG91ZC5zZXRTZXR0aW5ncyhzZXR0aW5ncywgbXlLZXkgKTsKfQpmdW5jdGlvbiBnZXRSZWFzb24oKSB7CiAgY29uc29sZS5sb2coc2V0dGluZ3NbJ3JlYXNvbiddKTsKfQoKZnVuY3Rpb24gd2l0aF9qcXVlcnkoZikgewogIHZhciBzY3JpcHQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCJzY3JpcHQiKTsKICBzY3JpcHQudHlwZSA9ICJ0ZXh0L2phdmFzY3JpcHQiOwogIHNjcmlwdC50ZXh0Q29udGVudCA9ICIoIiArIGYudG9TdHJpbmcoKSArICIpKGpRdWVyeSkiOwogIGRvY3VtZW50LmJvZHkuYXBwZW5kQ2hpbGQoc2NyaXB0KTsKfTsKCndpdGhfanF1ZXJ5KGZ1bmN0aW9uICgkKSB7CiAgdmFyIEZMQUdfREVMRVRFRCA9IDB4MDI7CgogIHZhciBjaGVja0RlbGV0ZWQgPSB0eXBlb2YgJCgiI2NvbGxhcHNlb2JqX3F1aWNrcmVwbHkiKS5odG1sKCkgPT0gdHlwZW9mIHVuZGVmaW5lZDsKICBpZihjaGVja0RlbGV0ZWQpeyByZXR1cm47IH0KCiAgJCgnaW5wdXRbaWRePSJwbGlzdF8iXScpLmVhY2goZnVuY3Rpb24gKCkgewogICAgdmFyIHBvc3RJZCA9ICQodGhpcykuYXR0cignaWQnKS5zcGxpdCgnXycpWzFdLAogICAgaXNEZWxldGVkID0gcGFyc2VJbnQoJCh0aGlzKS5hdHRyKCd2YWx1ZScpKSAmIEZMQUdfREVMRVRFRDsKCiAgICBpZiAoIWlzRGVsZXRlZCkgewogICAgICAkKHRoaXMpLmJlZm9yZSgKICAgICAgICAkKGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ2lucHV0JykpCiAgICAgICAgLmF0dHIoewogICAgICAgICAgdHlwZTogJ2J1dHRvbicsCiAgICAgICAgICBpZDogJ2RlbGV0ZV8nICsgcG9zdElkLAogICAgICAgICAgdmFsdWU6ICdEZWxldGUgUG9zdCcsCiAgICAgICAgICBzdHlsZTogJ2JvcmRlcjogbm9uZTtwYWRkaW5nOiAwO2JhY2tncm91bmQ6IG5vbmU7Y29sb3I6IHdoaXRlO3RleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lO2ZvbnQtd2VpZ2h0OiBib2xkO2ZvbnQtc2l6ZTogMTJweDsnCiAgICAgICAgfSkKICAgICAgICAuY2xpY2soZnVuY3Rpb24gKCkgewogICAgICAgICAgLy8gTWFrZSBzdXJlIHRoZSB1c2VyIGNhbm5vdCBmaXJlIGFub3RoZXIgcmVxdWVzdAogICAgICAgICAgJCh0aGlzKS5wcm9wKCJkaXNhYmxlZCIsIHRydWUpOwogICAgICAgICAgJCgiaW5wdXRbaWQ9J2RlbGV0ZV8iICsgcG9zdElkICsgIiddIikKICAgICAgICAgIC5jbG9zZXN0KCd0cicpCiAgICAgICAgICAubmV4dCgpCiAgICAgICAgICAuaGlkZSgnZmFzdCcpOwogICAgICAgICAgJC5hamF4KHsKICAgICAgICAgICAgdXJsOiAiaW5saW5lbW9kLnBocCIsCiAgICAgICAgICAgIHR5cGU6ICdQT1NUJywKICAgICAgICAgICAgZGF0YTogewogICAgICAgICAgICAgICdkZWxldGVyZWFzb24nOiBzZXR0aW5nc1sncmVhc29uJ10gPyBzZXR0aW5nc1sncmVhc29uJ10gOiAiIiwKICAgICAgICAgICAgICAnZGVsZXRldHlwZSc6ICIxIiwKICAgICAgICAgICAgICAnZG8nOiAiZG9kZWxldGVwb3N0cyIsCiAgICAgICAgICAgICAgJ3NlY3VyaXR5dG9rZW4nOiB3aW5kb3cuU0VDVVJJVFlUT0tFTiwKICAgICAgICAgICAgICAncG9zdGlkcyc6IHBvc3RJZCwKICAgICAgICAgICAgICAndCc6IHdpbmRvdy50aHJlYWRpZAogICAgICAgICAgICB9LAogICAgICAgICAgICBzdWNjZXNzOiBmdW5jdGlvbiAoZGF0YSkgewogICAgICAgICAgICAgICQoJyNwb3N0JyArIHBvc3RJZCkuYWZ0ZXIoJzx0YWJsZSB3aWR0aD0iMTAwJSIgY2VsbHNwYWNpbmc9IjAiIGNlbGxwYWRkaW5nPSI2IiBib3JkZXI9IjAiIGFsaWduPSJjZW50ZXIiIGNsYXNzPSJ0Ym9yZGVyIj48dGJvZHk+PHRyPjx0ZCBzdHlsZT0iZm9udC13ZWlnaHQ6bm9ybWFsOyBib3JkZXI6IDFweCBzb2xpZCAjRURFREVEOyBib3JkZXItcmlnaHQ6IDBweCIgY2xhc3M9InRoZWFkIj5TdWNjZXNzZnVsbHk8L3RkPjwvdHI+PHRyIHZhbGlnbj0idG9wIj48dGQgd2lkdGg9IjE3NSIgc3R5bGU9ImJvcmRlcjogMXB4IHNvbGlkICNFREVERUQ7IGJvcmRlci10b3A6IDBweDsgYm9yZGVyLWJvdHRvbTogMHB4IiBjbGFzcz0iYWx0MiI+PGRpdiBjbGFzcz0ic21hbGxmb250Ij4mbmJzcDs8YnI+PGI+UG9zdCBnb3QgZGVsZXRlZDwvYj48YnI+Jm5ic3A7PC9kaXY+ICA8L3RkPjwvdHI+PC90Ym9keT48L3RhYmxlPicpOwogICAgICAgICAgICAgICQoJyNwb3N0JyArIHBvc3RJZCkucmVtb3ZlKCk7CiAgICAgICAgICAgIH0KICAgICAgICAgIH0pOwogICAgICB9KSk7CiAgICB9IGVsc2UgewogICAgaWYgKHdpbmRvdy5sb2NhdGlvbi5wcm90b2NvbCAhPSAiaHR0cHM6IikgewogICAgICB2YXIgdXJsR2V0ID0gImh0dHA6Ly93d3cuZWxpdGVwdnBlcnMuY29tL2ZvcnVtL3Bvc3RpbmdzLnBocD9kbz1tYW5hZ2Vwb3N0JnA9IjsKICAgIH0gZWxzZSB7CiAgICAgIHZhciB1cmxHZXQgPSAiaHR0cHM6Ly93d3cuZWxpdGVwdnBlcnMuY29tL2ZvcnVtL3Bvc3RpbmdzLnBocD9kbz1tYW5hZ2Vwb3N0JnA9IjsKICAgIH0KICAgIHZhciBqcXhociA9ICQuZ2V0KCB1cmxHZXQgKyBwb3N0SWQsIGZ1bmN0aW9uKCkgewogICAgICAvLyBub25lCiAgICB9KQogICAgLmZhaWwoZnVuY3Rpb24oKSB7CiAgICAgIGNvbnNvbGUubG9nKCAiW0Vycm9yXVsiICsgZWxpdGVfY2xvdWRfc2NyaXB0X2lkICsgIl0gPT4gIiArIHdpbmRvdy5sb2NhdGlvbi5ocmVmKTsKICAgIH0pOwoKICAgIGpxeGhyLmFsd2F5cyhmdW5jdGlvbigpIHsKICAgICAgdmFyIGJ1ZmZlciA9IGpxeGhyLnJlc3BvbnNlVGV4dDsKICAgICAgJCggJyNwb3N0JyArIHBvc3RJZCApLmNsb3Nlc3QoImRpdiIpLmZpbmQoJy5hbHQxJykuaHRtbCggJzxkaXYgY2xhc3M9InNwb2lsZXItdW5jb2xsIj48ZGl2PjxzcGFuIGNsYXNzPSJzcG9pbGVyLXRpdGxlIHJvdW5kZWQtdG9wIj48YSBjbGFzcz0ic3BvaWxlci1idXR0b24iIGhyZWY9Iicrd2luZG93LmxvY2F0aW9uLmhyZWYrJyIjcG9zdCcrIHBvc3RJZCArJyIgcmVsPSJub2ZvbGxvdyIgb25jbGljaz0icmV0dXJuIHRvZ2dsZVNwb2lsZXIuY2FsbCh0aGlzKTsiPjxzcGFuIGNsYXNzPSJzcG9pbGVyLWljb24iPiZuYnNwOzwvc3Bhbj48c3BhbiBjbGFzcz0ic3BvaWxlci10ZXh0Ij5TaG93IHRleHQ8L3NwYW4+PC9hPjwvc3Bhbj48L2Rpdj48ZGl2IGNsYXNzPSJzcG9pbGVyLWNvbnRlbnQgcm91bmRlZC1ib3R0b20gYWx0MSIgc3R5bGU9ImRpc3BsYXk6IG5vbmU7Ij4nICsgJChidWZmZXIpLmZpbmQoIi5hbHQyIikuaHRtbCgpICsgJzwvZGl2PjwvZGl2PicgKTsKICAgICAgJCggIiNwb3N0IiArIHBvc3RJZCApLmZpbmQoJy5hbHQyOmZpcnN0JykuYXBwZW5kKCAnPGJyLz48c21hbGw+RGVsZXRlIFJlYXNvbjo8L3NtYWxsPicgKyAkKGJ1ZmZlcikuZmluZCggImlucHV0W25hbWU9J3JlYXNvbiddIiApLnZhbCgpICk7CiAgICB9KTsKCiAgICAkKCB0aGlzICkuY2xvc2VzdCggInRhYmxlIiApLmNzcyggIm9wYWNpdHkiLCAiLjciICk7CiAgICAkKCB0aGlzICkuY2xvc2VzdCggImRpdiIpLmZpbmQoJy5hbHQxJykudGV4dCggJ0xvYWRpbmcgdGV4dC4uLicgKTsKCiAgICAkKHRoaXMpLmJlZm9yZSgKICAgICAgJChkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdpbnB1dCcpKQogICAgICAuYXR0cih7CiAgICAgICAgdHlwZTogJ2J1dHRvbicsCiAgICAgICAgaWQ6ICdyZWRlbGV0ZV8nICsgcG9zdElkLAogICAgICAgIHZhbHVlOiAnUmVzdG9yZSBQb3N0JywKICAgICAgICBzdHlsZTogJ2JvcmRlcjogbm9uZTtwYWRkaW5nOiAwO2JhY2tncm91bmQ6IG5vbmU7Y29sb3I6IHdoaXRlO3RleHQtZGVjb3JhdGlvbjogdW5kZXJsaW5lO2ZvbnQtd2VpZ2h0OiBib2xkO2ZvbnQtc2l6ZTogMTJweDsnCiAgICAgIH0pCiAgICAgIC5jbGljayhmdW5jdGlvbiAoKSB7CiAgICAgICAgLy8gTWFrZSBzdXJlIHRoZSB1c2VyIGNhbm5vdCBmaXJlIGFub3RoZXIgcmVxdWVzdAogICAgICAgICQodGhpcykucHJvcCgiZGlzYWJsZWQiLCB0cnVlKTsKICAgICAgICAkKCJpbnB1dFtpZD0ncmVkZWxldGVfIiArIHBvc3RJZCArICInXSIpCiAgICAgICAgLmNsb3Nlc3QoJ3RyJykKICAgICAgICAubmV4dCgpCiAgICAgICAgLmhpZGUoJ2Zhc3QnKTsKICAgICAgICBkb2N1bWVudC5jb29raWUgPSAidmJ1bGxldGluX2lubGluZXBvc3Q9Iitwb3N0SWQgKyAiO3BhdGg9LyI7CiAgICAgICAgJC5hamF4KHsKICAgICAgICAgIHVybDogImlubGluZW1vZC5waHAiLAogICAgICAgICAgdHlwZTogJ1BPU1QnLAogICAgICAgICAgZGF0YTogewogICAgICAgICAgICAnZG8nOiAidW5kZWxldGVwb3N0cyIsCiAgICAgICAgICAgICdzZWN1cml0eXRva2VuJzogd2luZG93LlNFQ1VSSVRZVE9LRU4sCiAgICAgICAgICAgICdwb3N0aWRzJzogcG9zdElkLAogICAgICAgICAgICAndCc6IHdpbmRvdy50aHJlYWRpZAogICAgICAgICAgfSwKICAgICAgICAgIHN1Y2Nlc3M6IGZ1bmN0aW9uIChkYXRhKSB7CiAgICAgICAgICAgICQoJyNwb3N0JyArIHBvc3RJZCkuYWZ0ZXIoJzx0YWJsZSB3aWR0aD0iMTAwJSIgY2VsbHNwYWNpbmc9IjAiIGNlbGxwYWRkaW5nPSI2IiBib3JkZXI9IjAiIGFsaWduPSJjZW50ZXIiIGNsYXNzPSJ0Ym9yZGVyIj48dGJvZHk+PHRyPjx0ZCBzdHlsZT0iZm9udC13ZWlnaHQ6bm9ybWFsOyBib3JkZXI6IDFweCBzb2xpZCAjRURFREVEOyBib3JkZXItcmlnaHQ6IDBweCIgY2xhc3M9InRoZWFkIj5TdWNjZXNzZnVsbHk8L3RkPjwvdHI+PHRyIHZhbGlnbj0idG9wIj48dGQgd2lkdGg9IjE3NSIgc3R5bGU9ImJvcmRlcjogMXB4IHNvbGlkICNFREVERUQ7IGJvcmRlci10b3A6IDBweDsgYm9yZGVyLWJvdHRvbTogMHB4IiBjbGFzcz0iYWx0MiI+PGRpdiBjbGFzcz0ic21hbGxmb250Ij4mbmJzcDs8YnI+PGI+UmVzdG9yZWQgc3VjY2Vzc2Z1bGx5PC9iPjxicj4mbmJzcDs8L2Rpdj4gIDwvdGQ+PC90cj48L3Rib2R5PjwvdGFibGU+Jyk7CiAgICAgICAgICAgICQoJyNwb3N0JyArIHBvc3RJZCkucmVtb3ZlKCk7CiAgICAgICAgICB9CiAgICAgICAgfSk7CiAgICAgIH0pCiAgICApOwogIH0gLy8gZW5kIGVsc2UKICB9KTsgLy8gZW5kIGVhY2gKfSk7Cg=='),
	(17, 1, 'Doge amazing wow', 'doge_amazing_wow', 'U3VjaCAqKkFNQVpJTkcqKg==', 'Y29uc29sZS5sb2coZG9jdW1lbnQuY3VycmVudFNjcmlwdC5nZXRBdHRyaWJ1dGUoJ2lkJykpOw==');
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

-- Exportiere Daten aus Tabelle elitecloud.user_roles: ~1 rows (ungefähr)
DELETE FROM `user_roles`;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
	(1, 2);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;

-- Exportiere Struktur von Tabelle elitecloud.user_userscript
CREATE TABLE IF NOT EXISTS `user_userscript` (
  `user_id` int(11) NOT NULL,
  `userscript_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`userscript_id`),
  CONSTRAINT `user_userscript_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Exportiere Daten aus Tabelle elitecloud.user_userscript: ~2 rows (ungefähr)
DELETE FROM `user_userscript`;
/*!40000 ALTER TABLE `user_userscript` DISABLE KEYS */;
INSERT INTO `user_userscript` (`user_id`, `userscript_id`) VALUES
	(1, 1),
	(1, 17);
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

-- Exportiere Daten aus Tabelle elitecloud.user_userscripts_settings: ~1 rows (ungefähr)
DELETE FROM `user_userscripts_settings`;
/*!40000 ALTER TABLE `user_userscripts_settings` DISABLE KEYS */;
INSERT INTO `user_userscripts_settings` (`id`, `user_id`, `userscript_id`, `settings`) VALUES
	(0, 1, 1, '{"reason":"elite-cloud-debug"}');
/*!40000 ALTER TABLE `user_userscripts_settings` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
