FROM python:3.10-alpine

# Переменные, используемые для создания окружения, в котором запустится приложение
ARG USER=app
ARG UID=1001
ARG GID=1001

# Создание пользователя операционной системы и его домашнего каталога
RUN addgroup -g ${GID} -S ${USER} \
   && adduser -u ${UID} -S ${USER} -G ${USER} \
   && mkdir -p /app \
   && chown -R ${USER}:${USER} /app
USER ${USER}

# Переход в каталог /app
WORKDIR /app

# Добавление файла, содержащего "Hello world"
RUN echo "Hello world!" > /app/hello.html

# Переменные окружения, необходимые для запуска web-приложения
ENV PYTHONUNBUFFERED=1

# Публикация порта, который прослушивается приложением
EXPOSE 8000

# Команда запуска приложения
CMD ["python", "-m", "http.server", "8000"]
