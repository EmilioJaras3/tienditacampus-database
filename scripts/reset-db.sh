set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "️  TienditaCampus - RESET de Base de Datos"
echo "============================================"

if [ -z "${POSTGRES_USER:-}" ]; then
    if [ -f "$PROJECT_ROOT/.env" ]; then
        export $(grep -v '^
    fi
fi

if [ "${NODE_ENV:-development}" = "production" ]; then
    echo " ERROR: No se puede ejecutar reset en producción"
    exit 1
fi

echo ""
echo "️  ADVERTENCIA: Esto ELIMINARÁ todos los datos de '${POSTGRES_DB}'"
read -p "¿Estás seguro? Escribe 'RESET' para confirmar: " -r
echo

if [ "$REPLY" != "RESET" ]; then
    echo "️  Operación cancelada."
    exit 0
fi

echo "️  Eliminando base de datos..."
docker exec tc-database psql -U "${POSTGRES_USER}" -c "DROP DATABASE IF EXISTS ${POSTGRES_DB};"
docker exec tc-database psql -U "${POSTGRES_USER}" -c "CREATE DATABASE ${POSTGRES_DB};"

echo " Reinicializando..."
bash "$SCRIPT_DIR/init-db.sh"

echo ""
echo " Base de datos reseteada y reinicializada"