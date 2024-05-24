docker build -t db-container .

docker run --name database-container -d -p 5432:5432 db-container