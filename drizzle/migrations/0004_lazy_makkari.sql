CREATE TABLE "likes" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"post_id" uuid,
	"comment_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "likes_user_post_unique" UNIQUE("user_id","post_id"),
	CONSTRAINT "likes_user_comment_unique" UNIQUE("user_id","comment_id")
);
--> statement-breakpoint
CREATE TABLE "bookmarks" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"post_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "bookmarks_user_post_unique" UNIQUE("user_id","post_id")
);
--> statement-breakpoint
ALTER TABLE "users" DROP CONSTRAINT "users_referral_code_unique";--> statement-breakpoint
ALTER TABLE "followers" DROP CONSTRAINT "followers_unique";--> statement-breakpoint
DROP INDEX "users_username_idx";--> statement-breakpoint
ALTER TABLE "likes" ADD CONSTRAINT "likes_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "likes" ADD CONSTRAINT "likes_post_id_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "likes" ADD CONSTRAINT "likes_comment_id_comments_id_fk" FOREIGN KEY ("comment_id") REFERENCES "public"."comments"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookmarks" ADD CONSTRAINT "bookmarks_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bookmarks" ADD CONSTRAINT "bookmarks_post_id_posts_id_fk" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "likes_user_id_idx" ON "likes" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "likes_post_id_idx" ON "likes" USING btree ("post_id");--> statement-breakpoint
CREATE INDEX "likes_comment_id_idx" ON "likes" USING btree ("comment_id");--> statement-breakpoint
CREATE INDEX "likes_created_at_idx" ON "likes" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "bookmarks_user_id_idx" ON "bookmarks" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "bookmarks_post_id_idx" ON "bookmarks" USING btree ("post_id");--> statement-breakpoint
CREATE INDEX "bookmarks_created_at_idx" ON "bookmarks" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "users_role_idx" ON "users" USING btree ("role");--> statement-breakpoint
CREATE INDEX "users_country_code_idx" ON "users" USING btree ("country_code");--> statement-breakpoint
ALTER TABLE "users" DROP COLUMN "languages";--> statement-breakpoint
ALTER TABLE "users" DROP COLUMN "follower_count";--> statement-breakpoint
ALTER TABLE "users" DROP COLUMN "following_count";--> statement-breakpoint
ALTER TABLE "users" DROP COLUMN "referral_code";--> statement-breakpoint
ALTER TABLE "users" DROP COLUMN "is_identity_verified";--> statement-breakpoint
ALTER TABLE "users" ADD CONSTRAINT "users_phone_number_unique" UNIQUE("phone_number");--> statement-breakpoint
ALTER TABLE "followers" ADD CONSTRAINT "followers_unique_pair" UNIQUE("follower_id","following_id");