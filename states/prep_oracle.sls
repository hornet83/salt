#### prep_oracle.sls ####

include:
   - common

install required rpms:
   pkg.installed:
     - pkgs:
       - gcc-c++

update limits file:
   file.append:
     - name: /etc/security/limits.conf
     - text: |
          oracle   soft   nofile   65536
          oracle   hard   nofile   65536
          oracle   soft   nproc    2047
          oracle   hard   nproc    16384
          oracle   hard   stack    10240

update sysctl.conf file:
   file.append:
     - name: /etc/sysctl.conf
     - text: |
         fs.aio-max-nr = 1048576
         fs.file-max = 6815744
         kernel.shmall = 2097152
         kernel.shmmax = 536870912
         kernel.shmmni = 4096
         kernel.sem = 250 32000 100 128
         net.ipv4.ip_local_port_range = 9000 65500
         net.core.rmem_default = 262144
         net.core.rmem_max = 4194304
         net.core.wmem_default = 262144
         net.core.wmem_max = 1048586

load kernel parameters:
   cmd.run:
      - name: /sbin/sysctl -p

oracle/install/base:
   event.send:
     - name: oracle/install/base
