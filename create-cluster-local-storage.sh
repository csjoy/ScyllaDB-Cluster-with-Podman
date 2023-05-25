#!/bin/bash

podman network create cluster

podman run --network=cluster --name nodeX -v ./scylla/nodeX:/var/lib/scylla -d scylladb/scylla --smp 1

SEED=$(podman inspect nodeX --format "{{.NetworkSettings.Networks.cluster.IPAddress}}")

podman run --network=cluster --name nodeY -v ./scylla/nodeY:/var/lib/scylla -d scylladb/scylla --seeds=$SEED --smp 1

podman run --network=cluster --name nodeZ -v ./scylla/nodeZ:/var/lib/scylla -d scylladb/scylla --seeds=$SEED --smp 1
