#!/bin/bash

set -euo pipefail

# Configurações
DB_USER="login"
DB_PASSWORD="senha"
BACKUP_PARENT_DIR="/caminho/diretorio/backups"
CURRENT_DATE=$(date +%Y%m%d)
BACKUP_DIR="$BACKUP_PARENT_DIR/$CURRENT_DATE"

# Lista de bases de dados para backup
DATABASES=("banco1" "banco2" "banco3" "banco4" "banco5" "banco6" "banco7" "banco8" "banco9" "banco10")

# Cria o diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

# Função para imprimir mensagens de sucesso ou erro
print_message() {
    if [ $? -eq 0 ]; then
        echo "Sucesso: $1"
    else
        echo "Erro: $1"
        exit 1
    fi
}

# Loop através das bases de dados
for DB_NAME in "${DATABASES[@]}"; do
    BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$CURRENT_DATE.sql"

    # Comando para fazer o backup usando o mysqldump
    mysqldump --user="$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"
    print_message "Backup do banco de dados $DB_NAME criado em $BACKUP_FILE"
done

# Compacta a pasta de backup usando o tar e gzip
COMPRESSED_BACKUP_FILE="$BACKUP_PARENT_DIR/backup-$CURRENT_DATE.tar.gz"
tar czf "$COMPRESSED_BACKUP_FILE" -C "$BACKUP_PARENT_DIR" "$CURRENT_DATE"
print_message "Pasta de backup do dia $CURRENT_DATE comprimida em $COMPRESSED_BACKUP_FILE"

# Remove a pasta de backup original
rm -r "$BACKUP_DIR"
print_message "Pasta de backup do dia $CURRENT_DATE removida"

echo "Backup concluído com sucesso para o dia $CURRENT_DATE"
