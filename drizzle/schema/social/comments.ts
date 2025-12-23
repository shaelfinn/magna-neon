import {
  pgTable,
  uuid,
  text,
  timestamp,
  integer,
  jsonb,
  index,
} from "drizzle-orm/pg-core";
import { users } from "../users/users";
import { posts } from "./posts";

// ─── COMMENTS TABLE (SIMPLIFIED) ────────────────────────────────────────────────────────
export const comments = pgTable(
  "comments",
  {
    id: uuid("id").defaultRandom().primaryKey(),
    postId: uuid("post_id")
      .notNull()
      .references(() => posts.id, { onDelete: "cascade" }),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    parentCommentId: uuid("parent_comment_id"),
    content: text("content").notNull(),
    images: jsonb("images").$type<string[]>(),
    likeCount: integer("like_count").default(0).notNull(),
    createdAt: timestamp("created_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    index("comments_post_id_idx").on(table.postId),
    index("comments_user_id_idx").on(table.userId),
    index("comments_parent_comment_id_idx").on(table.parentCommentId),
    index("comments_created_at_idx").on(table.createdAt),
  ]
);

export type Comment = typeof comments.$inferSelect;
export type NewComment = typeof comments.$inferInsert;
