import { pgEnum } from "drizzle-orm/pg-core";

export const postTypeEnum = pgEnum("post_type", [
  "discussion",
  "offer",
  "gig",
  "showcase",
  "question",
  "announcement",
]);

export const postStatusEnum = pgEnum("post_status", [
  "draft",
  "active",
  "completed",
  "cancelled",
]);

export const postVisibilityEnum = pgEnum("post_visibility", [
  "public",
  "followers",
]);

export type PostType = (typeof postTypeEnum.enumValues)[number];
export type PostStatus = (typeof postStatusEnum.enumValues)[number];
export type PostVisibility = (typeof postVisibilityEnum.enumValues)[number];
