# Drizzle Database Schema

A clean, type-safe PostgreSQL database schema built with Drizzle ORM for a social platform with freelancing features.

## Architecture Overview

The schema is organized into domain-specific modules with proper separation of concerns:

```
drizzle/
├── schema/
│   ├── enums/           # PostgreSQL enums
│   │   ├── users.ts     # User-related enums
│   │   ├── social.ts    # Social platform enums
│   │   └── index.ts     # Export all enums
│   ├── users/           # User domain
│   │   ├── users.ts     # Core user table
│   │   ├── followers.ts # Follow relationships
│   │   └── index.ts     # Export user tables
│   └── social/          # Social domain
│       ├── posts.ts     # Posts/gigs table
│       ├── comments.ts  # Comments on posts
│       ├── likes.ts     # Likes for posts/comments
│       ├── bookmarks.ts # User bookmarks
│       └── index.ts     # Export social tables
├── migrations/          # Database migrations
├── db.ts               # Database connection
├── relations.ts        # Drizzle relations
├── schema.ts           # Main schema export
└── README.md           # This file
```

## Tables Overview

### Users Domain

#### `users`

Core user information with field-level uniqueness constraints:

- **Unique fields**: `email`, `username`, `phoneNumber`
- **Roles**: user, freelancer, business, moderator, admin
- **Status**: active, suspended, banned
- Profile data, verification flags, and social links
- **Note**: Follower/following counts are computed dynamically for data integrity

#### `followers`

User follow relationships:

- **Composite unique**: `(followerId, followingId)`
- Prevents duplicate follow relationships
- Self-referencing to users table

### Social Domain

#### `posts`

Multi-purpose posts supporting discussions and gig listings:

- **Post types**: discussion, offer, gig, showcase, question, announcement
- **Gig fields**: title, category, budget, location, skills, deadline
- **Engagement**: like/comment/share/view counts
- **Media**: image attachments, hashtags

#### `comments`

Nested comments on posts:

- Supports reply threads via `parentCommentId`
- Image attachments supported
- Like counts tracked

#### `likes`

Unified likes for posts and comments:

- **Composite unique**: `(userId, postId)` and `(userId, commentId)`
- Prevents duplicate likes
- Either `postId` OR `commentId` is set

#### `bookmarks`

User bookmarks for posts:

- **Composite unique**: `(userId, postId)`
- Prevents duplicate bookmarks

## Data Integrity Features

### Field-Level Uniqueness

All unique constraints are implemented at the field level using `.unique()`:

```typescript
email: varchar("email", { length: 255 }).notNull().unique(),
username: varchar("username", { length: 50 }).notNull().unique(),
```

### Composite Uniqueness

Multi-column uniqueness for relationship tables:

```typescript
unique("likes_user_post_unique").on(table.userId, table.postId),
```

### Cascade Deletes

Proper foreign key relationships with cascade deletes:

```typescript
userId: uuid("user_id")
  .notNull()
  .references(() => users.id, { onDelete: "cascade" }),
```

### Computed Counts

Follower/following counts are computed dynamically to ensure data integrity:

```typescript
// Get user with computed follower counts
const userWithCounts = await db
  .select({
    ...users,
    followerCount: sql<number>`(
      SELECT COUNT(*) FROM followers 
      WHERE following_id = ${users.id}
    )`,
    followingCount: sql<number>`(
      SELECT COUNT(*) FROM followers 
      WHERE follower_id = ${users.id}
    )`,
  })
  .from(users)
  .where(eq(users.id, userId));
```

## Performance Optimization

### Strategic Indexing

Indexes are created only for:

- Frequently queried non-unique fields
- Foreign key relationships
- Timestamp fields for sorting
- Status/type fields for filtering

### No Redundant Constraints

- Unique constraints are at field level, not duplicated in table constraints
- Indexes don't duplicate unique field constraints

### Computed vs Stored Counts

- **Follower counts**: Computed dynamically for accuracy
- **Engagement counts**: Stored for performance (likes, comments, views)
- Cache computed counts at application level if needed

## Type Safety

Full TypeScript inference for all tables:

```typescript
export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
```

## Relations

Comprehensive bidirectional relations defined in `relations.ts`:

- Users ↔ Posts, Comments, Likes, Bookmarks, Followers
- Posts ↔ Comments, Likes, Bookmarks
- Comments ↔ Likes, Replies (self-referencing)

## Usage Examples

### Database Connection

```typescript
import { db } from "./drizzle/db";
import { users, posts, followers } from "./drizzle/schema";
import { eq, sql, and, desc } from "drizzle-orm";
```

### User Queries with Computed Counts

```typescript
// Get user profile with follower counts
const getUserProfile = async (userId: string) => {
  return await db
    .select({
      id: users.id,
      username: users.username,
      fullName: users.fullName,
      avatar: users.avatar,
      bio: users.bio,
      followerCount: sql<number>`(
        SELECT COUNT(*) FROM followers 
        WHERE following_id = ${users.id}
      )`,
      followingCount: sql<number>`(
        SELECT COUNT(*) FROM followers 
        WHERE follower_id = ${users.id}
      )`,
    })
    .from(users)
    .where(eq(users.id, userId))
    .then((rows) => rows[0]);
};

// Check if user A follows user B
const isFollowing = async (followerId: string, followingId: string) => {
  const result = await db
    .select({ id: followers.id })
    .from(followers)
    .where(
      and(
        eq(followers.followerId, followerId),
        eq(followers.followingId, followingId)
      )
    )
    .limit(1);

  return result.length > 0;
};
```

### Follow/Unfollow Operations

```typescript
// Follow a user
const followUser = async (followerId: string, followingId: string) => {
  try {
    await db.insert(followers).values({
      followerId,
      followingId,
    });
  } catch (error) {
    // Handle duplicate follow (unique constraint violation)
    if (error.code === "23505") {
      throw new Error("Already following this user");
    }
    throw error;
  }
};

// Unfollow a user
const unfollowUser = async (followerId: string, followingId: string) => {
  await db
    .delete(followers)
    .where(
      and(
        eq(followers.followerId, followerId),
        eq(followers.followingId, followingId)
      )
    );
};
```

### Post Queries

```typescript
// Get user with posts
const userWithPosts = await db.query.users.findFirst({
  where: eq(users.id, userId),
  with: {
    posts: {
      orderBy: desc(posts.createdAt),
      limit: 10,
    },
  },
});

// Create a post
const newPost = await db
  .insert(posts)
  .values({
    userId,
    content: "Hello world!",
    type: "discussion",
  })
  .returning();
```

### Migrations

```bash
# Generate migration
npm run db:generate

# Apply migrations
npm run db:migrate

# Reset database (development)
npm run db:reset
```

## Environment Setup

Required environment variables:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
```

## Key Benefits

1. **Data Integrity**: Field-level uniqueness and computed counts prevent inconsistencies
2. **Performance**: Strategic indexing without redundancy
3. **Type Safety**: Full TypeScript inference and validation
4. **Maintainability**: Clean domain separation and clear relationships
5. **Scalability**: Optimized for common query patterns with caching opportunities
6. **Developer Experience**: Clear intent, comprehensive relations, and practical examples
7. **Stateless Design**: No session storage, perfect for modern authentication patterns

This schema provides a solid foundation for a social platform with freelancing features while maintaining excellent performance, data integrity, and developer experience.
