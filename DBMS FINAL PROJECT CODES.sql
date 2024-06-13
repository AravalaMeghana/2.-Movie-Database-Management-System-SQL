## A. CREATING TABLES ###
Create DATABASE MOVIES_DB;
USE MOVIES_DB;
DROP DATABASE IF EXISTS MOVIES_DB;

-- Creating Genres Table
CREATE TABLE Genres 
(
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(45) NOT NULL,
    UNIQUE (GenreID)
);

-- Creating Directors Table
CREATE TABLE Directors (
    DirectorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(45) NOT NULL,
    Gender ENUM('Male', 'Female', 'Other'),
    Age INT,
    Nationality VARCHAR(50),
    UNIQUE (DirectorID)
);


-- Creating Movies Table
CREATE TABLE Movies (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(45) NOT NULL,
    ReleaseDate DATE, -- Assuming ReleaseDate is a date type
    DirectorID INT,
    Rating DECIMAL(10,2),
    RunTime INT,
    GenreID INT,
    CensorCertification VARCHAR(45),
    PlotSummary VARCHAR(45),
    Budget INT,
    UNIQUE (MovieID), -- Ensuring MovieID is unique
    FOREIGN KEY (DirectorID) REFERENCES Directors(DirectorID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);
-- Creating Actors Table
CREATE TABLE Actors (
    ActorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(45) NOT NULL,
    Gender ENUM('Male', 'Female', 'Other'),
    Birthdate DATE,
    Nationality VARCHAR(45),
    Age INT,
    UNIQUE (ActorID)
);

-- Creating Reviews Table
DROP TABLE IF EXISTS Reviews;
CREATE TABLE IF NOT EXISTS Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    MovieID INT,
    ReviewText VARCHAR(45),
    Rating DECIMAL(10,2),
    ReviewerName VARCHAR(45),
    UNIQUE (ReviewID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);


-- Creating Awards Table
CREATE TABLE Awards (
    AwardID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(45) NOT NULL,
    Category VARCHAR(50),
    YearReceived INT,
    WinnerID INT,
    UNIQUE (AwardID),
    FOREIGN KEY (WinnerID) REFERENCES Movies(MovieID)
);

### INSERTING ROWS INTO EACH TABLE. ##

-- Inserting data into Genres Table
INSERT INTO Genres (GenreID, GenreName) VALUES
    (1,'Action'),
    (2,'Comedy'),
    (3,'Drama'),
    (4,'Sci-Fi'),
    (5,'Horror'),
    (6,'Suspence');

-- Inserting data into Directors Table
INSERT INTO Directors (DirectorID, Name, Gender, Age, Nationality) VALUES
    (1,'Sukumar', 'Male', 45, 'Indian'),
    (2,'Sharadha', 'Female', 50, 'Indian'),
    (3,'Patel', 'Male', 26, 'American'),
    (4,'Rao', 'Male' , 35, 'Canadian'),
    (5,'Lee', 'Male', 23, 'Chinese');

-- Inserting data into Movies Table
INSERT INTO Movies (MovieID, Title, ReleaseDate, DirectorID, Rating, GenreID, RunTime, CensorCertification, PlotSummary, Budget) VALUES
    (1, 'King', '2022-01-01', 1, 8.5, 3, 120, 'PG-13', 'About a King in the forest', 5000000),
    (2, 'Kong', '2023-02-01', 2, 7.8, 3, 110, 'PG', 'About a person named Kong and his beliefs', 4000000),
    (3, 'Marvel', '2020-04-07', 4, 8.8, 4, 166, 'U', 'Sci-fi Fantasy movie', 6800000),
    (4, 'Murder', '2019-09-23', 5, 8.5, 1, 145, 'PG-13', 'Movie based on true event of a psycho killer', 20000000),
    (5, 'Ghost', '2022-06-16', 3, 8.2, 5, 178, 'PG-13', 'Ghost who lived in a bungalow', 40000000);

    
-- Inserting data into Actors Table
INSERT INTO Actors (ActorID, Name, Gender, Nationality, Age) VALUES
    (1, 'Leonardo', 'Male', 'American', 43),
    (2, 'Jackson', 'Female', 'Canadian', 33),
    (3, 'Prabhas', 'Male',  'Indian', 34),
    (4, 'Kajal', 'Female',  'Indian', 24),
    (5, 'Seuin', 'Female', 'Chinese', 23);

-- Inserting data into Reviews Table
INSERT INTO Reviews (MovieID, ReviewText, Rating, ReviewerName) VALUES
    (1, 'Great movie!', 9.0, 'Subhash.G'),
    (2, 'Enjoyed it!', 7.5, 'Kamlesh.R'),
    (3, 'Well Executed!', 7.8, 'Srishti.A'),
    (4, 'Family Values are well presented', 8.0, 'Jagan.S'),
    (5, 'Great Execution', 8.2, 'Maggie.J');

-- Inserting data into Awards Table
INSERT INTO Awards (AwardID, Name, Category, YearReceived, WinnerID) VALUES
    (1,'Best Movie Award', 'Drama', 2022, 1),
    (2,'Best Director Award', 'Suspence', 2023, 2),
    (3,'Best Comedian Award', 'Comedy', 2022, 4),
    (4,'Best Actress Award', 'Sci-Fi', 2020, 3),
    (5,'Best Photography Award', 'Horror', 2022, 5);

# B. CREATING SQL QUERIES #

# 1. List directors who have won awards. (USING SUB-QUERY)
SELECT Name
FROM Directors
WHERE DirectorID IN (
    SELECT DISTINCT DirectorID
    FROM Awards
    WHERE DirectorID IS NOT NULL
);

# 2. Count the number of awards each movie has received
SELECT m.Title, COUNT(aw.AwardID) AS NumOfAwards
FROM Movies m
LEFT JOIN Awards aw ON m.MovieID = aw.WinnerID
GROUP BY m.Title;

# 3. Get the top 5 rated movies
SELECT Title, Rating
FROM Movies
ORDER BY Rating DESC
LIMIT 5;

# 4. Get movies with budgets higher than the average budget for movies in a specific genre
SELECT Title, Budget
FROM Movies
WHERE Budget > (
    SELECT AVG(Budget)
    FROM Movies
    WHERE GenreID = (
        SELECT GenreID
        FROM Genres
        WHERE GenreName = 'Action' 
    )
);

#5. Retrieve all movie titles and their corresponding directors
SELECT m.Title, d.Name AS Director
FROM Movies m
INNER JOIN Directors d ON m.DirectorID = d.DirectorID;

# 6. Find movies released in the year 2022
SELECT Title, ReleaseDate
FROM Movies
WHERE YEAR(ReleaseDate) = 2022;

# 7. Get the average age of directors in the database
SELECT AVG(Age) AS AverageDirectorAge
FROM Directors;

# 8.Retrieve the order of top 4  movie by its longest runtime and its details
SELECT Title, RunTime
FROM Movies
ORDER BY RunTime DESC
LIMIT 4;

# 9. Retrieve the longest movie (by runtime) and its details
SELECT m.Title, a.Name AS AwardName, a.Category
FROM Movies m
INNER JOIN Awards a ON m.MovieID = a.WinnerID;

# 10.List directors with the count of movies they directed
SELECT d.Name AS DirectorName, COUNT(m.DirectorID) AS MovieCount
FROM Directors d
LEFT JOIN Movies m ON d.DirectorID = m.DirectorID
GROUP BY d.Name;

#11.Updating Movies based on Director's Nationality using Joins:
UPDATE Movies
INNER JOIN Directors ON Movies.DirectorID = Directors.DirectorID
SET Movies.Rating = 5
WHERE Directors.Nationality = 'USA';

# 12. Deleting Records from the Awards Table for a Specific Category:
DELETE FROM Awards
WHERE Category = 'Best Actress Awards';







