# Magna Coders

A collaborative platform where developers, designers, and problem-solvers unite to create tech solutions for real-world challenges.

## Tech Stack

- **Framework**: [Next.js 16](https://nextjs.org/) with App Router
- **Styling**: [Tailwind CSS](https://tailwindcss.com/)
- **Database**: [Neon Postgres](https://neon.tech/) (serverless Postgres)
- **ORM**: [Drizzle ORM](https://orm.drizzle.team/)

## Getting Started

### Prerequisites

- Node.js (v20+ recommended)
- npm or yarn
- A PostgreSQL database (Neon recommended)

### Installation

1. Install dependencies:

   ```bash
   npm install
   ```

2. Set up your environment variables:

   ```bash
   cp .env.example .env
   ```

3. Configure your database URL in `.env`:
   ```
   DATABASE_URL=your_postgres_connection_string
   ```

### Running the Application

```bash
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000) to see the application.

## Learn More

For detailed database setup instructions, see the [drizzle/schema](drizzle/schema) directory.
