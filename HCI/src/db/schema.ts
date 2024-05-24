import { text, pgTable } from "drizzle-orm/pg-core";

export const ratingsTable = pgTable('ratings', {
    tconst: text('tconst'),
    averageRating: text('averageRating'),
    numVotes: text('numVotes'),
});