#!/bin/bash

DB_USER="root"
DB_PASSWORD="NKF!*pRDo]ydtjg4"
BACKUP_PARENT_DIR="/home/lorraine9/teste/backups"

BACKUP_DIR="$BACKUP_PARENT_DIR/$(date +%Y%m%d)"

DATABASES+=("loja1")
DATABASES+=("loja2")
DATABASES+=("loja3")
DATABASES+=("loja4")
DATABASES+=("loja5")
DATABASES+=("loja6")

mkdir -p "$BACKUP_DIR"

for DB_NAME in "${DATABASES[@]}"
do
    BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$(date +%Y%m%d%H%M%S).sql"
    
    mysqldump --user="$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"

    if [ $? -eq 0 ]; then
        echo "Backup do banco de dados $DB_NAME criado com sucesso em $BACKUP_FILE"
    else
        echo "Erro ao criar o backup do banco de dados $DB_NAME"
        continue
    fi
done

COMPRESSED_BACKUP_FILE="$BACKUP_PARENT_DIR/backup-$(date +%Y%m%d).tar.gz"

# Compacta a pasta de backup usando o tar e gzip
tar czf "$COMPRESSED_BACKUP_FILE" -C "$BACKUP_PARENT_DIR" "$(date +%Y%m%d)"

if [ $? -eq 0 ]; then
    echo "Pasta de backup do dia $(date +%Y%m%d) comprimida com sucesso em $COMPRESSED_BACKUP_FILE"
else
    echo "Erro ao compactar a pasta de backup do dia $(date +%Y%m%d)"
fi

# Remove a pasta de backup original
rm -r "$BACKUP_DIR"

echo "Pasta de backup do dia $(date +%Y%m%d) removida"
