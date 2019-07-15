#!/bin/bash

current_time=`date +%H`

for filename in /home/resizer/clusters_config/*.conf; do
	[ -e "$filename" ] || continue
	. $filename
	if [[ ${current_time#0} -ge $on_hour && ${current_time#0} -lt $off_hour ]]
	then
		echo "SCALING UP THE CLUSTER. LET'S DEPLOY AND WIN THE INTERNET"
		`gcloud config set account cluster-resizer@$project.iam.gserviceaccount.com`
		`gcloud container clusters resize -q --num-nodes $on_node_num --zone $zone --project $project $cluster_name`
	else
		echo "SCALING DOWN THE CLUSTER FOR SAVING YOUR DALLARZZZZ"
		`gcloud config set account cluster-resizer@$project.iam.gserviceaccount.com`
		`gcloud container clusters resize -q --num-nodes $off_node_num --zone $zone --project $project $cluster_name `
	fi
done
