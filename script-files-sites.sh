#!/bin/bash

destino="/diretorio/arquivos/sites/backup"

# Array de sites para backup 
SITES+=("site1")
SITES+=("site2")
SITES+=("site3")
SITES+=("site4")
SITES+=("site5")
SITES+=("site6")
SITES+=("site7")
SITES+=("site8")
SITES+=("site9")
SITES+=("site10")



for i in "${SITES[@]}"
do
  TARGET="/var/www/html/$i"
  cd "$TARGET"

  # Obter a data e hora atual
  data=$(date +"%Y-%m-%d")
  hora=$(date +"%H-%M-%S")

  # Nome do arquivo de backup
  nome="$i-$data-$hora.tar.gz"

  # Criar diretório de destino se não existir
  mkdir -p "$destino"

  # Compactar a pasta de origem para o diretório de destino
  # tar --ignore-failed-read -czf "$destino/$nome" -C "$TARGET" .
  tar -czf "$destino/$nome" -C "$(dirname $TARGET)" "$(basename $TARGET)"

  # Verificar se o backup foi criado com sucesso
  if [ $? -eq 0 ]; then
    echo "Backup completo criado em: $destino/$nome"
  else
    echo "Ocorreu um erro ao criar o backup."
  fi

  # Remover a pasta compactada após 20 dias
  find "$destino" -name "*.tar.gz" -mtime +20 -exec rm {} \;
  if [ $? -eq 0 ]; then
    echo "Pasta compactada será removida após 20 dias."
  else
    echo "Ocorreu um erro ao remover a pasta compactada."
  fi

done