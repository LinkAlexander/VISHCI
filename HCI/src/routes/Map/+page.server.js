import { sql } from '../../db/db'

export const load = async () => {
        let averagesByRegion;
        averagesByRegion = await sql`
        SELECT avg(rating.averagerating) AS avg,
        aka.region,
        title.startyear
        FROM AKAS AS aka
        JOIN ratings AS rating        
        ON aka.titleid = rating.tconst
        JOIN titlebasics as title
        ON title.tconst = rating.tconst
        GROUP BY aka.region, title.startyear 
        ORDER BY avg;
        `

        return {
            averagesByRegion
        }
}