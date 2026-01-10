# franck-cv

Modular LaTeX CV + cover-letter setup, compiled via Docker Compose (XeLaTeX via `latexmk -xelatex` for `fontspec` fonts).

## Requirements

- Docker + Docker Compose v2 (`docker compose`)
- Optional: `just` (command runner) to use the `justfile`

## Build

Recommended (target-based):

- CV: `TARGET=<name> docker compose run --rm cv`
- Letter: `TARGET=<name> docker compose run --rm letter`

Using `just` (shorter commands):

- CV: `just cv <name>` (defaults to `test-ingenieur` if omitted)
- Letter: `just letter <name>` (defaults to `test-ingenieur` if omitted)
- Build all CV targets: `just all`
- Build all standalone letters: `just all-letters`
- List commands + available targets: `just help`
- Clean build outputs: `just clean`

## Justfile usage

The `justfile` is a small command runner wrapper around Docker Compose.

- Discover available targets: `just help`
- Build a CV: `just cv test-ingenieur`
- Build a standalone letter: `just letter test-ingenieur`
- Build everything (CVs): `just all`
- Build everything (letters): `just all-letters`
- Clean: `just clean`

Convenience services (fixed target `test-ingenieur`):

- CV (with appended letter): `docker compose run --rm test-ingenieur`
- Standalone letter: `docker compose run --rm letter-test-ingenieur`

Outputs go to `build/` (e.g. `build/test-ingenieur.pdf`).
Standalone letters go to `build/letters/` (e.g. `build/letters/test-ingenieur.pdf`).
The Docker container mounts the repo read-only and `build/` read-write (see `compose.yml`).

Clean aux/output files:

- `docker compose --profile tools run --rm clean`

## Structure

- `entry-points/`: CV entry points (one `.tex` per target), usually thin wrappers that set:
  - `\CVBasename` (used to locate the matching letter body)
  - `\CVName`
  - `\CVRole` (role only; the header subtitle auto-prefixes with `Mechatronikingenieur (B.Sc.) |`)
  - then `\input{entry-points/_cv-template.tex}`
- `letters/`: standalone letter entry points (thin wrappers), usually set `\CVBasename` / `\CVRole` then `\input{letters/_letter-template.tex}`
- `libs/`: shared style + content
  - `libs/main.tex`: styling + fonts (Roboto body, Montserrat headings)
  - `libs/sections/*.tex`: CV sections
  - `libs/letters/*.tex`: letter bodies (reused by appended + standalone letters)

## Optional photo

Put a headshot at `images/profile.jpg`. If it’s missing, it’s skipped.

## Add a new target

Keep `<name>` identical across entry points so the pairing works.

1. Create `entry-points/<name>.tex` (sets macros, inputs `entry-points/_cv-template.tex`)
2. Create shared letter body `libs/letters/<name>.tex` (can start with `\input{libs/letters/_generic.tex}`)
3. Create standalone wrapper `letters/<name>.tex` (sets macros, inputs `letters/_letter-template.tex`)
4. Build: `TARGET=<name> docker compose run --rm cv` and `TARGET=<name> docker compose run --rm letter`
