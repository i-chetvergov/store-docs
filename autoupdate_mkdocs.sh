#!/bin/bash
cd /home/uac/mkdocs || exit

# Сохранить текущий commit ID
current_commit=$(git rev-parse HEAD)

# Обновить локальный репозиторий
git pull origin main

# Получить новый commit ID
new_commit=$(git rev-parse HEAD)

# Если изменения обнаружены, перезапустить контейнер
if [ "$current_commit" != "$new_commit" ]; then
    echo "$(date): Обнаружены обновления, перезапускаем контейнер..." >> /home/uac/update_docs.log
    sudo docker rm -f mkdocs-container
    sudo docker run -d --name mkdocs-container -p 8000:8000 -v /home/uac/mkdocs:/mkdocs my-mkdocs
else
    echo "$(date): Новых обновлений не найдено." >> /home/uac/update_docs.log
fi
