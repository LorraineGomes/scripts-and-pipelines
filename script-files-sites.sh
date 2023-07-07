#!/bin/bash

destino="/var/www/backup"

# Array de sites para backup 
SITES+=("atvbox")
SITES+=("agfarmus")
SITES+=("acifi-paginas")
SITES+=("altomax")
SITES+=("barbeariafaccin.com.br")
SITES+=("bebebistro")
SITES+=("blocosceramicos")
SITES+=("casafoz")
SITES+=("cdn")
SITES+=("cemel")
SITES+=("conceitoarquiteturafoz.com.br")
SITES+=("construfour.com.br")
SITES+=("crowpy.com")
SITES+=("crowtech")
SITES+=("donfrances")
SITES+=("estacaojkbarbearia.com.br")
SITES+=("hartman")
SITES+=("ifcforest.com")
SITES+=("ikigai")
SITES+=("intlsystems")
SITES+=("intregralab")
SITES+=("kempler")
SITES+=("magnitude")
SITES+=("maskking")
SITES+=("noelifaccin.com.br")
SITES+=("ouroverde")
SITES+=("premium")
SITES+=("preventiva")
SITES+=("publicar-paineis")
SITES+=("world-of-vape")


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