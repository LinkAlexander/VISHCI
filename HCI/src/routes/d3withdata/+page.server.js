import { sql } from '../../db/db'

export const load = async () => {
  const result = new Array();

  let quicksave;

  quicksave = await sql`
  select
  count(*)
  from ratings
  where "averagerating" > 0 and "averagerating" < 2
  `
  result[0] = quicksave[0].count;

  quicksave = await sql`
  select
    count(*)
  from ratings
  where "averagerating" > 2 and "averagerating" < 4
`
  result[1] = quicksave[0].count;

  quicksave = await sql`
    select
      count(*)
    from ratings
    where "averagerating" > 4 and "averagerating" < 6
  `
  result[2] = quicksave[0].count;


  quicksave = await sql`
  select
    count(*)
  from ratings
  where "averagerating" > 6 and "averagerating" < 8
`
  result[3] = quicksave[0].count;

  quicksave = await sql`
    select
      count(*)
    from ratings
    where "averagerating" > 8 and "averagerating" < 10
  `
  result[4] = quicksave[0].count;


  return {
    result
  }

}