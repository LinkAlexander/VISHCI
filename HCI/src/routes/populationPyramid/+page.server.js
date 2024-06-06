import { sql } from '../../db/db'

export const load = async () => {
    if (true) {
        let population = [];

        population[0] = await sql`
        SELECT WIDTH_BUCKET(EXTRACT(YEAR FROM age(current_date, make_date(birthyear, 1, 1))), 0, 100, 10) * 10 AS age_group,
        COUNT(*) AS count
        FROM namebasics
        WHERE deathyear IS NULL
        AND 'actor' = ANY(primaryprofession)
        GROUP BY age_group
        ORDER BY age_group;
        `
        population[1] = await sql`
        SELECT WIDTH_BUCKET(EXTRACT(YEAR FROM age(current_date, make_date(birthyear, 1, 1))), 0, 100, 10) * 10 AS age_group,
        COUNT(*) AS count
        FROM namebasics
        WHERE deathyear IS NULL
        AND 'actress' = ANY(primaryprofession)
        GROUP BY age_group
        ORDER BY age_group;
        `

        return {
            population
        }
    } else {
        return {};
    }
}