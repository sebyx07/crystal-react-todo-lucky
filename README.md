# 💎 Crystal Todo List

A modern todo list application built with [Lucky Framework](https://luckyframework.org), Crystal, and React.

## ✨ Features

- ✅ Full CRUD operations for todos
- 🔄 Mark todos as completed/pending
- 📝 Edit todos inline
- 🔐 User authentication (JWT + Sessions)
- ⚡ React 19 SPA with React Compiler optimization
- 🎨 Bootstrap 5 UI
- 🗄️ PostgreSQL database
- 🧪 Full test coverage (Frontend + Backend)
- 🐳 Docker support for development
- 🔒 Optional SSL/TLS support

## 🚀 Tech Stack

- **Backend:** Crystal 1.18.2 + Lucky Framework 1.4.0
- **Frontend:** React 19 + TypeScript + React Compiler
- **Database:** PostgreSQL 14
- **Runtime:** Bun v1.3.1 (assets & tests)
- **Styling:** Bootstrap 5 + Sass
- **Testing:** Crystal Spec + Vitest + React Testing Library

### 🛠️ Quick Start (Docker - Recommended)

All development is done via Docker Compose using the `bin/` scripts:

```bash
# Start the development server (includes database setup)
bin/dev
```

That's it! The app will be available at `http://localhost:3000` (or `https://localhost:3000` with SSL)

### 🐳 Available Commands

All scripts automatically handle Docker Compose for you:

```bash
# Development
bin/dev               # Start development server with hot reload

# Testing
bin/spec              # Run all specs (Backend + Frontend)
bin/spec spec/requests/todos/         # Run specs in directory
bin/spec spec/requests/todos/index_spec.cr  # Run specific file

# Linting & Formatting
bin/lint              # Auto-format all files (Crystal + JS/TS)
bin/lint --check      # Check formatting without modifying
```

### 🗄️ Database

PostgreSQL runs in Docker via `docker compose`:
- **Not exposed to host** (secure by default)
- **Accessed via container network only**
- Automatically managed by bin scripts

### ⚙️ Environment Configuration

The application uses `.env.development.local` for local development settings:
- APP_DOMAIN: dev-1.venom.is (for production SSL)
- PORT: 5000 (container-to-container port)
- DATABASE_URL: Automatically set by bin scripts

For SSL/TLS configuration, see [docs/ssl-setup.md](docs/ssl-setup.md)

### 🌐 API Endpoints

**Authentication:**
- `POST /api/sign_ins` - Sign in (returns JWT token)
- `POST /api/sign_ups` - Create account
- `DELETE /api/sign_ins` - Sign out

**Todos:**
- `GET /api/todos` - List todos (paginated, sorted by updated_at desc)
- `POST /api/todos` - Create a new todo
- `PATCH /api/todos/:id` - Update a todo
- `DELETE /api/todos/:id` - Delete a todo


### 💻 VSCode / code-server Setup

The project includes full VSCode/code-server configuration:

**Quick setup:**
```bash
bin/setup-vscode
```

This configures:
- ✅ Crystal language server with Docker integration
- ✅ Syntax highlighting and IntelliSense
- ✅ Format on save
- ✅ Jump to definition
- ✅ Integrated tasks (Ctrl+Shift+B to run dev server)
- ✅ Test runner (Ctrl+Shift+T)
- ✅ Debugging support

**Available tasks** (Ctrl+Shift+P → "Tasks: Run Task"):
- Run All Tests
- Run Current Test File
- Start Development Server
- Format Code
- Check Code Format
- Run Database Migrations
- Docker Compose Up/Down

**Files:**
- `.vscode/settings.json` - Crystal LSP and editor config
- `.vscode/tasks.json` - Integrated tasks
- `.vscode/launch.json` - Debug configurations
- `.vscode/extensions.json` - Recommended extensions
- `.editorconfig` - Cross-editor formatting

## 📚 Learning Resources

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
