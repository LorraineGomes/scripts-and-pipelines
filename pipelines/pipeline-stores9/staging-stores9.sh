#!/bin/bash
set -e

# Pipeline Stages Stores9
store_array+=("stage1")
store_array+=("stage2")
store_array+=("stage3")
store_array+=("stage4")
store_array+=("stage5")

echo "Deploying applications Stages..."

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

    # Instalando dependẽncias baseadas no composer.lock
    composer install --no-interaction --prefer-dist --optimize-autoloader

    # Rodando Dump-autoload
    composer dump-autoload

    # Rodando as migrations
    php artisan migrate --force

    # Restartando filas 
    php artisan queue:restart

    # Limpando Cache
    php artisan optimize

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

echo "Application deployed!"