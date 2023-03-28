# ScyllaDB-Cluster-with-Podman
Tutorial on how to setup a ScyllaDB cluster in you local machine with Podman

# 🚀 Manual:

### Step 1
Create separate network for you ScyllaDB nodes
```
podman network create cluster
```

### Step 2
This step is very similar to the docker one. Just add network to the command like below.
```
podman run --network=cluster --name NodeX -d scylladb/scylla --overprovisioned 1 --smp 1
```
### Step 3
Get the IP address of first node in a variable to use it as the seed for all the other nodes of our ScyllaDB cluster
```
SEED=$(podman inspect NodeX --format "{{.NetworkSettings.Networks.cluster.IPAddress}}")
```

### Step 4
Create any number of nodes you like for the cluster using the IP we just copied as the seed for the newer one. In my case it was
```
podman run --network=cluster --name NodeY -d scylladb/scylla --seed=$SEED --overprovisioned 1 --smp 1
podman run --network=cluster --name NodeZ -d scylladb/scylla --seed=$SEED --overprovisioned 1 --smp 1
...
```
### Step 5
To view your cluster setup run the following using any node. For this example I used NodeX. Note, it can take several minutes to show up all the nodes in the results.
```
podman exec -it NodeX nodetool status
```
output is similar to this one
```
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address     Load       Tokens       Owns    Host ID                               Rack
DN  10.89.0.9   552 KB     256          ?       a66c87cd-b68a-423e-8a3f-d464671f3f33  rack1
UN  10.89.0.8   212 KB     256          ?       6acc8e6b-3158-4bfb-a829-242ca19b5c53  rack1
UN  10.89.0.10  588 KB     256          ?       f6e712be-d1f6-4795-a6d5-b4880ddf2672  rack1
```

# 🧞 Automatic
Clone this repo and cd into it. Then run the following commands and you are done.
```
chmod +x ./create-cluster.sh
./create-cluster.sh
```