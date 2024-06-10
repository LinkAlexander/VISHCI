import { sql } from '../../db/db'

export const load = async () => {
        let averagesByRegion;
        averagesByRegion = await sql`
        SELECT ROUND(CAST(AVG(rating.averagerating) AS numeric), 2) AS avg,
        aka.region, startyear, isadult, COUNT(rating.averagerating) AS count
        FROM AKAS AS aka
        JOIN ratings AS rating
        ON aka.titleid = rating.tconst
        JOIN titlebasics as title
        ON title.tconst = rating.tconst
        GROUP BY aka.region, startyear, isadult;
        `

        return {
            averagesByRegion
        }
}