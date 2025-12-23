// Reference:
// https://orm.drizzle.team/docs/tutorials/drizzle-with-neon#connect-drizzle-orm-to-your-database

import { drizzle } from "drizzle-orm/neon-http";
import { neon } from "@neondatabase/serverless";
import { schema } from "./schema";

const sql = neon(process.env.DATABASE_URL!);

export const db = drizzle(sql, { schema });
