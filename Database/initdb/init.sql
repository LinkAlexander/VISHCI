--name.basics.tsv import
CREATE TABLE ratings (
    tconst VARCHAR(100),
    averageRating FLOAT,
    numVotes INT
);


COPY ratings (tconst, averageRating, numVotes) 
FROM '/docker-entrypoint-initdb.d/data/title.ratings.tsv' 
DELIMITER E'\t' 
CSV HEADER;


--name.basics.tsv import
CREATE TABLE temp_namebasics (
    nconst VARCHAR(100),
    primaryName VARCHAR(120),
    birthYear TEXT,
    deathYear TEXT,
    primaryProfession VARCHAR(100),
    knownForTitles VARCHAR(100)
);
CREATE TABLE namebasics (
    nconst VARCHAR(100),
    primaryName VARCHAR(120),
    birthYear INT,
    deathYear INT,
    primaryProfession VARCHAR(100),
    knownForTitles VARCHAR(100)
);


COPY temp_namebasics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles) 
FROM '/docker-entrypoint-initdb.d/data/name.basics.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO namebasics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles)
SELECT
    nconst,
    primaryName,
    NULLIF(birthYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    NULLIF(deathYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    primaryProfession,
    knownForTitles
FROM temp_namebasics;

DROP TABLE temp_namebasics;

--CREATE TABLE akas
CREATE TABLE akas (
    titleId VARCHAR(100),
    ordering INT,
    title VARCHAR(870),
    region VARCHAR(100),
    language VARCHAR(100),
    types VARCHAR(100),
    attributes VARCHAR(100),
    isOriginalTitle BOOLEAN
);


COPY akas (titleId, ordering, title, region, language, types, attributes, isOriginalTitle) 
FROM '/docker-entrypoint-initdb.d/data/title.akas.tsv' 
DELIMITER E'\t' 
CSV HEADER;

--CREATE TABLE titlebasics
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
    titleType VARCHAR(100),
    primaryTitle VARCHAR(450),
    originalTitle VARCHAR(450),
    isAdult BOOLEAN,
    startYear INT,
    endYear INT,
    runtimeMinutes INT,
    genres VARCHAR(100)
);


COPY temp_titlebasics (tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes, genres) 
FROM '/docker-entrypoint-initdb.d/data/title.basics.tsv' 
DELIMITER E'\t' 
CSV HEADER;

INSERT INTO titlebasics (tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes, genres)
SELECT
    tconst,
    titleType,
    primaryTitle,
    originalTitle,
    isAdult,
    NULLIF(startYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    NULLIF(endYear, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    NULLIF(runtimeMinutes, E'\\N')::INT,  -- \n in NULL konvertieren und in INT umwandeln
    genres
FROM temp_titlebasics;

DROP TABLE temp_titlebasics;

--CREATE TABLE crew
CREATE TABLE crew (
    tconst VARCHAR(100),
    directors VARCHAR(16000),
    writers VARCHAR(16000)
);


COPY crew (tconst, directors, writers) 
FROM '/docker-entrypoint-initdb.d/data/title.crew.tsv' 
DELIMITER E'\t' 
CSV HEADER;

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
