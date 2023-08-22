#!/bin/bash
set -e

# Lista de lojas fictícias
stores+=("store1" "store2" "store3" "store4" "store5" "store6" "store7")

echo "Iniciando o Deploy nas Lojas Sem Integração..."

for store in "${stores[@]}"; do
    # Diretório da loja
    TARGET="/var/www/html/$store"
    
    # Avisando sobre a loja atual
    echo "Deploying $store..."
    
    # Acessando o diretório
    cd "$TARGET"

    # Colocando a aplicação em modo de manutenção
    php artisan down

    # Atualizando o código
    git fetch origin feature/migrate-crow-store
    git reset --hard feature/migrate-crow-store
    git pull

    # Instalando dependências com base no composer.lock
    composer install --no-interaction --prefer-dist --optimize-autoloader

    # Atualizando o autoload
    composer dump-autoload

    # Rodando as migrações
    php artisan migrate --force

    # Reiniciando as filas
    php artisan queue:restart

    # Limpando o cache
    php artisan optimize:clear

    # Reiniciando o serviço PHP
    echo "" | sudo -S service php8.1-fpm reload

    # Configurando permissões
    chown -R www-data:dev .
    chmod -R 755 .
    chmod -R 775 storage/
    chmod -R 775 bootstrap/cache/

    # Desativando o modo de manutenção
    php artisan up

    echo "$store deployed!"
done

echo "Deploy concluído em todas as lojas!"
