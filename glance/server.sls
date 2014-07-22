{%- from "glance/map.jinja" import glance with context %}

{{ glance.name }}:
  pkg.installed:
    - refresh: False
    - pkgs:
      - {{ glance.pkg }}
  service.running:
    - name: {{ glance.service }}
    - enable: True
    - require:
      - pkg: {{ glance.name }}

/etc/glance:
  file.recurse:
    - source: salt://glance/files/
    - template: jinja
    - watch_in:
      - service: {{ glance.name }}
