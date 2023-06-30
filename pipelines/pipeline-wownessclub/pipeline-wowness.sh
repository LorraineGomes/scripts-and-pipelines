#!/bin/bash

# Pipeline Stage WownesClub.
store_array+=("stage")

    for i in "${store_array[@]}"
    do
        # Diretório para percorrer.
        TARGET="/var/www/html/$i"

        echo " | Rodando composer install          |"
        echo " |===================================/"
        cd /var/www/html/$i
        composer install
        echo " /===================================|"
        echo " | Executando Dump-Autoload..."
        echo " |===================================/"
        composer dump-autoload
        echo " /===================================|"
        echo " /===================================|"
        echo " | Mudando pra Branch main|"
        echo " |===================================/"
        cd $TARGET
        git checkout main
        echo " | Executando as Migrations|"
        echo " |===================================/"
        php artisan migrate
        echo " /===================================|"
        echo " | Alterando permissões de pastas..."
        echo " |===================================/"
        chown -R www-data:dev .
        chmod -R 755 .
        chmod -R 775 storage/
        chmod -R 775 bootstrap/cache/
        echo " /===================================|"
        echo " | Deploy no Ambiente Stages..."
        git stash
        git pull origin main
        echo " |===================================/"
        echo " /===================================|"
        echo " | Concluído... =)"
        echo " |===================================/"
        exit
    done
