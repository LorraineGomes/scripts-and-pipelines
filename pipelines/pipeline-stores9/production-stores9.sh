#!/bin/bash
set -e

# Percorre as lojas sem integração
store_array+=("altomax")
store_array+=("atelie")
store_array+=("autodoc24")
store_array+=("azza")
store_array+=("baratissimo")
store_array+=("bellagi")
store_array+=("bmtsr")
store_array+=("bmtsrpy")
store_array+=("champions")
store_array+=("coloridamente")
store_array+=("elchai")
store_array+=("farmaciaamorpy")
store_array+=("focoiluminacion")
store_array+=("iguassugaragem")
store_array+=("importauto")
store_array+=("maferpy")
store_array+=("paladino")
store_array+=("paranadecor")
store_array+=("paranadecorpy")
store_array+=("phoera")
store_array+=("prolight")
store_array+=("prolightbr")
store_array+=("prontoautomotores")
store_array+=("royalcompany")
store_array+=("smeg")
store_array+=("solufoz")
store_array+=("taticafoz")
store_array+=("trembala")
store_array+=("vitrinecell")

echo "Deploying em produção nas Lojas Sem integração..."

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

    # Limpando o Cache das aplicações
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

echo "Application deployed!"
