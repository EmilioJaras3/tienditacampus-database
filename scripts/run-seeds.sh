set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$DB_ROOT/.." && pwd)"
SEEDS_DIR="$DB_ROOT/seeds"
INCLUDE_DEV=false

for arg in "$@"; do
    case $arg in
        --dev) INCLUDE_DEV=true ;;
    esac
done

if [ -z "${POSTGRES_USER:-}" ]; then
    if [ -f "$PROJECT_ROOT/.env" ]; then
        export $(grep -v '^
    fi
fi

echo " Ejecutando seeds..."

for seed in "$SEEDS_DIR"/[0-9]*.sql; do
    if [ -f "$seed" ]; then
        filename=$(basename "$seed")
        echo "   $filename"
        docker exec -i tc-database psql \
            -U "${POSTGRES_USER}" \
            -d "${POSTGRES_DB}" \
            -f - < "$seed" 2>&1 | grep -v "^$" || true
    fi
done

if [ "$INCLUDE_DEV" = true ]; then
    echo ""
    echo " Ejecutando seeds de desarrollo..."
    for seed in "$SEEDS_DIR"/dev/[0-9]*.sql; do
        if [ -f "$seed" ]; then
            filename=$(basename "$seed")
            echo "   [DEV] $filename"
            docker exec -i tc-database psql \
                -U "${POSTGRES_USER}" \
                -d "${POSTGRES_DB}" \
                -f - < "$seed" 2>&1 | grep -v "^$" || true
        fi
    done
fi

echo " Seeds completados"