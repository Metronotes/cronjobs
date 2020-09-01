# Parity wallet keys backup script

## Usage

Simply add this script on the target machine, run `crontab -e` and add the following line:
```sh
0 0 * * * *script location*
```

This would result in all Parity wallets at the target location to be backed up to a GCS bucket of choice every day at 00:00.

## Configuration

|Name|Description|
|---|---|
|`BUCKET_PATH`|Target GCS bucket path including the `gs://` protocol|
|`BACKUP_PATH`|Local Parity key directory location|
|`GOOGLE_APPLICATION_CREDENTIALS`|GCP Service Account key location|

