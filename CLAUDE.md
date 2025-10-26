# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Technology Stack

This is a Lucky Framework web application built with Crystal. Lucky is a full-stack web framework that emphasizes type-safety, developer productivity, and fast performance.

**Core dependencies:**
- Crystal language (>= 1.18.2)
- Lucky Framework (~> 1.4.0) - Web framework
- Avram (~> 1.4.0) - Database ORM
- Authentic (>= 1.0.2) - Authentication
- PostgreSQL 14 - Database

## Development Commands

All development is done via Docker Compose using bin scripts. **Never run Crystal commands directly** - always use the bin scripts.

**Start development server:**
```bash
bin/dev
```
Starts PostgreSQL, runs migrations, and starts the Lucky dev server with hot-reloading at http://localhost:3000

**Run tests:**
```bash
bin/spec                                    # All tests
bin/spec spec/requests/todos/               # Directory
bin/spec spec/requests/todos/index_spec.cr  # Single file
```

**Format code:**
```bash
bin/lint              # Auto-format
bin/lint --check      # Check only
```

**Other Lucky commands:**
```bash
docker compose run --rm lucky lucky db.migrate      # Run migrations
docker compose run --rm lucky lucky db.rollback     # Rollback migration
docker compose run --rm lucky lucky db.create       # Create database
docker compose run --rm lucky lucky gen.migration MigrationName
```

## Architecture Overview

### Action Inheritance Hierarchy

Lucky uses two base action classes that define different authentication strategies:

**BrowserAction** (`src/actions/browser_action.cr`)
- For HTML pages served to browsers
- Includes `Auth::RequireSignIn` by default - all actions require authentication
- Uses session-based authentication via cookies
- To allow guest access: `include Auth::AllowGuests` in specific actions
- Exposes `current_user` to all pages

**ApiAction** (`src/actions/api_action.cr`)
- For JSON API endpoints
- Includes `Api::Auth::RequireAuthToken` by default - all actions require JWT token
- Uses JWT bearer token authentication
- To allow unauthenticated access: `include Api::Auth::SkipRequireAuthToken`
- Cookies disabled by default

### Lucky's Action-Operation-Query Pattern

Lucky enforces separation of concerns through distinct layers:

**Actions** (`src/actions/`)
- Handle routing and HTTP concerns
- Define routes inline: `post "/todos"`, `get "/todos/:id/edit"`
- Always inherit from BrowserAction or ApiAction
- Pass data to Operations, render Pages, handle redirects

**Operations** (`src/operations/`)
- Handle business logic and validations
- Named as `SaveTodo`, `DeleteTodo`, `SignUpUser`, etc.
- Inherit from `Model::SaveOperation` for database operations
- Use `permit_columns` to whitelist user input
- Validations in `before_save` block

**Queries** (`src/queries/`)
- Type-safe database queries
- Automatically generated from models (e.g., `TodoQuery` from `Todo`)
- Chainable: `TodoQuery.new.completed(true).title.ilike("%search%")`

**Models** (`src/models/`)
- Simple data structures with `table do` blocks
- Define columns: `column title : String`
- No business logic - that goes in Operations

**Pages** (`src/pages/`)
- Type-safe HTML rendering using Lucky's HTML builder
- Declare dependencies via `needs`: `needs operation : SaveTodo`
- Use components for reusable UI elements

### Authentication Architecture

**Browser authentication** (session-based):
- Handled by Authentic gem
- Mixins in `src/actions/mixins/auth/`
- `Auth::RequireSignIn` - Force authentication (default for BrowserAction)
- `Auth::AllowGuests` - Allow unauthenticated access
- `Auth::RedirectSignedInUsers` - Prevent signed-in users from seeing login page

**API authentication** (JWT token-based):
- Mixins in `src/actions/mixins/api/auth/`
- Tokens stored in `user_tokens` table
- `Api::Auth::RequireAuthToken` - Force token auth (default for ApiAction)
- `Api::Auth::SkipRequireAuthToken` - Allow unauthenticated access
- Helper methods in `Api::Auth::Helpers`

### Database Configuration

