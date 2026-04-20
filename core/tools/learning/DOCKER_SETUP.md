---
scope: shared
---

# Docker Setup Guide for Win Source Quest

This guide explains how to run the Win Source Quest application locally using Docker.

## Prerequisites

- Docker Desktop (or Docker Engine + Docker Compose)
- Git

## Quick Start (Frontend with Remote Supabase)

The default setup runs only the frontend and connects to the remote Supabase instance.

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone git@github.com:ArcanianAi/win-source-quest.git
   cd win-source-quest
   ```

2. **Copy the environment file**:
   ```bash
   cp .env.local .env
   ```

   The `.env` file is already configured to use the remote Supabase instance.

3. **Start the application**:
   ```bash
   docker-compose up -d
   ```

4. **Access the application**:
   - **Frontend Application**: http://localhost:5173

## Alternative: Running with Local Supabase Stack

If you want to run a complete local Supabase stack instead of using the remote instance:

1. **Use the full docker-compose configuration**:
   ```bash
   docker-compose -f docker-compose.full.yml up -d
   ```

2. **Access the services**:
   - **Frontend Application**: http://localhost:5173
   - **Supabase Studio** (Database UI): http://localhost:3000
   - **Supabase API**: http://localhost:54321
   - **PostgreSQL Database**: localhost:54322

## What's Included

The Docker setup includes:

- **Frontend**: Vite + React + TypeScript application
- **Supabase Stack**:
  - PostgreSQL Database (v15)
  - Supabase Studio (Database Management UI)
  - Auth Service (GoTrue)
  - REST API (PostgREST)
  - Realtime Service
  - Storage Service
  - Edge Functions (Deno runtime)
  - Kong API Gateway

## Environment Variables

The `.env.local` file contains default development credentials. **Important**:

⚠️ **NEVER use these credentials in production!**

For production deployment, generate new secure credentials:

```bash
# Generate a secure JWT secret (at least 32 characters)
openssl rand -base64 32

# Generate a secure PostgreSQL password
openssl rand -base64 32
```

### Key Environment Variables

- `POSTGRES_PASSWORD`: Database password
- `JWT_SECRET`: JWT signing secret
- `ANON_KEY`: Anonymous API key for client-side requests
- `SERVICE_ROLE_KEY`: Service role key for admin operations
- `SITE_URL`: Frontend application URL
- `VITE_SUPABASE_URL`: Supabase API URL for frontend

## Common Commands

### Start all services
```bash
docker-compose up -d
```

### Stop all services
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f db
```

### Restart a service
```bash
docker-compose restart frontend
```

### Rebuild the frontend
```bash
docker-compose build frontend
docker-compose up -d frontend
```

### Reset everything (including data)
```bash
docker-compose down -v
docker-compose up -d
```

## Database Migrations

Database migrations are automatically applied when the PostgreSQL container starts. Migration files are located in:

```
supabase/migrations/
```

To add a new migration:

1. Create a new SQL file in `supabase/migrations/`
2. Name it with a timestamp: `YYYYMMDDHHMMSS_description.sql`
3. Restart the database container:
   ```bash
   docker-compose restart db
   ```

## Edge Functions

Edge Functions are located in `supabase/functions/`. They run in a Deno runtime container.

To test an edge function locally:

```bash
curl -X POST http://localhost:54321/functions/v1/your-function-name \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0" \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

## Production Build

To build the frontend for production:

```bash
# Build production image
docker build -t win-source-quest:production --target production .

# Run production container
docker run -p 80:80 win-source-quest:production
```

## Troubleshooting

### Port conflicts
If you see port conflict errors, check if the following ports are available:
- 5173 (Frontend)
- 3000 (Supabase Studio)
- 54321 (Supabase API)
- 54322 (PostgreSQL)

### Container won't start
```bash
# Check container logs
docker-compose logs [service-name]

# Check container status
docker-compose ps
```

### Reset database
```bash
# Stop and remove all containers and volumes
docker-compose down -v

# Start fresh
docker-compose up -d
```

### Frontend hot reload not working
Make sure the volume mounts are correctly configured in `docker-compose.yml`:
```yaml
volumes:
  - .:/app
  - /app/node_modules
```

## Development Workflow

1. **Make code changes**: Edit files locally
2. **Hot reload**: Changes are automatically detected by Vite
3. **View changes**: Refresh browser at http://localhost:5173
4. **Database changes**: Use Supabase Studio at http://localhost:3000
5. **API testing**: Use the REST API at http://localhost:54321

## Syncing with Lovable

This project is integrated with Lovable. To sync local changes:

```bash
# Commit changes
git add .
git commit -m "Your changes"

# Push to remote
git push origin main
```

Changes pushed to the repository will be automatically synced with Lovable.

## Additional Resources

- [Supabase Local Development](https://supabase.com/docs/guides/cli/local-development)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Vite Documentation](https://vitejs.dev/)
- [Lovable Documentation](https://docs.lovable.dev/)
