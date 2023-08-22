#!/bin/bash

# Pipeline Produção Loja Sax
store_array+=("sax")

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
        chown -R www-data:dev .
        chmod -R 755 .
        chmod -R 775 storage/
        chmod -R 775 bootstrap/cache/
        echo " /===================================|"
        echo " | Deploy no Ambiente Stages..."
        git reset --hard
        git pull origin main 
        echo " | Limpando cache da aplicação..."
        php artisan optimize:clear
        echo " | Reiniciando as filas dos e-mails ..."
        php artisan queue:restart
        echo " |===================================/"
        echo " /===================================|"
        echo " | Concluído...!"
        echo " |===================================/"
        exit
        
    done