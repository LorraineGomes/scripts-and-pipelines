#!/bin/bash

# Função para exibir mensagens formatadas.
print_message() {
    echo " | $1"
    echo " |Iniciando|"
}

# Função para realizar as permissões e ownership adequados.
set_permissions() {
    chown -R www-data:dev .
    chmod -R 755 .
    chmod -R 775 storage/
    chmod -R 775 bootstrap/cache/
}

# Pipeline Monitor.
store_array=("monitor")

for i in "${store_array[@]}"; do
    # Diretório para percorrer.
    TARGET="/var/www/html/$i"

    print_message "Rodando composer install"
    cd "$TARGET"
    composer install

    print_message "Executando Dump-Autoload"
    composer dump-autoload

    print_message "Mudando para a Branch main"
    git checkout main

    print_message "Executando as Migrations"
    php artisan migrate

    print_message "Alterando permissões de pastas"
    set_permissions

    print_message "Deploy no Ambiente Stages"
    git pull origin main

    print_message "Concluído... =)"
    echo " |===================================|"
done
