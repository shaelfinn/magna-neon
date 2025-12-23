import { pgTable, uuid, timestamp, unique, index } from "drizzle-orm/pg-core";
import { users } from "./users";

// ─── FOLLOWERS TABLE ────────────────────────────────────────────────────────
export const followers = pgTable(
  "followers",
  {
    id: uuid("id").defaultRandom().primaryKey(),
    followerId: uuid("follower_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    followingId: uuid("following_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    unique("followers_unique_pair").on(table.followerId, table.followingId),
    index("followers_follower_id_idx").on(table.followerId),
    index("followers_following_id_idx").on(table.followingId),
    index("followers_created_at_idx").on(table.createdAt),
  ]
);

export type Follower = typeof followers.$inferSelect;
export type NewFollower = typeof followers.$inferInsert;
