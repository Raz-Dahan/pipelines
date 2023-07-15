#/bin/bash

gcloud beta container --project "named-signal-392608" clusters create "nasa-cluster-1" \
--zone "us-central1-c" \
--no-enable-basic-auth \
--cluster-version "1.26.5-gke.1200" \
--release-channel "regular" \
--machine-type "e2-medium" \
--image-type "COS_CONTAINERD" \
--disk-type "pd-balanced" \
--disk-size "32" \
--metadata disable-legacy-endpoints=true \
--scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
--max-pods-per-node "110" \
--num-nodes "3" \
--logging=SYSTEM,WORKLOAD \
--monitoring=SYSTEM \
--enable-ip-alias \
--network "projects/named-signal-392608/global/networks/default" \
--subnetwork "projects/named-signal-392608/regions/us-central1/subnetworks/default" \
--no-enable-intra-node-visibility \
--default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "1" \
--max-nodes "5" \
--security-posture=standard \
--workload-vulnerability-scanning=disabled \
--no-enable-master-authorized-networks \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--no-enable-managed-prometheus \
--enable-vertical-pod-autoscaling \
--enable-shielded-nodes \
--node-locations "us-central1-c"


