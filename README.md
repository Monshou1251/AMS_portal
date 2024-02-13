# Портал AMS

---

## Обзор проекта:

Портал AMS представляет собой полнофункциональное приложение, предназначенное для обеспечения удобного и эффективного взаимодействия с базой данных Exasol. Этот портал обеспечивает широкий спектр функций, начиная от просмотра и фильтрации данных до их редактирования, добавления и удаления. Важной частью функционала является возможность импорта и данных из файлов формата Excel, обеспечивая удобную интеграцию и обмен ин-формацией между различными источниками данных.

Для создания бэкенда приложения используется фреймворк Django, который предоставляет собой мощный и надежный набор инструментов для разработки веб-приложений. Клиентская часть приложения построена с использованием Vue.js, обеспечивая динамический интерфейс пользователя и позволяя эффективно взаимодействовать с данными. Интеграция с Active Directory и применение протокола LDAP обеспечивают безопасность и управление доступом к приложению, гарантируя безопасное взаимодействие пользователей с данными.
Кроме того, важной частью функционала проекта является интеграция с Apache Airflow, поз-воляющая мониторить и планировать рабочие процессы из портала.

---

## Функционал:

- Просмотр отдельных таблиц AMS (Данные ДГК, Данные АГК, Мэппинг страховых журналов, Справочники).
- Редактирование таблиц AMS (Открытые/Закрытые периоды).
- Запуск пакетных заданий Apache Airflow.
- Импорт данных в таблицы AMS (Импорт проводок из MS Excel в AMS, деактивация загруженных из MS Excel проводок).
- Редактирование пользователей Портала AMS.

---

## **Как развернуть проект:**

### **1. Установка Python:**

Cкачайте и установите Python (v 3.11.3):

```
https://www.python.org/downloads/release/python-3113/
```

---

### **2. Установка Node.js**

Скачайте и установите node.js (он будет необходим для запуска части проекта на vue):

```
https://nodejs.org/en/
```

---

### **3. Установка GIT.**

Убедитесь, что Git установлен на вашем компьютере:

```
https://git-scm.com/download/
```

Если же вы используете файлы проекта из уже имеющегося у вас архива с проектом, то вы можете пропустить этот шаг.

### **4. Развертывание Бэкенда.**

<details>
<summary>Для развертывания бэкенда проекта выполните следующие действия:</summary>

#### **4.1. Клонируйте репозиторий:**

```
git@github.com:Monshou1251/ams_portal.git
```

В случае если вы уже имеете файлы проекта, то просто распакуйте их в отдельную папку.

#### **4.2. Перейдите в папку проекта:**

```
cd AMS_portal
```

#### **4.3. Создайте и активируйте виртуальное окружение:**

```
py -m venv venv
```

```
. venv/bin/activate
```

или

```
. venv/scripts/activate
```

В случае возникновения ошибки "SecurityError: (:) [], PSSecurityException", введите команду:

```
Set-ExecutionPolicy RemoteSigned -Scope Process
```

Проверьте версию python, установленную в виртуальном окружении:

```
python --version
```

---

#### **4.4. Обновите (или установите) pip:**

```
py -m pip install --upgrade pip
```

Если на данном этапе вы встречаете ошибку "No module named pip" её можно решить следующей командой:

```
py –m ensurepip
```

#### **4.5. Перейдите в папку backend:**

```
cd backend
```

---

#### **4.6. Установите требования из файла requirements.txt:**

```
pip install -r requirements.txt
```

Если вы столкнулись с ошибкой связанной с Microsoft Visual C++, перейдите по ссылке ниже и установите Microsoft C++ Build Tools:

```
https://visualstudio.microsoft.com/visual-cpp-build-tools/
```

Выберите C++ build tools, в деталях установки (окно Installation details) выберите в разделе C++ build tools следующие пункты:

- MSVC V\*\*\*
- Windows ** SDK(**)
- C++ CMake tools for Windows
- Testing tools core features - Build Tools (optional)
- C++ AddressSanitizer (optional)

Если вы столкнулись с ошибкой связанной с python wheel, проверьте какая версия python установлена в виртуальном окружении.
Если отличная от рекомендуемой выше (3.11.3), открой файл requirements.txt, найдите следующую строку:

