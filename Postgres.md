#archlinux #postgres

After upgrading Postgres on local machine. to get rid of old data and start fresh 
```shell
mv /var/lib/postgres/data /var/lib/postgres/olddata
sudo su postgres
initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'
exit
sudo systemctl start postgresql
```