# Projekt vorbereiten
Daten hier runterladen: https://mega.nz/folder/91gjCTKZ#bBwNltiHFoHF3OazdAiz_Q

Daten müssen dann wie die title.ratings.tsv abgelegt werden:

![grafik](https://github.com/LinkAlexander/VISHCI/assets/167143907/25e8eb2f-6379-41d4-9073-816efc257a82)



# Datenbank erzeugen
Befehle in diesem ordner (beim Dockerfile) ausführen:

docker build -t db-container .

docker run --name database-container -d -p 5432:5432 db-container
