USE master
GO
if exists (select * from sysdatabases where name ='theater')
	DROP DATABASE theater
GO

CREATE DATABASE theater
GO
USE theater
GO

CREATE TABLE Cities(
 Code INT NOT NULL UNIQUE CHECK(Code >= 1000), CHECK(Code <= 9999),
 Name VARCHAR(20) NOT NULL,
 Region VARCHAR(20) NOT NULL
);

CREATE TABLE Theaters(
 Name VARCHAR(100) UNIQUE NOT NULL,
 Year INT NOT NULL CHECK (Year > 0),
 Address VARCHAR(100),
 City VARCHAR(20) NOT NULL,
 Region VARCHAR(20) NOT NULL,
 PhoneNumber VARCHAR(64) UNIQUE,
 Email VARCHAR(64) UNIQUE
);

CREATE TABLE Halls(
 Name VARCHAR(255) NOT NULL,
 Capacity INT NOT NULL CHECK (Capacity > 0),
 TheaterName VARCHAR(100) NOT NULL
);

CREATE TABLE Actors(
 Name VARCHAR(100) UNIQUE NOT NULL,
 BirthDate DATE,
 Gender CHAR(1) NOT NULL,
 HomeTown VARCHAR(20) NOT NULL,
 Country VARCHAR(50) NOT NULL
);

CREATE TABLE Performances(
 Name VARCHAR(255) NOT NULL,
 Producer VARCHAR(100) NOT NULL,
 Duration INT NOT NULL, CHECK(Duration > 0),
 PremiereDate DATE NOT NULL,
 Genre VARCHAR(20),
 AgeLimit INT,
 Playwright VARCHAR(100),
 CostumeDesigner VARCHAR(100),
 Country VARCHAR(50) 
);

CREATE TABLE StarsIn(
 PerformanceName VARCHAR(255) NOT NULL,
 PremiereDate DATE NOT NULL,
 ActorName VARCHAR(100) NOT NULL,
);

CREATE TABLE Schedule(
 PerformanceName VARCHAR(255) NOT NULL,
 PremiereDate DATE NOT NULL,
 TheaterName VARCHAR(100) NOT NULL,
 HallName VARCHAR(255) NOT NULL,
 Date DATE NOT NULL,
 StartAt CHAR(5) NOT NULL,
 EndAt CHAR(5) NOT NULL,
 IsMoving VARCHAR(3) DEFAULT 'NO',
 SoldTickets VARCHAR(3) DEFAULT 'NO',
 HomeTheater VARCHAR(100) 
);

CREATE TABLE Attendences(
PerformanceName VARCHAR(255) NOT NULL,
PremiereDate DATE NOT NULL,
TheaterName VARCHAR(100) NOT NULL,
HallName VARCHAR(255) NOT NULL,
Date DATE  NOT NULL,
SoldTickets INT CHECK (SoldTickets >= 0)
);

