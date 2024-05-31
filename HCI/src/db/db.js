import postgres from 'postgres'

const PGHOST = "localhost";
const PGDATABASE = "mydatabase";
const PGUSER = "myuser";
const PGPASSWORD = "mypassword";

export const sql = postgres({ host: PGHOST, database: PGDATABASE, username: PGUSER, password: PGPASSWORD, port: 5432 });

export default sql