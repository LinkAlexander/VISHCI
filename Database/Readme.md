# How To: Database Creation
Das Erstellen der Database geht mit einem Command:
```
docker run --name Db-Container -d -p 5432:5432 landstreicherjo/hci:latest
```
Die Logs mitzulesen geht mit folgendem Command:
```
 docker logs -f Db-Container
```
## Abschluss
Zum Verbinden mit der DB können in den Containerlogs Postgres-Version, IP-Adresse und Port ausgelesen werden. Diese Informationen werden nach der Initialisierung der DB angezeigt: 

![grafik](https://github.com/LinkAlexander/VISHCI/assets/167143907/97f55722-721a-404c-8b2a-e9610a67d6e7)

User, Password, Databasename können dem Database-Dockerfile entnommen werden

# Dokumentation
## Projekt vorbereiten
Daten hier runterladen: https://mega.nz/folder/91gjCTKZ#bBwNltiHFoHF3OazdAiz_Q

Daten müssen dann wie die title.ratings.tsv abgelegt werden:

![grafik](https://github.com/LinkAlexander/VISHCI/assets/167143907/25e8eb2f-6379-41d4-9073-816efc257a82)



## Datenbank erzeugen
Befehle im Database-Ordner (beim Dockerfile) ausführen:

``` 
docker build -t db-container .
```

```
docker run --name database-container -d -p 5432:5432 db-container
```

## Docker Image bei DockerHub hochladen
CMD 1 und 3

![grafik](https://github.com/LinkAlexander/VISHCI/assets/167143907/6f8e7f96-cdd5-4974-b946-ac4a4d3b430d)