```
python-ldap @ https://download.lfd.uci.edu/pythonlibs/archived/python_ldap-3.4.0-cp311-cp311-win_amd64.whl
```

Вам необходимо скачать и установить файл .wheel для python соотвествующий версии на вашем компьютере.
Дополнительно, если версия ниже 3.9, проверьте следующую строку в requirements.txt:

```
backports.zoneinfo;python_version<"3.9"
```

</details>

---

### **5. Подключение к Active Directory:**

<details>
<summary>Для настройки подключения к базе пользователей Active Directory выполните следующие действия:</summary>

Для того чтобы процесс аутентификации проходил с уже существующей базой AD, необходимо проделать следущие действия.

#### **5.1. Создать пользователя с правами read (чтение), получения списка пользователей, в определенной группе AD:**

#### **5.2. Зайдите в файл настроек Django:**

```
ams_portal\backend\backend\settings.py
```

#### **5.3. Найдите строку LDAP_AUTH_URL, укажите адрес AD.**

Пример ниже:

```
LDAP_AUTH_URL = ["ldap://example.ru"]
```

#### **5.4. Укажите группу пользователей, которые будут иметь доступ к порталу.**

Пример:

```
LDAP_AUTH_SEARCH_BASE = "OU=Sample,OU=Guests,OU=Special,DC=example,DC=ru"
```

#### **5.5. Укажите данные пользователя по-умолчанию, через которого будет проводиться проверка введеных данных по базе AD.**

Пример:

```
LDAP_AUTH_CONNECTION_USERNAME = (
    "CN=user,OU=Tech_account,OU=IT,OU=Back1,DC=example,DC=ru"
)
LDAP_AUTH_CONNECTION_PASSWORD = "password"
```

Пользователь должен иметь права на получение списка участников опр. группу или опр. подразделения, которое было указано в пункте 5.4.

</details>

---

### **6. Создание суперпользователя.**

В проекте AMS введена роль суперпользователя, обладающего расширенными правами доступа к системе.

<details>
<summary>Создание суперпользователя:</summary>
В проекте AMS введена роль суперпользователя, обладающего расширенными правами доступа к системе. Суперпользователь имеет следующие особенности:

- **Безусловный Доступ:**

  - Суперпользователь обладает полным и безоговорочным доступом ко всем функциональным возможностям проекта.
  - Ему предоставлен доступ к системе независимо от настроек и ограничений Active Directory.<br><br>

- **Преодоление Ограничений Active Directory:**

  - В обычных условиях, проект взаимодействует с Active Directory для аутентификации и авторизации пользователей. Однако, суперпользователь обходит эти ограничения и имеет доступ вне зависимости от данных, предоставленных Active Directory.<br><br>

- **Основные Задачи Суперпользователя:**

  - Создание и управление учетными записями пользователей.
  - Редактирование прав доступа и ролей других пользователей.

  - Изменение системных настроек и конфигураций проекта.
  - Произвольный доступ к данным и функциональности приложения.<br><br>

**Создание Суперпользователя:**

#### **6.1. Перейдите в папку с бекэндом проекта:**

```
cd ams_portal\backend
```

#### **6.2. Создайте суперпользователя следующей командой:**

```
python manage.py createsuperuser
```

Далее следуйте инструкции в терминале (ввод имени пользователя, имейла и пароля).
Сохраните эти данные, пользователь с введеными выше данными должен присутствовать в базей даных Exasol.

#### **6.3. Откройте файл settings.py**

```
cd backend\backend\settings.py
```

В переменную SUPER_USER введите имя суперпользователя, которое вы создали в п. 6.2.

```
SUPER_USER = 'your_super_user'
```

На данном этапе суперпользователь создан, убедитесь, что в базей данных Exasol присутствует пользователь с указанными данными.

</details>

---

### **7. Настройка базы данных Exasol.**

<details>
<summary>Перед тем как начать работу с базой данных Exasol необходимо её настроить:</summary>

#### **7.1. Работает ли Exasol сервер.**

Если нет, самым быстрым способом будет использованиe Docker:

- Установите Docker Desktop (для Windows);
  Чтобы проверить всё ли работает введите в терминале следующую команду:

