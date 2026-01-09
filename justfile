set dotenv-load := true

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
    t="$$(basename "$$f" .tex)"; \
    case "$$t" in _*) continue ;; esac; \
    echo "== CV: $$t =="; \
    docker compose run --rm -e TARGET="$$t" cv; \
  done

# Build standalone letters for every entry point in entry-points/
all-letters:
  @set -eu
  @for f in entry-points/*.tex; do \
    t="$$(basename "$$f" .tex)"; \
    case "$$t" in _*) continue ;; esac; \
    echo "== LETTER: $$t =="; \
    docker compose run --rm -e TARGET="$$t" letter; \
  done
