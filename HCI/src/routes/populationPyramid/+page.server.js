import { sql } from '../../db/db'

export const load = async () => {
    if (false) {
        let averagesByRegion;

        averagesByRegion = await sql`
        SELECT avg(rating.averagerating) AS avg,
        aka.region FROM AKAS AS aka
        JOIN ratings AS rating
        ON aka.titleid = rating.tconst
        GROUP BY aka.region
        ORDER BY avg;
        `

        return {
            averagesByRegion
        }
    } else {
        return {};
    }
}