```
docker --version
```

В случае если всё хорошо вы должны получить сообщение с примерным содержанием:

```
Docker version 24.0.6, build ed223bc
```

- Далее запуска Exasol в терминале введите следующую команду:

```
docker run --privileged --name myexadb -p 8563:8563 -e EXA_PASSWORD=mysecret -d exasol/docker-db:latest
```

,где
myexadb - имя базы данных,
EXA_PASSWORD - пароль,
-p 8563:8563 - порт
Эти параметры вы можете настраивать самостоятельно (или использовать указанные выше по-умолчанию).
Чтобы проверить, что контейнер запущен введите следующую команду:

```
docker ps
```

После ввода этой команды будет выведен список всех запущенных контейнеров. Проверьте, что контейнер
exasol/docker-db:latest запущен (в графе STATUS будет указано время работы контейнера с момента запуска - Up 33 minutes).

#### **7.2. Проверить установлен ли ODBC драйвер.**

Чтобы скачать драйвер пройдите по ссылке:

```
https://downloads.exasol.com/clients-and-drivers/odbc
```

На этом шаге также может возникнуть проблема с Microsoft C++, для решения проблема см. п. 4.6.

#### **7.3. Настроен ли ODBC Data Source на вашем компьютере.**

- В меню пуск введите в поиске ODBC Data Sources (64-bit);
- Выберите закладку System DSN;
- Справа нажмите кнопоку Add... (Добавить);
- Выберите EXASolution Driver;
- Data Source name - имя на выше усмотрение (для примера myexadb, в пункте 12 нам понадобится это имя);
- Connection string - если вы запустили Exasol через Docker, то адресом будет localhost,
  с портом указанным ранее (8563). Дополнительно в целях безопасности будет необходимо добавить finger print.
  В итоге строка подключения будет иметь следующий вид:

```
localhost/B38E705F2BD32B87DD1C744FA8F32FF040019AD332A2312B31D205D6C4A1C3BB4:8563
```

Эти данные понадобятся для настройки подключения Django.

#### **7.4. Далее необходимо заполнить базу данных необходимыми схемами и таблицами.**

AMS портал настроен на работу со определенными схемами и таблицами.
Если ваша база Exasol пустая запустите следующие SQL скрипты в любом SQL клиенте для работы с БД (DBeader, Exaplus etc.)
Скрипты лежат по следующему пути:

```
\ams_portal\backend\DDL
```

Скрипты для запуска:

```
\ams_portal\backend\DDL\AMS_GL_DDL.sql
```

```
\ams_portal\backend\DDL\AMS_LOG_DDL.sql
```

```
\ams_portal\backend\DDL\AMS_PORTAL_DDL.sql
```

Дополнительно, если в вашей базе есть все необходимые схемы и таблицы, но при этом в них нет данных, запустите скрипт:

```
\ams_portal\backend\DDL\insert_script.sql
```

Он заполнит таблицу AMS_GL.BUSINESS_LINE тестовыми данными.

</details>

---

### **8. Настройка Django для работы с базой данных Exasol.**

<details> 
<summary>Для настройки Django для работы с установленной базой данных Exasol, нужно проделать следущие шаги:</summary>

- Откройте следующий файл настроек:

```
ams_portal\backend\backend\settings.py
```

В строке 15 укажите имя вашей базы данных (см. пункт 11.3, в нашем случае это "myexadb"):

```
EXASOL_DB_NAME = "myexadb"
```

Эти данные нужны для подключения к базе данных Exasol с использование драйвера pyodbc (необходимого для SQLAlchemy).

А также заполните данные в строке 16, указав IP адрес и порт вашей базы Exasol:

```
EXASOL_DB_NAME_DIRECT = "11.116.11.200:8563"
```

На данном этапе django успешно настроен и готов к запуску:

```
python manage.py runserver
```

## </details>

---

### **9. Логирование (Vector)**

<details> 
<summary>Для сохранение логов с использованием Vector нужно проделать следущие шаги:</summary>

#### **9.1. Установка Vector**

Для этого создайте папку в удобном для вас месте, где будут храниться файлы Vector
(для примера была создана папка в корневой директории проекта):

