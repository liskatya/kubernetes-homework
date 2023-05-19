Для создания приложения, выводящего "Hello world!" при запросе по адресу в Dockerfile прописано выполнение действия 
'''RUN echo "Hello world!" > /app/hello.html'''
Файл создается на основе alpine образа Python.
Используются переменные окружения 


В качестве web-сервера используется python модуль http.server. Команда для запуска приложения на 8000 порту.
'''CMD ["python", "-m", "http.server", "8000"]'''

Также в докерфайле указан каталог, в котором находится приложение.

Созданный файл собирается в Docker image c тэгом 1.0.0 и отправляется в Docker Hub.

'''команда 1'''
'''команда 2'''

Далее ChatGPT сгенерировал Deployment manifest

 #вставить картинку

В дополнении к сгенерированному манифесту добавлены пути к hello.html для проверки ответа от сервера, а также Sturtup Probe.
'''
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /hello.html
            port: 8000
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
'''
'''
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /hello.html
            port: 8000
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
          initialDelaySeconds: 10
 '''

'''       startupProbe:
          httpGet:
            path: /
            port: 8000
          failureThreshold: 30
          periodSeconds: 10 
 '''
Запускаяем кластер
''' minikube start'''
Устанаваливаем deployment в кластер.
'''kubectl apply -f deployment-2.yaml --namespace=default'''

При успешном развертывании пода команда
'''kubectl describe pods''' 
должна выводить 

Для проверки доступности приложения в кластере
'''kubectl port-forward --address 0.0.0.0 deployment/web 8080:8000'''

Для просмотра подробноых свежений о результатах запуска подов ипользуем команду
'''kubectl describe deployment web'''

