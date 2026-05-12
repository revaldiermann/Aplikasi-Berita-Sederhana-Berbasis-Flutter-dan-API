-- phpMyAdmin SQL Dump
-- version 5.2.0
-- Database: `db_news`

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

--
-- Table structure for table `posting`
--

CREATE TABLE `posting` (
  `id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `isi` text NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posting`
--

INSERT INTO `posting` (`id`, `judul`, `isi`, `gambar`, `created_at`, `updated_at`) VALUES
(1, 'Berita Terkini tentang Teknologi', 'Ini adalah konten berita terkini tentang perkembangan teknologi terbaru.', 'tech1.jpg', '2023-08-10 06:30:00', NULL),
(2, 'Perkembangan Ekonomi Nasional', 'Berita tentang perkembangan ekonomi nasional terbaru.', 'economy.jpg', '2023-08-10 07:15:00', NULL),
(3, 'Prestasi Atlet Indonesia', 'Berita tentang prestasi terbaru atlet Indonesia di kancah internasional.', 'sport.jpg', '2023-08-10 08:00:00', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `posting`
--
ALTER TABLE `posting`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `posting`
--
ALTER TABLE `posting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

COMMIT; 