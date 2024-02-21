#!/bin/bash

destino="/diretorio/lojas/arquivos/backups"

LOJAS+=("loja1")
LOJAS+=("loja2")
LOJAS+=("loja3")
LOJAS+=("loja4")
LOJAS+=("loja5")
LOJAS+=("loja6")
LOJAS+=("loja7")
LOJAS+=("loja8")
LOJAS+=("loja9")
LOJAS+=("loja10")

for i in "${LOJAS[@]}"
do
  TARGET="/var/www/html/$i"
  cd "$TARGET"

  data=$(date +"%Y-%m-%d")
  hora=$(date +"%H-%M-%S")

  nome="$i-$data-$hora.tar.gz"

  mkdir -p "$destino"

  find . \( -name '.env' -o -name 'storage' \) -exec tar -czf "$destino/$nome" --transform="s|^./|$i/|" {} +

  if [ $? -eq 0 ]; then
    echo "Backup completo criado em: $destino/$nome"
  else
    echo "Ocorreu um erro ao criar o backup."
  fi

  find "$destino" -name "*.tar.gz" -mtime +20 -exec rm {} \;
  if [ $? -eq 0 ]; then
    echo "Pasta compactada será removida após 20 dias."
  else
    echo "Ocorreu um erro ao remover a pasta compactada."
  fi

done
