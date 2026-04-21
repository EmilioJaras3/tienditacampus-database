set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$DB_ROOT/.." && pwd)"

echo "️  TienditaCampus - Inicialización de BD"
echo "==========================================="

if [ -z "${POSTGRES_USER:-}" ]; then
    if [ -f "$PROJECT_ROOT/.env" ]; then
        export $(grep -v '^
    else
        echo " Error: Configura las variables de entorno o crea .env"
        exit 1
    fi
fi

echo ""
echo " Paso 1: Ejecutando migraciones..."
bash "$SCRIPT_DIR/run-migrations.sh"

echo ""
echo " Paso 2: Ejecutando seeds base..."
bash "$SCRIPT_DIR/run-seeds.sh"

echo ""
echo " Paso 3: Verificando integridad..."
bash "$SCRIPT_DIR/verify-db.sh"

echo ""
echo " Base de datos inicializada correctamente"