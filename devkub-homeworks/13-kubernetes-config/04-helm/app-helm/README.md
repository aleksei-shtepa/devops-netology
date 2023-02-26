### Содержание проекта **netology-app**

  - [Chart.yaml](./netology-app/Chart.yaml) - Helm chart приложения, основное описание проекта с указанием версии чарта и приложения;
  - [values.yaml](./netology-app/values.yaml) - Переменные для настройки процесса развёртывания - деплоя;
  - templates/[backend_deploy.yaml](./netology-app/templates/backend_deploy.yaml) - Создание деплоя backend;
  - templates/[backend_service.yaml](./netology-app/templates/backend_service.yaml) - Описание сервиса для доступа к backend;
  - templates/[db_pvc.yaml](./netology-app/templates/db_pvc.yaml) - Описание динамического хранилища для базы данных;
  - templates/[db_secret.yaml](./netology-app/templates/db_secret.yaml) - Секрет для хранения логина и пароля от базы данных;
  - templates/[db_service.yaml](./netology-app/templates/db_service.yaml) - Описание сервиса для доступа к базе данных;
  - templates/[db_statefulset.yaml](./netology-app/templates/db_statefulset.yaml) - Создание StatefulSet базы данных;
  - templates/[frontend_deploy.yaml](./netology-app/templates/frontend_deploy.yaml) - Создание деплоя frontend;
  - templates/[frontend_service.yaml](./netology-app/templates/frontend_service.yaml) - Описание сервиса для доступа к frontend;
  - templates/[NOTES.txt](./netology-app/templates/NOTES.txt) - Сообщение о конфигурации приложения, выводимое при установке / обновлении;
  - templates/tests/[test-frontend.yaml](./netology-app/templates/tests/test-frontend.yaml) - Pod для тестирования frontend;
  - templates/tests/[test-backend.yaml](./netology-app/templates/tests/test-backend.yaml) - Pod для тестирования backend.
