-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 10 Feb 2026 pada 06.34
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_lamp_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity_logs`
--

CREATE TABLE `activity_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `lamp_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `activity_logs`
--

INSERT INTO `activity_logs` (`log_id`, `user_id`, `lamp_id`, `action`, `description`, `ip_address`, `created_at`) VALUES
(1, 1, NULL, 'REGISTER', 'User rrnnndii_ mendaftar sebagai ADMIN', '127.0.0.1', '2026-02-10 03:40:40'),
(2, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 03:46:37'),
(3, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 03:47:33'),
(4, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 03:49:08'),
(5, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 03:53:15'),
(6, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 03:53:21'),
(7, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 03:56:39'),
(8, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 04:02:21'),
(9, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 04:02:22'),
(10, 1, NULL, 'LOGOUT', 'User rrnnndii_ logout', '127.0.0.1', '2026-02-10 04:02:31'),
(11, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 04:09:16'),
(12, 1, NULL, 'MODE_CHANGE', 'Mode lampu 1 dari AUTO ke MANUAL', '127.0.0.1', '2026-02-10 04:09:29'),
(13, 1, NULL, 'MODE_CHANGE', 'Mode lampu 1 dari MANUAL ke MANUAL', '127.0.0.1', '2026-02-10 04:10:45'),
(14, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 04:35:21'),
(15, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 04:35:22'),
(16, 1, 3, 'MODE_CHANGE', 'Mode lampu 3 dari AUTO ke MANUAL', '127.0.0.1', '2026-02-10 04:35:28'),
(17, 1, 3, 'MANUAL_COMMAND', 'Manual command lampu 3: ON (relay sebelumnya OFF)', '127.0.0.1', '2026-02-10 04:35:32'),
(18, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 04:58:40'),
(19, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 05:14:50'),
(20, 1, NULL, 'LOGIN', 'User rrnnndii_ login', '127.0.0.1', '2026-02-10 05:15:45'),
(21, 1, NULL, 'LOGOUT', 'User rrnnndii_ logout', '127.0.0.1', '2026-02-10 05:16:54'),
(22, 2, NULL, 'REGISTER', 'User keyka mendaftar sebagai USER', '127.0.0.1', '2026-02-10 05:27:20'),
(23, 3, NULL, 'REGISTER', 'User agus mendaftar sebagai USER', '127.0.0.1', '2026-02-10 05:28:42'),
(24, 3, NULL, 'LOGIN', 'User agus login', '127.0.0.1', '2026-02-10 05:29:16'),
(25, 3, NULL, 'LOGIN', 'User agus login', '127.0.0.1', '2026-02-10 05:29:17'),
(26, 3, 4, 'MODE_CHANGE', 'Mode lampu 4 dari AUTO ke MANUAL', '127.0.0.1', '2026-02-10 05:29:47'),
(27, 3, 4, 'MODE_CHANGE', 'Mode lampu 4 dari MANUAL ke MANUAL', '127.0.0.1', '2026-02-10 05:29:47');

-- --------------------------------------------------------

--
-- Struktur dari tabel `energy_usage`
--

CREATE TABLE `energy_usage` (
  `usage_id` int(11) NOT NULL,
  `lamp_id` int(11) NOT NULL,
  `voltage` decimal(6,2) NOT NULL DEFAULT 220.00,
  `current` decimal(6,3) DEFAULT NULL,
  `power_watt` decimal(8,2) DEFAULT NULL,
  `kwh` decimal(10,4) NOT NULL DEFAULT 0.0000,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `lamps`
--

CREATE TABLE `lamps` (
  `lamp_id` int(11) NOT NULL,
  `lamp_name` varchar(50) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `mode` enum('AUTO','MANUAL') NOT NULL DEFAULT 'AUTO',
  `relay_state` enum('ON','OFF') NOT NULL DEFAULT 'OFF',
  `last_changed` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `manual_command` enum('ON','OFF') NOT NULL DEFAULT 'OFF',
  `ldr_value` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `lamps`
--

INSERT INTO `lamps` (`lamp_id`, `lamp_name`, `location`, `mode`, `relay_state`, `last_changed`, `created_at`, `updated_at`, `manual_command`, `ldr_value`) VALUES
(3, 'Lampu ruang tamu', 'Ruang Tamu', 'MANUAL', 'OFF', NULL, '2026-02-10 04:34:32', '2026-02-10 05:30:55', 'ON', 0),
(4, 'Lampu kamar', 'Kamar', 'MANUAL', 'OFF', NULL, '2026-02-10 04:34:32', '2026-02-10 05:31:03', 'OFF', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `sensors`
--

CREATE TABLE `sensors` (
  `sensor_id` int(11) NOT NULL,
  `lamp_id` int(11) NOT NULL,
  `sensor_type` enum('LDR') NOT NULL DEFAULT 'LDR',
  `adc_value` int(11) NOT NULL DEFAULT 0,
  `last_read` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `settings`
--

CREATE TABLE `settings` (
  `setting_id` int(11) NOT NULL,
  `lamp_id` int(11) NOT NULL,
  `threshold_on` int(11) NOT NULL DEFAULT 1200,
  `threshold_off` int(11) NOT NULL DEFAULT 900,
  `auto_delay_ms` int(11) NOT NULL DEFAULT 1000,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER','GUEST') NOT NULL DEFAULT 'USER',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`user_id`, `name`, `username`, `password_hash`, `role`, `created_at`, `updated_at`) VALUES
(1, 'grandy', 'rrnnndii_', 'scrypt:32768:8:1$UQzqc87REKkBh3BY$371405b06ed6de672548539491e813afd9e117b090cec7cfb384b83108c4d430a8b0878dba43a06391d92296a1aec7c96eb2ce4b08092628e86130e705303b5b', 'ADMIN', '2026-02-10 03:40:39', '2026-02-10 03:40:39'),
(2, 'keyka', 'keyka', 'scrypt:32768:8:1$QAbTaJCUwTydIiUt$26c874b5fa2a8be8d82ce0733a40faba7cb4b4a95a5de3cebe91767a3554843bcb8ce343d0a77cfeb860478a7d213f44f6d39e5a01c5d2afd69078b3517b8e27', 'USER', '2026-02-10 05:27:20', '2026-02-10 05:27:20'),
(3, 'agus', 'agus', 'scrypt:32768:8:1$G9KIIenEAtaXpWLe$f634d317b4b794793430919cd3e278dc62b769217e3ae4070ed781fa2fee61184dde95335ce66d15ff3f2064f296e9c73fa8f79b1d918f3140a2c228738e5782', 'USER', '2026-02-10 05:28:41', '2026-02-10 05:28:41');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `lamp_id` (`lamp_id`);

--
-- Indeks untuk tabel `energy_usage`
--
ALTER TABLE `energy_usage`
  ADD PRIMARY KEY (`usage_id`),
  ADD KEY `lamp_id` (`lamp_id`);

--
-- Indeks untuk tabel `lamps`
--
ALTER TABLE `lamps`
  ADD PRIMARY KEY (`lamp_id`);

--
-- Indeks untuk tabel `sensors`
--
ALTER TABLE `sensors`
  ADD PRIMARY KEY (`sensor_id`),
  ADD KEY `lamp_id` (`lamp_id`);

--
-- Indeks untuk tabel `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_id`),
  ADD UNIQUE KEY `lamp_id` (`lamp_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT untuk tabel `energy_usage`
--
ALTER TABLE `energy_usage`
  MODIFY `usage_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `lamps`
--
ALTER TABLE `lamps`
  MODIFY `lamp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `sensors`
--
ALTER TABLE `sensors`
  MODIFY `sensor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `settings`
--
ALTER TABLE `settings`
  MODIFY `setting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `activity_logs_ibfk_2` FOREIGN KEY (`lamp_id`) REFERENCES `lamps` (`lamp_id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `energy_usage`
--
ALTER TABLE `energy_usage`
  ADD CONSTRAINT `energy_usage_ibfk_1` FOREIGN KEY (`lamp_id`) REFERENCES `lamps` (`lamp_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `sensors`
--
ALTER TABLE `sensors`
  ADD CONSTRAINT `sensors_ibfk_1` FOREIGN KEY (`lamp_id`) REFERENCES `lamps` (`lamp_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `settings`
--
ALTER TABLE `settings`
  ADD CONSTRAINT `settings_ibfk_1` FOREIGN KEY (`lamp_id`) REFERENCES `lamps` (`lamp_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
