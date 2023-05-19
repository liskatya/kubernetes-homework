# Web-приложение на основе Python и Docker

Это пример простого web-приложения, которое выводит содержимое из папки `app`. Приложение упаковано в Docker-контейнер и развернуто в кластере Kubernetes.

## Шаги выполнения

1. **Создание web-приложения и Docker image**

- Создается Dockerfile на основе базового образа `python:3.10-alpine`.
- Пользователь, от имени которого выполняются инструкции - 'app'с идентификатором 1001.
- Внутри контейнера в каталоге '/app' создается файл `hello.html`, куда записывается строка "Hello world!".
- В качестве web-сервера используется python модуль http.server. Команда для запуска на 8000 порту
```
CMD ["python", "-m", "http.server", "8000"]
```

- Для сборки и публикации Docker image:
```
docker build -t liskatya/homework:1.0.0 .
docker login
docker push liskatya/homework:1.0.0
```

2. **Развертывание в Kubernetes**

В качестве основы используется Deployment manifest, сгенерированный ChatGpt по заданию:
![image](https://github.com/liskatya/kubernetes-homework/assets/114883107/97ce28e0-69d8-44be-b73a-388e66f4d10d)
- В Probes сгенерированного манифеста добавлены пути к `hello.html` для проверки готовности и работоспособности приложения и исправлен порт, на котором работает приложение.
```
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /hello.html
            port: 8000
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
```
```
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /hello.html
            port: 8000
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
          initialDelaySeconds: 10
```
- Для проверки успешного запуска контейнера добавлена проба startup.
```       startupProbe:
          httpGet:
            path: /
            port: 8000
          failureThreshold: 30
          periodSeconds: 10
 ```

3. **Установка и проверка**

- Для установки и проверки Kubernetes Deployment используются следующие команды:
```
kubectl apply -f deployment.yaml
kubectl describe pods
kubectl port-forward --address 0.0.0.0 deployment/web 8080:8000
kubectl describe deployment web
```

- В веб-браузере по адресу [http://127.0.0.1:8080/hello.html](http://127.0.0.1:8080/hello.html) выводится `Hello world!`.
- Результат команды `kubectl describe deployment web` 
![результаты deployment pod](https://github.com/liskatya/kubernetes-homework/assets/114883107/9e88401b-3e67-44fb-8bfc-7c56a27b0b73)

