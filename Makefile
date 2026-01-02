init:
\tgit submodule update --init --recursive

up:
\tdocker compose -f docker-compose.dev.yml up -d --build

down:
\tdocker compose -f docker-compose.dev.yml down

logs:
\tdocker compose -f docker-compose.dev.yml logs -f --tail=200

status:
\tdocker compose -f docker-compose.dev.yml ps
