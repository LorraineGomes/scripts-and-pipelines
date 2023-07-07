#!/bin/bash

destino="/var/www/backup-arquivos"

# Array de sites para backup 
LOJAS+=("altomax")
LOJAS+=("atelie")
LOJAS+=("autodoc24")
LOJAS+=("azza")
LOJAS+=("baratissimo")
LOJAS+=("bellagi")
LOJAS+=("bmtsr")
LOJAS+=("bmtsrpy")
LOJAS+=("champions")
LOJAS+=("coloridamente")
LOJAS+=("elchai")
LOJAS+=("farmaciaamorpy")
LOJAS+=("focoiluminacion")
LOJAS+=("iguassugaragem")
LOJAS+=("importauto")
LOJAS+=("maferpy")
LOJAS+=("paladino")
LOJAS+=("paranadecor")
LOJAS+=("paranadecorpy")
LOJAS+=("phoera")
LOJAS+=("prolight")
LOJAS+=("prolightbr")
LOJAS+=("prontoautomotores")
LOJAS+=("royalcompany")
LOJAS+=("smeg")
LOJAS+=("solufoz")
LOJAS+=("taticafoz")

for i in "${LOJAS[@]}"
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

  # Compactar a pasta de origem para o diretório de destino, incluindo apenas o .env e a pasta storage
  find . \( -name '.env' -o -name 'storage' \) -exec tar -czf "$destino/$nome" --transform="s|^./|$i/|" {} +

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
