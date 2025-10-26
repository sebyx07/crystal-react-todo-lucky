# CLAUDE.md

Keywords and critical info for building and debugging this codebase.

## Stack

**Backend:** Crystal 1.18+ | Lucky 1.4 | Avram ORM | PostgreSQL 14 | JWT auth
**Frontend:** React 19 | React Router 7 | TypeScript (services) | JSX (components) | Bootstrap 5
**Build:** Bun 1.3+ (bundler + package manager)

## Commands

```bash
bin/dev              # Lucky server (localhost:3000)
bun run dev          # Asset watcher
bin/spec             # All tests (Crystal + JS)
bin/spec --crystal   # Crystal only
bin/spec --js        # Vitest only
bin/lint             # Format + lint + typecheck
bin/lint --check     # Check only
```

## Critical Patterns

**Lucky:**
- Actions = routing | Operations = logic | Queries = DB | Models = data | Serializers = JSON
- Load order: Base → Mixins → Models → Queries → Operations → Actions → Serializers
- Static files BEFORE route handler in middleware
- API actions inherit `ApiAction` + `Api::Auth::SkipRequireAuthToken` for public

**React:**
- Services (`.ts`) = API calls | Components (`.jsx`) = UI
- JWT in localStorage, auto-added to headers via `ApiService`
- Catch-all `GET /*` serves SPA (LAST route!)
- API prefix: `/api/*` to avoid conflicts

**Operations:**
- Trim strings BEFORE validation: `title.value = title.value.to_s.strip`
- Check `operation.valid?` + record exists in update actions
- `validate_required` doesn't catch empty strings after trim

**Testing:**
- Factories: `UserFactory.create`, `TodoFactory.create`
- API specs: `ApiClient.exec(Action, params)`
- Frontend: Vitest + React Testing Library
- Integration: LuckyFlow (pending - requires browser in Docker)
- Import React in JSX for Vitest compatibility
- flow-id attributes: `flow-id="button-name"` for LuckyFlow selectors

**Build:**
- `build.js` = Bun bundler script (replaces Webpack)
- Generates `mix-manifest.json` with content hashes
- Watch mode: `bun run dev`
- SCSS deprecation warnings silenced (Bootstrap 5 legacy code)

## Gotchas

1. **Update operations**: Lucky returns record even with validation errors
   ```crystal
   if updated && operation.valid?  # Both checks!
   ```

2. **Empty validation**: `validate_required` may miss whitespace-only strings
   ```crystal
   title.value = title.value.to_s.strip  # Trim first!
   validate_required title
   ```

3. **Middleware order**: Static files BEFORE routes
   ```crystal
   Lucky::StaticFileHandler.new("./public", fallthrough: true),
   Lucky::RouteHandler.new,  # Routes AFTER static
   ```

4. **Test runner**: Use `bun run test` (Vitest), not `bun test` (Bun's runner)

5. **ESLint + Vitest**: Add React import to JSX: `import React from 'react'`

6. **TypeScript headers**: Use `Record<string, string>` not `HeadersInit` for indexing

## File Structure

```
src/
├── actions/api/       # API routes (/api/*)
├── operations/        # SaveTodo, SaveUser
├── queries/          # TodoQuery.new.user_id(id)
├── models/           # Todo, User
├── serializers/      # TodoSerializer.new(todo).render
├── pages/            # AppLayout (serves React)
├── js/
│   ├── services/     # ApiService.ts (TypeScript)
│   ├── contexts/     # AuthContext.tsx
│   ├── pages/        # Dashboard.jsx, SignIn.jsx
│   └── components/   # TodoList.jsx, TodoItem.jsx
└── css/              # app.scss (Bootstrap imports)

spec/
├── requests/api/     # API endpoint tests
├── flows/           # LuckyFlow integration tests (pending - needs browser)
├── support/flows/   # Flow helpers (TodoFlow, BaseFlow)
└── src/js/**/*.test.* # Frontend unit tests
```

## Security

- User-scoped queries: `TodoQuery.new.user_id(current_user.id)`
- JWT required by default (ApiAction)
- Skip token: `include Api::Auth::SkipRequireAuthToken`
- `permit_columns` whitelist for operations

## Debug Tips

- **Tests fail**: Check operation.valid? in action
- **Asset 404**: Rebuild with `bun run build`
- **Route conflict**: Catch-all `GET /*` must be LAST
- **Type errors**: Run `bin/lint` (includes tsc)
- **Empty validation fails**: Trim before validate
