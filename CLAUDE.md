# CLAUDE.md

Guidance for Claude Code when working with this repository.

## Tech Stack

**Backend:**
- **Crystal** (>= 1.18.2) + **Lucky Framework** (~> 1.4.0)
- **Avram** (~> 1.4.0) - ORM
- **Authentic** (>= 1.0.2) - Auth
- **PostgreSQL 14**

**Frontend:**
- **React 19** with **React Router 7** - SPA framework
- **TypeScript** - Service classes
- **JavaScript** - Components (JSX)
- **Bootstrap 5** - UI styling
- **Bun v1.3.1** - Bundling and package management

## Commands

```bash
bin/dev            # Start Lucky server (http://localhost:3000)
bun run dev        # Watch and rebuild React/CSS assets
bin/spec           # Run all tests
bin/lint           # Format Crystal + lint/fix JS/TS
bin/lint --check   # Check formatting without modifying
bun run build      # Build assets once
bun run lint       # Lint JS/TS only
```

**Docker only** - Use `bin/` scripts or `docker compose run --rm lucky <command>`

**Development:** Run both `bin/dev` (Lucky server) and `bun run dev` (asset watcher) in separate terminals

## Principles

- **SOLID** - Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **TDD** - Write tests first, red-green-refactor
- **Lucky patterns** - Actions (routing), Operations (business logic), Queries (DB), Models (data), Pages (HTML)

## Architecture

**Backend (Lucky):**
- **Actions**: HTTP routing (`ApiAction` for JSON APIs)
- **Operations**: Business logic (e.g., `SaveTodo`)
- **Queries**: Database access (chainable, type-safe)
- **Models**: Data structures only
- **Serializers**: JSON response formatting

**Frontend (React SPA):**
- **Pages**: Top-level route components (`Dashboard`, `SignIn`, `SignUp`)
- **Components**: Reusable UI (`TodoList`, `TodoItem`, `TodoForm`)
- **Services**: API communication (`ApiService.ts` - TypeScript)
- **Contexts**: Global state (`AuthContext` - JWT auth)

**Authentication:**
- Backend: JWT tokens via `ApiAction` (requires token header)
- Frontend: JWT stored in localStorage, auto-added to requests
- Use `Api::Auth::SkipRequireAuthToken` for public API endpoints

**Routing:**
- Backend: Catch-all route `GET /*` serves React SPA
- Frontend: React Router handles client-side routing
- API endpoints: `/api/*` prefix (e.g., `/api/todos`)

**Load order:** Base → Mixins → Models → Queries → Operations → Actions → Serializers

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

**Backend:**
- Routes defined in actions: `post "/api/todos"`, `get "/api/todos/:id"`
- Operations inherit `Model::SaveOperation` for saves
- Use `permit_columns` to allow user input
- Validations in `before_save` blocks
- **Important**: Check `operation.valid?` in update actions, not just if record exists
- Always trim string inputs before validation
- User-scope queries: `TodoQuery.new.user_id(current_user.id)` for security

**Frontend:**
- API calls via `apiService` singleton (TypeScript)
- Protected routes use `<ProtectedRoute>` wrapper
- Components use `.jsx`, services use `.ts`
- Bootstrap classes for styling

## Generators

```bash
docker compose run --rm lucky lucky gen.model Todo title:String
docker compose run --rm lucky lucky gen.action.browser Todos::Index
docker compose run --rm lucky lucky gen.migration AddFieldToTable
```

## Important Learnings

**Lucky/Avram Gotchas:**
- `validate_required` checks for nil but may not catch empty strings in all cases
- In update operations, Lucky can return a record even with validation errors
- Always check `operation.valid?` along with the returned record in API actions:
  ```crystal
  if updated_record && operation.valid?  # Both checks needed!
  ```
- Trim string attributes before validation to catch whitespace-only inputs
- Static files must be served BEFORE route handler in middleware order

**React + Lucky Integration:**
- Single `GET /*` route serves React SPA (must be last route)
- All API routes use `/api/*` prefix to avoid conflicts
- JWT token in `Authorization: Bearer <token>` header
- React components in `src/js/`, styles in `src/css/`
- Bun native bundler (no Webpack/Laravel Mix needed)
- Manifest file (`mix-manifest.json`) required for asset versioning

## Resources

- [Lucky Docs](https://luckyframework.org/guides/)
- [Avram Validations](https://luckyframework.org/guides/database/callbacks-and-validations)
- [docs/ssl-setup.md](docs/ssl-setup.md) - SSL config
