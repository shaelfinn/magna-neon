import {
  pgTable,
  uuid,
  varchar,
  timestamp,
  unique,
  text,
  index,
  integer,
  jsonb,
  boolean,
} from "drizzle-orm/pg-core";
import { userRoleEnum, userStatusEnum } from "../enums";

// ─── USERS TABLE ────────────────────────────────────────────────────────
export const users = pgTable(
  "users",
  {
    id: uuid("id").defaultRandom().primaryKey(),
    email: varchar("email", { length: 255 }).notNull().unique(),
    username: varchar("username", { length: 50 }).notNull().unique(),
    fullName: varchar("full_name", { length: 255 }).notNull(),
    avatar: text("avatar"),
    bio: text("bio"),
    location: varchar("location", { length: 255 }),
    countryCode: varchar("country_code", { length: 2 }),
    country: varchar("country", { length: 100 }),
    phoneNumber: varchar("phone_number", { length: 20 }).unique(),
    twitterUrl: varchar("twitter_url", { length: 255 }),
    linkedinUrl: varchar("linkedin_url", { length: 255 }),
    availability: varchar("availability", { length: 50 }),
    skills: jsonb("skills").$type<string[]>(),
    role: userRoleEnum("role").default("user").notNull(),
    status: userStatusEnum("status").default("active").notNull(),
    passwordHash: text("password_hash"),
    isEmailVerified: boolean("is_email_verified").default(false).notNull(),
    isPhoneVerified: boolean("is_phone_verified").default(false).notNull(),
    createdAt: timestamp("created_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    index("users_status_idx").on(table.status),
    index("users_created_at_idx").on(table.createdAt),
    index("users_role_idx").on(table.role),
    index("users_country_code_idx").on(table.countryCode),
  ]
);

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
