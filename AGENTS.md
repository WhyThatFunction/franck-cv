# AGENTS.md

This repo is a modular LaTeX CV + cover-letter setup, compiled via Docker Compose.

## Build

- Build CV (and appended letter): `docker compose run --rm test-ingenieur`
- Build standalone letter: `docker compose run --rm letter-test-ingenieur`
- Build any CV by target (recommended): `TARGET=<name> docker compose run --rm cv`
- Build any letter by target (recommended): `TARGET=<name> docker compose run --rm letter`
- Build via `justfile` (optional): `just cv <name>` and `just letter <name>`
- Build all targets via `justfile`: `just all`
- Build all standalone letters via `justfile`: `just all-letters`
- Discover commands/targets: `just help`
- Clean build outputs: `just clean`
- Outputs:
  - CV: `build/<name>.pdf` (e.g. `build/test-ingenieur.pdf`)
  - Standalone letter: `build/letters/<name>.pdf` (e.g. `build/letters/test-ingenieur.pdf`)

Notes:
- Build uses **XeLaTeX** (`latexmk -xelatex`) because fonts are configured via `fontspec`.
- The Docker container mounts the repo read-only and `build/` read-write (see `compose.yml`).

## Structure (modular entry points)

- `entry-points/`
  - CV entry points (one `.tex` per category). Example: `entry-points/test-ingenieur.tex`.
  - Most entry points are thin files that set a few macros and then load `entry-points/_cv-template.tex`.
  - Template macros:
    - `\\CVBasename` (used to locate matching letter body)
    - `\\CVName`
    - `\\CVRole` (role only; the header subtitle auto-prefixes with `Mechatronikingenieur (B.Sc.) |`)
    - optional `\\CVTitlePrefix` to override the default prefix

- `libs/`
  - Shared style and macros: `libs/main.tex`
  - Reusable content blocks:
    - `libs/sections/*.tex` (CV sections)
    - `libs/letters/*.tex` (letter bodies)

- `letters/`
  - Standalone letter entry points (thin wrappers).
  - Most wrappers set `\\CVBasename` / `\\CVRole` and then load `letters/_letter-template.tex`.
  - **Naming convention**: for a given CV entry point `entry-points/<name>.tex`, the standalone letter must be `letters/<name>.tex` (same `<name>`).

## Layout conventions

Current `entry-points/test-ingenieur.tex` layout:

- Top of document: name (first line) and title (second line).
- Two-column body via `paracol`:
  - Left column (sidebar): optional photo + contact + profile + bar skills + languages + other.
  - Right column: experience + education + projects.
- After the columns (full width): long ATS-friendly skills enumeration (`libs/sections/skills-enum.tex`).
- New page: appended cover letter body (`libs/letters/test-ingenieur.tex`).

Optional photo:
- Place a headshot at `images/profile.jpg`. If missing, it’s skipped.

## Fonts and styling

Defined in `libs/main.tex`:
- Body font: `Roboto`
- Heading font (bold): `Montserrat` (SemiBold/ExtraBold)

If you change fonts, keep XeLaTeX enabled in `compose.yml`.

## Section patterns (keep spacing tight)

- Use `\resumeentry{<dates>}{<org/location>}{<role>}` for entries (experience/education/projects).
- Follow entries with `\begin{cvbullets} ... \end{cvbullets}`.
- Spacing is intentionally minimized:
  - `\resumeentry` suppresses extra gap before the following list.
  - `cvbullets` uses `topsep=0pt` to avoid extra vertical padding.

## Where to edit content

- Profile text: `libs/sections/profile.tex`
- Contact block (sidebar): `libs/sections/contact.tex`
- Sidebar bar skills: `libs/sections/skills.tex`
- Main sections:
  - Experience: `libs/sections/experience.tex`
  - Education: `libs/sections/education.tex`
  - Projects: `libs/sections/projects.tex`
- Long “ATS density” skills list: `libs/sections/skills-enum.tex`
- Letter body (reused by both CV append and standalone letter): `libs/letters/test-ingenieur.tex`
- Standalone letter wrapper: `letters/test-ingenieur.tex`

## Adding a new category (new CV + matching letter)

1. Create a CV entry point: `entry-points/<name>.tex` that sets `\\CVBasename`, `\\CVName`, `\\CVRole` and then `\\input{entry-points/_cv-template.tex}`.
2. Create the shared letter body: `libs/letters/<name>.tex` (you can start with `\\input{libs/letters/_generic.tex}`).
3. Create the standalone letter wrapper: `letters/<name>.tex` that sets `\\CVBasename`, `\\CVRole` and then `\\input{letters/_letter-template.tex}`.
4. Option A (preferred): build with `TARGET=<name> docker compose run --rm cv` and `TARGET=<name> docker compose run --rm letter`.
5. Option B: add dedicated services to `compose.yml` if you want fixed names.

Keep `<name>` identical across `entry-points/` and `letters/` to preserve the pairing convention.