```
cd ams_portal/Vector
```

Далее в терминале введите следующие команды (убедитесь, что вы находитесь в нужной папке):

```
powershell Invoke-WebRequest https://packages.timber.io/vector/0.35.0/vector-x64.msi -OutFile vector-0.35.0-x64.msi
```

```
.\vector-0.35.0-x64.msi
```

#### **9.2. Настройка Vector**

Далее необходимо настроить конфигурационные файлы. В корневой папке проекта ams найдите папку Vector, в ней
лежит пример настройки конфигурационного файла с настройками для хранения логов через Socket:
Файл vector_socket_ams.toml:

```
# В данном блоке, блок [sources], описывается источник получения данных, в данном случае socket
# Значение поля address должны соответствовать адресу, где запущен ваш экземпляр проекта ams
# Для более детальной информации смотри:
# https://vector.dev/docs/reference/configuration/sources/
[sources.in]
type = "socket"
address = "127.0.0.1:9093"
mode = "tcp"

# Print parsed logs to stdout
# В этом блоке, в блоке [sinks] настраивается вывод/сохранение полученных данных (логов).
# В данном случае логи будут выводиться в терминале, где запущен Vector (о запуске будет сказано ниже).
# Для более детальной информации смотри:
# https://vector.dev/docs/reference/configuration/sinks/
[sinks.out]
type = "console"
inputs = ["in"]
encoding.codec = "text"


# Параллельно с выводом логов в консоль ниже указаны настройки сохранения логов в файл
# В поле path укажите куда вы хотите сохранять логи.
# Для более детальной информации смотри:
# https://vector.dev/docs/reference/configuration/sinks/file/
[sinks.file]
type = "file"
inputs = ["in"]
encoding.codec = "text"
path = "F:\\XXX\\XXX\\XXX\\Vector\\Logs\\vector_M-%Y_%m_%d.log"
```

Далее для запуска Vector в терминале необходимо ввести следующую команду:

```
"C:\your_address\Vector\bin\vector" --config "F:\your_address\Vector\vector_socket_ams.toml"
```

где,

```
C:\your_address\Vector\bin\vector" - адрес где установлен ваш экземпляр вектора,
"F:\your_address\Vector\vector_socket_ams.toml" - адрес, где располагается файл настроек вектора.
```

Если возникает ошибка "Непредвиденная лексема "config" в выражении или операторе", введите команду:

```
& "C:\your_address\Vector\bin\vector" --config "F:\your_address\Vector\vector_socket_ams.toml"
```

В случае успешного запуска в терминале вы увидите сообщение:

```
INFO source{component_kind="source" component_id=in component_type=socket}: vector::sources::util::net::tcp: Listening. addr=127.0.0.1:9093
```

#### **9.2. Настройка Django для работы с Vector**

- Убедитесь, что в настройках Django, в файле settings.py:

```
backend\backend\settings.py
```

В поле LOGGING, handlers , указан правильный IP адрес и порт.

```
***
"handlers": {
        "vector": {
            "level": "INFO",
            "class": "backend.logger.CustomSocketHandler",
            "host": "127.0.0.1",
            "port": "9093",
            "formatter": "vector",
        },
***
```

</details>

---

### **10. Развертывание Фронтенда.**

<details> 
<summary>Для развертывания фронтенда проекта выполните следующие действия::</summary>

#### **10.1. Вернитесь в основную папку.**

```
cd ..
```

#### **10.2. Затем в папку frontend:**

```
cd frontend
```

#### **10.3. Установите npm (в этом случае будут включены все node_modules):**

```
npm install
```

#### **10.4. Теперь Vue готов к запуску:**

```
npm run serve
```

</details>

---

Проект успешно развернут!

## Технологии

В работе AMS_portal используются многие проекты с открытым исходным кодом:

- Vue 3
- Vuex
- Vue Router
- AG Grid Vue
- JavaScript
- Python
- Vector

---

## Лицензия

Этот проект лицензирован под [Лицензией MIT](LICENSE), см. файл LICENSE для получения дополнительной информации.

---

## Авторы

- Monshou1251

---

## Контакты

Для связи с автором проекта, отправьте электронное письмо по адресу: grigory.urchenko@gmail.com
