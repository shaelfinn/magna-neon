import {
  pgTable,
  uuid,
  varchar,
  text,
  timestamp,
  integer,
  jsonb,
  index,
  boolean,
} from "drizzle-orm/pg-core";
import { users } from "../users/users";
import { postTypeEnum, postStatusEnum, postVisibilityEnum } from "../enums";

// ─── POSTS TABLE (SIMPLIFIED) ────────────────────────────────────────────────────────
export const posts = pgTable(
  "posts",
  {
    id: uuid("id").defaultRandom().primaryKey(),
    userId: uuid("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    content: text("content").notNull(),
    type: postTypeEnum("type").default("discussion").notNull(),
    status: postStatusEnum("status").default("active").notNull(),
    visibility: postVisibilityEnum("visibility").default("public").notNull(),
    images: jsonb("images").$type<string[]>(),
    gigTitle: varchar("gig_title", { length: 255 }),
    gigCategory: varchar("gig_category", { length: 100 }),
    gigBudget: varchar("gig_budget", { length: 50 }),
    gigLocation: varchar("gig_location", { length: 255 }),
    gigIsRemote: boolean("gig_is_remote"),
    gigSkills: jsonb("gig_skills").$type<string[]>(),
    gigDeadline: timestamp("gig_deadline", { withTimezone: true }),
    likeCount: integer("like_count").default(0).notNull(),
    commentCount: integer("comment_count").default(0).notNull(),
    shareCount: integer("share_count").default(0).notNull(),
    viewCount: integer("view_count").default(0).notNull(),
    hashtags: jsonb("hashtags").$type<string[]>(),
    location: varchar("location", { length: 255 }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    index("posts_user_id_idx").on(table.userId),
    index("posts_type_idx").on(table.type),
    index("posts_status_idx").on(table.status),
    index("posts_visibility_idx").on(table.visibility),
    index("posts_gig_category_idx").on(table.gigCategory),
    index("posts_created_at_idx").on(table.createdAt),
    index("posts_like_count_idx").on(table.likeCount),
  ]
);

export type Post = typeof posts.$inferSelect;
export type NewPost = typeof posts.$inferInsert;
