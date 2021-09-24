-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 24 Wrz 2021, 10:08
-- Wersja serwera: 10.4.17-MariaDB
-- Wersja PHP: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `cr`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_profiles` (OUT `result` INT)  begin 
select COUNT(*)
into result
from profile;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CrimeProfile` ()  BEGIN
select profile.PR_profile_ID as ProfileID, profile.PR_first_name as FirstName, 
profile.PR_middle_name as MiddleName, profile.PR_last_name as LastName,
crime.CR_crime_ID as CrimeID, crime.CR_crime_category as CrimeCategory
FROM
profile, crime
where profile.CR_crime_ID=crime.CR_crime_ID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DepartmentDetail` ()  begin
        select department.DEP_department_name as DepartmentName, department.DEP_department_email as Email, 
        department.DEP_department_phone as Phone, department_adress.DEP_state as StateID, state.ST_state as State, 
        department_adress.DEP_city as CityID, city.CI_city as City, 
        department_adress.DEP_street as StreetID, street.STR_street as Street, 
        department_adress.DEP_zip_code as ZipCodeID, zip_code.ZI_zip_code as ZipCode 
        FROM
        department, department_adress,state, city, street, zip_code
        where department.DEP_department_ID=department_adress.DEP_department_ID
        and state.ST_state_ID=department_adress.DEP_state
        and city.CI_city_ID=department_adress.DEP_city
        and street.STR_street_ID=department_adress.DEP_street
        and zip_code.ZI_zip_code_ID=department_adress.DEP_zip_code;
        end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DetermineAge` ()  BEGIN
    DECLARE tempId INT DEFAULT 0;
    DECLARE birthDate DATE;
    DECLARE age INT DEFAULT 0;
    DECLARE done int DEFAULT 0;

    DECLARE cur CURSOR FOR
        select PR_profile_id, PR_birth_date from profile;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;

    REPEAT
        FETCH cur INTO tempId, birthDate;
        set age = YEAR(current_timestamp) - YEAR(birthDate) - (RIGHT(CURRENT_TIMESTAMP, 2) < RIGHT(birthDate, 2));
        UPDATE profile set PR_age=`age` where PR_profile_id = `tempId`;
    UNTIL done = 1 END REPEAT;
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PersonalDataAppearance` ()  begin
select profile.PR_profile_ID as ProfileID, profile.PR_first_name as FirstName, profile.PR_middle_name as MiddleName, profile.PR_last_name as LastName,
profile.PR_birth_date as BirthDate, profile_detail.PD_gender as Gender, profile_detail.PD_rase as Rase, profile_detail.PD_height as Height, 
profile_detail.PD_weight as Weight, profile_detail.PD_eyes as Eyes, profile_detail.PD_hair_color as HairColor, profile_detail.PD_hair_lenght as HairLenght
FROM
profile, profile_detail
where profile.PR_profile_ID=profile_detail.PR_profile_ID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProfileAddress` ()  BEGIN
select profile.PR_profile_ID as ProfileID, profile.PR_first_name as FirstName, 
profile.PR_middle_name as MiddleName, profile.PR_last_name as LastName, 
profile.PR_birth_date as BirthDate, 
profile_address.PA_state as StateID, state.ST_state as State, 
profile_address.PA_city as CityID, city.CI_city as City 
FROM 
profile, profile_address,state, city 
where 
profile.PR_profile_ID=profile_address.PR_profile_ID 
and state.ST_state_ID=profile_address.PA_state 
and city.CI_city_ID=profile_address.PA_city;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProfileWithCar` ()  begin
select profile.PR_profile_ID as ProfileID, profile.PR_first_name as FirstName, 
profile.PR_middle_name as MiddleName, profile.PR_last_name as LastName,
profile_car.PC_car_plate as CarPlate, profile_car.CB_car_brand_ID as CarBrandID, 
car_brand.CB_car_brand as CarBrand
FROM
profile, profile_car, car_brand
where profile.PR_profile_ID = profile_car.PR_profile_ID
and profile_car.CB_car_brand_ID=car_brand.CB_car_brand_ID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Średnia_Wagi_WhiteCollarCrimes` ()  BEGIN
SELECT avg(PD_weight) as Średnia_Wagi
from profile_detail, profile, crime
where profile.CR_crime_ID=crime.CR_crime_ID
and profile.PR_profile_ID=profile_detail.PR_profile_ID
and crime.CR_crime_category='White Collar Crimes';
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Średnia_Wzorstu_WhiteCollarCrimes` ()  BEGIN
SELECT avg(PD_height) as Średnia_Wzorstu
from profile_detail, profile, crime
where profile.CR_crime_ID=crime.CR_crime_ID
and profile.PR_profile_ID=profile_detail.PR_profile_ID
and crime.CR_crime_category='White Collar Crimes';
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `WhiteCollarCriminalsCity` ()  BEGIN 
select PA_city as CityID, CI_city as City
from profile_address, profile, crime, city
where profile.PR_profile_ID=profile_address.PR_profile_ID
and city.CI_city_ID=profile_address.PA_city
and profile.CR_crime_ID=crime.CR_crime_ID
and crime.CR_crime_category='White Collar Crimes';
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `car_brand`
--

CREATE TABLE `car_brand` (
  `CB_car_brand_ID` int(11) NOT NULL,
  `CB_car_brand` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `car_brand`
--

INSERT INTO `car_brand` (`CB_car_brand_ID`, `CB_car_brand`) VALUES
(1, 'Acura'),
(2, 'Alfa Romeo'),
(3, 'Audi'),
(4, 'BMW'),
(5, 'Bentley'),
(6, 'Buick'),
(7, 'Cadillac'),
(8, 'Chevrolet'),
(9, 'Chrysler'),
(10, 'Dodge'),
(11, 'Fiat'),
(12, 'Ford'),
(13, 'GMC'),
(14, 'Genesis'),
(15, 'Honda'),
(16, 'Hyundai'),
(17, 'Infiniti'),
(18, 'Jaguar'),
(19, 'Jeep'),
(20, 'Kia'),
(21, 'Land Rover'),
(22, 'Lexus'),
(23, 'Lincoln'),
(24, 'Lotus'),
(25, 'Maserati'),
(26, 'Mazda'),
(27, 'Mercedes-Benz'),
(28, 'Mercury'),
(29, 'Mini'),
(30, 'Mitsubishi'),
(31, 'Nikola'),
(32, 'Nissan'),
(33, 'Polestar'),
(34, 'Pontiac'),
(35, 'Porsche'),
(36, 'Ram'),
(37, 'Rivian'),
(38, 'Rolls-Royce'),
(39, 'Saab'),
(40, 'Saturn'),
(41, 'Scion'),
(42, 'Smart'),
(43, 'Subaru'),
(44, 'Suzuki'),
(45, 'Tesla'),
(46, 'Toyota'),
(47, 'Volkswagen'),
(48, 'Volvo');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `city`
--

CREATE TABLE `city` (
  `CI_city_ID` int(11) NOT NULL,
  `CI_city` varchar(15) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `city`
--

INSERT INTO `city` (`CI_city_ID`, `CI_city`) VALUES
(1, 'New York'),
(2, 'Los Angeles '),
(3, 'Chicago'),
(4, 'Houston'),
(5, 'Phoenix'),
(6, 'Philadelphia'),
(7, 'San Antonio'),
(8, 'San Diego'),
(9, 'Dallas'),
(10, 'Albany'),
(11, 'Albuquerque'),
(12, 'Anchorage'),
(13, 'Atlanta'),
(14, 'Baltimore'),
(15, 'Birmingham'),
(16, 'Chelsea'),
(17, 'Buffalo'),
(18, 'Charlotte'),
(19, 'Chicago'),
(20, 'Cincinnati'),
(21, 'Cleveland'),
(22, 'Columbia'),
(23, 'Dallas'),
(24, 'Denver'),
(25, 'Detroit'),
(26, 'El Paso'),
(27, 'Kapolei'),
(28, 'Houston'),
(29, 'Indianapolis'),
(30, 'Jackson'),
(31, 'Jacksonville'),
(32, 'Kansas City'),
(33, 'Knoxville'),
(34, 'Las Vegas'),
(35, 'Little Rock'),
(36, 'Los Angeles'),
(37, 'Louisville'),
(38, 'Memphis'),
(39, 'Miramar'),
(40, 'St. Francis'),
(41, 'Brooklyn Center'),
(42, 'Mobile'),
(43, 'New Haven'),
(44, 'New Orleans'),
(45, 'New York'),
(46, 'Newark'),
(47, 'Chesapeake'),
(48, 'Oklahoma City'),
(49, 'Omaha'),
(50, 'Philadelphia'),
(51, 'Phoenix'),
(52, 'Pittsburgh'),
(53, 'Portland'),
(54, 'Richmond'),
(55, 'Roseville'),
(56, 'Salt Lake City'),
(57, 'San Antonio'),
(58, 'San Diego'),
(59, 'San Francisco'),
(60, 'Hato Rey'),
(61, 'Seattle'),
(62, 'Springfield'),
(63, 'St. Louis'),
(64, 'Tampa'),
(65, 'Washington');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `crime`
--

CREATE TABLE `crime` (
  `CR_crime_ID` int(11) NOT NULL,
  `CR_crime_category` varchar(50) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `crime`
--

INSERT INTO `crime` (`CR_crime_ID`, `CR_crime_category`) VALUES
(1, 'Crimes against children'),
(2, 'Violent Crimes - Murders'),
(3, 'Kiddnaping'),
(4, 'Missing Persons'),
(5, 'Parental Kidnappings'),
(6, 'White Collar Crimes'),
(7, 'Torrorism'),
(8, 'Fugitives'),
(9, 'Capitol Violence'),
(10, 'Robbery');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `department`
--

CREATE TABLE `department` (
  `DEP_department_ID` int(11) NOT NULL,
  `DEP_department_name` varchar(15) COLLATE utf8mb4_bin NOT NULL,
  `DEP_department_email` varchar(40) COLLATE utf8mb4_bin NOT NULL,
  `DEP_department_phone` varchar(11) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `department`
--

INSERT INTO `department` (`DEP_department_ID`, `DEP_department_name`, `DEP_department_email`, `DEP_department_phone`) VALUES
(1, 'Albany fbi', 'albany.fbi@email.com', '5184657551'),
(2, 'Albuquerque fbi', 'albuquerque.fbi@email.com', '5058891300'),
(3, 'Anchorage fbi', 'anchorage.fbi@email.com', '9072764441'),
(4, 'Atlanta fbi', 'atlanta.fbi@email.com', '7702163000'),
(5, 'Baltimore fbi', 'baltimore.fbi@email.com', '4102658080'),
(6, 'Birmingham fbi', 'birmingham.fbi@email.com', '2053266166'),
(7, 'Boston fbi', 'boston.fbi@email.com', '8573862000'),
(8, 'Buffalo fbi', 'buffalo.fbi@email.com', '7168567800'),
(9, 'Charlotte fbi', 'charlotte.fbi@email.com', '7046726100'),
(10, 'Chicago fbi', 'chicago.fbi@email.com', '3124216700'),
(11, 'Cincinnati fbi', 'cincinnati.fbi@email.com', '5134214310'),
(12, 'Cleveland fbi', 'cleveland.fbi@email.com', '2165221400'),
(13, 'Columbia fbi', 'columbia.fbi@email.com', '8035514200'),
(14, 'Dallas fbi', 'dallas.fbi@email.com', '9725595000');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `department_adress`
--

CREATE TABLE `department_adress` (
  `DEP_state` int(11) DEFAULT NULL,
  `DEP_city` int(11) DEFAULT NULL,
  `DEP_street` int(11) DEFAULT NULL,
  `DEP_zip_code` int(11) DEFAULT NULL,
  `DEP_department_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `department_adress`
