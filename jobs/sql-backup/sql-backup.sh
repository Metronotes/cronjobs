#!/bin/bash

set -e

gcs_project="openware-production"
gcs_bucket="gs://openware-baremetal-sql-dumps"

function backup_postgres {
  echo "Backing up Postgres..."
  passwd=`cat $HOME/safe/passwd/root-sql.pw`
  filename="/dumps/steak-openware-drone-psql-dump-`date +%F`.sql.gz"
  echo "Taking a dump..."
  docker exec -it -u root drone_db sh -c "pg_dump --user drone | gzip > ${filename}"
  echo "Uploading to GCS..."
  gsutil cp ${HOME}/volumes${filename} ${gcs_bucket}
  echo "Success!"
}

function backup_mysql {
  echo "Backing up MySQL..."
  passwd=`cat $HOME/safe/passwd/root-sql.pw`
  filename="$HOME/dumps/steak-openware-jira-factory-mysql-dump-`date +%F`.sql.gz"
  echo "Taking a dump..."
  mysqldump --opt --single-transaction --databases jira factory --host=127.0.0.1 --user=root --password=${
passwd} | gzip > ${filename}
  echo "Uploading to GCS..."
  gsutil cp ${filename} ${gcs_bucket}
  echo "Success!"
}

backup_mysql
backup_postgres
