CREATE SCHEMA IF NOT EXISTS AMS_PORTAL;

CREATE TABLE IF NOT EXISTS USERS (
    ID         DECIMAL(10,0) IDENTITY COMMENT IS 'ID пользователя',
    LOGIN_NAME VARCHAR(255) UTF8 COMMENT IS 'Логин пользователя',
    FIO        VARCHAR(255) UTF8 COMMENT IS 'ФИО пользователя',
    DEPARTMENT VARCHAR(255) UTF8 COMMENT IS 'Подразделение пользователя'
) COMMENT IS 'Справочник "Пользователи, имеющие доступ к web-порталу AMS"';

CREATE TABLE IF NOT EXISTS PORTAL_SHEETS (
    ID         DECIMAL(5,0) IDENTITY COMMENT IS 'ID страницы web-портала AMS',
    SHEET_NAME VARCHAR(255) UTF8 COMMENT IS 'Название страницы web-портала AMS'
) COMMENT IS 'Справочник "Страницы web-портала AMS"';

CREATE TABLE IF NOT EXISTS USER_ACCESS (
    ID       DECIMAL(10,0) IDENTITY COMMENT IS 'ID строки доступа',
    USER_ID  DECIMAL(10,0) COMMENT IS 'ID пользователя',
    SHEET_ID DECIMAL(5,0) COMMENT IS 'ID страницы web-портала AMS',
    ALLOWED  BOOLEAN COMMENT IS 'Доступ к странице разрешён (Да/Нет)'
);


