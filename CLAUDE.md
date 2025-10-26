# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Technology Stack

**Lucky Framework** web app built with **Crystal** (>= 1.18.2)
- Lucky Framework (~> 1.4.0) - Web framework
- Avram (~> 1.4.0) - Database ORM
- Authentic (>= 1.0.2) - Authentication
- PostgreSQL 14 - Database
- Bun v1.3.1 - JavaScript/asset bundler

## Quick Start

```bash
bin/dev        # Start server (http://localhost:3000 or https://localhost:3000 if SSL enabled)
bin/spec       # Run tests
bin/lint       # Format code
```

**All development happens in Docker.** Never run Crystal/Lucky commands directly - use `bin/` scripts or `docker compose run --rm lucky <command>`.

## Coding Standards

### SOLID Principles

This project strictly follows **SOLID** principles:

- **Single Responsibility** - Each class has one reason to change
  - Actions: Handle HTTP only
  - Operations: Business logic only
  - Models: Data structure only
  - Queries: Database access only

- **Open/Closed** - Use mixins and inheritance, not modification
  - Example: `include Auth::AllowGuests` to extend behavior

- **Liskov Substitution** - Subtypes are interchangeable
  - All Actions inherit from `BrowserAction` or `ApiAction`

- **Interface Segregation** - Small, focused interfaces
  - Separate `BrowserAction` and `ApiAction` for different needs

- **Dependency Inversion** - Depend on abstractions
  - Operations receive dependencies, don't create them

### Test-Driven Development (TDD)

**Write tests first**, then implementation:

1. Write failing test in `spec/requests/` or `spec/`
2. Write minimal code to pass
3. Refactor while keeping tests green

**Test structure:**
- Use factories for test data (`TodoFactory.create`)
- Request specs test full stack (routing → action → operation → database)
- Keep tests fast - database auto-cleaned between tests

### Lucky Conventions

- **Actions** - HTTP routing only, inherit from `BrowserAction` or `ApiAction`
- **Operations** - Business logic and validations (e.g., `SaveTodo`, `DeleteUser`)
- **Queries** - Type-safe database queries, chainable
- **Models** - Data structures only, no business logic
- **Pages** - Type-safe HTML rendering

**Key conventions:**
- Actions define routes inline: `post "/todos"`, `get "/todos/:id"`
- Operations inherit from `Model::SaveOperation` for DB saves
- Use `permit_columns` to whitelist user input
- Validations go in `before_save` blocks

See [docs/architecture.md](docs/architecture.md) for details.

## Authentication

- **BrowserAction** - Session-based (cookies), requires sign-in by default
  - Allow guests: `include Auth::AllowGuests`
- **ApiAction** - JWT bearer tokens, requires token by default
  - Skip auth: `include Api::Auth::SkipRequireAuthToken`

See [docs/authentication.md](docs/authentication.md) for details.

## SSL/HTTPS Configuration

Development supports optional SSL/TLS:

1. Copy `docker-compose.override.yml.example` to `docker-compose.override.yml`
2. Uncomment and configure SSL settings
3. Server runs on port 3000 (HTTPS if enabled, HTTP otherwise)

See [docs/ssl-setup.md](docs/ssl-setup.md) for details.

## Common Tasks

**Generate files:**
```bash
docker compose run --rm lucky lucky gen.model Resource title:String
docker compose run --rm lucky lucky gen.action.browser Resources::Index
docker compose run --rm lucky lucky gen.migration AddFieldToTable
```

**Database:**
```bash
docker compose run --rm lucky lucky db.migrate
docker compose run --rm lucky lucky db.rollback
```

**Testing:**
- Factories in `spec/support/factories/` - Use `TodoFactory.create` or `UserFactory.create`
- Request specs in `spec/requests/` - Use `ApiClient.exec(Action, params)`
- Database auto-cleaned before each test

See [docs/development.md](docs/development.md) for complete guide.

## File Organization

```
src/
├── actions/          # HTTP routing (BrowserAction/ApiAction)
├── operations/       # Business logic & validations
├── queries/          # Type-safe DB queries
├── models/          # Data structures
├── pages/           # HTML rendering
└── components/      # Reusable UI

spec/
├── requests/        # Integration tests
├── flows/          # End-to-end browser tests
└── support/        # Factories and helpers
```

## Load Order

Crystal requires strict load order (see `src/app.cr`):
1. Base classes first
2. Mixins before classes that include them
3. Models → Queries → Operations → Actions → Pages

## Resources

- [Lucky Framework Docs](https://luckyframework.org/guides/)
- [docs/architecture.md](docs/architecture.md) - Architecture patterns
- [docs/authentication.md](docs/authentication.md) - Auth setup
- [docs/development.md](docs/development.md) - Development guide
- [docs/ssl-setup.md](docs/ssl-setup.md) - SSL/HTTPS configuration
