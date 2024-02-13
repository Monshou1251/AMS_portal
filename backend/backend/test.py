import ldap3
from django.contrib.auth import authenticate
from django.http import HttpResponse


server_uri = 'ldap://192.168.149.10'
bind_dn = "CN=bind,CN=Users,DC=ATK,DC=BIZ"
bind_password = "Hahalala90!"
conn = ldap3.Connection(ldap3.Server(server_uri), user=bind_dn, password=bind_password, auto_bind=True)

print(conn.search(search_base='DC=ATK,DC=BIZ', search_filter='(objectClass=person)', attributes=['givenName']))

conn.search(
    search_base='CN=django-admins,CN=Users,DC=ATK,DC=BIZ',
    search_filter='(objectClass=group)',
    search_scope='SUBTREE',
    attributes = ['member']
)

for entry in conn.entries:
    print(entry.member.values)
