import postgres from 'postgres'

const PGHOST = "127.0.0.1";
const PGDATABASE = "IMDb";
const PGUSER = "postgres";
const PGPASSWORD = "my_password";

export const sql = postgres({ host: PGHOST, database: PGDATABASE, username: PGUSER, password: PGPASSWORD, port: 5432 });

export default sql