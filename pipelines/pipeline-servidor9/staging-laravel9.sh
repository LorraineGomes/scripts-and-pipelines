#!/bin/bash
set -e

# Pipeline Stage Stores9
store_array+=("stage9")

echo "Deploying em STAGE9 -> stage9.cloudcrow.com.br"

for i in "${store_array[@]}"
do
    
    # Diretório Stage
    TARGET="/var/www/html/$i"
    cd $TARGET

    # Modo manutenção
    php artisan down

    # Atualizando código
    git fetch origin feature/migrate-crow-store
    git reset --hard feature/migrate-crow-store
    git pull

    # Rodando as migrations
    php artisan migrate --force

    cd /var/www && ./composer.sh
    # Restartando filas 
    php artisan queue:restart

    # Limpando Cache
    php artisan optimize:clear

    # Restart no serviço PHP
    echo "" | sudo -S service php8.1-fpm reload

    # Definindo permissões e grupos 
    chown -R www-data:dev .
    chmod -R 755 .
    chmod -R 775 storage/
    chmod -R 775 bootstrap/cache/
    # Fim do modo manutenção
    php artisan up 

done
