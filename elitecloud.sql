-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Erstellungszeit: 26. Aug 2016 um 18:32
-- Server-Version: 10.1.13-MariaDB
-- PHP-Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `elitecloud`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `flag` int(11) DEFAULT NULL,
  `authKey` varchar(255) NOT NULL,
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `user`
--

INSERT INTO `user` (`id`, `name`, `password`, `flag`, `authKey`, `registered`) VALUES
(1, 'Shawak', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 0, 'a0deb698e6e3827938b45a5159bd04d238d39d10c7e77c1844ead82274bddb89', '2016-08-05 01:19:31'),
(2, 'Shawak2', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 0, '', '2016-08-05 01:19:31'),
(3, 'Shawak3', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 0, '0ba8d1670f6dd3e4447e7423a767314590a47bceb0bc658489dc8a7c52248274', '2016-08-05 01:20:31');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `userscript`
--

CREATE TABLE `userscript` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `author` int(11) NOT NULL,
  `script` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `userscript`
--

INSERT INTO `userscript` (`id`, `name`, `author`, `script`) VALUES
(1, 'Erster userscript', 1, 'KGZ1bmN0aW9uKCkgew0KDQpjb25zb2xlLmxvZygiU2NyaXB0MSIpDQoNCn0pKCk7'),
(2, 'Zweiter Userscript', 1, 'KGZ1bmN0aW9uKCkgew0KDQpjb25zb2xlLmxvZygiU2NyaXB0MiIpDQoNCn0pKCk7'),
(3, 'Dritter Userscript', 1, '');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `user_userscript`
--

CREATE TABLE `user_userscript` (
  `userID` int(11) NOT NULL,
  `userscriptID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `user_userscript`
--

INSERT INTO `user_userscript` (`userID`, `userscriptID`) VALUES
(1, 1),
(1, 2);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`);

--
-- Indizes für die Tabelle `userscript`
--
ALTER TABLE `userscript`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `id_2` (`id`);

--
-- Indizes für die Tabelle `user_userscript`
--
ALTER TABLE `user_userscript`
  ADD PRIMARY KEY (`userID`,`userscriptID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT für Tabelle `userscript`
--
ALTER TABLE `userscript`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
