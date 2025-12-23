import { pgTable, uuid, timestamp, unique, index } from "drizzle-orm/pg-core";
import { users } from "../users/users";
import { posts } from "./posts";

export const bookmarks = pgTable(
  "bookmarks",
  {
    id: uuid("id").defaultRandom().primaryKey(),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    postId: uuid("post_id")
      .notNull()
      .references(() => posts.id, { onDelete: "cascade" }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    unique("bookmarks_user_post_unique").on(table.userId, table.postId),
    index("bookmarks_user_id_idx").on(table.userId),
    index("bookmarks_post_id_idx").on(table.postId),
    index("bookmarks_created_at_idx").on(table.createdAt),
  ]
);

export type Bookmark = typeof bookmarks.$inferSelect;
export type NewBookmark = typeof bookmarks.$inferInsert;
