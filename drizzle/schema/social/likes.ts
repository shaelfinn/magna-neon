import { pgTable, uuid, timestamp, unique, index } from "drizzle-orm/pg-core";
import { users } from "../users/users";
import { posts } from "./posts";
import { comments } from "./comments";

export const likes = pgTable(
  "likes",
  {
    id: uuid("id").defaultRandom().primaryKey(),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    postId: uuid("post_id").references(() => posts.id, { onDelete: "cascade" }),
    commentId: uuid("comment_id").references(() => comments.id, {
      onDelete: "cascade",
    }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    unique("likes_user_post_unique").on(table.userId, table.postId),
    unique("likes_user_comment_unique").on(table.userId, table.commentId),
    index("likes_user_id_idx").on(table.userId),
    index("likes_post_id_idx").on(table.postId),
    index("likes_comment_id_idx").on(table.commentId),
    index("likes_created_at_idx").on(table.createdAt),
  ]
);

export type Like = typeof likes.$inferSelect;
export type NewLike = typeof likes.$inferInsert;
