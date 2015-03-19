# Infrastructure Helpers
Note that `down` only works well if the variables defined before the invocation
of the script are similar to the variables defined before invoking the `up` 
command.

## Setup Kubernetes Controller
```bash
# create box
PROJECT=xperiment ./01-setup-control.mech up

# destroy box
PROJECT=xperiment ./01-setup-control.mech down
```

## Setup SSH Tunnel
```bash
LOCAL_PORT=4002 USER=david TUNNEL_HOST=CONTROLLER_EXTERNAL_IP ./02-setup-ssh-tunnels.sh up
```
Defining ```TUNNEL_HOST``` will tunnel the connection through the specified 
machine. Unless the ```REMOTE_HOST``` is specified, the tunnel will patch us 
through to the ```REMOTE_HOST``` which by default contains the loopback 
address therefore patching us through to the tunnel host itself :wink:.

```bash
LOCAL_PORT=4002 USER=david TUNNEL_HOST=CONTROLLER_EXTERNAL_IP ./02-setup-ssh-tunnels.sh down
```

## Flannel Config
In order to supply the flannel subnet manager its proper [configuration][flannel-config], 
one has to describe the setup in etcd.

```bash
CONTROL_HOST=CONTROLLER_EXTERNAL_IP MASK=10.X.0.0/16 ./03-config-flannel.sh up
```

[flannel-config]: https://coreos.com/docs/cluster-management/setup/flannel-config#publishing-config-to-etcd

## Setup Nodes
```bash
CONTROL_IP=CONTROLLER_INTERNAL_IP NODES="mercury venus earth mars" ./04-setup-nodes.sh up
```

## Deploy Kubernetes
Kubernetes requires a few services to start doing it's stuff. Provided that
the tunnel is up for `fleetctl` to do her work one may setup the 
Kubernetosphere.

## Create Registry Storage
```bash
LOCATION=EU NAME=example.port.rotterdam ./05-create-registry-storage.sh up
```

## Create Registry
```bash
```
[docker-gcs-registry]: https://github.com/GoogleCloudPlatform/docker-registry-driver-gcs
