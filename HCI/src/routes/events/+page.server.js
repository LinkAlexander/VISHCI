import { sql } from '../../db/db'

export const load = async () => {
    if (true) {
        let genreByYear;

        genreByYear = await sql`
        WITH GenreCounts AS (
            SELECT
                startyear,
                unnest(genres) AS genre
            FROM
                titlebasics
            WHERE
                startyear IS NOT NULL
        )
        
        SELECT
            startyear,
            COUNT(CASE WHEN genre = 'Drama' THEN 1 END) AS Drama,
            COUNT(CASE WHEN genre = 'Comedy' THEN 1 END) AS Comedy,
            COUNT(CASE WHEN genre = 'Talk-Show' THEN 1 END) AS Talk_Show,
            COUNT(CASE WHEN genre = 'Short' THEN 1 END) AS Short,
            COUNT(CASE WHEN genre = 'Documentary' THEN 1 END) AS Documentary,
            COUNT(CASE WHEN genre = 'Romance' THEN 1 END) AS Romance,
            COUNT(CASE WHEN genre = 'News' THEN 1 END) AS News,
            COUNT(CASE WHEN genre = 'Family' THEN 1 END) AS Family,
            COUNT(CASE WHEN genre = 'Reality-TV' THEN 1 END) AS Reality_TV,
            COUNT(CASE WHEN genre = 'Animation' THEN 1 END) AS Animation,
            COUNT(CASE WHEN genre = '\N' THEN 1 END) AS Unknown,
            COUNT(CASE WHEN genre = 'Crime' THEN 1 END) AS Crime,
            COUNT(CASE WHEN genre = 'Action' THEN 1 END) AS Action,
            COUNT(CASE WHEN genre = 'Adventure' THEN 1 END) AS Adventure,
            COUNT(CASE WHEN genre = 'Music' THEN 1 END) AS Music,
            COUNT(CASE WHEN genre = 'Game-Show' THEN 1 END) AS Game_Show,
            COUNT(CASE WHEN genre = 'Adult' THEN 1 END) AS Adult,
            COUNT(CASE WHEN genre = 'Sport' THEN 1 END) AS Sport,
            COUNT(CASE WHEN genre = 'Fantasy' THEN 1 END) AS Fantasy,
            COUNT(CASE WHEN genre = 'Mystery' THEN 1 END) AS Mystery,
            COUNT(CASE WHEN genre = 'Horror' THEN 1 END) AS Horror,
            COUNT(CASE WHEN genre = 'Thriller' THEN 1 END) AS Thriller,
            COUNT(CASE WHEN genre = 'History' THEN 1 END) AS History,
            COUNT(CASE WHEN genre = 'Biography' THEN 1 END) AS Biography,
            COUNT(CASE WHEN genre = 'Sci-Fi' THEN 1 END) AS Sci_Fi,
            COUNT(CASE WHEN genre = 'Musical' THEN 1 END) AS Musical,
            COUNT(CASE WHEN genre = 'War' THEN 1 END) AS War,
            COUNT(CASE WHEN genre = 'Western' THEN 1 END) AS Western,
            COUNT(CASE WHEN genre = 'Film-Noir' THEN 1 END) AS Film_Noir
        FROM
            GenreCounts
        GROUP BY
            startyear
        ORDER BY
            startyear;
        
        `

        return {
            genreByYear
        }
    } else {
        return {};
    }
}