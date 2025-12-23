CREATE TYPE "public"."post_status" AS ENUM('draft', 'active', 'completed', 'cancelled');--> statement-breakpoint
CREATE TYPE "public"."post_type" AS ENUM('discussion', 'offer', 'gig', 'showcase', 'question', 'announcement');--> statement-breakpoint
CREATE TYPE "public"."post_visibility" AS ENUM('public', 'followers');--> statement-breakpoint
ALTER TYPE "public"."user_role" ADD VALUE 'freelancer' BEFORE 'admin';--> statement-breakpoint
ALTER TYPE "public"."user_role" ADD VALUE 'business' BEFORE 'admin';--> statement-breakpoint
ALTER TYPE "public"."user_role" ADD VALUE 'moderator' BEFORE 'admin';--> statement-breakpoint
CREATE TABLE "followers" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"follower_id" uuid NOT NULL,
	"following_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "followers_unique" UNIQUE("follower_id","following_id")
);
--> statement-breakpoint
CREATE TABLE "posts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"content" text NOT NULL,
	"type" "post_type" DEFAULT 'discussion' NOT NULL,
	"status" "post_status" DEFAULT 'active' NOT NULL,
	"visibility" "post_visibility" DEFAULT 'public' NOT NULL,
	"images" jsonb,
	"gig_title" varchar(255),
	"gig_category" varchar(100),
	"gig_budget" varchar(50),
	"gig_location" varchar(255),
	"gig_is_remote" boolean,
	"gig_skills" jsonb,
	"gig_deadline" timestamp with time zone,
	"like_count" integer DEFAULT 0 NOT NULL,
	"comment_count" integer DEFAULT 0 NOT NULL,
	"share_count" integer DEFAULT 0 NOT NULL,
	"view_count" integer DEFAULT 0 NOT NULL,
	"hashtags" jsonb,
	"location" varchar(255),
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "comments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"post_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"parent_comment_id" uuid,
	"content" text NOT NULL,
	"images" jsonb,
	"like_count" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "accounts" DISABLE ROW LEVEL SECURITY;--> statement-breakpoint
ALTER TABLE "sessions" DISABLE ROW LEVEL SECURITY;--> statement-breakpoint
DROP TABLE "accounts" CASCADE;--> statement-breakpoint
DROP TABLE "sessions" CASCADE;--> statement-breakpoint
ALTER TABLE "users" RENAME COLUMN "name" TO "full_name";--> statement-breakpoint
ALTER TABLE "users" RENAME COLUMN "image" TO "avatar";--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "status" SET DATA TYPE text;--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "status" SET DEFAULT 'active'::text;--> statement-breakpoint
DROP TYPE "public"."user_status";--> statement-breakpoint
CREATE TYPE "public"."user_status" AS ENUM('active', 'suspended', 'banned');--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "status" SET DEFAULT 'active'::"public"."user_status";--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "status" SET DATA TYPE "public"."user_status" USING "status"::"public"."user_status";--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "country_code" DROP DEFAULT;--> statement-breakpoint
ALTER TABLE "users" ALTER COLUMN "country_code" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "username" varchar(50) NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "bio" text;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "location" varchar(255);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "phone_number" varchar(20);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "languages" jsonb;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "twitter_url" varchar(255);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "linkedin_url" varchar(255);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "availability" varchar(50);--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "skills" jsonb;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "follower_count" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "following_count" integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "is_email_verified" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "is_phone_verified" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "is_identity_verified" boolean DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE "followers" ADD CONSTRAINT "followers_follower_id_users_id_fk" FOREIGN KEY ("follower_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "followers" ADD CONSTRAINT "followers_following_id_users_id_fk" FOREIGN KEY ("following_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "posts" ADD CONSTRAINT "posts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "comments" ADD CONSTRAINT "comments_post_id_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "comments" ADD CONSTRAINT "comments_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "followers_follower_id_idx" ON "followers" USING btree ("follower_id");--> statement-breakpoint
CREATE INDEX "followers_following_id_idx" ON "followers" USING btree ("following_id");--> statement-breakpoint
CREATE INDEX "followers_created_at_idx" ON "followers" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "posts_user_id_idx" ON "posts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "posts_type_idx" ON "posts" USING btree ("type");--> statement-breakpoint
CREATE INDEX "posts_status_idx" ON "posts" USING btree ("status");--> statement-breakpoint
CREATE INDEX "posts_visibility_idx" ON "posts" USING btree ("visibility");--> statement-breakpoint
CREATE INDEX "posts_gig_category_idx" ON "posts" USING btree ("gig_category");--> statement-breakpoint
CREATE INDEX "posts_created_at_idx" ON "posts" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "posts_like_count_idx" ON "posts" USING btree ("like_count");--> statement-breakpoint
CREATE INDEX "comments_post_id_idx" ON "comments" USING btree ("post_id");--> statement-breakpoint
CREATE INDEX "comments_user_id_idx" ON "comments" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "comments_parent_comment_id_idx" ON "comments" USING btree ("parent_comment_id");--> statement-breakpoint
CREATE INDEX "comments_created_at_idx" ON "comments" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "users_username_idx" ON "users" USING btree ("username");--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_username_unique" UNIQUE("username");