CREATE TABLE Tickets(
PerformanceName VARCHAR(255) NOT NULL,
PremiereDate DATE NOT NULL,
TheaterName VARCHAR(100) NOT NULL,
HallName VARCHAR(255) NOT NULL,
Price FLOAT CHECK(PRICE >= 0) NOT NULL, 
Discount FLOAT CHECK(Discount BETWEEN 0 AND 100),
Date DATE NOT NULL
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE Cities ADD CONSTRAINT PK_Cities PRIMARY KEY(Name, Region);

ALTER TABLE Theaters ADD CONSTRAINT PK_Theaters PRIMARY KEY(Name);
ALTER TABLE Theaters ADD CONSTRAINT FK_Theaters FOREIGN KEY(City, Region) REFERENCES Cities(Name, Region);

ALTER TABLE Halls ADD CONSTRAINT PK_Halls PRIMARY KEY(Name, TheaterName);
ALTER TABLE Halls ADD CONSTRAINT FK_Halls FOREIGN KEY(TheaterName) REFERENCES Theaters(Name);

ALTER TABLE Actors ADD CONSTRAINT PK_Actors PRIMARY KEY(Name);

ALTER TABLE Performances ADD CONSTRAINT PK_Performances PRIMARY KEY(Name, PremiereDate);

ALTER TABLE StarsIn ADD CONSTRAINT PK_StarsIn PRIMARY KEY(PerformanceName, PremiereDate, ActorName);
ALTER TABLE StarsIn ADD CONSTRAINT FK_StarsIn_One FOREIGN KEY(ActorName) REFERENCES Actors(Name);
ALTER TABLE StarsIn ADD CONSTRAINT FK_StarsIn_Three FOREIGN KEY(PerformanceName, PremiereDate) REFERENCES Performances(Name, PremiereDate);

ALTER TABLE Schedule ADD CONSTRAINT PK_Schedule PRIMARY KEY(TheaterName, Date, HallName, StartAt);
ALTER TABLE Schedule ADD CONSTRAINT FK_Schedule_One FOREIGN KEY(TheaterName) REFERENCES Theaters(Name);
ALTER TABLE Schedule ADD CONSTRAINT FK_Schedule_Two FOREIGN KEY(PerformanceName, PremiereDate) REFERENCES Performances(Name, PremiereDate);
ALTER TABLE Schedule ADD CONSTRAINT FK_Schedule_Three FOREIGN KEY(HallName, TheaterName) REFERENCES Halls(Name, TheaterName);

ALTER TABLE Attendences ADD CONSTRAINT PK_Attendences PRIMARY KEY(TheaterName, Date, HallName, PerformanceName, PremiereDate);
ALTER TABLE Attendences ADD CONSTRAINT FK_Attendences_One FOREIGN KEY(TheaterName) REFERENCES Theaters(Name);
ALTER TABLE Attendences ADD CONSTRAINT FK_Attendences_Two FOREIGN KEY(PerformanceName, PremiereDate) REFERENCES Performances(Name, PremiereDate);
ALTER TABLE Attendences ADD CONSTRAINT FK_Attendences_Three FOREIGN KEY(HallName, TheaterName) REFERENCES Halls(Name, TheaterName);

ALTER TABLE Tickets ADD CONSTRAINT PK_Ticket PRIMARY KEY(PerformanceName, PremiereDate, Date);
ALTER TABLE Tickets ADD CONSTRAINT FK_Ticket_One FOREIGN KEY(TheaterName) REFERENCES Theaters(Name);
ALTER TABLE Tickets ADD CONSTRAINT FK_Ticket_Two FOREIGN KEY(HallName, TheaterName) REFERENCES Halls(Name, TheaterName);
ALTER TABLE Tickets ADD CONSTRAINT FK_Ticket_Three FOREIGN KEY(PerformanceName, PremiereDate) REFERENCES Performances(Name, PremiereDate);

----Cities------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

INSERT INTO Cities VALUES(1000, 'Sofia', 'Sofia');
INSERT INTO Cities VALUES(5800, 'Pleven', 'Pleven');
INSERT INTO Cities VALUES(2700, 'Blagoevgrad', 'Blagoevgrad');
INSERT INTO Cities VALUES(9000, 'Varna', 'Varna');
INSERT INTO Cities VALUES(8000, 'Burgas', 'Burgas');
INSERT INTO Cities VALUES(5500, 'Lovech', 'Lovech');
INSERT INTO Cities VALUES(6000, 'Stara Zagora', 'Stara Zagora');
INSERT INTO Cities VALUES(7000, 'Ruse', 'Ruse');
INSERT INTO Cities VALUES(5000, 'Veliko Tarnovo', 'Veliko Tarnovo');
INSERT INTO Cities VALUES(5300, 'Gabrovo', 'Gabrovo');
INSERT INTO Cities VALUES(4000, 'Plovdiv', 'Plovdiv');
INSERT INTO Cities VALUES(7100, 'Byala', 'Ruse');
INSERT INTO Cities VALUES(9101, 'Byala', 'Varna');
INSERT INTO Cities VALUES(5600, 'Troyan', 'Lovech');
INSERT INTO Cities VALUES(2790, 'Yakoruda', 'Blagoevgrad');
INSERT INTO Cities VALUES(3000, 'Vratsa', 'Vratsa');
INSERT INTO Cities VALUES(8230, 'Nessebar', 'Burgas');
INSERT INTO Cities VALUES(5900, 'Levski', 'Pleven');
INSERT INTO Cities VALUES(5100, 'Gorna Oryahovitsa', 'Veliko Tarnovo');
INSERT INTO Cities VALUES(3700, 'Vidin', 'Vidin');
INSERT INTO Cities VALUES(3400, 'Dimitrovgrad', 'Haskovo');
INSERT INTO Cities VALUES(9300, 'Dobrich', 'Dobrich');
INSERT INTO Cities VALUES(4400, 'Pazardzhik', 'Pazardzhik');
INSERT INTO Cities VALUES(6300, 'Haskovo', 'Haskovo');
INSERT INTO Cities VALUES(2300, 'Pernik', 'Pernik');

--------Theaters-----------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Theaters VALUES('National Theater "Ivan Vazov"', 1962, 'Dyakon Ignatiy 5', 'Sofia', 'Sofia', '02 8119227', 'theaterIvanVazov@abv.bg');
INSERT INTO Theaters VALUES('State Puppet Theater Gabrovo', 1970, 'St. St. Kiril and Metodii 11', 'Gabrovo', 'Gabrovo', '066809951', 'statePupetGabrovo@gmail.com');
INSERT INTO Theaters VALUES('Theater Laboratory Sfumato', 2011, 'D. Grekov 2','Sofia', 'Sofia', '02 9433890', 'theaterSfumato@gmail.com');
INSERT INTO Theaters VALUES('Metropolitan Puppet Theater', 1946, 'Yanko Sakazov 19', 'Sofia', 'Sofia', '02 9441424', 'theaterMetroPuppetSofia@abv.bg');
INSERT INTO Theaters VALUES('Bulgarian Navy Theater', 1936, 'Georgi Sava Rakovski 98','Sofia', 'Sofia', '02 9872303', 'navyBulgarianTheater@gmail.com');
INSERT INTO Theaters VALUES('Dramatic Theater "Ivan Radoev"', 1919, 'Vasil Levski 155','Pleven', 'Pleven', '064 834 376', 'dramatic_theater_Ivan_Radoev@gmail.com');
INSERT INTO Theaters VALUES('Dramatic Puppet Theater "Nikola Vaptsarov"', 1919, 'Georgi Izmirliev - Makedonche 1','Blagoevgrad', 'Blagoevgrad', '0879523729', 'dramaticTheaterNikolaVaptsarov@abv.bg');
INSERT INTO Theaters VALUES('Puppet Theater VESEL', 1998, 'Bacho Kiro 2', 'Veliko Tarnovo', 'Veliko Tarnovo', '0887790549', 'theaterVesel@gmail.com');
INSERT INTO Theaters VALUES('Dramatic Theater Lovech', 1969, 'Targovska 49','Lovech', 'Lovech', '068604194', 'dramaticTheaterLovech@gmail.com');
INSERT INTO Theaters VALUES('Dramatic Theater "Stoyan Bachvarov"', 1923, 'pl. Nezavisimost 1', 'Varna', 'Varna', '052614600', 'dramaticTheaterStoyanBachvarov@gmail.com');
INSERT INTO Theaters VALUES('State Puppet Theater Varna', 1952, 'Gragoman 4', 'Varna', 'Varna', '052607844', 'statePuppetTheaterVarna@gmail.com');
INSERT INTO Theaters VALUES('Antique Theater Plovdiv', 1980, 'Tsar Ivaylo 4', 'Plovdiv', 'Plovdiv', '032621040', 'anituqeTheaterPlovdiv@gmail.com');
INSERT INTO Theaters VALUES('Dramatic Theater Plovdiv', 1881, 'Knyaz Aleksandar I 38','Plovdiv', 'Plovdiv', '032271271', 'dramaticTheaterPlovdiv@abv.bg');
INSERT INTO Theaters VALUES('State Puppet Theater Plovdiv', 1946, 'Hristo Danev 14', 'Plovdiv', 'Plovdiv', '032623275', 'statePuppetTheaterPlovdiv@abv.bg');
INSERT INTO Theaters VALUES('Aleko Konstantinov Theater of Satire', 1957, 'Stefan Karadza 26', 'Sofia', 'Sofia', '070020766', 'theaterOfSatireSofia@abv.bg');
INSERT INTO Theaters VALUES('Dramatic Theater "Sava Ognyanov"', 1907, 'Svoboda 4','Ruse', 'Ruse', '082830168', 'dramaticTheaterSavaOgnyanov@gmail.com');
INSERT INTO Theaters VALUES('State Puppet Theater "Dora Gabe"', 1963, '25-ti Septemvri 44', 'Dobrich', 'Dobrich', '058602483', 'statePuppetTheaterDoraGabe@abv.bg');
INSERT INTO Theaters VALUES('Dramatic Puppet Theater-Vratsa', 1938 , 'Hristo Botev 1','Vratsa', 'Vratsa', '092621081', 'dramaticPuppetTheaterVratsa@abv.bg');
INSERT INTO Theaters VALUES('National palace of culture', 1981 , 'bul Bulgaria 1463','Sofia', 'Sofia', '029166300', 'national_palace_of_culture@gmail.com');
INSERT INTO Theaters VALUES('Theater "Balgaran"', 2009 ,'Bratya Shkorpil 33', 'Varna', 'Varna', '05262828', 'theaterBalgaran@abv.bg');
INSERT INTO Theaters VALUES('Dramatic Theater "Geo Milev"', 1950 , 'Metodii Kusev 28','Stara Zagora', 'Stara Zagora', '042622273', 'dramaticTheaterGeoMilev@abv.bg');
INSERT INTO Theaters VALUES('Dramatic Puppet Theater "Ivan Dimov"', 1926 , 'Otec Paisiy 40','Haskovo', 'Haskovo', '038590492', 'dramaticTheaterIvanDimov@gmail.com');
INSERT INTO Theaters VALUES('State Puppet Theater Ruse', 1955 , 'Knyazheska 9', 'Ruse', 'Ruse', '082835804', 'statePuppetTheaterRuse@abv.bg');
INSERT INTO Theaters VALUES('State Puppet Theater Burgas', 1954 ,'Kliment Ohridski 2', 'Burgas', 'Burgas', '056841235', 'statePuppetTheaterBurgas@abv.bg');
INSERT INTO Theaters VALUES('Municipal Puppet Theater "Apostol Karamitev"', 1953, 'bul Dimitar Blagoev 13','Dimitrovgrad', 'Haskovo', '039166336', 'municipalTheaterApostolKaramitev@gmial.com');
INSERT INTO Theaters VALUES('Municipal Dramatic Theater "Boyan Danovski"', 1919 , 'Krakra Pernishki 3','Pernik', 'Pernik', '076603203', 'municipalTheaterBoyanDanovski@gmial.com');

---------Halls------------------------------------------------------------------------------

INSERT INTO Halls VALUES('Main Stage', 780, 'National Theater "Ivan Vazov"');
INSERT INTO Halls VALUES('Chamber Hall', 130, 'National Theater "Ivan Vazov"');
INSERT INTO Halls VALUES('Apostol Karamitev Stage', 88, 'National Theater "Ivan Vazov"');
INSERT INTO Halls VALUES('Main Stage', 590, 'Aleko Konstantinov Theater of Satire');
INSERT INTO Halls VALUES('Chamber Hall "Metodi Andonnov"', 100, 'Aleko Konstantinov Theater of Satire');
INSERT INTO Halls VALUES('Comedy Bar Happy', 200, 'Aleko Konstantinov Theater of Satire');
INSERT INTO Halls VALUES('Main Stage', 250, 'Dramatic Theater "Sava Ognyanov"');
INSERT INTO Halls VALUES('Chamber Hall "Slavi Shkarov"', 80, 'Dramatic Theater "Sava Ognyanov"');
INSERT INTO Halls VALUES('Main Stage', 250, 'Theater Laboratory Sfumato');
INSERT INTO Halls VALUES('Chamber Hall', 90, 'Theater Laboratory Sfumato');
INSERT INTO Halls VALUES('Chamber Hall "Miracle"', 300, 'Bulgarian Navy Theater');
INSERT INTO Halls VALUES('Stage "Aleksandar Gyurov"', 240, 'Dramatic Theater "Ivan Radoev"');
INSERT INTO Halls VALUES('Main Stage', 180, 'Dramatic Theater Lovech');
INSERT INTO Halls VALUES('Main Stage', 320, 'Dramatic Theater "Stoyan Bachvarov"');
INSERT INTO Halls VALUES('Main Stage', 430, 'Dramatic Theater Plovdiv');
INSERT INTO Halls VALUES('Chamber Hall "Zoom Zone"', 70, 'Dramatic Theater Plovdiv');
INSERT INTO Halls VALUES('Summer Stage', 100, 'Dramatic Theater Plovdiv');
INSERT INTO Halls VALUES('Main Stage', 190, 'Theater "Balgaran"');
INSERT INTO Halls VALUES('Main Stage', 370, 'Dramatic Theater "Geo Milev"');
INSERT INTO Halls VALUES('Chamber Hall', 150, 'Dramatic Theater "Geo Milev"');
INSERT INTO Halls VALUES('Main Stage', 290, 'Municipal Dramatic Theater "Boyan Danovski"');

-------Actors--------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Actors VALUES('Philip Avramov', '1974-09-09', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Julian Vergov', '1970-07-15', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Albena Pavlova', '1966-08-07', 'F', 'Ruse', 'Bulgaria');
INSERT INTO Actors VALUES('Asen Blatechki', '1971-03-21', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Veselin Plachkov', '1980-06-23', 'M', 'Pleven', 'Bulgaria');
INSERT INTO Actors VALUES('Victor Kalev', '1969-10-20', 'M', 'Zlatograd', 'Bulgaria');
INSERT INTO Actors VALUES('Desislava Bakardzhieva', '1978-11-04', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Elena Petrova', '1975-11-01', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Ivaylo Zahariev', '1984-10-04', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Ivan Yurukov', '1978-05-27', 'M', 'Sandanski', 'Bulgaria');
INSERT INTO Actors VALUES('Kalin Vrachanski', '1981-06-09', 'M', 'Cherven bryag', 'Bulgaria');
INSERT INTO Actors VALUES('Louise Grigorova', '1990-06-07', 'F', 'Pernik', 'Bulgaria');
INSERT INTO Actors VALUES('Lyubomir Neykov', '1972-02-07', 'M', 'Cherven bryag', 'Bulgaria');
INSERT INTO Actors VALUES('Nencho Balabanov', '1980-04-17', 'M', 'Kotel', 'Bulgaria');
INSERT INTO Actors VALUES('Nencho Ilchev', '1972-05-03', 'M', 'Momchilovtsi', 'Bulgaria');
INSERT INTO Actors VALUES('Silviya Petkova', '1987-07-07', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Yana Marinova', '1978-08-17', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Ruslan Mynov', '1976-11-15', 'M', 'Ishmael', 'Ukraine');
INSERT INTO Actors VALUES('Vladimir Karamazov', '1979-04-27', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Vasil Draganov', '1975-11-06', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Silviya Lulcheva', '1969-08-28', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Maya Bejanska', '1972-05-19', 'F', 'Blagoevgrad', 'Bulgaria');
INSERT INTO Actors VALUES('Ralitsa Paskaleva', '1989-09-20', 'F', 'Ruse', 'Bulgaria');
INSERT INTO Actors VALUES('Dilyana Popova', '1981-09-24', 'F', 'Gulyantsi', 'Bulgaria');
INSERT INTO Actors VALUES('Zahari Baharov', '1980-08-12', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Georgi Mamalev', '1952-08-05', 'M', 'Mamarchevo', 'Bulgaria');
INSERT INTO Actors VALUES('Hristo Mutafchiev', '1969-04-04', 'M', 'Karlovo', 'Bulgaria');
INSERT INTO Actors VALUES('Antoaneta Dobreva', '1975-09-14', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Evelin Kostova', '1993-09-20', 'F', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Kalin Sarmenov', '1963-05-25', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Malin Krustev', '1970-04-23', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Krastiu Lafazanov', '1961-07-18', 'M', 'Varna', 'Bulgaria');
INSERT INTO Actors VALUES('Vladimir Penev', '1958-10-24', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Valeri Yordanov', '1974-02-22', 'M', 'Sofia', 'Bulgaria');
INSERT INTO Actors VALUES('Sofia Bobcheva', '1985-06-14', 'F', 'Sofia', 'Bulgaria');

-----------------------------------------Performances--------------------------------------------------------------------------------

INSERT INTO Performances VALUES('Uncle Vanya', 'Nikolay Lambrev - Mihaylovski', 115, '2020-02-21', 'Drama', 12, 'Nikolay Lambrev - Mihaylovski', 'Chayka Petrusheva', 'Bulgaria' );
INSERT INTO Performances VALUES('Sweetie', 'Emil Bonev', 120, '2020-02-20', 'Musical', 12, 'Elena Ivanova', 'Elena Ivanova', 'Bulgaria' );
INSERT INTO Performances VALUES('Karakoncolos', 'Stoyan Radev', 80, '2020-01-21', 'Monodrama', 12, 'Elitsa Georgieva', 'Elitsa Georgieva', 'Bulgaria' );
INSERT INTO Performances VALUES('The Son', 'Diana Dobreva', 110, '2020-01-18', 'Drama', 12, 'Mira Kalanova', 'Mira Kalanova', 'Bulgaria' );
INSERT INTO Performances VALUES('A Nice Lady in a Bad Company', 'Yurii Dachev', 90, '2019-11-07', 'Drama', 12, 'Yurii Dachev', 'Radina Bliznakova', 'Bulgaria' );
INSERT INTO Performances VALUES('#MyHusbandsFault', 'Liza Shopova', 60, '2020-02-05', 'Comedy', NULL, 'Antonia Popova', 'Elena Spasova', 'Bulgaria' );
INSERT INTO Performances VALUES('Network', 'Andrey Avramov', 100, '2019-12-16', 'Satire Drama', NULL, 'Antonia Popova', 'Elena Spasova', 'Bulgaria' );
INSERT INTO Performances VALUES('Albena', 'Krasimir Spasov', 115, '2017-03-16', 'Drama', NULL, 'Krasimir Vulkanov', 'Mariya Dimanova', 'Bulgaria' );
INSERT INTO Performances VALUES('Dekameron', 'Diana Dobreva', 125, '2017-02-21', NULL, NULL, 'Nina Pashova', 'NinaPashova', 'Bulgaria' );
INSERT INTO Performances VALUES('One night with you', 'Krasimir Spasov', 115, '2018-02-21', 'Drama', NULL, 'Krasimir Vulkanov', 'Krasimir Vulkanov', 'Bulgaria' );
INSERT INTO Performances VALUES('Love, love, love', 'Krasimir Spasov', 95, '2018-08-21', NULL, NULL, 'Krasimir Vulkanov', 'Maria Dimanova', 'Bulgaria' );
INSERT INTO Performances VALUES('The Credit', 'Bina Haralambieva', 115, '2018-06-21', 'Drama', 12, 'Petya Stoykova', 'Velina Kokalova', 'Bulgaria' );
INSERT INTO Performances VALUES('For Mice And Men', 'Asen Blatechki', 130, '2012-02-21', 'Drama', NULL, 'Elena Ivanova', 'Elena Ivanova', 'Bulgaria' );
INSERT INTO Performances VALUES('An Ideal Husband', 'Tieri Arkur', 100, '2007-05-18', 'Comedy', 12, 'Elena Ivanova', 'Elena Ivanova', 'Bulgaria' );
INSERT INTO Performances VALUES('Dom Juan', 'Alexander Morfov', 170, '2006-09-29', 'Comedy', 12, 'Alexander Morfov', 'Marina Raychinova', 'Bulgaria' );
INSERT INTO Performances VALUES('Peach Thief', 'Boyko Iliev', 90, '2008-12-19', 'Drama', 12, 'Nina Pashova', 'Nina Pashova', 'Bulgaria' );
INSERT INTO Performances VALUES('The Goat or Who Is Sylvia?', 'Yavor Gardev', 115, '2009-10-11', 'Drama', 16, 'Nikola Toromanov', 'Nikola Toromanov', 'Bulgaria' );
INSERT INTO Performances VALUES('When Thunder Strikes, The Echo Fades', 'Bina Haralampieva', 100, '2019-03-25', 'Drama', 12, 'Svila Velichkova', 'Svila Velichkova', 'Bulgaria' );
INSERT INTO Performances VALUES('The Spirit of the Poet', 'Margarita Mladenova', 75, '2013-04-07', 'Drama', 14, 'Daniela Oleg Lyahova', 'Daniela Oleg Lyahova', 'Bulgaria' );
INSERT INTO Performances VALUES('I Pay', 'Vladlen Aleksandrov', 120, '2010-10-30', 'Comedy', 12, 'Elena Ivanova', 'Elena Ivanova', 'Bulgaria' );
INSERT INTO Performances VALUES('The chicken that says KU', 'Ivan Yurukov', 90, '2010-09-25', NULL, NULL, 'Aleksandur Urumov', NULL, 'Bulgaria');
INSERT INTO Performances VALUES('Spinach with potatoes', 'Bogdan Petkanin', 110, '2016-10-25', 'Comedy', NULL, 'Petio Nachev', NULL, 'Bulgaria');

------------StarsIn------------------------------------------------------------------------------------

INSERT INTO StarsIn VALUES('The chicken that says KU', '2010-09-25', 'Ivan Yurukov');
INSERT INTO StarsIn VALUES('I pay', '2010-10-30', 'Georgi Mamalev');
INSERT INTO StarsIn VALUES('The spirit of the Poet', '2013-04-07', 'Hristo Mutafchiev');
INSERT INTO StarsIn VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'Ivan Yurukov');
INSERT INTO StarsIn VALUES('The Goat or Who Is Sylvia?', '2009-10-11', 'Julian Vergov');
INSERT INTO StarsIn VALUES('Dom Juan', '2006-09-29', 'Julian Vergov');
INSERT INTO StarsIn VALUES('Dom Juan', '2006-09-29', 'Philip Avramov');
INSERT INTO StarsIn VALUES('Peach Thief', '2008-12-19', 'Julian Vergov');
INSERT INTO StarsIn VALUES('An Ideal Husband', '2007-05-18', 'Julian Vergov');
INSERT INTO StarsIn VALUES('An Ideal Husband', '2007-05-18', 'Vladimir Karamazov');
INSERT INTO StarsIn VALUES('An Ideal Husband', '2007-05-18', 'Ivan Yurukov');
INSERT INTO StarsIn VALUES('For Mice And Men', '2012-02-21', 'Asen Blatechki');
INSERT INTO StarsIn VALUES('For Mice And Men', '2012-02-21', 'Kalin Vrachanski');
INSERT INTO StarsIn VALUES('The Credit', '2018-06-21', 'Asen Blatechki');
INSERT INTO StarsIn VALUES('The Credit', '2018-06-21', 'Kalin Vrachanski');
INSERT INTO StarsIn VALUES('Love, Love, Love', '2018-08-21', 'Antoaneta Dobreva');
INSERT INTO StarsIn VALUES('Love, Love, Love', '2018-08-21', 'Evelin Kostova');
INSERT INTO StarsIn VALUES('One night with you ', '2018-02-21', 'Evelin Kostova');
INSERT INTO StarsIn VALUES('Dekameron', '2017-02-21', 'Antoaneta Dobreva');
INSERT INTO StarsIn VALUES('Albena', '2017-03-16', 'Evelin Kostova');
INSERT INTO StarsIn VALUES('Network', '2019-12-16', 'Kalin Sarmenov');
INSERT INTO StarsIn VALUES('Network', '2019-12-16', 'Malin Krustev');
INSERT INTO StarsIn VALUES('#MyHusbandsFault', '2020-02-05', 'Silviya Lulcheva');
INSERT INTO StarsIn VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Krastiu Lafazanov');
INSERT INTO StarsIn VALUES('The Son', '2020-01-18', 'Zahari Baharov');
INSERT INTO StarsIn VALUES('The Son', '2020-01-18', 'Vladimir Penev');
INSERT INTO StarsIn VALUES('Karakoncolos', '2020-01-21', 'Valeri Yordanov');
INSERT INTO StarsIn VALUES('Sweetie', '2020-02-20', 'Sofia Bobcheva');
INSERT INTO StarsIn VALUES('Spinach with potatoes', '2016-10-25', 'Julian Vergov');
INSERT INTO StarsIn VALUES('Spinach with potatoes', '2016-10-25', 'Asen Blatechki');
INSERT INTO StarsIn VALUES('Spinach with potatoes', '2016-10-25', 'Zahari Baharov');

-----------------------Schedule--------------------------------------------------------------------------

INSERT INTO Schedule VALUES('Spinach with potatoes', '2016-10-25', 'Aleko Konstantinov Theater of Satire', 'Main Stage', '2020-03-06', '19:00', '20:50', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('Spinach with potatoes', '2016-10-25', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage', '2020-03-10', '17:30', '19:20', 'YES', 'NO', 'Aleko Konstantinov Theater of Satire');
INSERT INTO Schedule VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-03-21', '11:00', '13:00', 'NO', 'YES', NULL);
INSERT INTO Schedule VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-03-12', '15:30', '17:30', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-04', '18:00', '19:55', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-09', '17:00', '18:55', 'NO', 'YES', NULL);
INSERT INTO Schedule VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater "Sava Ognyanov"','Chamber Hall "Slavi Shkarov"' , '2020-03-10', '19:00', '20:30', 'YES', 'YES', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-11', '11:00', '12:30', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater "Ivan Radoev"', 'Stage "Aleksandar Gyurov"' , '2020-03-13', '14:00', '15:30', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('Peach Thief', '2008-12-19', 'Dramatic Theater Lovech', 'Main Stage' , '2020-03-02', '19:00', '20:30', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-14', '16:30', '18:00', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('The Goat or Who Is Sylvia?', '2009-10-11', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-19', '15:00', '17:55', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('The Goat or Who Is Sylvia?', '2009-10-11', 'National Theater "Ivan Vazov"', 'Chamber Hall' ,'2020-03-29', '20:40', '22:35', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'Dramatic Theater "Ivan Radoev"', 'Stage "Aleksandar Gyurov"' ,'2020-03-11', '15:30', '17:10', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-31', '20:00', '21:40', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('The Spirit of the Poet', '2013-04-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-30', '19:00', '20:15', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('I Pay', '2010-10-30', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-03-28', '19:00', '21:00', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('An Ideal Husband', '2007-05-18', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-03-02', '17:30', '19:10', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('An Ideal Husband', '2007-05-18', 'Dramatic Theater Lovech', 'Main Stage' ,'2020-03-09', '21:30', '23:10', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('An Ideal Husband', '2007-05-18', 'National Theater "Ivan Vazov"', 'Main Stage' ,'2020-03-22', '19:00', '20:40', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('An Ideal Husband', '2007-05-18', 'Dramatic Theater "Sava Ognyanov"', 'Main Stage' , '2020-03-28', '18:35', '20:15', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('Dom Juan', '2006-09-29', 'Theater "Balgaran"', 'Main Stage' , '2020-03-08', '19:00', '21:50', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('Dom Juan', '2006-09-29', 'Dramatic Theater Plovdiv', 'Main Stage' , '2020-03-25', '17:30', '20:20', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('Dom Juan', '2006-09-29', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-03-31', '18:00', '20:50', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('The Son', '2020-01-18', 'Dramatic Theater "Stoyan Bachvarov"', 'Main Stage' ,  '2020-03-13', '19:00', '20:50', 'YES', 'NO', 'National Theater "Ivan Vazov"');
INSERT INTO Schedule VALUES('The Son', '2020-01-18', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-03-28', '14:00', '15:50', 'NO', 'YES', NULL);
INSERT INTO Schedule VALUES('Karakoncolos', '2020-01-21', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-03-13', '18:30', '19:50', 'NO', 'YES', NULL);
INSERT INTO Schedule VALUES('Karakoncolos', '2020-01-21', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-03-19', '20:00', '21:20', 'NO', 'YES', NULL);
INSERT INTO Schedule VALUES('#MyHusbandsFault', '2020-02-05', 'Aleko Konstantinov Theater of Satire', 'Comedy Bar Happy' ,'2020-03-15', '13:30', '14:30', 'NO', 'YES', NULL);
INSERT INTO Schedule VALUES('Network', '2019-12-16', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , '2020-03-15', '17:00', '18:40', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('Network', '2019-12-16', 'Aleko Konstantinov Theater of Satire', 'Main Stage' ,'2020-03-27', '19:00', '20:40', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('The chicken that says KU', '2010-09-25', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-03-16', '19:00', '20:30', 'YES', 'NO', 'National palace of culture');
INSERT INTO Schedule VALUES('For Mice And Men', '2012-02-21', 'Dramatic Theater "Ivan Radoev"', 'Stage "Aleksandar Gyurov"' ,'2020-03-16', '18:30', '20:40', 'YES', 'NO', 'Municipal Dramatic Theater "Boyan Danovski"');
INSERT INTO Schedule VALUES('The Credit', '2018-06-21', 'Dramatic Theater "Geo Milev"', 'Main Stage' , '2020-03-20', '19:00', '20:50', 'YES', 'NO', 'Dramatic Theater Plovdiv');
INSERT INTO Schedule VALUES('Albena', '2017-03-16', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , '2020-03-16', '21:00', '22:50', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('Dekameron', '2017-02-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , '2020-03-28', '18:30', '20:35', 'NO', 'NO', NULL);
INSERT INTO Schedule VALUES('One night with you', '2018-02-21', 'Theater Laboratory Sfumato', 'Main stage' , '2020-03-15', '18:30', '20:25', 'YES', 'NO','Bulgarian Navy Theater' );
INSERT INTO Schedule VALUES('Love, love, love', '2018-08-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , '2020-03-14', '19:00', '20:35', 'NO', 'NO', NULL);

---------------Attendences-------------------------------------------------------------------------------------------------------------


INSERT INTO Attendences VALUES('Spinach with potatoes', '2016-10-25', 'Aleko Konstantinov Theater of Satire', 'Main Stage', '2020-02-20', 500);
INSERT INTO Attendences VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater Plovdiv', 'Main Stage', '2020-02-21', 400);
INSERT INTO Attendences VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater "Geo Milev"', 'Main Stage', '2020-02-22', 320);
INSERT INTO Attendences VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater "Sava Ognyanov"', 'Main Stage', '2020-02-25', 213);
INSERT INTO Attendences VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater "Stoyan Bachvarov"', 'Main Stage', '2020-02-28', 274);
INSERT INTO Attendences VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-02-20', 88);
INSERT INTO Attendences VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-02-22', 87);
INSERT INTO Attendences VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-02-07', 87);
INSERT INTO Attendences VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-21', 130);
INSERT INTO Attendences VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-23', 130);
INSERT INTO Attendences VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-25', 125);
INSERT INTO Attendences VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-26', 127);
INSERT INTO Attendences VALUES('Uncle Vanya', '2020-02-21', 'Dramatic Theater "Geo Milev"', 'Chamber Hall' , '2020-02-28', 149);
INSERT INTO Attendences VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-09', 121);
INSERT INTO Attendences VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Theater Laboratory Sfumato', 'Chamber Hall' , '2020-02-15', 85);
INSERT INTO Attendences VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater "Geo Milev"', 'Chamber Hall' , '2020-02-17', 137);
INSERT INTO Attendences VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater Plovdiv', 'Chamber Hall "Zoom Zone"' , '2020-02-27', 60);
INSERT INTO Attendences VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-10', 112);
INSERT INTO Attendences VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-12', 100);
INSERT INTO Attendences VALUES('Peach Thief', '2008-12-19', 'Aleko Konstantinov Theater of Satire', 'Chamber Hall "Metodi Andonnov"' , '2020-02-16', 80);
INSERT INTO Attendences VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-19', 104);
INSERT INTO Attendences VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-11', 113);
INSERT INTO Attendences VALUES('The Spirit of the Poet', '2013-04-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , '2020-02-03', 99);
INSERT INTO Attendences VALUES('I Pay', '2010-10-30', 'National Theater "Ivan Vazov"', 'Chamber Hall' ,'2020-02-04', 75);
INSERT INTO Attendences VALUES('An Ideal Husband', '2007-05-18', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage' , '2020-02-11', 280);
INSERT INTO Attendences VALUES('An Ideal Husband', '2007-05-18', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-02-28', 500);
INSERT INTO Attendences VALUES('Dom Juan', '2006-09-29', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-02-08', 497);
INSERT INTO Attendences VALUES('Dom Juan', '2006-09-29', 'Dramatic Theater Lovech', 'Main Stage' , '2020-02-28', 164);
INSERT INTO Attendences VALUES('The Son', '2020-01-18', 'National Theater "Ivan Vazov"', 'Main Stage' , '2020-02-15', 637);
INSERT INTO Attendences VALUES('The Son', '2020-01-18', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage' , '2020-02-27', 257);
INSERT INTO Attendences VALUES('Karakoncolos', '2020-01-21', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , '2020-02-13', 88);
INSERT INTO Attendences VALUES('#MyHusbandsFault', '2020-02-05', 'Aleko Konstantinov Theater of Satire', 'Comedy Bar Happy' , '2020-02-05', 200);
INSERT INTO Attendences VALUES('#MyHusbandsFault', '2020-02-05', 'Aleko Konstantinov Theater of Satire', 'Comedy Bar Happy' , '2020-02-10', 197);
INSERT INTO Attendences VALUES('Network', '2019-12-16', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , '2020-02-12', 483);
INSERT INTO Attendences VALUES('The chicken that says KU', '2010-09-25', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , '2020-02-12', 576);
INSERT INTO Attendences VALUES('For Mice And Men', '2012-02-21', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage' , '2020-02-16', 241);
INSERT INTO Attendences VALUES('The Credit', '2018-06-21', 'Dramatic Theater "Sava Ognyanov"', 'Chamber Hall "Slavi Shkarov"' , '2020-02-20', 65);
INSERT INTO Attendences VALUES('Albena', '2017-03-16', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , '2020-02-16', 278);
INSERT INTO Attendences VALUES('Dekameron', '2017-02-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , '2020-02-18', 238);
INSERT INTO Attendences VALUES('One night with you', '2018-02-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , '2020-02-22', 263);
INSERT INTO Attendences VALUES('Love, love, love', '2018-08-21', 'Theater Laboratory Sfumato', 'Main stage' , '2020-02-15', 276);

-----------------------Tickets--------------------------------------------------------------------------

INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Aleko Konstantinov Theater of Satire', 'Main Stage', 15, 0, '2020-02-20');
INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater Plovdiv', 'Main Stage', 25, 0, '2020-02-21');
INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater "Geo Milev"', 'Main Stage', 20, 0, '2020-02-22');
INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater "Sava Ognyanov"', 'Main Stage', 20, 0, '2020-02-25');
INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Dramatic Theater "Stoyan Bachvarov"', 'Main Stage', 20, 0, '2020-02-28');
INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Aleko Konstantinov Theater of Satire', 'Main Stage', 20, 0, '2020-03-06');
INSERT INTO Tickets VALUES('Spinach with potatoes', '2016-10-25', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage', 20, 0, '2020-03-10');
INSERT INTO Tickets VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 30, 0, '2020-02-20');
INSERT INTO Tickets VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 30, 0, '2020-02-22');
INSERT INTO Tickets VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 25, 0, '2020-02-07');
INSERT INTO Tickets VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 25, 0, '2020-03-21');
INSERT INTO Tickets VALUES('Sweetie', '2020-02-20', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 25, 20, '2020-03-12');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 30, 0, '2020-02-21');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 25, 0, '2020-02-23');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-02-25');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 20, '2020-02-26');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'Dramatic Theater "Geo Milev"', 'Chamber Hall' , 20, 25, '2020-02-28');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 15, 0, '2020-03-04');
INSERT INTO Tickets VALUES('Uncle Vanya', '2020-02-21', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 10, '2020-03-09');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 10, '2020-02-09');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Theater Laboratory Sfumato', 'Chamber Hall' , 20, 10, '2020-02-15');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater "Geo Milev"', 'Chamber Hall' , 20, 10, '2020-02-17');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater Plovdiv', 'Chamber Hall "Zoom Zone"' , 20, 10, '2020-02-27');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater "Sava Ognyanov"','Chamber Hall "Slavi Shkarov"' , 20, 0, '2020-03-10');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-03-11');
INSERT INTO Tickets VALUES('A Nice Lady in a Bad Company', '2019-11-07', 'Dramatic Theater "Ivan Radoev"', 'Stage "Aleksandar Gyurov"' , 20, 0, '2020-03-13');
INSERT INTO Tickets VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-02-10');
INSERT INTO Tickets VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 50, '2020-02-12');
INSERT INTO Tickets VALUES('Peach Thief', '2008-12-19', 'Aleko Konstantinov Theater of Satire', 'Chamber Hall "Metodi Andonnov"' , 20, 50, '2020-02-16');
INSERT INTO Tickets VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 20, '2020-02-19');
INSERT INTO Tickets VALUES('Peach Thief', '2008-12-19', 'Dramatic Theater Lovech', 'Main Stage' , 20, 25, '2020-03-02');
INSERT INTO Tickets VALUES('Peach Thief', '2008-12-19', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 25, '2020-03-14');
INSERT INTO Tickets VALUES('The Goat or Who Is Sylvia?', '2009-10-11', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-03-19');
INSERT INTO Tickets VALUES('The Goat or Who Is Sylvia?', '2009-10-11', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-03-29');
INSERT INTO Tickets VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-02-11');
INSERT INTO Tickets VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'Dramatic Theater "Ivan Radoev"', 'Stage "Aleksandar Gyurov"' , 20, 10, '2020-03-11');
INSERT INTO Tickets VALUES('When Thunder Strikes, The Echo Fades', '2019-03-25', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 25, 20, '2020-03-31');
INSERT INTO Tickets VALUES('The Spirit of the Poet', '2013-04-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-02-03');
INSERT INTO Tickets VALUES('The Spirit of the Poet', '2013-04-07', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 25, 20, '2020-03-30');
INSERT INTO Tickets VALUES('I Pay', '2010-10-30', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 0, '2020-02-04');
INSERT INTO Tickets VALUES('I Pay', '2010-10-30', 'National Theater "Ivan Vazov"', 'Chamber Hall' , 20, 20, '2020-03-28');
INSERT INTO Tickets VALUES('An Ideal Husband', '2007-05-18', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage' , 20, 20, '2020-02-11');
INSERT INTO Tickets VALUES('An Ideal Husband', '2007-05-18', 'National Theater "Ivan Vazov"', 'Main Stage' , 20, 0, '2020-02-28');
INSERT INTO Tickets VALUES('An Ideal Husband', '2007-05-18', 'National Theater "Ivan Vazov"', 'Main Stage' , 25, 20, '2020-03-02');
INSERT INTO Tickets VALUES('An Ideal Husband', '2007-05-18', 'Dramatic Theater Lovech', 'Main Stage' , 25, 0, '2020-03-09');
INSERT INTO Tickets VALUES('An Ideal Husband', '2007-05-18', 'National Theater "Ivan Vazov"', 'Main Stage' , 20, 50, '2020-03-22');
INSERT INTO Tickets VALUES('An Ideal Husband', '2007-05-18', 'Dramatic Theater "Sava Ognyanov"', 'Main Stage' , 30, 75, '2020-03-28');
INSERT INTO Tickets VALUES('Dom Juan', '2006-09-29', 'National Theater "Ivan Vazov"', 'Main Stage' , 20, 0, '2020-02-08');
INSERT INTO Tickets VALUES('Dom Juan', '2006-09-29', 'Dramatic Theater Lovech', 'Main Stage' , 25, 20, '2020-02-28');
INSERT INTO Tickets VALUES('Dom Juan', '2006-09-29', 'Theater "Balgaran"', 'Main Stage' , 20, 0, '2020-03-08');
INSERT INTO Tickets VALUES('Dom Juan', '2006-09-29', 'Dramatic Theater Plovdiv', 'Main Stage' , 20, 20, '2020-03-25');
INSERT INTO Tickets VALUES('Dom Juan', '2006-09-29', 'National Theater "Ivan Vazov"', 'Main Stage' , 20, 15, '2020-03-31');
INSERT INTO Tickets VALUES('The Son', '2020-01-18', 'National Theater "Ivan Vazov"', 'Main Stage' , 30, 0, '2020-02-15');
INSERT INTO Tickets VALUES('The Son', '2020-01-18', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage' , 30, 30, '2020-02-27');
INSERT INTO Tickets VALUES('The Son', '2020-01-18', 'Dramatic Theater "Stoyan Bachvarov"', 'Main Stage' , 20, 30, '2020-03-13');
INSERT INTO Tickets VALUES('The Son', '2020-01-18', 'National Theater "Ivan Vazov"', 'Main Stage' , 30, 0, '2020-03-28');
INSERT INTO Tickets VALUES('Karakoncolos', '2020-01-21', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 30, 0, '2020-02-13');
INSERT INTO Tickets VALUES('Karakoncolos', '2020-01-21', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 30, 0, '2020-03-13');
INSERT INTO Tickets VALUES('Karakoncolos', '2020-01-21', 'National Theater "Ivan Vazov"', 'Apostol Karamitev Stage' , 30, 20, '2020-03-19');
INSERT INTO Tickets VALUES('#MyHusbandsFault', '2020-02-05', 'Aleko Konstantinov Theater of Satire', 'Comedy Bar Happy' , 30, 0, '2020-02-05');
INSERT INTO Tickets VALUES('#MyHusbandsFault', '2020-02-05', 'Aleko Konstantinov Theater of Satire', 'Comedy Bar Happy' , 30, 0, '2020-02-10');
INSERT INTO Tickets VALUES('#MyHusbandsFault', '2020-02-05', 'Aleko Konstantinov Theater of Satire', 'Comedy Bar Happy' , 30, 20, '2020-03-15');
INSERT INTO Tickets VALUES('Network', '2019-12-16', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , 30, 10, '2020-02-12');
INSERT INTO Tickets VALUES('Network', '2019-12-16', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , 30, 10, '2020-03-15');
INSERT INTO Tickets VALUES('Network', '2019-12-16', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , 30, 20, '2020-03-27');
INSERT INTO Tickets VALUES('The chicken that says KU', '2010-09-25', 'Aleko Konstantinov Theater of Satire', 'Main Stage' , 30, 0, '2020-02-12');
INSERT INTO Tickets VALUES('The chicken that says KU', '2010-09-25', 'National Theater "Ivan Vazov"', 'Main Stage' , 30, 0, '2020-03-16');
INSERT INTO Tickets VALUES('For Mice And Men', '2012-02-21', 'Municipal Dramatic Theater "Boyan Danovski"', 'Main Stage' , 20, 10, '2020-02-16');
INSERT INTO Tickets VALUES('For Mice And Men', '2012-02-21', 'Dramatic Theater "Ivan Radoev"', 'Stage "Aleksandar Gyurov"' , 20, 0, '2020-03-16');
INSERT INTO Tickets VALUES('The Credit', '2018-06-21', 'Dramatic Theater "Sava Ognyanov"', 'Chamber Hall "Slavi Shkarov"' , 20, 0, '2020-02-20');
INSERT INTO Tickets VALUES('The Credit', '2018-06-21', 'Dramatic Theater "Geo Milev"', 'Main Stage' , 25, 0, '2020-03-20');
INSERT INTO Tickets VALUES('Albena', '2017-03-16', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , 25, 25, '2020-02-16');
INSERT INTO Tickets VALUES('Albena', '2017-03-16', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , 35, 0, '2020-03-16');
INSERT INTO Tickets VALUES('Dekameron', '2017-02-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , 15, 0, '2020-02-18');
INSERT INTO Tickets VALUES('Dekameron', '2017-02-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , 20, 0, '2020-03-28');
INSERT INTO Tickets VALUES('One night with you', '2018-02-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , 15, 0, '2020-02-22');
INSERT INTO Tickets VALUES('One night with you', '2018-02-21', 'Theater Laboratory Sfumato', 'Main stage' , 15, 0, '2020-03-15');
INSERT INTO Tickets VALUES('Love, love, love', '2018-08-21', 'Theater Laboratory Sfumato', 'Main stage' , 15, 0, '2020-02-15');
INSERT INTO Tickets VALUES('Love, love, love', '2018-08-21', 'Bulgarian Navy Theater', 'Chamber Hall "Miracle"' , 15, 0, '2020-03-14');

ALTER TABLE Actors ADD IsDeleted VARCHAR(3);
UPDATE Actors SET IsDeleted = 'NO';
ALTER TABLE Actors ADD WhenDeleted DATETIME;

ALTER TABLE Theaters ADD IsDeleted VARCHAR(3);
UPDATE Theaters SET IsDeleted = 'NO';
ALTER TABLE Theaters ADD WhenDeleted DATETIME;

ALTER TABLE Performances ADD IsDeleted VARCHAR(3);
UPDATE Performances SET IsDeleted = 'NO';
ALTER TABLE Performances ADD WhenDeleted DATETIME;

CREATE TABLE Actors_audits(
 Name VARCHAR(100) NOT NULL,
 BirthDate DATE,
 Gender CHAR(1) NOT NULL,
 HomeTown VARCHAR(20) NOT NULL,
 Country VARCHAR(50) NOT NULL,
 IsDeleted VARCHAR(3) DEFAULT 'NO',
 WhenDeleted DATETIME,
 UpdatedAt DATETIME
);

CREATE TABLE Performances_audits(
 Name VARCHAR(255) NOT NULL,
 Producer VARCHAR(100) NOT NULL,
 Duration INT NOT NULL, CHECK(Duration > 0),
 PremiereDate DATE NOT NULL,
 Genre VARCHAR(20),
 AgeLimit INT,
 Playwright VARCHAR(100),
 CostumeDesigner VARCHAR(100),
 Country VARCHAR(50),
 IsDeleted VARCHAR(3) DEFAULT 'NO',
 WhenDeleted DATE,
 UpdatedAt DATE
);

CREATE TABLE Theaters_audits(
 Name VARCHAR(100) NOT NULL,
 Year INT NOT NULL CHECK (Year > 0),
 Address VARCHAR(100),
 City VARCHAR(20) NOT NULL,
 Region VARCHAR(20) NOT NULL,
 PhoneNumber VARCHAR(64),
 Email VARCHAR(64),
 IsDeleted VARCHAR(3) DEFAULT 'NO',
 WhenDeleted DATE,
 UpdatedAt DATE
);

SELECT * FROM Cities 

SELECT * FROM Theaters

SELECT * FROM Halls

SELECT * FROM Actors 

SELECT * FROM Performances 

SELECT * FROM StarsIn 

SELECT * FROM Schedule

SELECT * FROM Attendences

SELECT * FROM Tickets