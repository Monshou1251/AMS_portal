import os
from pathlib import Path
import ldap
from django_auth_ldap.config import LDAPSearch, GroupOfNamesType

# from django_auth_ldap.backend import NTLMAuthenticationBackend
import logging
from datetime import timedelta
import ssl
import pyexasol


logger = logging.getLogger("django_auth_ldap")
# logger.debug('Authenticating user %s', username)
EXASOL_DB_NAME = "YOUR_DB"  # Источник данных ODBC, системный DSN
EXASOL_DB_NAME_DIRECT = "192.168.xxx.xxx:8563"

SUPER_USER = "superuser_ams"  # суперпользователь для управления порталом, будучи вне базы Active Directory


AUTHENTICATION_BACKENDS = [
    "django_python3_ldap.auth.LDAPBackend",
    "AMS.custom_auth_backend.CustomAuthBackend",
    "django.contrib.auth.backends.ModelBackend",
]
# CN=User,CN=Users,DC=IceQueen,DC=ru

LDAP_AUTH_URL = ["ldap://IceQueen.ru"]
LDAP_AUTH_USE_TLS = False
LDAP_AUTH_TLS_VERSION = ssl.PROTOCOL_TLSv1_2
# LDAP_AUTH_SEARCH_BASE = "CN=EXA_DBA,OU=EXA,OU=Special,DC=vesta,DC=ru"
LDAP_AUTH_SEARCH_BASE = "CN=User,CN=Users,DC=XXX,DC=ru"
LDAP_AUTH_OBJECT_CLASS = "user"
LDAP_AUTH_USER_FIELDS = {
    # "username": "mailNickname",
    "username": "mail",
    "first_name": "givenName",
    "last_name": "sn",
    "email": "mail",
}
LDAP_AUTH_USER_LOOKUP_FIELDS = ("username",)
LDAP_AUTH_CLEAN_USER_DATA = "django_python3_ldap.utils.clean_user_data"
LDAP_AUTH_SYNC_USER_RELATIONS = "django_python3_ldap.utils.sync_user_relations"
LDAP_AUTH_FORMAT_SEARCH_FILTERS = "django_python3_ldap.utils.format_search_filters"
LDAP_AUTH_FORMAT_USERNAME = "django_python3_ldap.utils.format_username_active_directory"
# LDAP_AUTH_ACTIVE_DIRECTORY_DOMAIN = None
LDAP_AUTH_CONNECTION_USERNAME = "CN=user_ams,CN=Users,DC=XXX,DC=ru"
LDAP_AUTH_CONNECTION_PASSWORD = "XXXX"


EXASOL_CONNECTION_STRING = ""
USERNAME = ""
PASSWORD = ""


LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "vector": {
            "format": "%(asctime)s - %(levelname)s - %(message)s",
            "datefmt": "%Y-%m-%d %H:%M:%S",
            "class": "logging.Formatter",
        },
    },
    "handlers": {
        "vector": {
            "level": "INFO",
            "class": "backend.logger.CustomSocketHandler",
            "host": "127.0.0.1",
            "port": "9093",
            "formatter": "vector",
        },
        "console": {
            "class": "logging.StreamHandler",
        },
    },
    "loggers": {
        "": {
            "handlers": ["vector", "console"],
            "level": "INFO",
            "propagate": True,
        },
    },
}

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ],
}

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = ""

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = [
    "192.168.149.10",
    "127.0.0.1",
    "localhost",
]


INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "djoser",
    "corsheaders",
    "rest_framework_simplejwt",
    "django_python3_ldap",
    "AMS",
]

SIMPLE_JWT = {
    "AUTH_HEADER_TYPES": ("Bearer",),
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=10),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=1),
}

CORS_ALLOWED_ORIGINS = [
    "http://localhost:8080",
    "http://127.0.0.1:8000",
    # Add any other trusted origins here
]

CORS_ALLOW_HEADERS = [
    "X-Username",
    "Authorization",
    "content-type",
]

MIDDLEWARE = [
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

# CORS_ORIGIN_ALLOW_ALL = True

# CORS_ORIGIN_ALLOW_ALL = False

# CORS_ORIGIN_WHITELIST = [
#     'http://localhost:8080',
#     # Add any other trusted origins here
# ]


CSRF_TRUSTED_ORIGINS = [
    "https://localhost:8080",
    "http://localhost:8080",
]

ROOT_URLCONF = "backend.urls"

TEMPLATES_DIR = os.path.join(BASE_DIR, "templates")

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "backend.wsgi.application"


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}


# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


SESSION_ENGINE = "django.contrib.sessions.backends.cache"

CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.locmem.LocMemCache",
        "LOCATION": "unique-snowflake",
        "TIMEOUT": None,
    }
}


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = "/static/"
STATIC_ROOT = "C:/App/backend/static/"


# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
