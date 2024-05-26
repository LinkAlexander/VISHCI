CREATE TABLE ratings (
    tconst VARCHAR(100),
    averageRating FLOAT,
    numVotes INT
);


COPY ratings (tconst, averageRating, numVotes) 
FROM '/docker-entrypoint-initdb.d/data/title.ratings.tsv' 
DELIMITER E'\t' 
CSV HEADER;


CREATE TABLE namebasics (
    nconst VARCHAR(100),
    primaryName VARCHAR(120),
    birthYear VARCHAR(100),
    deathYear VARCHAR(100),
    primaryProfession VARCHAR(100),
    knownForTitles VARCHAR(100)
);


COPY namebasics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles) 
FROM '/docker-entrypoint-initdb.d/data/name.basics.tsv' 
DELIMITER E'\t' 
CSV HEADER;


CREATE TABLE akas (
    titleId VARCHAR(100),
    ordering VARCHAR(120),
    title VARCHAR(870),
    region VARCHAR(100),
    language VARCHAR(100),
    types VARCHAR(100),
    attributes VARCHAR(100),
    isOriginalTitle VARCHAR(100)
);


COPY akas (titleId, ordering, title, region, language, types, attributes, isOriginalTitle) 
FROM '/docker-entrypoint-initdb.d/data/title.akas.tsv' 
DELIMITER E'\t' 
CSV HEADER;


CREATE TABLE titlebasics (
    tconst VARCHAR(100),
    titleType VARCHAR(100),
    primaryTitle VARCHAR(450),
    originalTitle VARCHAR(450),
    isAdult VARCHAR(100),
    startYear VARCHAR(100),
    endYear VARCHAR(100),
    runtimeMinutes VARCHAR(100),
    genres VARCHAR(100)
);


COPY titlebasics (tconst, titleType, primaryTitle, originalTitle, isAdult, startYear, endYear, runtimeMinutes, genres) 
FROM '/docker-entrypoint-initdb.d/data/title.basics.tsv' 
DELIMITER E'\t' 
CSV HEADER;


CREATE TABLE crew (
    tconst VARCHAR(100),
    directors VARCHAR(16000),
    writers VARCHAR(16000)
);


COPY crew (tconst, directors, writers) 
FROM '/docker-entrypoint-initdb.d/data/title.crew.tsv' 
DELIMITER E'\t' 
CSV HEADER;


CREATE TABLE episode (
    tconst VARCHAR(100),
    parentTconst VARCHAR(100),
    seasonNumber VARCHAR(100),
    episodeNumber VARCHAR(100)
);


COPY episode (tconst, parentTconst, seasonNumber, episodeNumber) 
FROM '/docker-entrypoint-initdb.d/data/title.episode.tsv' 
DELIMITER E'\t' 
CSV HEADER;


CREATE TABLE principals (
    tconst VARCHAR(100),
    ordering VARCHAR(100),
    nconst VARCHAR(100),
    category VARCHAR(100),
    job VARCHAR(500),
    characters VARCHAR(1000)
);


COPY principals (tconst, ordering, nconst, category, job, characters) 
FROM '/docker-entrypoint-initdb.d/data/title.principals.tsv' 
DELIMITER E'\t' 
CSV HEADER;