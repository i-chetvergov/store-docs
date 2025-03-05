# Используем официальный образ Python как базовый
FROM python:3.10-slim

# Устанавливаем системные зависимости
RUN apt-get update && \
    apt-get install -y --no-install-recommends git openssh-client && \
    rm -rf /var/lib/apt/lists/*

# Добавляем GitHub в known_hosts
RUN mkdir -p /home/mkdocs/.ssh && \
ssh-keyscan github.com >> /home/mkdocs/.ssh/known_hosts

# Создаем непривилегированного пользователя для повышения безопасности
RUN useradd -m -s /bin/bash mkdocs

# Создаем рабочую директорию /mkdocs и устанавливаем права для пользователя mkdocs
USER root
RUN mkdir -p /mkdocs && chown -R mkdocs:mkdocs /mkdocs

# Переключаемся на непривилегированного пользователя
USER mkdocs

# Обновляем pip и устанавливаем MkDocs с темой mkdocs-material, а также дополнительные плагины
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir mkdocs mkdocs-material mkdocs-glightbox mkdocs-swagger-ui-tag && \
    pip install --no-cache-dir mkdocs-build-plantuml-plugin mkdocs-enumerate-headings-plugin

# Добавляем путь к установленным бинарным файлам для пользователя mkdocs
ENV PATH="/home/mkdocs/.local/bin:${PATH}"

# Устанавливаем рабочую директорию для документации
WORKDIR /mkdocs

# Объявляем том для хранения исходных файлов документации
VOLUME ["/mkdocs"]

# Открываем порт для веб-сервера MkDocs (обычно 8000)
EXPOSE 8000

# Команда по умолчанию для запуска локального сервера документации
CMD ["mkdocs", "serve", "-a", "0.0.0.0:8000"]