--

INSERT INTO `department_adress` (`DEP_state`, `DEP_city`, `DEP_street`, `DEP_zip_code`, `DEP_department_ID`) VALUES
(37, 10, 1, 1, 1),
(36, 11, 2, 2, 2),
(2, 12, 3, 3, 3),
(13, 13, 4, 4, 4),
(25, 14, 5, 5, 5),
(1, 15, 6, 6, 6),
(37, 17, 8, 8, 8),
(38, 18, 9, 9, 9),
(41, 20, 11, 11, 11),
(48, 22, 13, 13, 13);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `nationalities`
--

CREATE TABLE `nationalities` (
  `NA_nationality_ID` int(11) NOT NULL,
  `NA_nationality` varchar(15) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `nationalities`
--

INSERT INTO `nationalities` (`NA_nationality_ID`, `NA_nationality`) VALUES
(1, 'Afghan'),
(2, 'Albanian'),
(3, 'Algerian'),
(4, 'Argentinian'),
(5, 'Australian'),
(6, 'Austrian'),
(7, 'Bangladeshi'),
(8, 'Belgian'),
(9, 'Bolivian'),
(10, 'Batswana'),
(11, 'Brazilian'),
(12, 'Bulgarian'),
(13, 'Cambodian'),
(14, 'Cameroonian'),
(15, 'Canadian'),
(16, 'Chilean'),
(17, 'Chinese'),
(18, 'Colombian'),
(19, 'Costa Rican'),
(20, 'Croatian'),
(21, 'Cuban'),
(22, 'Czech'),
(23, 'Danish'),
(24, 'Dominican'),
(25, 'Ecuadorian'),
(26, 'Egyptian'),
(27, 'Salvadorian'),
(28, 'English'),
(29, 'Estonian'),
(30, 'Ethiopian'),
(31, 'Fijian'),
(32, 'Finnish'),
(33, 'French'),
(34, 'German'),
(35, 'Ghanaian'),
(36, 'Greek'),
(37, 'Guatemalan'),
(38, 'Haitian'),
(39, 'Honduran'),
(40, 'Hungarian'),
(41, 'Icelandic'),
(42, 'Indian'),
(43, 'Indonesian'),
(44, 'Iranian'),
(45, 'Iraqi'),
(46, 'Irish'),
(47, 'Israeli'),
(48, 'Italian'),
(49, 'Jamaican'),
(50, 'Japanese'),
(51, 'Jordanian'),
(52, 'Kenyan'),
(53, 'Kuwaiti'),
(54, 'Lao'),
(55, 'Latvian'),
(56, 'Lebanese'),
(57, 'Libyan'),
(58, 'Lithuanian'),
(59, 'Malagasy'),
(60, 'Malaysian'),
(61, 'Malian'),
(62, 'Maltese'),
(63, 'Mexican'),
(64, 'Mongolian'),
(65, 'Moroccan'),
(66, 'Mozambican'),
(67, 'Namibian'),
(68, 'Nepalese'),
(69, 'Dutch'),
(70, 'New Zealand'),
(71, 'Nicaraguan'),
(72, 'Nigerian'),
(73, 'Norwegian'),
(74, 'Pakistani'),
(75, 'Panamanian'),
(76, 'Paraguayan'),
(77, 'Peruvian'),
(78, 'Philippine'),
(79, 'Polish'),
(80, 'Portuguese'),
(81, 'Romanian'),
(82, 'Russian'),
(83, 'Saudi'),
(84, 'Scottish'),
(85, 'Senegalese'),
(86, 'Serbian'),
(87, 'Singaporean'),
(88, 'Slovak'),
(89, 'South African'),
(90, 'Korean'),
(91, 'Spanish'),
(92, 'Sri Lankan'),
(93, 'Sudanese'),
(94, 'Swedish'),
(95, 'Swiss'),
(96, 'Syrian'),
(97, 'Taiwanese'),
(98, 'Tajikistani'),
(99, 'Thai'),
(100, 'Tongan'),
(101, 'Tunisian'),
(102, 'Turkish'),
(103, 'Ukrainian'),
(104, 'Emirati'),
(105, 'British'),
(106, 'American'),
(107, 'Uruguayan'),
(108, 'Venezuelan'),
(109, 'Vietnamese'),
(110, 'Welsh'),
(111, 'Zambian'),
(112, 'Zimbabwean');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `profile`
--

CREATE TABLE `profile` (
  `PR_profile_ID` int(11) NOT NULL,
  `PR_first_name` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `PR_middle_name` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `PR_last_name` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `PR_birth_date` date DEFAULT NULL,
  `PR_age` int(11) DEFAULT NULL,
  `CR_crime_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `profile`
--

INSERT INTO `profile` (`PR_profile_ID`, `PR_first_name`, `PR_middle_name`, `PR_last_name`, `PR_birth_date`, `PR_age`, `CR_crime_ID`) VALUES
(1, 'Jerold', 'C.', 'Dunning', '1959-12-07', 62, 1),
(2, 'Joanne', 'Deborah', 'Chesimard', '1947-06-16', 74, 7),
(3, 'Danielle', NULL, 'Imbo', '1970-08-07', 51, 3),
(4, 'Matthew', 'Alan', 'Mullaney', '1981-11-05', 40, 4),
(5, 'Ashley', 'Cynthia', 'Montalvo', '1984-04-28', 37, 2),
(6, 'Jeniffer', 'Lea', 'Settle', '1971-01-30', 50, 5),
(7, 'Hamed', 'Ahmed', 'Elbarki', '1977-02-12', 44, 6),
(8, 'Evelyn', NULL, 'Guzman', '1981-08-20', 40, 7),
(9, 'John', 'K.', 'Smith', '1975-05-03', 46, 5),
(12, 'Lucian', NULL, 'Michealson', '1997-02-03', 24, 6);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `profile_address`
--

CREATE TABLE `profile_address` (
  `PA_state` int(11) DEFAULT NULL,
  `PA_city` int(11) DEFAULT NULL,
  `PA_street` int(11) DEFAULT NULL,
  `PA_zip_code` int(11) DEFAULT NULL,
  `PR_profile_ID` int(11) DEFAULT NULL,
  `CR_crime_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `profile_address`
--

INSERT INTO `profile_address` (`PA_state`, `PA_city`, `PA_street`, `PA_zip_code`, `PR_profile_ID`, `CR_crime_ID`) VALUES
(6, 58, NULL, NULL, 7, 6),
(4, 5, NULL, NULL, 12, 6);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `profile_car`
--

CREATE TABLE `profile_car` (
  `PC_car_plate` varchar(7) COLLATE utf8mb4_bin DEFAULT NULL,
  `PR_profile_ID` int(11) DEFAULT NULL,
  `CB_car_brand_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `profile_car`
--

INSERT INTO `profile_car` (`PC_car_plate`, `PR_profile_ID`, `CB_car_brand_ID`) VALUES
('507-KLV', 1, 4);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `profile_detail`
--

CREATE TABLE `profile_detail` (
  `PD_gender` varchar(6) COLLATE utf8mb4_bin DEFAULT NULL,
  `PD_rase` varchar(15) COLLATE utf8mb4_bin DEFAULT NULL,
  `PD_height` int(3) DEFAULT NULL,
  `PD_weight` int(3) DEFAULT NULL,
  `PD_eyes` varchar(7) COLLATE utf8mb4_bin DEFAULT NULL,
  `PD_hair_color` varchar(6) COLLATE utf8mb4_bin DEFAULT NULL,
  `PD_hair_lenght` varchar(6) COLLATE utf8mb4_bin DEFAULT NULL,
  `PD_glasses` tinyint(1) DEFAULT 0,
  `PR_profile_ID` int(11) DEFAULT NULL,
  `NA_nationality_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `profile_detail`
--

INSERT INTO `profile_detail` (`PD_gender`, `PD_rase`, `PD_height`, `PD_weight`, `PD_eyes`, `PD_hair_color`, `PD_hair_lenght`, `PD_glasses`, `PR_profile_ID`, `NA_nationality_ID`) VALUES
('male', 'white', 170, 77, 'brown', 'brown', 'short', 0, 1, NULL),
('female', 'black', 170, 68, 'brown', 'black', 'long', 0, 2, NULL),
('female', 'white', 165, 62, 'hazel', 'brown', 'medium', 0, 3, NULL),
('male', 'white', 186, 82, 'hazel', 'brown', 'short', 0, 4, NULL),
('female', 'white', 156, 58, 'brown', 'blond', 'medium', 0, 5, NULL),
('female', 'white', 75, 167, 'brown', 'brown', 'long', 0, 6, NULL),
('male', 'white', 198, 94, 'blue', 'brown', 'bald', 0, 7, NULL),
('female', 'white', 172, 68, 'brown', 'black', 'long', 0, 8, NULL),
('male', 'white', 186, 88, 'brown', 'brown', 'short', 0, 9, 8),
('male', 'white', 190, 78, 'green', 'brown', 'short', 0, 12, 5);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `state`
--

CREATE TABLE `state` (
  `ST_state_ID` int(11) NOT NULL,
  `ST_state` varchar(15) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `state`
--

INSERT INTO `state` (`ST_state_ID`, `ST_state`) VALUES
(1, 'Alabama'),
(2, 'Alaska'),
(3, 'American Samoa'),
(4, 'Arizona'),
(5, 'Arkansas'),
(6, 'California'),
(7, 'Colorado'),
(8, 'Connecticut'),
(9, 'Delaware'),
(10, 'District of Col'),
(11, 'Federated State'),
(12, 'Florida'),
(13, 'Georgia'),
(14, 'Guam'),
(15, 'Hawaii'),
(16, 'Idaho'),
(17, 'Illinois'),
(18, 'Indiana'),
(19, 'Iowa'),
(20, 'Kansas'),
(21, 'Kentucky'),
(22, 'Louisiana'),
(23, 'Maine'),
(24, 'Marshall Island'),
(25, 'Maryland'),
(26, 'Massachusetts'),
(27, 'Michigan'),
(28, 'Minnesota'),
(29, 'Mississippi'),
(30, 'Missouri'),
(31, 'Montana'),
(32, 'Nebraska'),
(33, 'Nevada'),
(34, 'New Hampshire'),
(35, 'New Jersey'),
(36, 'New Mexico'),
(37, 'New York'),
(38, 'North Carolina'),
(39, 'North Dakota'),
(40, 'Northern Marian'),
(41, 'Ohio'),
(42, 'Oklahoma'),
(43, 'Oregon'),
(44, 'Palau'),
(45, 'Pennsylvania'),
(46, 'Puerto Rico'),
(47, 'Rhode Island'),
(48, 'South Carolina'),
(49, 'South Dakota'),
(50, 'Tennessee'),
(51, 'Texas'),
(52, 'Utah'),
(53, 'Vermont'),
(54, 'Virgin Islands'),
(55, 'Virginia'),
(56, 'Washington'),
(57, 'West Virginia'),
(58, 'Wisconsin'),
(59, 'Wyoming');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `street`
--

CREATE TABLE `street` (
  `STR_street_ID` int(11) NOT NULL,
  `STR_street` varchar(25) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `street`
--

INSERT INTO `street` (`STR_street_ID`, `STR_street`) VALUES
(1, 'McCarty Avenue'),
(2, 'Luecking Park Avenue'),
(3, 'East Sixth Avenue'),
(4, 'Flowers Road S'),
(5, 'Lord Baltimore Drive'),
(6, '18th Street North Birming'),
(7, 'Maple Street'),
(8, 'Plaza'),
(9, 'Microsoft Way'),
(10, 'Roosevelt Road'),
(11, 'Ronald Reagan Drive'),
(12, 'Lakeside Avenue'),
(13, 'Westpark Boulevard'),
(14, 'One Justice Way'),
(15, 'East 36th Avenue'),
(16, 'Michigan Ave'),
(17, 'South Mesa Hills Drive'),
(18, 'Enterprise Street'),
(19, 'Justice Park Drive'),
(20, 'Nelson B Klein Pkwy'),
(21, 'Echelon Parkway'),
(22, ' Gate Parkway'),
(23, 'Summit Street'),
(24, ' Dowell Springs Boulevard'),
(25, 'West Lake Mead Boulevard'),
(26, 'Shackleford West Boulevar'),
(27, 'Wilshire Boulevard'),
(28, 'Sycamore Station Place'),
(29, 'North Humphreys Boulevard'),
(30, '145th Avenue'),
(31, 'S. Lake Drive'),
(32, 'Freeway Boulevard'),
(33, 'North Royal Street'),
(34, ' State Street'),
(35, 'Leon C. Simon Boulevard'),
(36, 'Federal Plaza'),
(37, 'Centre Place'),
(38, 'West Memorial Road'),
(39, 'South 121st Court'),
(40, 'William J. Green'),
(41, 'N. 7th Street'),
(42, ' East Carson Street'),
(43, 'Cascades Parkway'),
(44, 'East Parham Road'),
(45, ' Freedom Way'),
(46, 'West Amelia Earhart Drive'),
(47, 'Heights Blvd'),
(48, 'Vista Sorrento'),
(49, 'Golden Gate Avenue'),
(50, 'Carlos Chardon Avenue'),
(51, '3rd Avenue'),
(52, 'East Linton Avenue'),
(53, ' Market Street'),
(54, 'West Gray Street'),
(55, ' 4th Street'),
(56, 'McCarty Avenue'),
(57, 'Luecking Park Avenue'),
(58, 'East Sixth Avenue'),
(59, 'Flowers Road S'),
(60, 'Lord Baltimore Drive'),
(61, '18th Street North Birming'),
(62, 'Maple Street'),
(63, 'Plaza'),
(64, 'Microsoft Way'),
(65, 'Roosevelt Road'),
(66, 'Ronald Reagan Drive'),
(67, 'Lakeside Avenue'),
(68, 'Westpark Boulevard'),
(69, 'One Justice Way'),
(70, 'East 36th Avenue'),
(71, 'Michigan Ave'),
(72, 'South Mesa Hills Drive'),
(73, 'Enterprise Street'),
(74, 'Justice Park Drive'),
(75, 'Nelson B Klein Pkwy'),
(76, 'Echelon Parkway'),
(77, ' Gate Parkway'),
(78, 'Summit Street'),
(79, ' Dowell Springs Boulevard'),
(80, 'West Lake Mead Boulevard'),
(81, 'Shackleford West Boulevar'),
(82, 'Wilshire Boulevard'),
(83, 'Sycamore Station Place'),
(84, 'North Humphreys Boulevard'),
(85, '145th Avenue'),
(86, 'S. Lake Drive'),
(87, 'Freeway Boulevard'),
(88, 'North Royal Street'),
(89, ' State Street'),
(90, 'Leon C. Simon Boulevard'),
(91, 'Federal Plaza'),
(92, 'Centre Place'),
(93, 'West Memorial Road'),
(94, 'South 121st Court'),
(95, 'William J. Green'),
(96, 'N. 7th Street'),
(97, ' East Carson Street'),
(98, 'Cascades Parkway'),
(99, 'East Parham Road'),
(100, ' Freedom Way'),
(101, 'West Amelia Earhart Drive'),
(102, 'Heights Blvd'),
(103, 'Vista Sorrento'),
(104, 'Golden Gate Avenue'),
(105, 'Carlos Chardon Avenue'),
(106, '3rd Avenue'),
(107, 'East Linton Avenue'),
(108, ' Market Street'),
(109, 'West Gray Street'),
(110, ' 4th Street');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zip_code`
--

CREATE TABLE `zip_code` (
  `ZI_zip_code_ID` int(11) NOT NULL,
  `ZI_zip_code` varchar(7) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Zrzut danych tabeli `zip_code`
--

INSERT INTO `zip_code` (`ZI_zip_code_ID`, `ZI_zip_code`) VALUES
(1, '12209'),
(2, '87107'),
(3, '99501'),
(4, '30341'),
(5, '21244'),
(6, '35203'),
(7, '02150'),
(8, '14202'),
(9, '28273'),
(10, '60608'),
(11, '45236'),
(12, '44114'),
(13, '29210'),
(14, '75220'),
(15, '80238'),
(16, '48226'),
(17, '79912'),
(18, '96707'),
(19, '77292'),
(20, '46250'),
(21, '39213'),
(22, '32256'),
(23, '64105'),
(24, '37909'),
(25, '89106'),
(26, '72211'),
(27, '90024'),
(28, '40299'),
(29, '38120'),
(30, '33027'),
(31, '53235'),
(32, '55430'),
(33, '36602'),
(34, '06511'),
(35, '70126'),
(36, '10278'),
(37, '07102'),
(38, '23320'),
(39, '73134'),
(40, '68137'),
(41, '19106'),
(42, '85024'),
(43, '15203'),
(44, '97220'),
(45, '23228'),
(46, '95678'),
(47, '84116'),
(48, '78249'),
(49, '92121'),
(50, '94102'),
(51, '00918'),
(52, '98101'),
(53, '62703'),
(54, '63103'),
(55, '33609'),
(56, '20535');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `car_brand`
--
ALTER TABLE `car_brand`
  ADD PRIMARY KEY (`CB_car_brand_ID`);

--
-- Indeksy dla tabeli `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`CI_city_ID`);

--
-- Indeksy dla tabeli `crime`
--
ALTER TABLE `crime`
  ADD PRIMARY KEY (`CR_crime_ID`);

--
-- Indeksy dla tabeli `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`DEP_department_ID`),
  ADD UNIQUE KEY `DEP_department_email` (`DEP_department_email`);

--
-- Indeksy dla tabeli `department_adress`
--
ALTER TABLE `department_adress`
  ADD KEY `DEP_department_ID` (`DEP_department_ID`),
  ADD KEY `UPDATE_ST_state_ID` (`DEP_state`),
  ADD KEY `UPDATE_CI_city_ID` (`DEP_city`),
  ADD KEY `UPDATE_STR_street_ID` (`DEP_street`),
  ADD KEY `UPDATE_ZI_zip_code_ID` (`DEP_zip_code`);

--
-- Indeksy dla tabeli `nationalities`
--
ALTER TABLE `nationalities`
  ADD PRIMARY KEY (`NA_nationality_ID`);

--
-- Indeksy dla tabeli `profile`
--
ALTER TABLE `profile`
  ADD PRIMARY KEY (`PR_profile_ID`),
  ADD KEY `CR_crime_ID` (`CR_crime_ID`);

--
-- Indeksy dla tabeli `profile_address`
--
ALTER TABLE `profile_address`
  ADD KEY `ST_state_ID` (`PA_state`),
  ADD KEY `CI_city_ID` (`PA_city`),
  ADD KEY `STR_street_ID` (`PA_street`),
  ADD KEY `ZI_zip_code_ID` (`PA_zip_code`),
  ADD KEY `PR_profile_ID` (`PR_profile_ID`),
  ADD KEY `CR_crime_ID` (`CR_crime_ID`);

--
-- Indeksy dla tabeli `profile_car`
--
ALTER TABLE `profile_car`
  ADD KEY `CB_car_brand_ID` (`CB_car_brand_ID`),
  ADD KEY `PR_profile_ID` (`PR_profile_ID`);

--
-- Indeksy dla tabeli `profile_detail`
--
ALTER TABLE `profile_detail`
  ADD KEY `PD_nationality_ID` (`NA_nationality_ID`),
  ADD KEY `PR_profile_ID` (`PR_profile_ID`);

--
-- Indeksy dla tabeli `state`
--
ALTER TABLE `state`
  ADD PRIMARY KEY (`ST_state_ID`);

--
-- Indeksy dla tabeli `street`
--
ALTER TABLE `street`
  ADD PRIMARY KEY (`STR_street_ID`);

--
-- Indeksy dla tabeli `zip_code`
--
ALTER TABLE `zip_code`
  ADD PRIMARY KEY (`ZI_zip_code_ID`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `car_brand`
--
ALTER TABLE `car_brand`
  MODIFY `CB_car_brand_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT dla tabeli `city`
--
ALTER TABLE `city`
  MODIFY `CI_city_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT dla tabeli `crime`
--
ALTER TABLE `crime`
  MODIFY `CR_crime_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT dla tabeli `department`
--
ALTER TABLE `department`
  MODIFY `DEP_department_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT dla tabeli `nationalities`
--
ALTER TABLE `nationalities`
  MODIFY `NA_nationality_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT dla tabeli `profile`
--
ALTER TABLE `profile`
  MODIFY `PR_profile_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `state`
--
ALTER TABLE `state`
  MODIFY `ST_state_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT dla tabeli `street`
--
ALTER TABLE `street`
  MODIFY `STR_street_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT dla tabeli `zip_code`
--
ALTER TABLE `zip_code`
  MODIFY `ZI_zip_code_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `department_adress`
--
ALTER TABLE `department_adress`
  ADD CONSTRAINT `UPDATE_CI_city_ID` FOREIGN KEY (`DEP_city`) REFERENCES `city` (`CI_city_ID`),
  ADD CONSTRAINT `UPDATE_STR_street_ID` FOREIGN KEY (`DEP_street`) REFERENCES `street` (`STR_street_ID`),
  ADD CONSTRAINT `UPDATE_ST_state_ID` FOREIGN KEY (`DEP_state`) REFERENCES `state` (`ST_state_ID`),
  ADD CONSTRAINT `UPDATE_ZI_zip_code_ID` FOREIGN KEY (`DEP_zip_code`) REFERENCES `zip_code` (`ZI_zip_code_ID`),
  ADD CONSTRAINT `department_adress_ibfk_1` FOREIGN KEY (`DEP_department_ID`) REFERENCES `department` (`DEP_department_ID`);

--
-- Ograniczenia dla tabeli `profile`
--
ALTER TABLE `profile`
  ADD CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`CR_crime_ID`) REFERENCES `crime` (`CR_crime_ID`);

--
-- Ograniczenia dla tabeli `profile_address`
--
ALTER TABLE `profile_address`
  ADD CONSTRAINT `CI_city_ID` FOREIGN KEY (`PA_city`) REFERENCES `city` (`CI_city_ID`),
  ADD CONSTRAINT `STR_street_ID` FOREIGN KEY (`PA_street`) REFERENCES `street` (`STR_street_ID`),
  ADD CONSTRAINT `ST_state_ID` FOREIGN KEY (`PA_state`) REFERENCES `state` (`ST_state_ID`),
  ADD CONSTRAINT `ZI_zip_code_ID` FOREIGN KEY (`PA_zip_code`) REFERENCES `zip_code` (`ZI_zip_code_ID`),
  ADD CONSTRAINT `profile_address_ibfk_1` FOREIGN KEY (`PR_profile_ID`) REFERENCES `profile` (`PR_profile_ID`),
  ADD CONSTRAINT `profile_address_ibfk_2` FOREIGN KEY (`CR_crime_ID`) REFERENCES `crime` (`CR_crime_ID`);

--
-- Ograniczenia dla tabeli `profile_car`
--
ALTER TABLE `profile_car`
  ADD CONSTRAINT `profile_car_ibfk_1` FOREIGN KEY (`CB_car_brand_ID`) REFERENCES `car_brand` (`CB_car_brand_ID`),
  ADD CONSTRAINT `profile_car_ibfk_2` FOREIGN KEY (`PR_profile_ID`) REFERENCES `profile` (`PR_profile_ID`);

--
-- Ograniczenia dla tabeli `profile_detail`
--
ALTER TABLE `profile_detail`
  ADD CONSTRAINT `PD_nationality_ID` FOREIGN KEY (`NA_nationality_ID`) REFERENCES `nationalities` (`NA_nationality_ID`),
  ADD CONSTRAINT `profile_detail_ibfk_1` FOREIGN KEY (`PR_profile_ID`) REFERENCES `profile` (`PR_profile_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
