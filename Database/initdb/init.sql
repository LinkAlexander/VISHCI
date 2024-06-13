--name.basics.tsv import------------------------------------------------------------------------------------------------------------------------
CREATE TABLE temp_ratings (
    tconst VARCHAR(100),
    averageRating FLOAT,
    numVotes INT
);

CREATE TABLE ratings (
    tconst VARCHAR(100),
    averageRating FLOAT
);


COPY temp_ratings (tconst, averageRating, numVotes) 
FROM '/docker-entrypoint-initdb.d/data/title.ratings.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO ratings (tconst, averageRating)
SELECT
    tconst,
    averageRating
FROM temp_ratings;

DROP TABLE temp_ratings;

--name.basics.tsv import ------------------------------------------------------------------------------------------------------------------------
CREATE TABLE temp_namebasics (
    nconst VARCHAR(100),
    primaryName VARCHAR(120),
    birthYear TEXT,
    deathYear TEXT,
    primaryProfession VARCHAR(100),
    knownForTitles VARCHAR(100)
);
CREATE TABLE namebasics (
    birthYear INT,
    deathYear INT,
    primaryProfession TEXT[]
);


COPY temp_namebasics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles) 
FROM '/docker-entrypoint-initdb.d/data/name.basics.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO namebasics (birthYear, deathYear, primaryProfession)
SELECT
    NULLIF(birthYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    NULLIF(deathYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    string_to_array(primaryProfession, ',')
FROM temp_namebasics;

DROP TABLE temp_namebasics;


--CREATE TABLE akas------------------------------------------------------------------------------------------------------------------------
CREATE TABLE temp_akas (
    titleId VARCHAR(100),
    ordering INT,
    title VARCHAR(870),
    region VARCHAR(100),
    language VARCHAR(100),
    types VARCHAR(100),
    attributes VARCHAR(100),
    isOriginalTitle BOOLEAN
);

CREATE TABLE akas (
    titleId VARCHAR(100),
    region VARCHAR(100)
);


COPY temp_akas (titleId, ordering, title, region, language, types, attributes, isOriginalTitle) 
FROM '/docker-entrypoint-initdb.d/data/title.akas.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO akas (titleId, region)
SELECT
    titleId,
    region
FROM temp_akas;

DROP TABLE temp_akas;

--CREATE TABLE titlebasics------------------------------------------------------------------------------------------------------------------------
CREATE TABLE temp_titlebasics (
    tconst VARCHAR(100),
    titleType VARCHAR(100),
    primaryTitle VARCHAR(450),
    originalTitle VARCHAR(450),
    isAdult BOOLEAN,
    startYear TEXT,
    endYear TEXT,
    runtimeMinutes TEXT,
    genres VARCHAR(100)
);
CREATE TABLE titlebasics (
    tconst VARCHAR(100),
    isAdult BOOLEAN,
    startYear INT,
    genres TEXT[]
);


COPY temp_titlebasics (tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes, genres) 
FROM '/docker-entrypoint-initdb.d/data/title.basics.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO titlebasics (tconst, isAdult, startYear, genres)
SELECT
    tconst,
    isAdult,
    NULLIF(startYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    string_to_array(genres, ',')
FROM temp_titlebasics;

DROP TABLE temp_titlebasics;

/*
--CREATE TABLE crew------------------------------------------------------------------------------------------------------------------------
CREATE TABLE temp_crew (
    tconst VARCHAR(100),
    directors VARCHAR(16000),
    writers VARCHAR(16000)
);

CREATE TABLE crew (
    tconst VARCHAR(100),
    directors TEXT[],
    writers TEXT[]
);

COPY temp_crew (tconst, directors, writers) 
FROM '/docker-entrypoint-initdb.d/data/title.crew.tsv' 
DELIMITER E'\t' 
CSV HEADER;


INSERT INTO crew (tconst, directors, writers)
SELECT
    tconst,
    string_to_array(directors, ','),
    string_to_array(writers, ',')
FROM temp_crew;

DROP TABLE temp_crew;
*/

/*
--CREATE TABLE episode
CREATE TABLE episode (
    tconst VARCHAR(100),
    parentTconst VARCHAR(100),
    seasonNumber INT,
    episodeNumber INT
);

CREATE TABLE temp_episode (
    tconst VARCHAR(100),
    parentTconst VARCHAR(100),
    seasonNumber VARCHAR(100),
    episodeNumber VARCHAR(100)
);

COPY temp_episode (tconst, parentTconst, seasonNumber, episodeNumber) 
FROM '/docker-entrypoint-initdb.d/data/title.episode.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO episode (tconst, parentTconst, seasonNumber, episodeNumber)
SELECT
    tconst,
    parentTconst,
    NULLIF(seasonNumber, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    NULLIF(episodeNumber, E'\\N')::INT
FROM temp_episode;

DROP TABLE temp_episode;
*/

/*
--CREATE TABLE principals
CREATE TABLE principals (
    tconst VARCHAR(100),
    ordering INT,
    nconst VARCHAR(100),
    category VARCHAR(100),
    job VARCHAR(500),
    characters VARCHAR(1000)
);


COPY principals (tconst, ordering, nconst, category, job, characters) 
FROM '/docker-entrypoint-initdb.d/data/title.principals.tsv' 
DELIMITER E'\t' 
CSV HEADER;
*/