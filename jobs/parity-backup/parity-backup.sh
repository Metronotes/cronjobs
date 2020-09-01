#!/bin/bash

set -ex

BUCKET_PATH="gs://opendax-baremetal-crypto-backup/parity_keys"
BACKUP_PATH="/data/parity/keys/ethereum"
GOOGLE_APPLICATION_CREDENTIALS="/home/deploy/safe/gcs-backup-key.json"

gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
gsutil -m cp -r ${BACKUP_PATH} ${BUCKET_PATH}
