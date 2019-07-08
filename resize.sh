#!/bin/bash

cluster_configs=`ls -qd /home/resizer/clusters_config/*`

for i in "${cluster_configs[@]}"
do
	. "$i"
	if [[ `date +%H` -ge $on_hour && `date +%H` -lt $off_hour ]] 
	then
		echo "SCALING UP THE CLUSTER. LET'S DEPLOY AND WIN THE INTERNET"
		`gcloud container clusters resize -q --num-nodes $on_node_num $cluster_name --zone $zone --project $project` 
	else
		echo "SCALING DOWN THE CLUSTER FOR SAVING YOUR DALLARZZZZ"
		`gcloud container clusters resize -q --num-nodes $off_node_num $cluster_name --zone $zone --project $project` 
	fi
done
