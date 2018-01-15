#### install_oracle.sls ####
{% if salt['grains.get']('oracle_install') != 'completed' %}

copy oracle install files:
   file.recurse:
     - name: /tmp/
     - source: salt://files/oracle_install/

prepare oracle install:
   cmd.run:
      - name: yum -y install /tmp/oracle-database-server-12cR2-preinstall-1.0-1.el7.x86_64.rpm

{% for dir in ['/u01', '/u01/oracle', '/u01/base', '/u01/orainv', '/stage'] %}
{{ dir }}:
   file.directory:
     - user: oracle
     - group: dba
     - mode: 755
     - makedirs: True
{% endfor %}

prepare oracle install files:
   cmd.run:
      - name: unzip /tmp/linuxx64_*_database.zip -d /stage/

move response file:
   cmd.run:
      - name: |
         mv /tmp/db_install.rsp /stage/database/response/
         chown -R oracle /stage/database

run the install as oracle:
   cmd.run:
      - name: |
         su - oracle -c 'ulimit -n 65536; export DISTRIB=/stage/database; export TMPDIR=/tmp; /stage/database/runInstaller -silent -responseFile /stage/database/response/db_install.rsp oracle.install.db.isCustomInstall=false SELECTED_LANGUAGES=en'

run root cmds post install:
   cmd.run:
      - name: |
         /u01/orainv/orainstRoot.sh
         /u01/oracle/root.sh

create grain that shows oracle install is done:
   grains.present:
      - name: oracle_install
      - value: completed

{% endif %}
