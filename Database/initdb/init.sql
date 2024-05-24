CREATE TABLE ratings (
    tconst VARCHAR(100),
    averageRating FLOAT,
    numVotes INT
);

-- Laden der Daten aus der TSV-Datei
COPY ratings (tconst, averageRating, numVotes) 
FROM '/docker-entrypoint-initdb.d/data/title.ratings.tsv' 
DELIMITER E'\t' 
CSV HEADER;
