import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from '../../db/schema';
import { sql } from '../../db/db'

export const load = async () => {
  // for query purposes
  //const queryClient = postgres("postgres://postgres:my_password@127.0.0.1:5432/IMDb");
  //const db = drizzle(queryClient, { schema });
  //const result = await db.query.ratingsTable.findFirst();
  const result = new Array();

  let quicksave;

  quicksave = await sql`
  select
  count(*)
  from ratings
  where "averageRating" > 0 and "averageRating" < 2
  `
  result[0] = quicksave[0].count;

  quicksave = await sql`
  select
    count(*)
  from ratings
  where "averageRating" > 2 and "averageRating" < 4
`
  result[1] = quicksave[0].count;

  quicksave = await sql`
    select
      count(*)
    from ratings
    where "averageRating" > 4 and "averageRating" < 6
  `
  result[2] = quicksave[0].count;


  quicksave = await sql`
  select
    count(*)
  from ratings
  where "averageRating" > 6 and "averageRating" < 8
`
  result[3] = quicksave[0].count;

  quicksave = await sql`
    select
      count(*)
    from ratings
    where "averageRating" > 8 and "averageRating" < 10
  `
  result[4] = quicksave[0].count;


  return {
    result
  }

}