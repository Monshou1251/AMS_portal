from django.contrib.auth.signals import user_logged_in
import logging


logger = logging.getLogger(__name__)


def log_successful_login(sender, request, user, **kwargs):
    logger.info(f"User {user.username} logged in successfully.")


user_logged_in.connect(log_successful_login)