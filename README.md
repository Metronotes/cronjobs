# Cluster Resizer Script

###### Cluster Resizer script is used to resize clusters to a specified amount of nodes when it's not used. This let's you to have a sort-of working hours for a specific cluster. 

It runs as a **cronjob** and uses **gcloud cli** to resize the specified clusters. The script is located in `/home/resizer/resize.sh` and the entry in the `/etc/crontab` shoud be as follows:

```
0  * 	* * *   resizer ./resize.sh
```

The parameters for resizing the cluster are stored under `/home/resizer/clusters_config` folder and are automatically loaded by the script. 

## Adding another cluster

#### Add the configuration

Example configuration for a cluster:

`/home/resizer/clusters_config`

```bash
cluster_name=test
zone=europe-west4-c
project=test-project
off_node_num=1
on_node_num=3
on_hour=7
off_hour=16
```

#### Authenticate the service account 

##### Create a role

Resizer uses service account with a custom role that only allows the service account to update cluster. 

So we need to create a role with the following permissions
Reguired permissions:

- Kubernetes cluster get
- Kubernetes cluser list
- Kubernetes cluser update
- Container operations get

You can create a role using *gcloud console* or *gcloud cli*, by passing this command.

```
gcloud iam roles create cluster_resizer --project my-project-id \
--file my-role-definition.yaml
```

with this file:

```yaml
title: "Cluster Resizer"
description: "Let's save money"
stage: "ALPHA"
includedPermissions:
- container.clusters.get
- container.clusters.list
- container.clusters.update
- container.operations.get
```

##### Create a Service Account

Now we need to create a service account, it can be created by executing this command:

```
gcloud beta iam service-accounts create my-sa \
    --description "Cluster resizer" \
    --display-name "Cluster Resizer"
```

Now we need to bind this service account to the role we've previously created

```
gcloud projects add-iam-policy-binding my-project-123 \
  --member serviceAccount:my-sa@my-project-id.iam.gserviceaccount.com \
  --role roles/cluster_resizer
```

##### Create a key for the service account

To do so run the following command: 

```
gcloud iam service-accounts keys create ~/key.json \
  --iam-account my-sa@my-project-id.iam.gserviceaccount.com
```

After the key is created we need to **authenticate** in **on the host, where the cronjob is running.**

To authenticate run the following command:

```
gcloud auth activate-service-account \
  --key-file=openware-prod.json
```


