import { pgEnum } from "drizzle-orm/pg-core";

export const userRoleEnum = pgEnum("user_role", [
  "user",
  "freelancer",
  "business",
  "moderator",
  "admin",
]);

export const userStatusEnum = pgEnum("user_status", [
  "active",
  "suspended",
  "banned",
]);

export type UserRole = (typeof userRoleEnum.enumValues)[number];
export type UserStatus = (typeof userStatusEnum.enumValues)[number];
