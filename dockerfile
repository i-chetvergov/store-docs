# Используем официальный образ Python как базовый
FROM python:3.10-slim

# Устанавливаем системные зависимости
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Создаем непривилегированного пользователя для повышения безопасности
RUN useradd -m -s /bin/bash mkdocs

# Создаем рабочую директорию /mkdocs и устанавливаем права для пользователя mkdocs
USER root
RUN mkdir -p /mkdocs && chown -R mkdocs:mkdocs /mkdocs

# Переключаемся на непривилегированного пользователя
USER mkdocs

# Обновляем pip и устанавливаем MkDocs с выбранной темой (mkdocs-material)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir mkdocs mkdocs-material

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

