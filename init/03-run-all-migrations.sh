set -euo pipefail

echo "Levantando migraciones automáticas..."

MIGRATIONS_DIR="/migrations"

for migration in "$MIGRATIONS_DIR"/V*.sql; do
    if [ -f "$migration" ]; then
        filename=$(basename "$migration")
        echo "   Preparando: $filename"

        psql -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -f "$migration"
    fi
done

echo " Migraciones en el Container terminadas"