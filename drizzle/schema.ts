// Export enums first
export * from "./schema/enums";
// Export all domain tables and types
export * from "./schema/users";
export * from "./schema/social";
// Export relations
export * from "./relations";
// Import tables for schema object
import { users, followers } from "./schema/users";
import { posts, comments, likes, bookmarks } from "./schema/social";

// Schema object.
export const schema = {
  // users
  users,
  followers,
  // social
  posts,
  comments,
  likes,
  bookmarks,
};
