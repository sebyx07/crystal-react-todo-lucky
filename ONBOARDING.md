# New Developer Onboarding

Welcome to the Crystal Todo List project! This guide will help you get up and running in under 10 minutes.

## Prerequisites

Before you start, make sure you have:

- **Docker** and **Docker Compose** installed
  - [Install Docker](https://docs.docker.com/get-docker/)
  - Docker Compose is included with Docker Desktop
- **Git** installed
- **VSCode** or **code-server** (optional, but recommended)
  - [Download VSCode](https://code.visualstudio.com/)

That's it! You don't need Crystal, PostgreSQL, or Node.js installed locally - everything runs in Docker.

## Step 1: Clone the Repository

```bash
git clone <repository-url>
cd crystal_todo_list
```

## Step 2: Start the Development Server

```bash
./bin/dev
```

This single command will:
- ✅ Pull and start the PostgreSQL container
- ✅ Install all dependencies (shards, npm packages)
- ✅ Create and migrate the development database
- ✅ Start the Lucky development server with hot reloading

Wait for this message:
```
🚀 Starting Lucky development server...
   Server will be available at http://localhost:3000
```

Open your browser to **http://localhost:3000** - you should see the todo app!

## Step 3: Run Tests

In a new terminal:

```bash
./bin/spec
```

Expected output:
```
21 examples, 0 failures, 0 errors, 3 pending
```

Congratulations! Your development environment is working.

## Step 4: VSCode Setup (Recommended)

If using VSCode or code-server:

```bash
./bin/setup-vscode
```

Then:
1. Open the project in VSCode
2. When prompted to install recommended extensions, click "Install All"
3. Reload the window (Ctrl+Shift+P → "Developer: Reload Window")

You now have:
- ✅ Crystal syntax highlighting
- ✅ IntelliSense (autocomplete)
- ✅ Jump to definition (Ctrl+Click)
- ✅ Format on save
- ✅ Integrated tasks
- ✅ Debugging support

### Quick VSCode Tasks

- **Ctrl+Shift+B** - Start development server
- **Ctrl+Shift+T** - Run all tests
- **Ctrl+Shift+P** → "Tasks: Run Task" - See all available tasks

## Project Overview

### What We're Building

A todo list application with:
- ✅ Create, read, update, delete todos
- ✅ Mark todos as completed/pending
- ✅ PostgreSQL database
- ✅ Full test coverage
- ✅ RESTful API

### Tech Stack

- **Language**: [Crystal](https://crystal-lang.org/) (like Ruby, but compiled and type-safe)
- **Framework**: [Lucky](https://luckyframework.org/) (Rails-like web framework)
- **Database**: PostgreSQL
- **ORM**: [Avram](https://luckyframework.org/guides/database/intro-to-avram-and-orms)
- **Testing**: Crystal Spec (RSpec-style)
- **Container**: Docker & Docker Compose

## Development Workflow

### Making Changes

1. **Edit code** - All source files are in `src/`
2. **See changes immediately** - Hot reloading is enabled
3. **Run tests** - `./bin/spec`
4. **Format code** - `./bin/lint` (auto-runs in VSCode)

### Common Commands

```bash
# Development
./bin/dev                    # Start dev server
./bin/spec                   # Run all tests
./bin/spec spec/requests/todos/  # Run specific tests
./bin/lint                   # Format code
./bin/lint --check           # Check formatting

# Docker
docker compose ps            # See running containers
docker compose logs -f       # View logs
docker compose down          # Stop all services
docker compose down -v       # Stop and remove volumes (fresh start)

# Database
docker compose exec postgres psql -U lucky -d crystal_todo_list_development
```

## Project Structure

```
crystal_todo_list/
├── bin/                    # Development scripts (run these!)
│   ├── dev                 # Start development server
│   ├── spec                # Run tests
│   ├── lint                # Format code
│   └── setup-vscode        # Configure VSCode
│
├── src/                    # Application source code
│   ├── actions/            # Controllers (handle requests)
│   │   ├── todos/          # Todo CRUD actions
│   │   └── home/           # Home page
│   ├── models/             # Database models
│   │   └── todo.cr         # Todo model
│   ├── operations/         # Save/update logic
│   │   └── save_todo.cr    # Todo save operation
│   ├── queries/            # Database queries
│   │   └── todo_query.cr   # Todo query helpers
│   └── pages/              # HTML views
│       └── todos/          # Todo page templates
│
├── spec/                   # Tests
│   ├── requests/           # Request specs (controller tests)
│   │   └── todos/          # Todo endpoint tests
│   └── support/            # Test helpers
│       └── factories/      # Test data factories
│
├── config/                 # Configuration
│   ├── database.cr         # Database connection
│   ├── server.cr           # Server settings
│   └── route_helper.cr     # URL generation
│
├── db/migrations/          # Database migrations
│
├── .vscode/                # VSCode configuration
│   ├── settings.json       # Editor settings
│   ├── tasks.json          # Integrated tasks
│   └── launch.json         # Debug config
│
└── docker-compose.yml      # Docker services
```

## Your First Feature

Let's add a "priority" field to todos!

### 1. Create a Migration

```bash
docker compose run --rm lucky lucky gen.migration AddPriorityToTodos
```

Edit the generated file in `db/migrations/`:

```crystal
def migrate
  alter table_for(Todo) do
    add priority : String, default: "normal"
  end
end

def rollback
  alter table_for(Todo) do
    remove :priority
  end
end
```

Run it:
```bash
docker compose run --rm -e DATABASE_URL=postgres://lucky:password@postgres:5432/crystal_todo_list_development lucky lucky db.migrate
```

### 2. Update the Model

Edit `src/models/todo.cr`:

```crystal
class Todo < BaseModel
  table do
    column title : String
    column completed : Bool
    column priority : String  # Add this line
  end
end
```

### 3. Update the Operation

Edit `src/operations/save_todo.cr`:

```crystal
permit_columns title, completed, priority  # Add priority
```

### 4. Run Tests

```bash
./bin/spec
```

That's it! You've added a new feature.

## Common Issues

### Port 3000 is already in use

```bash
# Stop the development server
docker compose down

# Or change the port in docker-compose.yml
```

### Database connection errors

```bash
# Ensure PostgreSQL is running
docker compose up -d postgres

# Check status
docker compose ps
```

### "Can't find file" errors

```bash
# Reinstall dependencies
docker compose run --rm lucky shards install
```

### VSCode language server not working

```bash
# Run setup again
./bin/setup-vscode

# Reload VSCode
# Ctrl+Shift+P → "Developer: Reload Window"
```

### Fresh start needed

```bash
# Remove everything and start over
docker compose down -v
./bin/dev
```

## Learning Resources

### Crystal Language
- [Crystal Docs](https://crystal-lang.org/reference/) - Official language reference
- [Crystal for Rubyists](https://crystal-lang.org/reference/crystal_for_rubyists/) - If you know Ruby

### Lucky Framework
- [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky) - Framework documentation
- [Avram ORM Guide](https://luckyframework.org/guides/database/intro-to-avram-and-orms) - Database/ORM
- [Lucky Actions](https://luckyframework.org/guides/http-and-routing/http-handlers) - Routing and controllers

### Project-Specific
- `DEVELOPMENT.md` - Detailed development guide
- `README.md` - Project overview
- Code comments - We try to explain tricky parts

## Getting Help

- Ask in team chat/Slack
- Check existing issues in the repository
- Read the [Lucky Framework](https://luckyframework.org/guides) guides
- Crystal community: [Crystal Forum](https://forum.crystal-lang.org/)

## Next Steps

Now that you're set up:

1. **Explore the codebase** - Start with `src/actions/todos/index.cr`
2. **Run the tests** - Understand how tests work
3. **Make a small change** - Try modifying a page template
4. **Read DEVELOPMENT.md** - Deeper dive into development workflow
5. **Pick up a ticket** - Start contributing!

Welcome aboard! 🚀
