# CLAUDE.md

Guidance for Claude Code when working with this repository.

## Tech Stack

- **Crystal** (>= 1.18.2) + **Lucky Framework** (~> 1.4.0)
- **Avram** (~> 1.4.0) - ORM
- **Authentic** (>= 1.0.2) - Auth
- **PostgreSQL 14**
- **Bun v1.3.1** - Assets

## Commands

```bash
bin/dev        # Start server (https://localhost:3000 or http://localhost:3000)
bin/spec       # Run tests
bin/lint       # Format code
```

**Docker only** - Use `bin/` scripts or `docker compose run --rm lucky <command>`

## Principles

- **SOLID** - Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **TDD** - Write tests first, red-green-refactor
- **Lucky patterns** - Actions (routing), Operations (business logic), Queries (DB), Models (data), Pages (HTML)

## Architecture

**Separation of concerns:**
- Actions: HTTP only (`BrowserAction` or `ApiAction`)
- Operations: Business logic only (e.g., `SaveTodo`)
- Queries: Database access only (chainable, type-safe)
- Models: Data structures only (no logic)
- Pages: HTML rendering only

**Authentication:**
- `BrowserAction` - Session/cookies, requires sign-in (use `Auth::AllowGuests` for public)
- `ApiAction` - JWT tokens, requires token (use `Api::Auth::SkipRequireAuthToken` for public)

**Load order:** Base → Mixins → Models → Queries → Operations → Actions → Pages

## SSL/HTTPS

Optional SSL via `docker-compose.override.yml`:
1. Copy `docker-compose.override.yml.example` → `docker-compose.override.yml`
2. Set `SSL_ENABLED=true`, `SSL_CERT_PATH`, `SSL_KEY_PATH`
3. Port 3000 serves HTTPS (if enabled) or HTTP

See [docs/ssl-setup.md](docs/ssl-setup.md)

## Testing

- Factories: `TodoFactory.create`, `UserFactory.create`
- Request specs: `ApiClient.exec(Action, params)`
- Database auto-cleaned per test

## File Structure

```
src/
├── actions/          # HTTP routing
├── operations/       # Business logic
├── queries/          # Database
├── models/          # Data
├── pages/           # HTML
└── components/      # Reusable UI
```

## Key Conventions

- Routes defined in actions: `post "/todos"`, `get "/todos/:id"`
- Operations inherit `Model::SaveOperation` for saves
- Use `permit_columns` for user input
- Validations in `before_save` blocks

## Generators

```bash
docker compose run --rm lucky lucky gen.model Todo title:String
docker compose run --rm lucky lucky gen.action.browser Todos::Index
docker compose run --rm lucky lucky gen.migration AddFieldToTable
```

## Resources

- [Lucky Docs](https://luckyframework.org/guides/)
- [docs/ssl-setup.md](docs/ssl-setup.md) - SSL config