Database settings in `config/database.cr`:
- Development: `crystal_todo_list_development`
- Test: `crystal_todo_list_test`
- Connections via `DATABASE_URL` environment variable (set by bin scripts)
- PostgreSQL runs in Docker, not exposed to host (container network only)

### Load Order

The `src/app.cr` file defines strict load order (critical for Crystal's compilation):
```crystal
require "./models/base_model"
require "./models/mixins/**"
require "./models/**"
require "./queries/mixins/**"
require "./queries/**"
require "./operations/mixins/**"
require "./operations/**"
```

**When creating new files**, follow this pattern:
1. Base classes first (BaseModel, BrowserAction, etc.)
2. Mixins before the classes that include them
3. Models → Queries → Operations → Actions → Pages

### File Organization

```
src/
├── actions/          # Route handlers (BrowserAction/ApiAction)
│   ├── mixins/      # Reusable action behaviors
│   ├── todos/       # Todo CRUD actions
│   └── api/         # JSON API endpoints
├── models/          # Database models
├── operations/      # Business logic & validations
├── queries/         # Type-safe DB queries
├── pages/           # HTML rendering
├── components/      # Reusable UI components
└── serializers/     # JSON serialization (for APIs)

spec/
├── requests/        # Integration tests for actions
├── flows/          # End-to-end browser tests
└── support/        # Test helpers and factories
```

## Common Development Patterns

### Creating a new resource

Lucky doesn't have a full scaffold generator. Generate files using Lucky generators:

```bash
# Generate model with migration
docker compose run --rm lucky lucky gen.model Resource title:String

# Generate browser action (HTML)
docker compose run --rm lucky lucky gen.action.browser Resources::Index

# Generate API action (JSON)
docker compose run --rm lucky lucky gen.action.api Api::Resources::Index

# Generate page
docker compose run --rm lucky lucky gen.page Resources::ShowPage

# Generate component
docker compose run --rm lucky lucky gen.component Shared::ResourceCard
```

Then create files manually:
1. **Model:** Auto-generated with `gen.model`
2. **Query:** Auto-generated from model
3. **Operation:** Create `src/operations/save_resource.cr` manually
4. **Actions:** Use `gen.action.browser` or `gen.action.api`
5. **Pages:** Use `gen.page`

### Testing patterns

**Factories** (`spec/support/factories/`):
```crystal
# Create with defaults
todo = TodoBox.create

# Create with attributes
todo = TodoBox.create &.title("Custom").completed(true)

# Build without saving
params = TodoBox.build_attributes
```

**Request specs:**
```crystal
require "../spec_helper"

describe Todos::Create do
  it "creates a todo" do
    params = TodoBox.build_attributes
    response = ApiClient.exec(Todos::Create, todo: params)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
```

**Database cleaning:**
- Automatic truncation before each test via `spec/setup/clean_database.cr`
- Tests are isolated - no manual cleanup needed

### Working with Docker

All Crystal execution happens in Docker containers:
- Source code mounted as volume (changes reflect immediately)
- `lib/` (dependencies) stored in Docker volume for performance
- Postgres data persisted in Docker volume
- Run commands via `docker compose run --rm lucky <command>`

**Common Docker commands:**
```bash
docker compose ps              # See running services
docker compose logs -f         # Follow logs
docker compose down            # Stop all services
docker compose down -v         # Stop and remove volumes (fresh start)
docker compose restart lucky   # Restart Lucky server
```

## Debugging

**In code:**
```crystal
pp some_variable      # Pretty print for debugging
Log.info { "message" } # Structured logging
```

**VSCode debugging:**
- Press F5 to start debugger
- Set breakpoints by clicking line numbers
- Use Debug Console for REPL

**Database console:**
```bash
docker compose exec postgres psql -U lucky -d crystal_todo_list_development
```

## Troubleshooting

**Port 3000 already in use:**
```bash
docker compose down
```

**Database connection errors:**
```bash
docker compose up -d postgres
docker compose ps  # Verify postgres is running
```

**Missing dependencies:**
```bash
docker compose run --rm lucky shards install
```

**VSCode language server not working:**
```bash
bin/setup-vscode
# Then: Ctrl+Shift+P → "Developer: Reload Window"
```

**Fresh start:**
```bash
docker compose down -v
bin/dev
```
