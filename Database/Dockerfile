# Verwende das offizielle PostgreSQL-Image als Basis
FROM postgres:16.3-alpine

# Setze Umgebungsvariablen für PostgreSQL
ENV POSTGRES_DB=mydatabase
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword

# Kopiere die Initialisierungs-SQL-Dateien und Daten in das Verzeichnis, das von PostgreSQL überwacht wird
COPY ./initdb /docker-entrypoint-initdb.d/
