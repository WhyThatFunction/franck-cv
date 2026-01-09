set dotenv-load := true

# Show available commands + targets
help:
  @echo "Usage:"
  @echo "  just cv [TARGET]"
  @echo "  just letter [TARGET]"
  @echo "  just all"
  @echo "  just all-letters"
  @echo "  just clean"
  @echo ""
  @echo "Targets (from entry-points/*.tex):"
  @for f in entry-points/*.tex; do \
    t="$(basename "$f" .tex)"; \
    case "$t" in _*) continue ;; esac; \
    echo "  - $t"; \
  done

# Remove build outputs/aux files
clean:
  docker compose --profile tools run --rm clean

# Build CV for a given target (defaults to test-ingenieur)
cv TARGET="test-ingenieur":
  docker compose run --rm -e TARGET={{TARGET}} cv

# Build standalone letter for a given target (defaults to test-ingenieur)
letter TARGET="test-ingenieur":
  docker compose run --rm -e TARGET={{TARGET}} letter

# Build all CVs + letters for every entry point in entry-points/
all:
  @set -eu
  @for f in entry-points/*.tex; do \
    t="$(basename "$f" .tex)"; \
    case "$t" in _*) continue ;; esac; \
    echo "== CV: $t =="; \
    docker compose run --rm -e TARGET="$t" cv; \
  done

# Build standalone letters for every entry point in entry-points/
all-letters:
  @set -eu
  @for f in entry-points/*.tex; do \
    t="$(basename "$f" .tex)"; \
    case "$t" in _*) continue ;; esac; \
    echo "== LETTER: $t =="; \
    docker compose run --rm -e TARGET="$t" letter; \
  done
