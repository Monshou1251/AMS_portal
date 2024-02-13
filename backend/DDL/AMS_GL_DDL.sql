CREATE SCHEMA IF NOT EXISTS AMS_GL;

CREATE TABLE IF NOT EXISTS INTEGRATION_CODE (
    INTEGRATION_CODE_SID      DECIMAL(5,0) IDENTITY,
    INTEGRATION_CODE          VARCHAR(128) UTF8 COMMENT IS 'INTEGRATION_CODE',
    INTEGRATION_CODE_NAME     VARCHAR(1024) UTF8 COMMENT IS 'Наименование кода интеграции',
    INSURANCE_TYPE_CODE       VARCHAR(32) UTF8,
    CONTRACT_TYPE_CHAIN_CODE  VARCHAR(32) UTF8,
    PERIOD_TYPE_CODE          VARCHAR(32) UTF8,
    SIGN_SUM_CODE             VARCHAR(32) UTF8,
    TYPE_CONTRACT_STATUS_CODE VARCHAR(32) UTF8,
    ACCRUALS_TYPE_CODE        VARCHAR(32) UTF8,
    REINSURANCE_TYPE_CODE     VARCHAR(32) UTF8,
    REINSURANCE_GROUP_CODE    VARCHAR(32) UTF8,
    FORM_TYPE_CODE            VARCHAR(32) UTF8,
    AMS_INTEGR_CODE           VARCHAR(256) UTF8 COMMENT IS 'INTEGRATION_CODE',
    AMS_DATE_CREATED          TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED         TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS SOURCE_SYSTEM (
    SYSTEM_SID        DECIMAL(3,0) IDENTITY COMMENT IS 'ID системы-источника',
    SYSTEM_NAME       VARCHAR(30) UTF8 COMMENT IS 'Наименование системы-источника',
    PARENT_SYSTEM_SID DECIMAL(3,0) COMMENT IS 'ID родительской системы',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'SYSTEM_NAME',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS'
);

CREATE TABLE IF NOT EXISTS ENTRY_TYPE (
    ENTRY_TYPE_SID    DECIMAL(5,0) IDENTITY COMMENT IS 'ID типа проводки (1 - все проводки, кроме комиссии, 2 - комиссия)',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'ID типа проводки в системе-источнике',
    ENTRY_TYPE_NAME   VARCHAR(40) UTF8 COMMENT IS 'Наименование типа проводки',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'SOURCE_ID',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DEPARTMENT (
    DEPARTMENT_SID    DECIMAL(10,0) IDENTITY COMMENT IS 'Подразделение ID (суррогатный ключ в AMS)',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'ID подразделения в системе-источнике',
    DEPARTMENT_CODE   VARCHAR(32) UTF8 COMMENT IS 'Код подразделения (филиала)',
    DEPARTMENT_NAME   VARCHAR(120) UTF8 COMMENT IS 'Аналитический счёт (наименование)',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'FIN_CODE',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS CURRENCY_RATE (
    CURRENCY_SID      DECIMAL(5,0) COMMENT IS 'Валюта SID в AMS',
    RATE_DATE         TIMESTAMP COMMENT IS 'Дата курса валюты',
    RATE              DECIMAL(25,10) COMMENT IS 'Курс валюты',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS SUBJECT (
    SUBJECT_SID                   DECIMAL(10,0) IDENTITY COMMENT IS 'Контрагент ID',
    SYSTEM_SID                    DECIMAL(3,0) COMMENT IS 'ID системы-источника',
    SOURCE_ID                     VARCHAR(32) UTF8 COMMENT IS 'ID контрагента в системе-источнике',
    SUBJECT_TYPE                  VARCHAR(20) UTF8 COMMENT IS 'Тип субъекта ',
    SUBJECT_NAME                  VARCHAR(255) UTF8 COMMENT IS 'Имя контрагента',
    SUBJECT_CDI_UID               DECIMAL(20,0) COMMENT IS 'HID из MDM',
    SUBJECT_AMS_UID               DECIMAL(10,0) COMMENT IS 'Унифицированный ID контрагента',
    INN                           VARCHAR(20) UTF8 COMMENT IS 'ИНН',
    SUBJECT_ABBR_NAME             VARCHAR(20) UTF8 COMMENT IS 'Сокращенное наименование юр.лица',
    SUBJECT_SHORT_NAME            VARCHAR(160) UTF8 COMMENT IS 'Краткое наименование юр.лица',
    SUBJECT_FULL_NAME             VARCHAR(2000) UTF8 COMMENT IS 'Полное наименование юр.лица',
    REGISTER_DATE                 TIMESTAMP COMMENT IS 'Дата регистрации',
    IS_RESIDENT                   DECIMAL(1,0) COMMENT IS 'Является ли резидентом?',
    VIP                           DECIMAL(5,0) COMMENT IS 'VIP',
    SUBJECT_NOTES                 VARCHAR(255) UTF8 COMMENT IS 'Примечания',
    KPP                           VARCHAR(20) UTF8 COMMENT IS 'КПП',
    EGR                           VARCHAR(30) UTF8 COMMENT IS 'ЕГР',
    OKPO                          VARCHAR(255) UTF8 COMMENT IS 'ОКПО',
    REGISTRATION_COUNTRY          VARCHAR(50) UTF8 COMMENT IS 'Страна регистрации',
    FIRST_NAME                    VARCHAR(75) UTF8 COMMENT IS 'Имя',
    MIDDLE_NAME                   VARCHAR(75) UTF8 COMMENT IS 'Отчество',
    LAST_NAME                     VARCHAR(100) UTF8 COMMENT IS 'Фамилия',
    BIRTH_DATE                    DATE COMMENT IS 'Дата рождения',
    BIRTH_PLACE                   VARCHAR(255) UTF8 COMMENT IS 'Место рождения',
    SEX                           VARCHAR(1) UTF8 COMMENT IS 'Пол',
    OGRN                          VARCHAR(50) UTF8 COMMENT IS 'ОГРН',
    AFFILATION_TO_RELATED_PARTIES VARCHAR(100) UTF8 COMMENT IS 'Принадлежность к связанным сторонам',
    BANK_REQUISITES               VARCHAR(100) UTF8 COMMENT IS 'Банковские реквизиты страхового контрагента',
    AMS_INTEGR_CODE               VARCHAR(128) UTF8 COMMENT IS 'SYSTEM_SID-SOURCE_ID',
    AMS_DATE_CREATED              TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED             TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS SUBJECT_1C (
    SUBJECT_1C_SID    DECIMAL(5,0) IDENTITY COMMENT IS 'Контрагент 1С SID',
    SOURCE_ID         VARCHAR(16) UTF8 COMMENT IS 'ID контрагента в системе-источнике',
    SUBJECT_1C_CODE   VARCHAR(20) UTF8 COMMENT IS 'Тип субъекта ',
    SUBJECT_1C_NAME   VARCHAR(255) UTF8 COMMENT IS 'Имя контрагента',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'FILES_SUBJECT.NAME',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS INS_CONTRACT (
    CONTRACT_SID      DECIMAL(18,0) IDENTITY COMMENT IS 'Договор страхования SID',
    SYSTEM_SID        DECIMAL(3,0) COMMENT IS 'SID системы-источника',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'ID договора страхования в системе-источнике',
    CONTRACT_ID       DECIMAL(10,0) COMMENT IS 'ID договора страхования в системе-источнике',
    CONTRACT_NUMBER   VARCHAR(50) UTF8 COMMENT IS 'Номер договора страхования',
    CONTRACT_SERIA    VARCHAR(10) UTF8 COMMENT IS 'Договор Серия',
    CONTRACT_TYPE     VARCHAR(50) UTF8 COMMENT IS 'Тип контракта',
    CONTRACT_OPTION   VARCHAR(50) UTF8 COMMENT IS 'Тип договора',
    DATE_SIGN         TIMESTAMP COMMENT IS 'Дата заключения',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'SYSTEM_SID-SOURCE_ID',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS LPU_INVOICE (
    LPU_INVOICE_SID    DECIMAL(18,0) IDENTITY COMMENT IS 'Счет на оплату ЛПУ SID',
    SYSTEM_SID         DECIMAL(3,0) COMMENT IS 'SID системы-источника',
    SOURCE_ID          VARCHAR(32) UTF8 COMMENT IS 'ID счёта на оплату ЛПУ в системе-источнике',
    LPU_INVOICE_NUMBER VARCHAR(32) UTF8 COMMENT IS 'Номер счёта на оплату ЛПУ',
    CREATED_DATE       DATE COMMENT IS 'Дата создания счёта на оплату ЛПУ',
    AMS_INTEGR_CODE    VARCHAR(128) UTF8 COMMENT IS 'SYSTEM_SID-SOURCE_ID',
    AMS_DATE_CREATED   TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED  TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS CLAIM_STATEMENT (
    CLAIM_STATEMENT_SID DECIMAL(18,0) IDENTITY COMMENT IS 'Дело по убытку ID (Суррогатный  ключ в AMS)',
    SYSTEM_SID          DECIMAL(3,0) COMMENT IS 'ID системы-источника',
    SOURCE_ID           VARCHAR(32) UTF8 COMMENT IS 'ID дела по убытку в системе-источнике',
    CLAIM_STATEMENT_ID  DECIMAL(10,0),
    FILE_NUMBER         VARCHAR(64) UTF8 COMMENT IS 'Номер дела по убытку',
    AMS_INTEGR_CODE     VARCHAR(128) UTF8 COMMENT IS 'SYSTEM_SID-SOURCE_ID',
    AMS_DATE_CREATED    TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED   TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS INS_OBJECT_TYPE (
    INS_OBJECT_TYPE_SID   DECIMAL(10,0) IDENTITY COMMENT IS 'ТОС ID',
    SOURCE_ID             VARCHAR(32) UTF8 COMMENT IS 'ID ТОС в системе-источнике',
    INS_OBJECT_TYPE_CODE  VARCHAR(10) UTF8 COMMENT IS 'Код ТОС',
    INS_OBJECT_TYPE_NAME  VARCHAR(100) UTF8 COMMENT IS 'Наименование ТОС',
    INS_OBJECT_TYPE_NOTES VARCHAR(250) UTF8 COMMENT IS 'Краткое название ТОС',
    AMS_INTEGR_CODE       VARCHAR(128) UTF8 COMMENT IS 'UNC_INS_OBJECT_TYPE.CODE',
    AMS_DATE_CREATED      TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED     TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS PL_ITEM (
    PL_ITEM_SID                 DECIMAL(10,0) IDENTITY COMMENT IS 'Прочие доходы и расходы Статья SID',
    SOURCE_ID                   VARCHAR(32) UTF8 COMMENT IS 'ID статьи прочих доходов и расходов в системе-источнике',
    PL_ITEM_CODE                VARCHAR(32) UTF8 COMMENT IS 'Код статьи прочих доходов и расходов',
    PL_ITEM_NAME                VARCHAR(200) UTF8 COMMENT IS 'Наименование статьи прочих доходов и расходов',
    OFR_CODE                    VARCHAR(10) UTF8 COMMENT IS 'Символ ОФР',
    ACCEPTED_FOR_TAX_ACCOUNTING DECIMAL(1,0) COMMENT IS 'Принимается к НУ',
    INSURANCE_TYPE              VARCHAR(30) UTF8 COMMENT IS 'Тип страхования (из колонки Группа)',
    AMS_INTEGR_CODE             VARCHAR(128) UTF8 COMMENT IS 'PL_ITEM_CODE',
    AMS_DATE_CREATED            TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED           TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS BUSINESS_LINE (
    BUSINESS_LINE_SID        DECIMAL(10,0) IDENTITY COMMENT IS 'Линия бизнеса SID',
    SOURCE_ID                VARCHAR(32) UTF8 COMMENT IS 'ID линии бизнеса в системе-источнике',
    BUSINESS_LINE_CODE       VARCHAR(32) UTF8 COMMENT IS 'Код линии бизнеса',
    BUSINESS_LINE_NAME       VARCHAR(512) UTF8 COMMENT IS 'Наименование линии бизнеса',
    BUSINESS_LINE_SHORT_NAME VARCHAR(64) UTF8 COMMENT IS 'Краткое наименование линии бизнеса',
    AMS_INTEGR_CODE          VARCHAR(128) UTF8 COMMENT IS 'Код для интеграции справочника с другими системами',
    AMS_DATE_CREATED         TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED        TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS SETTLEMENT_TYPE (
    SETTLEMENT_TYPE_SID  DECIMAL(10,0) IDENTITY COMMENT IS 'Вид расчёта по страховым операциям SID',
    SOURCE_ID            VARCHAR(32) UTF8 COMMENT IS 'ID вида расчёта по страховым операциям в системе-источнике 1С (поле "Код в 1С")',
    SETTLEMENT_TYPE_CODE VARCHAR(32) UTF8 COMMENT IS 'Код вида расчёта по страховым операциям  (поле "Код в 1С")',
    SETTLEMENT_TYPE_NAME VARCHAR(110) UTF8 COMMENT IS 'Наименование вида расчёта по страховым операциям',
    IS_TRANSIT           DECIMAL(1,0) COMMENT IS 'Является транзитным (1 - Да, 0 - Нет)',
    AMS_INTEGR_CODE      VARCHAR(128) UTF8 COMMENT IS 'AMS_INTEGR_CODE = SOURCE_ID (поле "Код в 1С")',
    AMS_DATE_CREATED     TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED    TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS INS_RESERVE (
    INS_RESERVE_SID   DECIMAL(10,0) IDENTITY COMMENT IS 'Страховой резерв SID',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'ID страхового резерва в системе-источнике 1С',
    INS_RESERVE_CODE  VARCHAR(10) UTF8 COMMENT IS 'Код страхового резерва',
    INS_RESERVE_NAME  VARCHAR(100) UTF8 COMMENT IS 'Наименование страхового резерва',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'INS_RESERVE_NAME',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS PROVISION (
    PROVISION_SID     DECIMAL(10,0) IDENTITY COMMENT IS 'Оценочные обязательства и резервы - суррогатный ID',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'ID оценочного обязательства и резерва в системе-источнике 1С',
    PROVISION_CODE    VARCHAR(10) UTF8 COMMENT IS 'Код оценочного обязательства и резерва',
    PROVISION_NAME    VARCHAR(100) UTF8 COMMENT IS 'Наименование оценочного обязательства и резерва',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'PROVISION_NAME',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS GL_ACCOUNT_2 (
    GL_ACCOUNT_2_SID  DECIMAL(17,0) IDENTITY COMMENT IS 'Суррогатный ID счёта  Парус-C в AMS',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'RN счёта в плане счетов в Парус-C',
    ACC_NUMBER        VARCHAR(40) UTF8 COMMENT IS 'Номер счёта Парус-C',
    ACC_NAME          VARCHAR(240) UTF8 COMMENT IS 'Название счёта Парус-C',
    ACC_TYPE          VARCHAR(20) UTF8 COMMENT IS 'Тип учёта (бухгалтерский, налоговый, бюджет)',
    ACC_BALANCE       DECIMAL(1,0) COMMENT IS 'Признак балансового счёта, 1 - балансовый, 0 - небалансовый',
    ACC_FORM_CODE     DECIMAL(15,0) COMMENT IS 'Числовой код типовой формы аналитического учёта',
    ACC_FORM_NAME     VARCHAR(80) UTF8 COMMENT IS 'Название типовой формы аналитического учёта',
    IS_CURRENCY       DECIMAL(1,0) COMMENT IS 'Признак, что на счёте ведётся валютный учёт (1 - Да, 0 - Нет)',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'ACC_NUMBER',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS GL_ACCOUNT_5 (
    GL_ACCOUNT_5_SID  DECIMAL(17,0) IDENTITY COMMENT IS 'Суррогатный ID счёта Парус-F в AMS',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'RN счёта в плане счетов в Парус-F',
    ACC_NUMBER        VARCHAR(40) UTF8 COMMENT IS 'Номер счёта Парус-F',
    ACC_NAME          VARCHAR(240) UTF8 COMMENT IS 'Название счёта Парус-F',
    ACC_TYPE          VARCHAR(20) UTF8 COMMENT IS 'Тип учёта (бухгалтерский, налоговый, бюджет)',
    ACC_BALANCE       DECIMAL(1,0) COMMENT IS 'Признак балансового счёта, 1 - балансовый, 0 - небалансовый',
    ACC_FORM_CODE     DECIMAL(15,0) COMMENT IS 'Числовой код формы счёта',
    ACC_FORM_NAME     VARCHAR(80) UTF8 COMMENT IS 'Название формы счёта',
    IS_CURRENCY       DECIMAL(1,0) COMMENT IS 'Признак, что на счёте ведётся валютный учёт (1 - Да, 0 - Нет)',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'ACC_NUMBER',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS GL_ACCOUNT (
    GL_ACCOUNT_SID    DECIMAL(5,0) IDENTITY COMMENT IS 'ID счёта 1C',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'ID счёта в плане счетов в 1С',
    ACC_NUMBER        VARCHAR(5) UTF8 COMMENT IS 'Номер счёта 1C',
    ACC_NAME          VARCHAR(200) UTF8 COMMENT IS 'Название счёта 1C',
    ACC_KIND          VARCHAR(50) UTF8 COMMENT IS 'Вид счёта 1С',
    ACC_TYPE          VARCHAR(20) UTF8 COMMENT IS 'Тип учёта (бухгалтерский, налоговый, бюджет)',
    ACC_BALANCE       DECIMAL(1,0) COMMENT IS 'Признак балансового счёта',
    IS_CURRENCY       DECIMAL(1,0) COMMENT IS 'Признак, что на счёте ведётся валютный учёт',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'ACC_NUMBER',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DGL_INS_JRNL_BUFFER (
    SYSTEM_SID                DECIMAL(5,0) COMMENT IS 'SID источника',
    PARENT_SYSTEM_SID         DECIMAL(5,0) COMMENT IS 'SID родительской системы-источника',
    SOURCE_ID                 VARCHAR(32) UTF8 COMMENT IS 'ID строки журнала в системе-источнике',
    ENTRY_TYPE_ID             DECIMAL(5,0) COMMENT IS 'Тип проводки SID',
    BUFFER_SID                DECIMAL(18,0) COMMENT IS 'SID записи в буфере',
    INTEGRATION_ROW_TYPE_CODE VARCHAR(128) UTF8 COMMENT IS 'Код интеграции',
    ENTRY_DATE                DATE COMMENT IS 'Дата операции',
    ACCOUNT_2_DT              VARCHAR(32) UTF8 COMMENT IS 'Счёт 2-х значного плана счетов Дт',
    ACCOUNT_2_CR              VARCHAR(32) UTF8 COMMENT IS 'Счёт 2-х значного плана счетов Кт',
    ACCOUNT_DT                VARCHAR(32) UTF8 COMMENT IS 'Счёт плана счетов 1С Дт',
    ACCOUNT_CR                VARCHAR(32) UTF8 COMMENT IS 'Счёт плана счетов 1С Кт',
    CURRENCY                  VARCHAR(3) UTF8 COMMENT IS 'Валюта операции',
    INS_CONTRACT              VARCHAR(32) UTF8 COMMENT IS 'Договор страхования ID',
    REINS_CONTRACT            VARCHAR(32) UTF8 COMMENT IS 'Договор перестрахования ID',
    INS_POLICY                VARCHAR(32) UTF8 COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT           VARCHAR(32) UTF8 COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_DT             VARCHAR(32) UTF8 COMMENT IS 'Подразделение Дт',
    DEPARTMENT_CR             VARCHAR(32) UTF8 COMMENT IS 'Подразделение Кт',
    AMOUNT                    DECIMAL(18,2) COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE               DECIMAL(18,2) COMMENT IS 'Сумма в рублях',
    AMOUNT_NU                 DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR                 DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR                 DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    CHANGE_ACC_2_DT_CR        VARCHAR(4) UTF8 COMMENT IS 'Смена аналитик и суммы для двузначки (1 - Да, 0 - Нет)',
    PL_ITEM_DT                VARCHAR(32) UTF8 COMMENT IS 'Прочие доходы и расходы Дт',
    PL_ITEM_CR                VARCHAR(32) UTF8 COMMENT IS 'Прочие доходы и расходы Кт',
    SETTLEMENT_TYPE_DT        VARCHAR(32) UTF8 COMMENT IS 'Виды расчётов по страховым операциям Дт',
    SETTLEMENT_TYPE_CR        VARCHAR(32) UTF8 COMMENT IS 'Виды расчётов по страховым операциям Кт',
    SUBJECT_1C_DT             VARCHAR(32) UTF8 COMMENT IS 'Контрагент 1С Дт',
    SUBJECT_1C_CR             VARCHAR(32) UTF8 COMMENT IS 'Контрагент 1С Кт',
    TOC_DT                    VARCHAR(32) UTF8 COMMENT IS 'ТОС Дт',
    TOC_CR                    VARCHAR(32) UTF8 COMMENT IS 'ТОС Кт',
    SUBJECT_DT                VARCHAR(32) UTF8 COMMENT IS 'Контрагент Дт',
    SUBJECT_CR                VARCHAR(32) UTF8 COMMENT IS 'Контрагент Кт',
    BUSINESS_LINE_DT          VARCHAR(32) UTF8 COMMENT IS 'Линия бизнеса Дт',
    BUSINESS_LINE_CR          VARCHAR(32) UTF8 COMMENT IS 'Линия бизнеса Кт',
    COOLOFF_PARTNER_DT        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Партнёр Дт',
    COOLOFF_PARTNER_CR        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Партнёр Кт',
    COOLOFF_PRODUCT_DT        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Продукт Дт',
    COOLOFF_PRODUCT_CR        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Продукт Кт',
    PAYDOC_DT                 VARCHAR(32) UTF8 COMMENT IS 'Платёжный документ Дт',
    PAYDOC_CR                 VARCHAR(32) UTF8 COMMENT IS 'Платёжный документ Кт',
    CREATE_OPERATION          DECIMAL(1,0) COMMENT IS 'Флаг создания прямой проводки',
    CREATE_STORNO             DECIMAL(1,0) COMMENT IS 'Флаг создания сторно проводки'
);

CREATE TABLE IF NOT EXISTS GL_DIMENSION (
    DIM_SID           DECIMAL(5,0) IDENTITY COMMENT IS 'SID справочника аналитики',
    DIM_NAME          VARCHAR(100) UTF8 COMMENT IS 'Наименование справочника аналитики',
    TABLE_NAME        VARCHAR(100) UTF8 COMMENT IS 'Наименование таблицы справочника в AMS',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS AGL_ENTRY_BUFFER (
    AGL_ENTRY_SID       CHAR(32) UTF8 COMMENT IS 'SID проводки АГК',
    SYSTEM_NAME         VARCHAR(26) UTF8 COMMENT IS 'Наименование системы-источника',
    ENTRY_DATE          DATE COMMENT IS 'Дата операции',
    ACCOUNT_DT          VARCHAR(256) UTF8 COMMENT IS 'СчётДт 1С ID',
    ACCOUNT_CR          VARCHAR(256) UTF8 COMMENT IS 'СчётКт 1С ID',
    CURRENCY            VARCHAR(256) UTF8 COMMENT IS 'Валюта операции ',
    AGG_PERS_ACCOUNT_DT VARCHAR(20) UTF8 COMMENT IS 'Агрегированный лицевой счёт Дт',
    AGG_PERS_ACCOUNT_CR VARCHAR(20) UTF8 COMMENT IS 'Агрегированный лицевой счёт Кт',
    DEPARTMENT_DT       VARCHAR(256) UTF8 COMMENT IS 'Подразделение Дт',
    DEPARTMENT_CR       VARCHAR(256) UTF8 COMMENT IS 'Подразделение Кт',
    BUSINESS_LINE_DT    VARCHAR(256) UTF8 COMMENT IS 'Линия Бизнеса Дт',
    BUSINESS_LINE_CR    VARCHAR(256) UTF8 COMMENT IS 'Линия Бизнеса Кт',
    PL_ITEM_DT          VARCHAR(256) UTF8 COMMENT IS 'Прочие Доходы и Расходы Дт',
    PL_ITEM_CR          VARCHAR(256) UTF8 COMMENT IS 'Прочие Доходы и Расходы Кт',
    ST_TYPE_DT          VARCHAR(256) UTF8 COMMENT IS 'Виды расчетов по страховым операциям Дт',
    ST_TYPE_CR          VARCHAR(256) UTF8 COMMENT IS 'Виды расчетов по страховым операциям Кт',
    SUBJECT_1C_DT       VARCHAR(256) UTF8 COMMENT IS 'Контрагент 1С Дт',
    SUBJECT_1C_CR       VARCHAR(256) UTF8 COMMENT IS 'Контрагент 1С Кт',
    AMOUNT              DECIMAL(18,2) COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE         DECIMAL(18,2) COMMENT IS 'Сумма в рублях',
    AMOUNT_NU           DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR           DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR           DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    AMS_DATE_CREATED    TIMESTAMP COMMENT IS 'Дата создания в AMS'
);

CREATE TABLE IF NOT EXISTS AMS_UPDATE_STATUS (
    SYSTEM_SID    DECIMAL(3,0),
    LAST_READ_DTS TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ACC_PERIODS (
    PERIOD_START        DATE,
    PERIOD_IS_CLOSED_1  DECIMAL(1,0),
    PERIOD_IS_CLOSED_2  DECIMAL(1,0),
    AMS_DATE_MODIFIED_1 TIMESTAMP,
    AMS_DATE_MODIFIED_2 TIMESTAMP
);

CREATE TABLE IF NOT EXISTS INT_CODE_MAP (
    "ID строки мэппинга"                      DECIMAL(10,0),
    INT_INTEGRATION_ROW_TYPE_CODE           VARCHAR(64) UTF8,
    "Сообщения Unicus"                        VARCHAR(64) UTF8,
    "Вид страховой операции"                  VARCHAR(64) UTF8,
    "Фильтр по Линии бизнеса"                 VARCHAR(8) UTF8,
    "Коэффициент пересчёта суммы проводки"    DECIMAL(36,10),
    "Смена аналитик и суммы для двузначки"    VARCHAR(4) UTF8,
    "СчётДТ 1C ДГК"                           VARCHAR(5) UTF8,
    "СчётКТ 1C ДГК"                           VARCHAR(5) UTF8,
    "Счет 2зн ДТ"                             VARCHAR(32) UTF8,
    "Учитывать Тип Валюты ДТ"                 DECIMAL(1,0),
    "Счет 2зн КТ"                             VARCHAR(32) UTF8,
    "Учитывать Тип Валюты КТ"                 DECIMAL(1,0),
    "Журнал"                                  VARCHAR(32) UTF8,
    "Дата операции"                           VARCHAR(32) UTF8,
    "Подразделение"                           VARCHAR(8) UTF8,
    "Подразделение Дт"                        VARCHAR(32) UTF8,
    "Подразделение Кт"                        VARCHAR(32) UTF8,
    "Валюта"                                  VARCHAR(32) UTF8,
    "Контрагент"                              VARCHAR(8) UTF8,
    "Контрагент Дт"                           VARCHAR(64) UTF8,
    "Контрагент Кт"                           VARCHAR(64) UTF8,
    "Контрагент 1С"                           VARCHAR(8) UTF8,
    "Контрагент 1С Дт"                        VARCHAR(32) UTF8,
    "Контрагент 1С Кт"                        VARCHAR(32) UTF8,
    "Договор страхования"                     VARCHAR(64) UTF8,
    "Договор перестрахования"                 VARCHAR(32) UTF8,
    "Страховой полис"                         VARCHAR(128) UTF8,
    "Счет на оплату ЛПУ"                      VARCHAR(16) UTF8,
    "Платежный документ"                      VARCHAR(8) UTF8,
    "Платежный документ Дт"                   VARCHAR(32) UTF8,
    "Платежный документ Кт"                   VARCHAR(32) UTF8,
    "Дело по убытку"                          VARCHAR(32) UTF8,
    "Виды расчетов по страховым операциям"    VARCHAR(8) UTF8,
    "Виды расчетов по страховым операциям Дт" VARCHAR(32) UTF8,
    "Виды расчетов по страховым операциям Кт" VARCHAR(32) UTF8,
    "Прочие доходы и расходы"                 VARCHAR(8) UTF8,
    "Прочие доходы и расходы Дт"              DECIMAL(10,0),
    "Прочие доходы и расходы Кт"              DECIMAL(10,0),
    "Линии бизнеса"                           VARCHAR(8) UTF8,
    "Линии бизнеса Дт"                        VARCHAR(32) UTF8,
    "Линии бизнеса Кт"                        VARCHAR(32) UTF8,
    "Кулл-офф Партнеры"                       VARCHAR(8) UTF8,
    "Кулл-офф Партнеры Дт"                    VARCHAR(32) UTF8,
    "Кулл-офф Партнеры Кт"                    VARCHAR(32) UTF8,
    "Кулл-офф Продукты"                       VARCHAR(8) UTF8,
    "Кулл-офф Продукты Дт"                    VARCHAR(32) UTF8,
    "Кулл-офф Продукты Кт"                    VARCHAR(32) UTF8,
    "ТОС"                                     VARCHAR(8) UTF8,
    "ТОС Дт"                                  VARCHAR(128) UTF8,
    "ТОС Кт"                                  VARCHAR(128) UTF8,
    "Сумма Вал"                               VARCHAR(32) UTF8,
    "Сумма Руб"                               VARCHAR(32) UTF8,
    "Сумма Регл НУ"                           VARCHAR(32) UTF8,
    "Сумма Регл ВР"                           VARCHAR(32) UTF8,
    "Сумма Регл ПР"                           VARCHAR(32) UTF8,
    "Транзитный счет 2зн по умолчанию"        VARCHAR(32) UTF8,
    "Транзитный счет по умолчанию"            VARCHAR(5) UTF8,
    "Виды расчетов по умолчанию"              VARCHAR(32) UTF8
);

CREATE TABLE IF NOT EXISTS PAY_INT_CODE_MAP (
    "Парус-F Тип"                              VARCHAR(4) UTF8,
    "Парус-F Счет"                             VARCHAR(12) UTF8,
    "Парус-F Знак"                             DECIMAL(1,0),
    INTEGRATION_DOC_TYPE_CODE                VARCHAR(32) UTF8,
    INTEGRATION_DOC_TYPE_DESC                VARCHAR(128) UTF8,
    "ДГК Тип"                                  VARCHAR(4) UTF8,
    "ДГК Знак"                                 DECIMAL(1,0),
    "ДГК Парус-С Счет"                         VARCHAR(12) UTF8,
    "ДГК 1С Счет"                              VARCHAR(12) UTF8,
    "ДКГ Виды расчетов по страховым операциям" VARCHAR(12) UTF8
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY_DIMS_BUFFER (
    BUFFER_SID DECIMAL(18,0) COMMENT IS 'SID строки в буфере',
    DT_CR      DECIMAL(1,0) COMMENT IS 'Признак ДтКт (0 - Дебет, 1 - Кредит)',
    DIM_SID    DECIMAL(5,0) COMMENT IS 'SID справочника',
    VALUE_SID  DECIMAL(10,0) COMMENT IS 'SID значения аналитики'
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY_EXCEPTIONS (
    DGL_ENTRY_BUFFER_SID DECIMAL(18,0) IDENTITY COMMENT IS 'SID проводки в буферной таблице',
    SYSTEM_SID           DECIMAL(5,0) COMMENT IS 'SID источника',
    SOURCE_ID            VARCHAR(32) UTF8 COMMENT IS 'ID строки журнала в системе-источнике',
    ENTRY_TYPE_SID       DECIMAL(5,0) COMMENT IS 'Тип проводки SID',
    BUFFER_SID           DECIMAL(18,0) COMMENT IS 'SID записи в буфере',
    ENTRY_DATE           DATE COMMENT IS 'Дата операции',
    ACCOUNT_2_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Дт',
    ACCOUNT_2_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Кт',
    ACCOUNT_5_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Дт',
    ACCOUNT_5_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Кт',
    ACCOUNT_DT_SID       DECIMAL(5,0) COMMENT IS 'Счёт 1С ID Дт',
    ACCOUNT_CR_SID       DECIMAL(5,0) COMMENT IS 'Счёт 1С ID Кт',
    CURRENCY_SID         DECIMAL(5,0) COMMENT IS 'Валюта операции ID',
    DET_PERS_ACCOUNT_DT  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Дт',
    DET_PERS_ACCOUNT_CR  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Кт',
    INS_CONTRACT_SID     DECIMAL(18,0) COMMENT IS 'Договор страхования ID',
    REINS_CONTRACT_SID   DECIMAL(18,0) COMMENT IS 'Договор перестрахования ID',
    INS_POLICY_SID       DECIMAL(18,0) COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT_SID  DECIMAL(10,0) COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_DT_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Дт',
    DEPARTMENT_CR_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Кт',
    AMOUNT               DECIMAL(18,2) COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE          DECIMAL(18,2) COMMENT IS 'Сумма в рублях',
    AMOUNT_NU            DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR            DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR            DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    OPERATION_CONTENT    VARCHAR(200) UTF8 COMMENT IS 'Содержание операции',
    CHANGE_ACC_2_DT_CR   DECIMAL(1,0) COMMENT IS 'Смена аналитик и суммы для двузначки (1 - Да, 0 - Нет)',
    INTEGRATION_CODE_SID DECIMAL(5,0) COMMENT IS 'ID кода интеграции',
    AGL_ENTRY_SID        CHAR(32) UTF8 COMMENT IS 'ID проводки АГК',
    IS_SOURCE_UPDATE     DECIMAL(1,0) COMMENT IS 'Флаг: является ли операция результатом обновления более ранней записи? (Да/Нет)'
);

CREATE TABLE IF NOT EXISTS COOLOFF_PRODUCT (
    COOLOFF_PRODUCT_SID DECIMAL(10,0) IDENTITY COMMENT IS 'Кулл-офф Продукт SID',
    SOURCE_ID           VARCHAR(32) UTF8 COMMENT IS 'ID Кулл-офф Продукта в системе-источнике',
    PRODUCT_NUMBER      VARCHAR(40) UTF8 COMMENT IS 'Номер Кулл-офф Продукта',
    PRODUCT_NAME        VARCHAR(240) UTF8 COMMENT IS 'Наименование Кулл-офф Продукта',
    AMS_INTEGR_CODE     VARCHAR(128) UTF8 COMMENT IS 'PRODUCT_NAME',
    AMS_DATE_CREATED    TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED   TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS COOLOFF_PARTNER (
    COOLOFF_PARTNER_SID DECIMAL(10,0) IDENTITY COMMENT IS 'Кулл-офф Партнер ID',
    SOURCE_ID           VARCHAR(32) UTF8 COMMENT IS 'ID Кулл-офф Партнера в системе-источнике',
    PARTNER_NUMBER      VARCHAR(40) UTF8 COMMENT IS 'Номер Кулл-офф Партнера',
    PARTNER_NAME        VARCHAR(240) UTF8 COMMENT IS 'Наименование Кулл-офф Партнера',
    AMS_INTEGR_CODE     VARCHAR(128) UTF8 COMMENT IS 'PARTNER_NAME',
    AMS_DATE_CREATED    TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED   TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS PAYDOC (
    PAYDOC_SID        DECIMAL(10,0) IDENTITY COMMENT IS 'Платёжный документ SID',
    SOURCE_ID         CHAR(32) ASCII COMMENT IS 'HASH_MD5(PBUHF_DOCTYPES.DOCCODE, PBUHF_ECONOPRS.FACT_DOCNUMB, PBUHF_ECONOPRS.FACT_DOCDATE)',
    PAYDOC_TYPE_CODE  VARCHAR(10) UTF8 COMMENT IS 'Код типа платёжного документа',
    PAYDOC_TYPE_NAME  VARCHAR(80) UTF8 COMMENT IS 'Наименование типа платёжного документа',
    PAYDOC_NUMBER     VARCHAR(240) UTF8 COMMENT IS 'Номер платёжного документа',
    PAYDOC_DATE       TIMESTAMP COMMENT IS 'Дата платёжного документа',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'PAYDOC_TYPE_CODE|PAYDOC_NUMBER|PAYDOC_DATE',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS INS_POLICY (
    POLICY_SID           DECIMAL(18,0) IDENTITY COMMENT IS 'SID полиса',
    SYSTEM_SID           DECIMAL(3,0) COMMENT IS 'SID системы-источника',
    SOURCE_ID            VARCHAR(32) UTF8 COMMENT IS 'ID полиса в системе-источнике',
    POLICY_ID            VARCHAR(32) UTF8 COMMENT IS 'ID полиса в системе-источнике',
    INSURANCE_LIMIT      DECIMAL(25,5) COMMENT IS 'Полис Страховая Сумма',
    LIABILITY_BEGIN_DATE TIMESTAMP COMMENT IS 'Полис Дата Начала Ответственности',
    LIABILITY_END_DATE   TIMESTAMP COMMENT IS 'Полис Дата Окончания Ответственности',
    INSURANCE_AMOUNT     DECIMAL(20,5),
    INSURANCE_PREMIUM    DECIMAL(15,2) COMMENT IS 'Полис Страховая Премия (Риск)',
    POLICY_NUMBER        VARCHAR(50) UTF8 COMMENT IS 'Полис Номер',
    AMS_INTEGR_CODE      VARCHAR(128) UTF8 COMMENT IS 'SYSTEM_SID-SOURCE_ID',
    AMS_DATE_CREATED     TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED    TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY_DIMS (
    DGL_ENTRY_SID DECIMAL(18,0) COMMENT IS 'SID проводки ДГК',
    DT_CR         DECIMAL(1,0) COMMENT IS 'Признак ДтКт (0 - Дебет, 1 - Кредит)',
    DIM_SID       DECIMAL(5,0) COMMENT IS 'SID справочника',
    VALUE_SID     DECIMAL(10,0) COMMENT IS 'SID значения аналитики'
);

CREATE TABLE IF NOT EXISTS XLSX_DGL_BUFFER (
    SOURCE_FILE_NAME   VARCHAR(200) UTF8 COMMENT IS 'Название файла-источника',
    SHEET_NAME         VARCHAR(64) UTF8 COMMENT IS 'Название листа в файле-источнике',
    USER_NAME          VARCHAR(50) UTF8 COMMENT IS 'Логин пользователя',
    LOAD_TIMESTAMP     TIMESTAMP COMMENT IS 'Дата + время загрузки данных из файла',
    LINE_ID            VARCHAR(32) UTF8 COMMENT IS 'ID строки в файле-источнике',
    ENTRY_DATE         VARCHAR(32) UTF8 COMMENT IS 'Дата проводки',
    GL_ACCOUNT_2_DT    VARCHAR(32) UTF8 COMMENT IS 'Код номера 2-х значного счёта Дт',
    GL_ACCOUNT_2_CR    VARCHAR(32) UTF8 COMMENT IS 'Код номера 2-х значного счёта Кт',
    GL_ACCOUNT_DT      VARCHAR(32) UTF8 COMMENT IS 'Код номера счёта 1С Дт',
    GL_ACCOUNT_CR      VARCHAR(32) UTF8 COMMENT IS 'Код номера счёта 1С Кт',
    CURRENCY           VARCHAR(3) UTF8 COMMENT IS 'Код валюты',
    INS_CONTRACT_ID    VARCHAR(32) UTF8 COMMENT IS 'ID договора',
    REINS_CONTRACT_ID  VARCHAR(32) UTF8 COMMENT IS 'ID договора перестрахования',
    INS_POLICY_ID      VARCHAR(32) UTF8 COMMENT IS 'ID страхового полиса',
    CLAIM_STATEMENT_ID VARCHAR(32) UTF8 COMMENT IS 'ID Дела по убытку',
    DEPARTMENT_DT      VARCHAR(32) UTF8 COMMENT IS 'Код подразделения Дт',
    DEPARTMENT_CR      VARCHAR(32) UTF8 COMMENT IS 'Код подразделения Кт',
    AMOUNT             VARCHAR(32) UTF8 COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE        VARCHAR(32) UTF8 COMMENT IS 'Сумма в рублях',
    AMOUNT_NU          VARCHAR(32) UTF8 COMMENT IS 'Сумма НУ',
    AMOUNT_VR          VARCHAR(32) UTF8 COMMENT IS 'Сумма ВР',
    AMOUNT_PR          VARCHAR(32) UTF8 COMMENT IS 'Сумма ПР',
    OPERATION_CONTENT  VARCHAR(200) UTF8 COMMENT IS 'Содержание проводки',
    PL_ITEM_DT         VARCHAR(32) UTF8 COMMENT IS 'Код прочих доходов и расходов Дт',
    PL_ITEM_CR         VARCHAR(32) UTF8 COMMENT IS 'Код прочих доходов и расходов Кт',
    SETTLEMENT_TYPE_DT VARCHAR(32) UTF8 COMMENT IS 'Код вида расчёта по страховым операциям Дт',
    SETTLEMENT_TYPE_CR VARCHAR(32) UTF8 COMMENT IS 'Код вида расчёта по страховым операциям Кт',
    SUBJECT_1C_DT      VARCHAR(32) UTF8 COMMENT IS 'Код контрагента 1С Дт',
    SUBJECT_1C_CR      VARCHAR(32) UTF8 COMMENT IS 'Код контрагента 1С Кт',
    TOC_DT             VARCHAR(32) UTF8 COMMENT IS 'Код ТОС Дт',
    TOC_CR             VARCHAR(32) UTF8 COMMENT IS 'Код ТОС Кт',
    SUBJECT_ID_DT      VARCHAR(32) UTF8 COMMENT IS 'ID контрагента Дт',
    SUBJECT_ID_CR      VARCHAR(32) UTF8 COMMENT IS 'ID контрагента Кт',
    BUSINESS_LINE_DT   VARCHAR(32) UTF8 COMMENT IS 'Код линии бизнеса Дт',
    BUSINESS_LINE_CR   VARCHAR(32) UTF8 COMMENT IS 'Код линии бизнеса Кт',
    COOLOFF_PARTNER_DT VARCHAR(50) UTF8 COMMENT IS 'Код COOLOFF партнёра Дт',
    COOLOFF_PARTNER_CR VARCHAR(50) UTF8 COMMENT IS 'Код COOLOFF партнёра Кт',
    COOLOFF_PRODUCT_DT VARCHAR(75) UTF8 COMMENT IS 'Код COOLOFF продукта Дт',
    COOLOFF_PRODUCT_CR VARCHAR(75) UTF8 COMMENT IS 'Код COOLOFF продукта Кт',
    PAYDOC_DT          VARCHAR(50) UTF8 COMMENT IS 'ID платёжного документа Дт',
    PAYDOC_CR          VARCHAR(50) UTF8 COMMENT IS 'ID платёжного документа Кт'
);

CREATE TABLE IF NOT EXISTS DGL_JOURNAL_INFO (
    DGL_JOURNAL_INFO_SID   DECIMAL(18,0) IDENTITY COMMENT IS 'ID загрузки',
    SOURCE_FILE_NAME       VARCHAR(250) UTF8 COMMENT IS 'Название файла-источника с полным путем',
    SHEET_NAME             VARCHAR(100) UTF8 COMMENT IS 'Название листа в файле-источнике',
    USER_NAME              VARCHAR(50) UTF8 COMMENT IS 'Логин пользователя, выполнившего загрузку проводок из файла',
    ENTRIES_BATCH_CONTENT  VARCHAR(250) UTF8 COMMENT IS 'Содержание пакета проводок',
    ENTRIES_BATCH_TYPE     VARCHAR(100) UTF8 COMMENT IS 'Тип пакета проводок',
    ENTRIES_BATCH_GROUP_ID DECIMAL(10,0) COMMENT IS 'ID группы пакетов проводок',
    LOAD_TIMESTAMP         TIMESTAMP COMMENT IS 'Таймстемп начала процесса загрузки проводок из файла',
    ROWS_COUNT             DECIMAL(8,0) COMMENT IS 'Количество загруженных из файла строк',
    IS_ACTIVE              DECIMAL(1,0) COMMENT IS 'Флаг, что загруженные из файла проводки являются активными (0 - Нет, 1 - Да)',
    AMS_DATE_CREATED       TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED      TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DGL_JOURNAL_ENTRY (
    DGL_JOURNAL_ENTRY_SID  DECIMAL(18,0) IDENTITY COMMENT IS 'ID строки таблицы',
    DGL_JOURNAL_INFO_SID   DECIMAL(10,0) COMMENT IS 'ID файла-источника в таблице EXT_FILES_INFO',
    LINE_ID                DECIMAL(10,0) COMMENT IS 'ID строки в файле-источнике',
    ENTRY_DATE             DATE COMMENT IS 'Дата проводки',
    ENTRY_TYPE_SID         DECIMAL(5,0) COMMENT IS 'ID типа проводки',
    ACCOUNT_2_DT_SID       DECIMAL(5,0) COMMENT IS '2-х значный счёт ID Дт',
    ACCOUNT_2_CR_SID       DECIMAL(5,0) COMMENT IS '2-х значный счёт ID Кт',
    ACCOUNT_DT_SID         DECIMAL(5,0) COMMENT IS 'Счёт 1С ID Дт',
    ACCOUNT_CR_SID         DECIMAL(5,0) COMMENT IS 'Счёт 1С ID Кт',
    CURRENCY_SID           DECIMAL(5,0) COMMENT IS 'Валюта ID',
    DET_PERS_ACCOUNT_DT    VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт Дт',
    DET_PERS_ACCOUNT_CR    VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт Кт',
    INS_CONTRACT_SID       DECIMAL(18,0) COMMENT IS 'Страховой договор ID',
    REINS_CONTRACT_SID     DECIMAL(18,0) COMMENT IS 'Договор перестрахования ID',
    INS_POLICY_SID         DECIMAL(18,0) COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT_SID    DECIMAL(10,0) COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_SID_DT      DECIMAL(5,0) COMMENT IS 'Подразделение ID Дт',
    DEPARTMENT_SID_CR      DECIMAL(5,0) COMMENT IS 'Подразделение ID Кт',
    AMOUNT                 DECIMAL(18,2) COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE            DECIMAL(18,2) COMMENT IS 'Сумма в рублях',
    AMOUNT_NU              DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR              DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR              DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    OPERATION_CONTENT      VARCHAR(200) UTF8 COMMENT IS 'Содержание проводки',
    PL_ITEM_SID_DT         DECIMAL(5,0) COMMENT IS 'Прочие доходы и расходы Дт',
    PL_ITEM_SID_CR         DECIMAL(5,0) COMMENT IS 'Прочие доходы и расходы Кт',
    SETTLEMENT_TYPE_SID_DT DECIMAL(5,0) COMMENT IS 'Вид расчётов по страховым операциям Дт',
    SETTLEMENT_TYPE_SID_CR DECIMAL(5,0) COMMENT IS 'Вид расчётов по страховым операциям Кт',
    SUBJECT_1C_SID_DT      DECIMAL(10,0) COMMENT IS 'Контрагент 1С ID Дт',
    SUBJECT_1C_SID_CR      DECIMAL(10,0) COMMENT IS 'Контрагент 1С ID Кт',
    TOC_SID_DT             DECIMAL(5,0) COMMENT IS 'ТОС ID Дт',
    TOC_SID_CR             DECIMAL(5,0) COMMENT IS 'ТОС ID Кт',
    SUBJECT_SID_DT         DECIMAL(10,0) COMMENT IS 'Контрагент ID Дт',
    SUBJECT_SID_CR         DECIMAL(10,0) COMMENT IS 'Контрагент ID Кт',
    BUSINESS_LINE_SID_DT   DECIMAL(5,0) COMMENT IS 'Линия бизнеса ID Дт',
    BUSINESS_LINE_SID_CR   DECIMAL(5,0) COMMENT IS 'Линия бизнеса ID Кт',
    COOLOFF_PARTNER_SID_DT DECIMAL(5,0) COMMENT IS 'ID COOLOFF партнёра Дт',
    COOLOFF_PARTNER_SID_CR DECIMAL(5,0) COMMENT IS 'ID COOLOFF партнёра Кт',
    COOLOFF_PRODUCT_SID_DT DECIMAL(5,0) COMMENT IS 'ID COOLOFF продукта Дт',
    COOLOFF_PRODUCT_SID_CR DECIMAL(5,0) COMMENT IS 'ID COOLOFF продукта Кт',
    PAYDOC_SID_DT          DECIMAL(10,0) COMMENT IS 'ID платёжного документа Дт',
    PAYDOC_SID_CR          DECIMAL(10,0) COMMENT IS 'ID платёжного документа Кт',
    AGL_ENTRY_SID          CHAR(32) UTF8 COMMENT IS 'ID проводки АГК',
    AMS_DATE_CREATED       TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED      TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS CURRENCY (
    CURRENCY_SID      DECIMAL(5,0) IDENTITY COMMENT IS 'Валюта ID',
    SOURCE_ID         VARCHAR(3) UTF8 COMMENT IS 'Код валюты в системе-источнике (поле CURRENCY в Unicus)',
    CURRENCY_CODE     VARCHAR(3) UTF8 COMMENT IS 'Код валюты',
    CURRENCY_NAME     VARCHAR(20) UTF8 COMMENT IS 'Наименование валюты',
    CURRENCY_TYPE     VARCHAR(20) UTF8 COMMENT IS 'Тип валюты',
    CURRENCY_ISO_CODE VARCHAR(10) UTF8 COMMENT IS 'ISO код валюты',
    IS_EQUIVALENT     VARCHAR(1) UTF8 COMMENT IS 'Является эквивалентом (Y - Да, N - Нет)',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'UNC_CURRENCY.CURRENCY',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS CUR_REVAL_RULES (
    GL_ACCOUNT_SID      DECIMAL(5,0),
    GL_ACCOUNT_2_SID    DECIMAL(17,0),
    CURRENCY_TYPE       VARCHAR(20) UTF8,
    SETTLEMENT_TYPE_SID DECIMAL(10,0),
    REVAL_TYPE          DECIMAL(1,0) COMMENT IS 'Тип переоценки: 0 - любое сальдо, 1 - положительное, 2 - отрицательное'
);

CREATE TABLE IF NOT EXISTS PAIRED_ACCOUNTS (
    START_DATE       DATE COMMENT IS 'Дата начала действия комбинации парных счетов',
    MAIN_ACCOUNT_SID DECIMAL(5,0) COMMENT IS 'SID основного счёта 1С',
    PAIR_ACCOUNT_SID DECIMAL(5,0) COMMENT IS 'SID парного счёта 1C'
);

CREATE TABLE IF NOT EXISTS FACT_DOC_F (
    FACT_DOC_F_SID       DECIMAL(10,0) IDENTITY COMMENT IS 'Документ подтверждения SID',
    SOURCE_ID            CHAR(32) ASCII COMMENT IS 'HASH_MD5(PBUHF_DOCTYPES.DOCCODE, PBUHF_ECONOPRS.FACT_DOCNUMB, PBUHF_ECONOPRS.FACT_DOCDATE)',
    FACT_DOC_F_TYPE_CODE VARCHAR(10) UTF8 COMMENT IS 'Код типа документа-подтверждения Parus-F',
    FACT_DOC_F_TYPE_NAME VARCHAR(80) UTF8 COMMENT IS 'Наименование типа документа-подтверждения Parus-F',
    FACT_DOC_F_NUMBER    VARCHAR(240) UTF8 COMMENT IS 'Номер документа-подтверждения Parus-F',
    FACT_DOC_F_DATE      TIMESTAMP COMMENT IS 'Дата документа-подтверждения Parus-F',
    AMS_INTEGR_CODE      VARCHAR(128) UTF8 COMMENT IS 'FACT_DOC_F_TYPE_CODE|FACT_DOC_F_NUMBER|FACT_DOC_F_DATE',
    AMS_DATE_CREATED     TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED    TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS VALID_DOC_F (
    VALID_DOC_F_SID       DECIMAL(10,0) IDENTITY COMMENT IS 'Документ основания SID',
    SOURCE_ID             CHAR(32) ASCII COMMENT IS 'HASH_MD5(PBUHF_DOCTYPES.DOCCODE, PBUHF_ECONOPRS.FACT_DOCNUMB, PBUHF_ECONOPRS.FACT_DOCDATE)',
    VALID_DOC_F_TYPE_CODE VARCHAR(10) UTF8 COMMENT IS 'Код типа документа-основания Parus-F',
    VALID_DOC_F_TYPE_NAME VARCHAR(80) UTF8 COMMENT IS 'Наименование типа документа-основания Parus-F',
    VALID_DOC_F_NUMBER    VARCHAR(240) UTF8 COMMENT IS 'Номер документа-основания Parus-F',
    VALID_DOC_F_DATE      TIMESTAMP COMMENT IS 'Дата документа-основания Parus-F',
    AMS_INTEGR_CODE       VARCHAR(128) UTF8 COMMENT IS 'VALID_DOC_F_TYPE_CODE|VALID_DOC_F_NUMBER|VALID_DOC_F_DATE',
    AMS_DATE_CREATED      TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED     TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS ESCORT_DOC_F (
    ESCORT_DOC_F_SID       DECIMAL(10,0) IDENTITY COMMENT IS 'Документ сопровождения SID',
    SOURCE_ID              CHAR(32) ASCII COMMENT IS 'HASH_MD5(PBUHF_DOCTYPES.DOCCODE, PBUHF_ECONOPRS.FACT_DOCNUMB, PBUHF_ECONOPRS.FACT_DOCDATE)',
    ESCORT_DOC_F_TYPE_CODE VARCHAR(10) UTF8 COMMENT IS 'Код типа документа-сопровождения Parus-F',
    ESCORT_DOC_F_TYPE_NAME VARCHAR(80) UTF8 COMMENT IS 'Наименование типа документа-сопровождения Parus-F',
    ESCORT_DOC_F_NUMBER    VARCHAR(240) UTF8 COMMENT IS 'Номер документа-сопровождения Parus-F',
    ESCORT_DOC_F_DATE      TIMESTAMP COMMENT IS 'Дата документа-сопровождения Parus-F',
    AMS_INTEGR_CODE        VARCHAR(128) UTF8 COMMENT IS 'ESCORT_DOC_F_TYPE_CODE|ESCORT_DOC_F_NUMBER|ESCORT_DOC_F_DATE',
    AMS_DATE_CREATED       TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED      TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY (
    DGL_ENTRY_SID        DECIMAL(18,0) IDENTITY COMMENT IS 'SID проводки ДГК',
    SYSTEM_SID           DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'SID источника',
    SOURCE_ID            VARCHAR(32) UTF8 NOT NULL ENABLE COMMENT IS 'ID строки журнала в системе-источнике',
    ENTRY_TYPE_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Тип проводки SID',
    ENTRY_DATE           DATE NOT NULL ENABLE COMMENT IS 'Дата операции',
    ACCOUNT_2_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Дт',
    ACCOUNT_2_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Кт',
    ACCOUNT_5_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Дт',
    ACCOUNT_5_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Кт',
    ACCOUNT_DT_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Счёт 1С ID Дт',
    ACCOUNT_CR_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Счёт 1С ID Кт',
    CURRENCY_SID         DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Валюта операции ',
    COMPANY_SID          DECIMAL(5,0) COMMENT IS 'Компания ID',
    OPERATION_PREF       VARCHAR(80) UTF8 COMMENT IS 'Префикс операции',
    SPECIAL_MARK         VARCHAR(80) UTF8 COMMENT IS 'Специальная отметка',
    DET_PERS_ACCOUNT_DT  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Дт',
    DET_PERS_ACCOUNT_CR  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Кт',
    INS_CONTRACT_SID     DECIMAL(18,0) COMMENT IS 'Договор страхования ID',
    REINS_CONTRACT_SID   DECIMAL(18,0) COMMENT IS 'Договор перестрахования ID',
    INS_POLICY_SID       DECIMAL(18,0) COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT_SID  DECIMAL(10,0) COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_DT_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Дт',
    DEPARTMENT_CR_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Кт',
    AMOUNT               DECIMAL(18,2) NOT NULL ENABLE COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE          DECIMAL(18,2) NOT NULL ENABLE COMMENT IS 'Сумма в рублях',
    AMOUNT_NU            DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR            DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR            DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    OPERATION_CONTENT    VARCHAR(200) UTF8 COMMENT IS 'Содержание операции',
    CHANGE_ACC_2_DT_CR   DECIMAL(1,0) DEFAULT 0 NOT NULL ENABLE COMMENT IS 'Смена аналитик и суммы для двузначки (1 - Да, 0 - Нет)',
    INTEGRATION_CODE_SID DECIMAL(5,0) COMMENT IS 'ID кода интеграции',
    AGL_ENTRY_SID        CHAR(32) UTF8 NOT NULL ENABLE COMMENT IS 'ID проводки АГК',
    IS_SOURCE_UPDATE     DECIMAL(1,0) NOT NULL ENABLE COMMENT IS 'Флаг: является ли операция результатом обновления более ранней записи? (Да/Нет)',
    IS_ACTIVE            DECIMAL(1,0) DEFAULT 1 COMMENT IS 'Флаг, что проводка является активной (0 - Нет, 1 -Да)',
    AMS_DATE_CREATED     TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED    TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS COMPANY (
    COMPANY_SID       DECIMAL(5,0) IDENTITY COMMENT IS 'Company SID',
    SOURCE_ID         VARCHAR(32) UTF8 COMMENT IS 'COMPANY.NAME',
    COMPANY_NAME      VARCHAR(160) UTF8 COMMENT IS 'Наименование компании',
    COMPANY_FULLNAME  VARCHAR(160) UTF8 COMMENT IS 'Полное наименование компании',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'COMPANY_NAME',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY_BUFFER (
    DGL_ENTRY_BUFFER_SID DECIMAL(18,0) IDENTITY COMMENT IS 'SID проводки в буферной таблице',
    SYSTEM_SID           DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'SID источника',
    SOURCE_ID            VARCHAR(32) UTF8 NOT NULL ENABLE COMMENT IS 'ID строки журнала в системе-источнике',
    ENTRY_TYPE_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Тип проводки SID',
    BUFFER_SID           DECIMAL(18,0) COMMENT IS 'SID записи в буфере',
    ENTRY_DATE           DATE NOT NULL ENABLE COMMENT IS 'Дата операции',
    ACCOUNT_2_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Дт',
    ACCOUNT_2_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Кт',
    ACCOUNT_5_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Дт',
    ACCOUNT_5_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Кт',
    ACCOUNT_DT_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Счёт 1С ID Дт',
    ACCOUNT_CR_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Счёт 1С ID Кт',
    CURRENCY_SID         DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Валюта операции ID',
    COMPANY_SID          DECIMAL(5,0) COMMENT IS 'Компания ID',
    OPERATION_PREF       VARCHAR(80) UTF8 COMMENT IS 'Префикс операции',
    SPECIAL_MARK         VARCHAR(80) UTF8 COMMENT IS 'Специальная отметка',
    DET_PERS_ACCOUNT_DT  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Дт',
    DET_PERS_ACCOUNT_CR  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Кт',
    INS_CONTRACT_SID     DECIMAL(18,0) COMMENT IS 'Договор страхования ID',
    REINS_CONTRACT_SID   DECIMAL(18,0) COMMENT IS 'Договор перестрахования ID',
    INS_POLICY_SID       DECIMAL(18,0) COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT_SID  DECIMAL(10,0) COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_DT_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Дт',
    DEPARTMENT_CR_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Кт',
    AMOUNT               DECIMAL(18,2) NOT NULL ENABLE COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE          DECIMAL(18,2) NOT NULL ENABLE COMMENT IS 'Сумма в рублях',
    AMOUNT_NU            DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR            DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR            DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    OPERATION_CONTENT    VARCHAR(200) UTF8 COMMENT IS 'Содержание операции',
    CHANGE_ACC_2_DT_CR   DECIMAL(1,0) DEFAULT 0 NOT NULL ENABLE COMMENT IS 'Смена аналитик и суммы для двузначки (1 - Да, 0 - Нет)',
    INTEGRATION_CODE_SID DECIMAL(5,0) COMMENT IS 'ID кода интеграции',
    AGL_ENTRY_SID        CHAR(32) UTF8 NOT NULL ENABLE COMMENT IS 'ID проводки АГК',
    IS_SOURCE_UPDATE     DECIMAL(1,0) NOT NULL ENABLE COMMENT IS 'Флаг: является ли операция результатом обновления более ранней записи? (Да/Нет)'
);

CREATE TABLE IF NOT EXISTS NOMENCLATURE_F (
    NOMENCLATURE_F_SID  DECIMAL(10,0) IDENTITY COMMENT IS 'Валюта ID',
    SOURCE_ID           VARCHAR(20) UTF8 COMMENT IS 'Код номенклатуры NOMEN_CODE',
    NOMENCLATURE_F_CODE VARCHAR(20) UTF8 COMMENT IS 'Код номенклатуры NOMEN_CODE',
    NOMENCLATURE_F_NAME VARCHAR(2000) UTF8 COMMENT IS 'Наименование номенклатуры',
    AMS_INTEGR_CODE     VARCHAR(37) UTF8 COMMENT IS 'Код номенклатуры AMS_HODS.PBUHF_DICNOMNS.NOMEN_CODE',
    AMS_DATE_CREATED    TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED   TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS DIMS_F (
    DIMS_F_SID        DECIMAL(10,0) IDENTITY COMMENT IS 'Аналитика Parus-F SID',
    SOURCE_ID         CHAR(32) UTF8 COMMENT IS 'RN аналитики Parus-F из DICANLS',
    DIMS_F_NAME       VARCHAR(160) UTF8 COMMENT IS 'Наименование аналитики',
    DIMS_F_ANL_NUMBER VARCHAR(40) UTF8 COMMENT IS 'Номер аналитики Parus-F из DICANLS',
    DIMS_F_ANL_NAME   VARCHAR(240) UTF8 COMMENT IS 'Значение аналитики Parus-F из DICANLS',
    AMS_INTEGR_CODE   VARCHAR(128) UTF8 COMMENT IS 'DIMS_F_NUMBER',
    AMS_DATE_CREATED  TIMESTAMP COMMENT IS 'Дата создания в AMS',
    AMS_DATE_MODIFIED TIMESTAMP COMMENT IS 'Дата изменения в AMS'
);

CREATE TABLE IF NOT EXISTS PBUHF_OPRSPECS_TEMP (
    HODS_ENTRY_ID           DECIMAL(18,0),
    RN                      DECIMAL(17,0),
    COMPANY                 DECIMAL(15,0),
    JUR_PERS                DECIMAL(17,0),
    OPERATION_DATE          TIMESTAMP,
    ACCOUNT_DEBIT           DECIMAL(17,0),
    ANALYTIC_DEBIT1         DECIMAL(17,0),
    ANALYTIC_DEBIT2         DECIMAL(17,0),
    ANALYTIC_DEBIT3         DECIMAL(17,0),
    ANALYTIC_DEBIT4         DECIMAL(17,0),
    ANALYTIC_DEBIT5         DECIMAL(17,0),
    ACCOUNT_CREDIT          DECIMAL(17,0),
    ANALYTIC_CREDIT1        DECIMAL(17,0),
    ANALYTIC_CREDIT2        DECIMAL(17,0),
    ANALYTIC_CREDIT3        DECIMAL(17,0),
    ANALYTIC_CREDIT4        DECIMAL(17,0),
    ANALYTIC_CREDIT5        DECIMAL(17,0),
    CURRENCY                DECIMAL(17,0),
    NOMENCLATURE            DECIMAL(17,0),
    ACNT_SUM                DECIMAL(17,2),
    ACNT_BASE_SUM           DECIMAL(17,2),
    HODS_OPEN_PERIOD        DATE,
    HODS_EFF_START          TIMESTAMP,
    HODS_EFF_END            TIMESTAMP,
    OPERATION_PREF          VARCHAR(80) UTF8,
    SPECIAL_MARK            DECIMAL(17,0),
    OPERATION_CONTENTS      VARCHAR(800) UTF8,
    AGENT_FROM              DECIMAL(17,0),
    AGENT_TO                DECIMAL(17,0),
    COMP_NAME               VARCHAR(160) UTF8,
    COMP_FULLNAME           VARCHAR(160) UTF8,
    DEPT_CODE               VARCHAR(20) UTF8,
    DEPT_NAME               VARCHAR(160) UTF8,
    CURR_INTCODE            VARCHAR(10) UTF8,
    CURR_CURNAME            VARCHAR(80) UTF8,
    CURR_CURCODE            VARCHAR(10) UTF8,
    DNOM_NOMEN_CODE         VARCHAR(20) UTF8,
    DNOM_NOMEN_NAME         VARCHAR(2000) UTF8,
    SUBJ_FROM_AGNTYPE       DECIMAL(15,0),
    SUBJ_FROM_AGNNAME       VARCHAR(160) UTF8,
    SUBJ_FROM_RESIDENT_SIGN DECIMAL(5,0),
    SUBJ_FROM_AGNIDNUMB     VARCHAR(20) UTF8,
    SUBJ_FROM_FULLNAME      VARCHAR(2000) UTF8,
    SUBJ_FROM_SEX           DECIMAL(5,0),
    SUBJ_FROM_AGNFAMILYNAME VARCHAR(40) UTF8,
    SUBJ_FROM_AGNFIRSTNAME  VARCHAR(40) UTF8,
    SUBJ_FROM_AGNLASTNAME   VARCHAR(40) UTF8,
    SUBJ_TO_AGNTYPE         DECIMAL(15,0),
    SUBJ_TO_AGNNAME         VARCHAR(160) UTF8,
    SUBJ_TO_RESIDENT_SIGN   DECIMAL(5,0),
    SUBJ_TO_AGNIDNUMB       VARCHAR(20) UTF8,
    SUBJ_TO_FULLNAME        VARCHAR(2000) UTF8,
    SUBJ_TO_SEX             DECIMAL(5,0),
    SUBJ_TO_AGNFAMILYNAME   VARCHAR(40) UTF8,
    SUBJ_TO_AGNFIRSTNAME    VARCHAR(40) UTF8,
    SUBJ_TO_AGNLASTNAME     VARCHAR(40) UTF8,
    FACT_DOC_F_ID           CHAR(32) ASCII,
    FACT_DOC_F_TYPE_CODE    VARCHAR(10) UTF8,
    FACT_DOC_F_TYPE_NAME    VARCHAR(80) UTF8,
    FACT_DOC_F_NUMBER       VARCHAR(240) UTF8,
    FACT_DOC_F_DATE         TIMESTAMP,
    VALID_DOC_F_ID          CHAR(32) ASCII,
    VALID_DOC_F_TYPE_CODE   VARCHAR(10) UTF8,
    VALID_DOC_F_TYPE_NAME   VARCHAR(80) UTF8,
    VALID_DOC_F_NUMBER      VARCHAR(240) UTF8,
    VALID_DOC_F_DATE        TIMESTAMP,
    ESCORT_DOC_F_ID         CHAR(32) ASCII,
    ESCORT_DOC_F_TYPE_CODE  VARCHAR(10) UTF8,
    ESCORT_DOC_F_TYPE_NAME  VARCHAR(80) UTF8,
    ESCORT_DOC_F_NUMBER     VARCHAR(240) UTF8,
    ESCORT_DOC_F_DATE       TIMESTAMP,
    PREV_VERSION_IS_EQUAL   DECIMAL(1,0),
    NEXT_VERSION_IS_EQUAL   DECIMAL(1,0)
);

CREATE TABLE IF NOT EXISTS PBUHF_OPERATION_TEMP (
    HODS_ENTRY_ID          DECIMAL(18,0),
    RN                     DECIMAL(17,0),
    COMPANY                DECIMAL(15,0),
    JUR_PERS               DECIMAL(17,0),
    OPERATION_DATE         TIMESTAMP,
    ACCOUNT_DEBIT          DECIMAL(17,0),
    ANALYTIC_DEBIT1        DECIMAL(17,0),
    ANALYTIC_DEBIT2        DECIMAL(17,0),
    ANALYTIC_DEBIT3        DECIMAL(17,0),
    ANALYTIC_DEBIT4        DECIMAL(17,0),
    ANALYTIC_DEBIT5        DECIMAL(17,0),
    ACCOUNT_CREDIT         DECIMAL(17,0),
    ANALYTIC_CREDIT1       DECIMAL(17,0),
    ANALYTIC_CREDIT2       DECIMAL(17,0),
    ANALYTIC_CREDIT3       DECIMAL(17,0),
    ANALYTIC_CREDIT4       DECIMAL(17,0),
    ANALYTIC_CREDIT5       DECIMAL(17,0),
    CURRENCY               DECIMAL(17,0),
    NOMENCLATURE           DECIMAL(17,0),
    ACNT_SUM               DECIMAL(17,2),
    ACNT_BASE_SUM          DECIMAL(17,2),
    HODS_OPEN_PERIOD       DATE,
    HODS_EFF_START         TIMESTAMP,
    HODS_EFF_END           TIMESTAMP,
    OPERATION_PREF         VARCHAR(80) UTF8,
    SPECIAL_MARK           DECIMAL(17,0),
    OPERATION_CONTENTS     VARCHAR(800) UTF8,
    AGENT_FROM             DECIMAL(17,0),
    AGENT_TO               DECIMAL(17,0),
    COMP_NAME              VARCHAR(160) UTF8,
    DEPT_CODE              VARCHAR(20) UTF8,
    CURR_INTCODE           VARCHAR(10) UTF8,
    FACT_DOC_F_ID          CHAR(32) ASCII,
    FACT_DOC_F_TYPE_CODE   VARCHAR(10) UTF8,
    FACT_DOC_F_TYPE_NAME   VARCHAR(80) UTF8,
    FACT_DOC_F_NUMBER      VARCHAR(240) UTF8,
    FACT_DOC_F_DATE        TIMESTAMP,
    VALID_DOC_F_ID         CHAR(32) ASCII,
    VALID_DOC_F_TYPE_CODE  VARCHAR(10) UTF8,
    VALID_DOC_F_TYPE_NAME  VARCHAR(80) UTF8,
    VALID_DOC_F_NUMBER     VARCHAR(240) UTF8,
    VALID_DOC_F_DATE       TIMESTAMP,
    ESCORT_DOC_F_ID        CHAR(32) ASCII,
    ESCORT_DOC_F_TYPE_CODE VARCHAR(10) UTF8,
    ESCORT_DOC_F_TYPE_NAME VARCHAR(80) UTF8,
    ESCORT_DOC_F_NUMBER    VARCHAR(240) UTF8,
    ESCORT_DOC_F_DATE      TIMESTAMP,
    PREV_VERSION_IS_EQUAL  DECIMAL(1,0),
    NEXT_VERSION_IS_EQUAL  DECIMAL(1,0)
);

CREATE TABLE IF NOT EXISTS PBUHF_DIMENSIONS_TEMP (
    BUFFER_SID DECIMAL(19,0),
    DT_CR      DECIMAL(1,0),
    DIM_NAME   VARCHAR(22) UTF8,
    DIM_VALUE  DECIMAL(17,0)
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY_DIMS_BUFFER_PBF (
    BUFFER_SID DECIMAL(18,0) COMMENT IS 'SID строки в буфере',
    DT_CR      DECIMAL(1,0) COMMENT IS 'Признак ДтКт (0 - Дебет, 1 - Кредит)',
    DIM_SID    DECIMAL(5,0) COMMENT IS 'SID справочника',
    VALUE_SID  DECIMAL(10,0) COMMENT IS 'SID значения аналитики'
);

CREATE TABLE IF NOT EXISTS DGL_ENTRY_BUFFER_PBF (
    DGL_ENTRY_BUFFER_SID DECIMAL(18,0) IDENTITY COMMENT IS 'SID проводки в буферной таблице',
    SYSTEM_SID           DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'SID источника',
    SOURCE_ID            VARCHAR(32) UTF8 NOT NULL ENABLE COMMENT IS 'ID строки журнала в системе-источнике',
    ENTRY_TYPE_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Тип проводки SID',
    BUFFER_SID           DECIMAL(18,0) COMMENT IS 'SID записи в буфере',
    ENTRY_DATE           DATE NOT NULL ENABLE COMMENT IS 'Дата операции',
    ACCOUNT_2_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Дт',
    ACCOUNT_2_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-C ID Кт',
    ACCOUNT_5_DT_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Дт',
    ACCOUNT_5_CR_SID     DECIMAL(5,0) COMMENT IS 'Счёт Парус-F ID Кт',
    ACCOUNT_DT_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Счёт 1С ID Дт',
    ACCOUNT_CR_SID       DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Счёт 1С ID Кт',
    CURRENCY_SID         DECIMAL(5,0) NOT NULL ENABLE COMMENT IS 'Валюта операции ID',
    COMPANY_SID          DECIMAL(5,0) COMMENT IS 'Компания ID',
    OPERATION_PREF       VARCHAR(80) UTF8 COMMENT IS 'Префикс операции',
    SPECIAL_MARK         VARCHAR(80) UTF8 COMMENT IS 'Специальная отметка',
    DET_PERS_ACCOUNT_DT  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Дт',
    DET_PERS_ACCOUNT_CR  VARCHAR(20) UTF8 COMMENT IS 'Детальный лицевой счёт ID Кт',
    INS_CONTRACT_SID     DECIMAL(18,0) COMMENT IS 'Договор страхования ID',
    REINS_CONTRACT_SID   DECIMAL(18,0) COMMENT IS 'Договор перестрахования ID',
    INS_POLICY_SID       DECIMAL(18,0) COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT_SID  DECIMAL(10,0) COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_DT_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Дт',
    DEPARTMENT_CR_SID    DECIMAL(5,0) COMMENT IS 'Подразделение ID Кт',
    AMOUNT               DECIMAL(18,2) NOT NULL ENABLE COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE          DECIMAL(18,2) NOT NULL ENABLE COMMENT IS 'Сумма в рублях',
    AMOUNT_NU            DECIMAL(18,2) COMMENT IS 'Сумма НУ',
    AMOUNT_VR            DECIMAL(18,2) COMMENT IS 'Сумма ВР',
    AMOUNT_PR            DECIMAL(18,2) COMMENT IS 'Сумма ПР',
    OPERATION_CONTENT    VARCHAR(800) UTF8 COMMENT IS 'Содержание операции',
    CHANGE_ACC_2_DT_CR   DECIMAL(1,0) DEFAULT 0 NOT NULL ENABLE COMMENT IS 'Смена аналитик и суммы для двузначки (1 - Да, 0 - Нет)',
    INTEGRATION_CODE_SID DECIMAL(5,0) COMMENT IS 'ID кода интеграции',
    AGL_ENTRY_SID        CHAR(32) UTF8 NOT NULL ENABLE COMMENT IS 'ID проводки АГК',
    IS_SOURCE_UPDATE     DECIMAL(1,0) NOT NULL ENABLE COMMENT IS 'Флаг: является ли операция результатом обновления более ранней записи? (Да/Нет)'
);

CREATE TABLE IF NOT EXISTS DGL_PBUHF_JRNL_BUFFER (
    SYSTEM_SID                DECIMAL(5,0) COMMENT IS 'SID источника',
    PARENT_SYSTEM_SID         DECIMAL(5,0) COMMENT IS 'SID родительской системы-источника',
    SOURCE_ID                 VARCHAR(32) UTF8 COMMENT IS 'ID строки журнала в системе-источнике',
    ENTRY_TYPE_ID             DECIMAL(5,0) COMMENT IS 'Тип проводки SID',
    BUFFER_SID                DECIMAL(18,0) COMMENT IS 'SID записи в буфере',
    INTEGRATION_ROW_TYPE_CODE VARCHAR(128) UTF8 COMMENT IS 'Код интеграции',
    ENTRY_DATE                DATE COMMENT IS 'Дата операции',
    ACCOUNT_5_DT              VARCHAR(32) UTF8 COMMENT IS 'Счёт 5 значного плана счетов Дт',
    ACCOUNT_5_CR              VARCHAR(32) UTF8 COMMENT IS 'Счёт 5 значного плана счетов Кт',
    ACCOUNT_DT                VARCHAR(32) UTF8 COMMENT IS 'Счёт плана счетов 1С Дт',
    ACCOUNT_CR                VARCHAR(32) UTF8 COMMENT IS 'Счёт плана счетов 1С Кт',
    CURRENCY                  VARCHAR(3) UTF8 COMMENT IS 'Валюта операции',
    COMPANY                   VARCHAR(32) UTF8 COMMENT IS 'Компания ID',
    OPERATION_PREF            VARCHAR(80) UTF8 COMMENT IS 'Префикс операции',
    SPECIAL_MARK              VARCHAR(32) UTF8 COMMENT IS 'Специальная отметка',
    INS_CONTRACT              VARCHAR(32) UTF8 COMMENT IS 'Договор страхования ID',
    REINS_CONTRACT            VARCHAR(32) UTF8 COMMENT IS 'Договор перестрахования ID',
    INS_POLICY                VARCHAR(32) UTF8 COMMENT IS 'Страховой полис ID',
    CLAIM_STATEMENT           VARCHAR(32) UTF8 COMMENT IS 'Дело по убытку ID',
    DEPARTMENT_DT             VARCHAR(32) UTF8 COMMENT IS 'Подразделение Дт',
    DEPARTMENT_CR             VARCHAR(32) UTF8 COMMENT IS 'Подразделение Кт',
    AMOUNT                    DECIMAL(18,2) COMMENT IS 'Сумма в валюте',
    AMOUNT_BASE               DECIMAL(18,2) COMMENT IS 'Сумма в рублях',
    OPERATION_CONTENT         VARCHAR(800) UTF8 COMMENT IS 'Содержание операции',
    NOMENCLATURE_DT           VARCHAR(32) UTF8 COMMENT IS 'Номенклатура Дт',
    NOMENCLATURE_CR           VARCHAR(32) UTF8 COMMENT IS 'Номенклатура Кт',
    PL_ITEM_DT                VARCHAR(32) UTF8 COMMENT IS 'Прочие доходы и расходы Дт',
    PL_ITEM_CR                VARCHAR(32) UTF8 COMMENT IS 'Прочие доходы и расходы Кт',
    SETTLEMENT_TYPE_DT        VARCHAR(32) UTF8 COMMENT IS 'Виды расчётов по страховым операциям Дт',
    SETTLEMENT_TYPE_CR        VARCHAR(32) UTF8 COMMENT IS 'Виды расчётов по страховым операциям Кт',
    SUBJECT_1C_DT             VARCHAR(32) UTF8 COMMENT IS 'Контрагент 1С Дт',
    SUBJECT_1C_CR             VARCHAR(32) UTF8 COMMENT IS 'Контрагент 1С Кт',
    TOC_DT                    VARCHAR(32) UTF8 COMMENT IS 'ТОС Дт',
    TOC_CR                    VARCHAR(32) UTF8 COMMENT IS 'ТОС Кт',
    SUBJECT_DT                VARCHAR(32) UTF8 COMMENT IS 'Контрагент Дт',
    SUBJECT_CR                VARCHAR(32) UTF8 COMMENT IS 'Контрагент Кт',
    BUSINESS_LINE_DT          VARCHAR(32) UTF8 COMMENT IS 'Линия бизнеса Дт',
    BUSINESS_LINE_CR          VARCHAR(32) UTF8 COMMENT IS 'Линия бизнеса Кт',
    COOLOFF_PARTNER_DT        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Партнёр Дт',
    COOLOFF_PARTNER_CR        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Партнёр Кт',
    COOLOFF_PRODUCT_DT        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Продукт Дт',
    COOLOFF_PRODUCT_CR        VARCHAR(32) UTF8 COMMENT IS 'COOLOFF Продукт Кт',
    PAYDOC_DT                 VARCHAR(32) UTF8 COMMENT IS 'Платёжный документ Дт',
    PAYDOC_CR                 VARCHAR(32) UTF8 COMMENT IS 'Платёжный документ Кт',
    FACT_DOC_F_DT             VARCHAR(32) UTF8,
    FACT_DOC_F_CR             VARCHAR(32) UTF8,
    VALID_DOC_F_DT            VARCHAR(32) UTF8,
    VALID_DOC_F_CR            VARCHAR(32) UTF8,
    ESCORT_DOC_F_DT           VARCHAR(32) UTF8,
    ESCORT_DOC_F_CR           VARCHAR(32) UTF8,
    CREATE_OPERATION          DECIMAL(1,0) COMMENT IS 'Флаг создания прямой проводки',
    CREATE_STORNO             DECIMAL(1,0) COMMENT IS 'Флаг создания сторно проводки'
);

ALTER TABLE INTEGRATION_CODE ADD CONSTRAINT PK_INTEGRATION_CODE PRIMARY KEY(INTEGRATION_CODE_SID) ENABLE;
ALTER TABLE SOURCE_SYSTEM ADD CONSTRAINT PK_SOURCE_SYSTEM PRIMARY KEY(SYSTEM_SID) ENABLE;
ALTER TABLE ENTRY_TYPE ADD CONSTRAINT PK_ENTRY_TYPE PRIMARY KEY(ENTRY_TYPE_SID) ENABLE;
ALTER TABLE DEPARTMENT ADD CONSTRAINT PK_DEPARTMENT PRIMARY KEY(DEPARTMENT_SID) ENABLE;
ALTER TABLE CURRENCY_RATE ADD CONSTRAINT PK_CURRENCY_RATE PRIMARY KEY(CURRENCY_SID, RATE_DATE) ENABLE;
ALTER TABLE SUBJECT ADD CONSTRAINT PK_SUBJECT PRIMARY KEY(SUBJECT_SID) ENABLE;
ALTER TABLE SUBJECT_1C ADD CONSTRAINT PK_SUBJECT_1C PRIMARY KEY(SUBJECT_1C_SID) ENABLE;
ALTER TABLE INS_CONTRACT ADD CONSTRAINT PK_INS_CONTRACT PRIMARY KEY(CONTRACT_SID) ENABLE;
ALTER TABLE LPU_INVOICE ADD CONSTRAINT PK_LPU_INVOICE PRIMARY KEY(LPU_INVOICE_SID) ENABLE;
ALTER TABLE CLAIM_STATEMENT ADD CONSTRAINT PK_CLAIM_STATEMENT PRIMARY KEY(CLAIM_STATEMENT_SID) ENABLE;
ALTER TABLE INS_OBJECT_TYPE ADD CONSTRAINT PK_INS_OBJECT_TYPE PRIMARY KEY(INS_OBJECT_TYPE_SID) ENABLE;
ALTER TABLE PL_ITEM ADD CONSTRAINT PK_PL_ITEM PRIMARY KEY(PL_ITEM_SID) ENABLE;
ALTER TABLE BUSINESS_LINE ADD CONSTRAINT PK_BUSINESS_LINE PRIMARY KEY(BUSINESS_LINE_SID) ENABLE;
ALTER TABLE SETTLEMENT_TYPE ADD CONSTRAINT PK_SETTLEMENT_TYPE PRIMARY KEY(SETTLEMENT_TYPE_SID) ENABLE;
ALTER TABLE INS_RESERVE ADD CONSTRAINT PK_INS_RESERVE PRIMARY KEY(INS_RESERVE_SID) ENABLE;
ALTER TABLE PROVISION ADD CONSTRAINT PK_PROVISION PRIMARY KEY(PROVISION_SID) ENABLE;
ALTER TABLE GL_ACCOUNT_2 ADD CONSTRAINT PK_GL_ACCOUNT_2 PRIMARY KEY(GL_ACCOUNT_2_SID) ENABLE;
ALTER TABLE GL_ACCOUNT_5 ADD CONSTRAINT PK_GL_ACCOUNT_5 PRIMARY KEY(GL_ACCOUNT_5_SID) ENABLE;
ALTER TABLE GL_ACCOUNT ADD CONSTRAINT PK_GL_ACCOUNT PRIMARY KEY(GL_ACCOUNT_SID) ENABLE;
ALTER TABLE GL_DIMENSION ADD CONSTRAINT PK_GL_DIMENSION PRIMARY KEY(DIM_SID) ENABLE;
ALTER TABLE AGL_ENTRY_BUFFER ADD CONSTRAINT PK_AGL_ENTRY_BUFFER PRIMARY KEY(AGL_ENTRY_SID) ENABLE;
ALTER TABLE AMS_UPDATE_STATUS ADD CONSTRAINT PK_AMS_UPDATE_STATUS PRIMARY KEY(SYSTEM_SID) ENABLE;
ALTER TABLE ACC_PERIODS ADD CONSTRAINT PK_ACC_PERIODS PRIMARY KEY(PERIOD_START) ENABLE;
ALTER TABLE INT_CODE_MAP ADD CONSTRAINT PK_INT_CODE_MAP PRIMARY KEY("ID строки мэппинга") ENABLE;
ALTER TABLE PAY_INT_CODE_MAP ADD CONSTRAINT PK_PAY_INT_CODE_MAP PRIMARY KEY(INTEGRATION_DOC_TYPE_CODE) ENABLE;
ALTER TABLE DGL_ENTRY_DIMS_BUFFER ADD CONSTRAINT PK_DGL_ENTRY_DIMS_BUFFER PRIMARY KEY(BUFFER_SID, DT_CR, DIM_SID) ENABLE;
ALTER TABLE DGL_ENTRY_EXCEPTIONS ADD CONSTRAINT PK_DGL_ENTRY_BUFFER PRIMARY KEY(DGL_ENTRY_BUFFER_SID) ENABLE;
ALTER TABLE COOLOFF_PRODUCT ADD CONSTRAINT PK_COOLOFF_PRODUCT PRIMARY KEY(COOLOFF_PRODUCT_SID) ENABLE;
ALTER TABLE COOLOFF_PARTNER ADD CONSTRAINT PK_COOLOFF_PARTNER PRIMARY KEY(COOLOFF_PARTNER_SID) ENABLE;
ALTER TABLE PAYDOC ADD CONSTRAINT PK_PAYDOC PRIMARY KEY(PAYDOC_SID) ENABLE;
ALTER TABLE INS_POLICY ADD CONSTRAINT PK_INS_POLICY PRIMARY KEY(POLICY_SID) ENABLE;
ALTER TABLE DGL_ENTRY_DIMS ADD CONSTRAINT PK_DGL_ENTRY_DIMS PRIMARY KEY(DGL_ENTRY_SID, DT_CR, DIM_SID) ENABLE;
ALTER TABLE CURRENCY ADD CONSTRAINT PK_CURRENCY PRIMARY KEY(CURRENCY_SID) ENABLE;
ALTER TABLE CUR_REVAL_RULES ADD CONSTRAINT PK_CUR_REVAL_RULES PRIMARY KEY(GL_ACCOUNT_SID, GL_ACCOUNT_2_SID) ENABLE;
ALTER TABLE PAIRED_ACCOUNTS ADD CONSTRAINT PK_PAIRED_ACCOUNTS PRIMARY KEY(START_DATE, MAIN_ACCOUNT_SID) ENABLE;
ALTER TABLE FACT_DOC_F ADD CONSTRAINT PK_FACT_DOC_F PRIMARY KEY(FACT_DOC_F_SID) ENABLE;
ALTER TABLE VALID_DOC_F ADD CONSTRAINT PK_VALID_DOC_F PRIMARY KEY(VALID_DOC_F_SID) ENABLE;
ALTER TABLE ESCORT_DOC_F ADD CONSTRAINT PK_ESCORT_DOC_F PRIMARY KEY(ESCORT_DOC_F_SID) ENABLE;
ALTER TABLE DGL_ENTRY ADD CONSTRAINT PK_DGL_ENTRY PRIMARY KEY(DGL_ENTRY_SID) ENABLE;
ALTER TABLE COMPANY ADD CONSTRAINT PK_COMPANY PRIMARY KEY(COMPANY_SID) ENABLE;
ALTER TABLE NOMENCLATURE_F ADD CONSTRAINT SYS_13264513048307797154432011264 PRIMARY KEY(NOMENCLATURE_F_SID) ENABLE;
ALTER TABLE DIMS_F ADD CONSTRAINT PK_DIMS_F PRIMARY KEY(DIMS_F_SID) ENABLE;
ALTER TABLE DGL_ENTRY_DIMS_BUFFER_PBF ADD CONSTRAINT PK_DGL_ENTRY_DIMS_BUFFER PRIMARY KEY(BUFFER_SID, DT_CR, DIM_SID) ENABLE;

