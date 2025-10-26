FROM crystallang/crystal:1.18.2

# Install utilities required to make this Dockerfile run
RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    rm -rf /var/lib/apt/lists/*

# Apt installs:
# - Postgres cli tools are required for lucky-cli.
# - tmux is required for the Overmind process manager.
RUN apt-get update && \
    apt-get install -y postgresql-client tmux && \
    rm -rf /var/lib/apt/lists/*

# Install Bun 1.3.1
RUN curl -fsSL https://bun.sh/install | bash -s "bun-v1.3.1"
ENV PATH="/root/.bun/bin:${PATH}"

# Install Mix globally using Bun
RUN bun install -g mix

# Install lucky cli
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.4.1 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 3000
EXPOSE 3001

