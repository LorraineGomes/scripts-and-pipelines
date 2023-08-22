#!/bin/bash

# Pipeline Produção stage SAX
store_array+=("saxstagedev")

    for i in "${store_array[@]}"
    do
        # Diretório para percorrer.
        TARGET="/var/www/html/$i"

        echo " | Rodando composer install          |"
        echo " |===================================/"
        cd $TARGET
        composer install --prefer-dist --no-ansi --no-interaction --no-progress --no-scripts
        echo " /===================================|"
        echo " | Executando Dump-Autoload..."
        echo " |===================================/"
        composer dump-autoload
        echo " /===================================|"
        echo " /===================================|"
        echo " | Mudando pra Branch main|"
        echo " |===================================/"
        git checkout main
        echo " | Executando as Migrations|"
        echo " |===================================/"
        php artisan migrate --force
        echo " /===================================|"
        echo " | Alterando permissões de pastas..."
        echo " |===================================/"
        cd $TARGET
        chown -R www-data:dev .
        chmod -R 755 .
        chmod -R 775 storage/
        chmod -R 775 bootstrap/cache/
        echo " /===================================|"
        echo " | Deploy no Ambiente Stage..."
        git reset --hard
        git pull origin main 
        echo " | Limpando cache da aplicação..."
        php artisan optimize:clear
        echo " |===================================/"
        echo " /===================================|"
        echo " | Concluído em saxstagedev.cloudcrow.com.br =)"
        echo " |===================================/"
        exit
    done