# SQL backup script

## Usage

Simply add this script on the target machine, run `crontab -e` and add the following line:
```sh
0 */24 * * * *username* *script location*
```

This would result in your SQL databases being backed up to GCS in .sql.gz format every day at 00:00.

## Default behaviour

The following algorythm is executed for MySQL and PostgreSQL accessible from localhost:
1. Take a database dump and compress it using gzip
2. Load the result to the specified GCS bucket
