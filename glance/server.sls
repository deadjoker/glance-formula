{%- from "glance/map.jinja" import glance with context %}
include:
  - .db

{{ glance.name }}:
  pkg.installed:
    - refresh: False
    - pkgs: {{ glance.pkg }}
  service.running:
    - names: {{ glance.service }}
    - enable: True
    - require:
      - pkg: {{ glance.name }}

/etc/glance:
  file.recurse:
    - source: salt://glance/files/
    - template: jinja
    - watch_in:
      - service: {{ glance.name }}

{{ glance.name }}_sync_db:
  cmd.run:
    - name: glance-manage db_sync
    - require:
      - mysql_database: {{ glance.name }}-db
      - mysql_user: {{ glance.name }}-db
      - mysql_grants: {{ glance.name }}-db
      - file: /etc/glance
