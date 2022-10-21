-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.22-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for g00398357
CREATE DATABASE IF NOT EXISTS `g00398357` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `g00398357`;

-- Dumping structure for table g00398357.items
CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `description` text NOT NULL,
  `price` float NOT NULL,
  `capacity` int(11) DEFAULT NULL,
  `imgURL` char(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table g00398357.items: ~7 rows (approximately)
INSERT INTO `items` (`id`, `name`, `description`, `price`, `capacity`, `imgURL`) VALUES
	(1, 'Faithfull', 'Standard pressed steel construction. 5L capacity to meet petrol transportation regulations.', 29.99, 5, 'Faithfull-5L.jpg'),
	(2, 'Halfords', 'Green pressed steel construction, recessed centre weld. Single centred carrying handle.', 49.99, 20, 'Halfords-20L.jpg'),
	(3, 'Jefferson', 'Green pressed steel construction. Mid sized alternative.', 39.99, 10, 'Jefferson-10L.jpg'),
	(4, 'Lordos', 'White plastic construction with pouring tap. Ideal for drinking water.', 25, 20, 'Lordos-20L.jpg'),
	(5, 'Plastic', 'Plastique construction, black, light weight. Screw on pouring spout supplied.', 32.99, 20, 'Plastic-20L.jpg'),
	(6, 'Sealey', 'Red pressed steel construction, recessed centre weld.', 55, 20, 'Sealey-20L.jpg'),
	(7, 'TradeWest', 'Grey pressed steel construction, centre weld, plastic lined.', 38.99, 20, 'TradeWest-20L.jpg'),
	(8, 'Vintage', 'An original vintage container from the 1940\'s featuring all the design features that have held through to the best cans available today.', 259.99, 20, 'Vintage-20L.jpg');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
