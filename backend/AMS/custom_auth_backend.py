from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.models import User
from django.conf import settings

SUPER_USER = settings.SUPER_USER

class CustomAuthBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        print("Im in CustomAuth")

        # Check if the username is your specific superuser
        if username == SUPER_USER:
            try:
                # Try to authenticate against the SQLite database
                user = User.objects.get(username=username)
                if user.check_password(password):
                    print(f"User {username} authenticated successfully against SQLite.")
                    return user
                else:
                    print(f"Invalid password for user {username}.")
                    return None
            except User.DoesNotExist:
                print(f"User {username} not found in the SQLite database.")
                return None

        # For other users, delegate to the default authentication backend
        return super().authenticate(request, username=username, password=password, **kwargs)
