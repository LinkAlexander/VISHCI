import { sql } from '../../db/db'

export const load = async () => {
    let result = await sql`
  WITH split_professions AS (
    SELECT
        unnest(primaryprofession) AS profession
    FROM
        namebasics
)

-- Gruppiere und zähle die einzelnen Berufe
SELECT
    profession,
    COUNT(*) AS count
FROM
    split_professions
GROUP BY
    profession
ORDER BY
    count DESC;
  `
    result = berufeAnpassen(result);

    return {
        result
    }

}

function berufeAnpassen(daten) {
    return daten.map(eintrag => {
        if (eintrag.profession === '\\N') {
            eintrag.profession = 'no profession';
        }
        return eintrag;
    });
}