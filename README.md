# Crystal Todo List

A todo list application built with [Lucky Framework](https://luckyframework.org) and Crystal programming language.

## Features

- Create, Read, Update, and Delete (CRUD) todos
- Mark todos as completed/pending
- PostgreSQL database
- Full test coverage with specs
- Docker support for development

### Setting up the project

1. [Install required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies)
1. Update database settings in `config/database.cr`
1. Run `script/setup`
1. Run `lucky dev` to start the app

### Using Docker for development (Recommended)

All development and testing is done via Docker Compose for consistency.

**Start development server:**
```bash
bin/dev
```
The app will be available at `http://localhost:3000`

**Run tests:**
```bash
bin/spec                              # Run all specs
bin/spec spec/requests/todos/         # Run specs in directory
bin/spec spec/requests/todos/index_spec.cr  # Run specific file
```

**Format code:**
```bash
bin/lint              # Auto-format all Crystal files
bin/lint --check      # Check formatting without modifying
```

### Database

PostgreSQL runs in Docker via `docker compose`:
- **Not exposed to host** (secure by default)
- **Accessed via container network only**
- Automatically managed by bin scripts

### Environment Configuration

The application uses `.env.development.local` for local development settings:
- APP_DOMAIN: dev-1.venom.is (for production SSL)
- PORT: 5000 (container-to-container port)
- DATABASE_URL: Automatically set by bin scripts

### API Endpoints

- `GET /` - Redirects to todos list
- `GET /todos` - List all todos
- `GET /todos/new` - New todo form
- `POST /todos` - Create a new todo
- `GET /todos/:id` - Show a specific todo
- `GET /todos/:id/edit` - Edit todo form
- `PATCH /todos/:id` - Update a todo
- `DELETE /todos/:id` - Delete a todo


### VSCode / code-server Setup

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

### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
