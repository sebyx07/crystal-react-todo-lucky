# Development Guide

This guide covers development workflow, testing, and VSCode setup for the Crystal Todo List application.

## Prerequisites

- Docker and Docker Compose
- VSCode or code-server (optional, for IDE features)

## Quick Start

```bash
# Start development server
bin/dev

# Run tests
bin/spec

# Format code
bin/lint
```

## Development Scripts

All development is done through containerized bash scripts in `bin/`:

### `bin/dev`
Starts the full development environment:
- Starts PostgreSQL in Docker
- Creates/migrates development database
- Starts Lucky development server with hot reloading
- Available at http://localhost:3000

### `bin/spec [path]`
Runs specs in Docker container:
```bash
bin/spec                              # Run all specs
bin/spec spec/requests/todos/         # Run directory
bin/spec spec/requests/todos/index_spec.cr  # Run specific file
```

Features:
- Automatic PostgreSQL setup
- Automatic test database creation
- Automatic shard installation
- Database truncation before each test

### `bin/lint [--check]`
Format Crystal code using `crystal tool format`:
```bash
bin/lint          # Auto-format all files (default)
bin/lint --check  # Check only, no modifications
```

## VSCode / code-server Integration

### Setup
```bash
bin/setup-vscode
```

This installs recommended extensions and configures Crystal language features.

### Features

**Language Server:**
- Type information on hover
- Jump to definition (Ctrl+Click)
- Auto-completion
- Real-time error checking
- Format on save

**Integrated Tasks** (Ctrl+Shift+P → "Tasks"):
- `Ctrl+Shift+B` - Start Development Server
- `Ctrl+Shift+T` - Run All Tests
- Run Current Test File
- Format Code
- Database Migrations

**Debugging:**
- F5 to start debugging
- Breakpoint support
- Variable inspection

### Configuration Files

- `.vscode/settings.json` - Crystal LSP, formatter, editor settings
- `.vscode/tasks.json` - Integrated tasks for common operations
- `.vscode/launch.json` - Debug configurations
- `.vscode/extensions.json` - Recommended extensions
- `.editorconfig` - Cross-editor formatting rules

## Database

PostgreSQL runs in Docker:
- **Not exposed to host** (secure by default)
- Accessed only via Docker internal network
- Automatic setup via bin scripts
- Truncated before each test

### Manual Database Operations

```bash
# Run migrations
docker compose run --rm \
  -e DATABASE_URL=postgres://lucky:password@postgres:5432/crystal_todo_list_development \
  lucky lucky db.migrate

# Create migration
docker compose run --rm lucky lucky gen.migration CreateSomething

# Access PostgreSQL console
docker compose exec postgres psql -U lucky -d crystal_todo_list_development
```

## Testing

### Test Structure

```
spec/
├── requests/          # Request specs (API/controller tests)
│   ├── todos/         # Todo CRUD specs
│   ├── authentication_spec.cr
│   └── api/           # API endpoint specs
├── flows/             # Browser flow specs (pending - LuckyFlow issues)
├── support/           # Test helpers
│   └── factories/     # Test data factories
└── setup/             # Test setup (DB cleaning, etc)
```

### Writing Tests

```crystal
require "../spec_helper"

describe Todos::Create do
  it "creates a todo with valid params" do
    params = {
      "title" => "New todo",
      "completed" => "false"
    }

    client = ApiClient.new
    response = client.exec(Todos::Create, todo: params)

    response.status.should eq(HTTP::Status::FOUND)
    TodoQuery.new.select_count.should eq 1
  end
end
```

### Test Helpers

**Factories:**
```crystal
# Create todo with defaults
todo = TodoFactory.create

# Create with custom attributes
todo = TodoFactory.create &.title("Custom").completed(true)

# Create user
user = UserFactory.create &.email("test@example.com")
```

**Database Cleaning:**
- Automatic truncation before each test via `Spec.before_each`
- Ensures test isolation
- No need for manual cleanup

## Code Quality

### Linting/Formatting

Crystal has a built-in formatter:
```bash
bin/lint          # Auto-format
bin/lint --check  # Check only
```

Format is enforced by:
- `crystal tool format` in bin/lint
- VSCode format-on-save
- `.editorconfig` rules

### Best Practices

1. **Format on save** - Enabled in VSCode settings
2. **Run tests before commit** - `bin/spec`
3. **Use factories** - Don't create records manually in tests
4. **Keep specs fast** - Use request specs over browser specs
5. **Use explicit types** - Helps with IDE features

## Debugging

### In VSCode
1. Set breakpoints in code
2. Press F5
3. Use Debug Console for REPL

### Manual Debugging
```crystal
# Add to code
pp some_variable  # Pretty print
debugger         # REPL breakpoint (requires -d flag)
```

### Logging
```crystal
Log.info { "Something happened" }
Log.debug { "Debug info" }
Log.error { "Error occurred" }
```

## Common Tasks

### Generate Resources

```bash
# Generate model with migration
docker compose run --rm lucky lucky gen.model Post title:String

# Generate action
docker compose run --rm lucky lucky gen.action.browser Posts::Index

# Generate migration
docker compose run --rm lucky lucky gen.migration AddFieldToUsers
```

### Docker Management

```bash
# View logs
docker compose logs -f

# Restart services
docker compose restart

# Stop all services
docker compose down

# Remove volumes (fresh start)
docker compose down -v
```

## Troubleshooting

### "Can't find file" errors
```bash
# Reinstall shards in container
docker compose run --rm lucky shards install
```

### Database connection errors
```bash
# Ensure postgres is running
docker compose up -d postgres

# Check if running
docker compose ps
```

### Port already in use
```bash
# Stop existing services
docker compose down

# Or change port in docker-compose.yml
```

### VSCode language server not working
```bash
# Run setup again
bin/setup-vscode

# Reload VSCode window
# Ctrl+Shift+P → "Developer: Reload Window"
```

## Project Structure

```
crystal_todo_list/
├── bin/                    # Development scripts
│   ├── dev                 # Start dev server
│   ├── spec                # Run tests
│   ├── lint                # Format code
│   └── setup-vscode        # VSCode setup
├── config/                 # App configuration
├── db/migrations/          # Database migrations
├── docker/                 # Docker configuration
├── spec/                   # Tests
├── src/                    # Application code
│   ├── actions/            # Controllers/Actions
│   ├── models/             # Database models
│   ├── operations/         # Save operations
│   ├── queries/            # Database queries
│   └── pages/              # HTML pages
├── .vscode/                # VSCode configuration
├── docker-compose.yml      # Docker services
└── shard.yml               # Dependencies
```

## Resources

- [Lucky Framework Guides](https://luckyframework.org/guides)
- [Crystal Language Docs](https://crystal-lang.org/reference/)
- [Avram ORM Guide](https://luckyframework.org/guides/database/intro-to-avram-and-orms)
