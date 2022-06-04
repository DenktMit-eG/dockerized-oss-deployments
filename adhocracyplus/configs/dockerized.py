from .base import *
import os

DEBUG = True

# replace 'your.domain' with your desired domain
BASE_URL = 'http://localhost:8000'
ALLOWED_HOSTS = ['*']

# database config - we recommend postgresql for production purposes
DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.sqlite3',
    'NAME': 'aplus-test-database',
  }
}

def asInt(value: str) -> int:
    return None if (value is None or value == 'None') else int(value)

def asBoolean(value: str) -> bool:
    return "True" == value

# Configure E-Mail System
EMAIL_BACKEND = os.getenv('EMAIL_BACKEND', 'django.core.mail.backends.smtp.EmailBackend')
EMAIL_HOST = os.getenv('EMAIL_HOST')
EMAIL_HOST_PASSWORD = os.getenv('EMAIL_HOST_PASSWORD')
EMAIL_HOST_USER = os.getenv('EMAIL_HOST_USER')
EMAIL_PORT = asInt(os.getenv('EMAIL_PORT', 465))
EMAIL_SUBJECT_PREFIX = os.getenv('EMAIL_SUBJECT_PREFIX', '[Adhocracy]')
EMAIL_TIMEOUT = asInt(os.getenv('EMAIL_TIMEOUT', None))
EMAIL_USE_LOCALTIME = asBoolean(os.getenv('EMAIL_USE_LOCALTIME', False))
EMAIL_USE_SSL = asBoolean(os.getenv('EMAIL_USE_SSL', True))
EMAIL_USE_TLS = asBoolean(os.getenv('EMAIL_USE_TLS', False))
SERVER_EMAIL = os.getenv('SERVER_EMAIL')
DEFAULT_FROM_EMAIL = os.getenv('DEFAULT_FROM_EMAIL')


# folder for user-uploads, directly served from the webserver (see nginx example below). Must be created manually.
MEDIA_ROOT='/home/aplus/aplus-media'

# replace the value below with some random value
SECRET_KEY = os.getenv('SECRET_KEY', u'SOMESECRETKEY')

# some basic security settings for serving the website over https - see django docu
CSRF_COOKIE_SECURE=True
#SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SESSION_COOKIE_SECURE=False
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SESSION_COOKIE_HTTPONLY = True

FILE_UPLOAD_PERMISSIONS = 0o644