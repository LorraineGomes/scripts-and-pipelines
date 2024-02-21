#!/bin/bash

destino="/diretorio/arquivos/sites/backup"

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
  
  data=$(date +"%Y-%m-%d")
  hora=$(date +"%H-%M-%S")

  nome="$i-$data-$hora.tar.gz"

  mkdir -p "$destino"

  # tar --ignore-failed-read -czf "$destino/$nome" -C "$TARGET" .
  tar -czf "$destino/$nome" -C "$(dirname $TARGET)" "$(basename $TARGET)"

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
