-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2024 at 08:15 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `diabetesrisk`
--

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `filename` varchar(255) NOT NULL,
  `file_size` int(11) NOT NULL,
  `file_type` varchar(50) NOT NULL,
  `upload_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`filename`, `file_size`, `file_type`, `upload_date`) VALUES
('uploads/67480e41c8b40_6704c7b18a5a4_image.jpg', 165125, 'jpg', '2024-11-28 12:01:29'),
('uploads/67480e43c4868_6704c7b18a5a4_image.jpg', 165125, 'jpg', '2024-11-28 12:01:31'),
('uploads/67480f41123b9_6704c7b18a5a4_image.jpg', 165125, 'jpg', '2024-11-28 12:05:45'),
('uploads/imagecomponent.png', 444436, 'png', '2024-11-28 12:42:18'),
('uploads/imagecomponent.png', 444436, 'png', '2024-11-28 12:42:40'),
('uploads/imagecomponent.png', 444436, 'png', '2024-11-28 12:44:08'),
('uploads/imagecomponent.png', 192414, 'png', '2024-11-28 12:44:08');

-- --------------------------------------------------------

--
-- Table structure for table `patientdetails`
--

CREATE TABLE `patientdetails` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patientdetails`
--

INSERT INTO `patientdetails` (`id`, `name`, `age`, `gender`, `image`) VALUES
(45, 'John Doe', 30, 'Male', 'patients/67480c24aa593.png'),
(415, 'John Doe', 30, 'Male', 'patients/67481629340de.png'),
(12345, 'John Doe', 30, 'Male', 'patients/67480b9926142.png');

-- --------------------------------------------------------

--
-- Table structure for table `registration`
--

CREATE TABLE `registration` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `registration_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `registration`
--

INSERT INTO `registration` (`id`, `name`, `mobile`, `email`, `username`, `password`, `registration_date`) VALUES
(1, 'chaithu', '7981915077', 'chaithu@gmail.com', 'chethan', '$2y$10$6MeUFRM8/8zLYqlxP.YM5.WJWNQS0vv8uUqpal8nShknwHurZvzxu', '2024-10-15'),
(2, 'sjdfklsd', '7981915077', 'sfjlsd@gmail.com', 'aac', '$2y$10$9wq332qBng4UwY/JO96yEOwHRGfWSvyRRdwgGQu/n.L1u8OYFxEk6', '2024-10-15');

-- --------------------------------------------------------

--
-- Table structure for table `risk`
--

CREATE TABLE `risk` (
  `id` int(11) NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Predicted_VF_Area` double NOT NULL,
  `Pancreas_Density` double NOT NULL,
  `Diabetes_Risk` varchar(100) NOT NULL,
  `TIMESTAMP` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `risk`
--

INSERT INTO `risk` (`id`, `Gender`, `Predicted_VF_Area`, `Pancreas_Density`, `Diabetes_Risk`, `TIMESTAMP`) VALUES
(1, 'Male', 12.5, 45.2, 'Yes', '2024-11-28 12:33:14');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `patientdetails`
--
ALTER TABLE `patientdetails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `registration`
--
ALTER TABLE `registration`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `risk`
--
ALTER TABLE `risk`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `patientdetails`
--
ALTER TABLE `patientdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12346;

--
-- AUTO_INCREMENT for table `registration`
--
ALTER TABLE `registration`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `risk`
--
ALTER TABLE `risk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
