#!/bin/bash
set -e

# Pipeline Lojas com Integração!
store_array+=("loja1")
store_array+=("loja2")
store_array+=("loja3")
store_array+=("loja4")
store_array+=("loja5")
store_array+=("loja6")
store_array+=("loja7")
store_array+=("loja8")
store_array+=("loja9")
store_array+=("loja10")


echo "Deploying nas Lojas em Produção..."

for i in "${store_array[@]}"
do
    
    # Diretório Lojas
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

    # Restartando filas 
    php artisan queue:restart

    # Limpando Cache
    php artisan optimize:clear

    cd /var/www && ./composer.sh

    cd $TARGET
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