#!/bin/bash

set -euo pipefail

DB_USER="login"
DB_PASSWORD="senha"
BACKUP_PARENT_DIR="/caminho/diretorio/backups"
CURRENT_DATE=$(date +%Y%m%d)
BACKUP_DIR="$BACKUP_PARENT_DIR/$CURRENT_DATE"

DATABASES=("banco1" "banco2" "banco3" "banco4" "banco5" "banco6" "banco7" "banco8" "banco9" "banco10")

mkdir -p "$BACKUP_DIR"

print_message() {
    if [ $? -eq 0 ]; then
        echo "Sucesso: $1"
    else
        echo "Erro: $1"
        exit 1
    fi
}

for DB_NAME in "${DATABASES[@]}"; do
    BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$CURRENT_DATE.sql"

    mysqldump --user="$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"
    print_message "Backup do banco de dados $DB_NAME criado em $BACKUP_FILE"
done

COMPRESSED_BACKUP_FILE="$BACKUP_PARENT_DIR/backup-$CURRENT_DATE.tar.gz"
tar czf "$COMPRESSED_BACKUP_FILE" -C "$BACKUP_PARENT_DIR" "$CURRENT_DATE"
print_message "Pasta de backup do dia $CURRENT_DATE comprimida em $COMPRESSED_BACKUP_FILE"

rm -r "$BACKUP_DIR"
print_message "Pasta de backup do dia $CURRENT_DATE removida"

echo "Backup concluído com sucesso para o dia $CURRENT_DATE"
