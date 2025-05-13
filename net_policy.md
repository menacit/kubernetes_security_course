---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Network policies"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about network policies for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Helsinki Hacklab (CC BY 2.0)" -->
# Network policies
### Restricting pod networking

![bg right:30%](images/router_beer_tap.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Helsinki Hacklab (CC BY 2.0)" -->
By default, no restriction of
pod network traffic is enforced.  
  
May communicate freely with pods,
nodes and hosts outside the cluster.  

"NetworkPolicy" resources can be
defined to limit a pod's ingress
and egress network traffic.

Basically layer 4 firewall rules,
but more "workload-centric".

![bg right:30%](images/router_beer_tap.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Shiv's fotografia (CC BY 4.0)" -->
## A NetworkPolicy...
- Apply to pods in namespace based on labels
- Permits traffic based on labels or IP range
- Is "deny by default-ish" and "unordered"

Let's try breaking it down!

![bg right:30%](images/green_magpie_branch.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Shiv's fotografia (CC BY 4.0)" -->
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  namespace: bank-app
  name: backend-traffic
spec:
  podSelector:
    matchLabels:
      component: backend
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
        - podSelector:
            matchLabels:
              app: api-gw
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: monitoring
      ports:
        - protocol: TCP
          port: 8443
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: operations
          podSelector:
            matchLabels:
              app: backup-bot
      ports:
        - protocol: TCP
          port: admin-interface
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
          podSelector:
            matchLabels:
              k8s-app: kube-dns
    - to:
        - ipBlock:
            cidr: 0.0.0.0/0
            except:
              - 169.254.169.254/32
              - 192.168.42.0/24
        - ipBlock:
            cidr: ::/0
            except:
              - fd00:ec2::254/128
      ports:
        - protocol: TCP
          port: 1337
        - protocol: UDP
          port: 1338
```

![bg right:30%](images/green_magpie_branch.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Wolfgang Stief (CC BY 2.0)" -->
## Targeting policies
Network policies are "namespace-bound".

Label selectors are used to filter
pods for policy enforcement.

Based on its labels, none or multiple
policies may be applied to a pod.

![bg right:30%](images/dec_pdp_rack_row.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Wolfgang Stief (CC BY 2.0)" -->
## Targeting policies
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  namespace: bank-app
  name: backend-traffic
spec:
  podSelector:
    matchLabels:
      component: backend
[...]
```

_(matches all pods with the label
component=backend in namespace "bank-app")_

![bg right:30%](images/dec_pdp_rack_row.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% SMTW.de (CC BY-SA 4.0)" -->
## Defining source/destination
A policy may define multiple
ingress and/or egress rules.

Specify source/target using...

- Pod labels
- Namespace labels
- Namespace \+ pod labels
- IPv4/IPv6 CIDR

Optional filtering based on
destination ports (TCP, UDP and SCTP).

![bg right:30%](images/bornhack_2021_drone_photo.jpg)

<!--
-->

---
## Defining ingress rules
```yaml
[...]
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
        - podSelector:
            matchLabels:
              app: api-gw
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: monitoring
      ports:
        - protocol: TCP
          port: 8443
[...]
```

_("kubernetes.io/metadata.name" is immutable and unique)_

<!--
-->

---
## Defining ingress rules (cont.)
```yaml
[...]
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: operations
          podSelector:
            matchLabels:
              app: backup-bot
      ports:
        - protocol: TCP
          port: admin-interface
[...]
```

_(common mistake to put "namespaceSelector"
and "podSelector" as different list items - beware!)_

<!--
-->

---
## Defining egress rules
```yaml
[...]
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
          podSelector:
            matchLabels:
              k8s-app: kube-dns
[...]
```

_(missing "ports" property means all will be allowed)_

_(if any network policies are defined in foreign namespace,
they must also permit the resulting ingress traffic)_

<!--
-->

---
## Defining egress rules (cont.)
```yaml
[...]
    - to:
        - ipBlock:
            cidr: 0.0.0.0/0
            except:
              - 169.254.169.254/32
              - 192.168.42.0/24
        - ipBlock:
            cidr: ::/0
            except:
              - fd00:ec2::254/128
      ports:
        - protocol: TCP
          port: 1337
        - protocol: UDP
          port: 1338
```

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Andrew Pontzen/Fabio Governato (CC BY 2.0)" -->
## Implicitly denied traffic
Policy rules may only allow traffic,
not explicitly deny it\*.
  
If at least one policy with ingress
rules targets the pod, all other
ingress is implicitly denied.
  
If at least one policy with egress
rules targets the pod, all other
egress is implicitly denied.
  
Beware of the "policy type" split!

![bg right:30%](images/universe_light_distribution.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kevin L Neff (CC BY 2.0)" -->
## Rule processing
As network policies only permit traffic,
there is no need for "rule ordering".

If one policy permits traffic,
it will be allowed.

![bg right:30%](images/propane_torch_soldering.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Michael Garlick (CC BY-SA 2.0)" -->
By defining a label selector that
includes all pods in a namespace,
we can enforce a "default policy"
instead of no traffic restrictions.

Further workload-specific policies
may permit required communication.

Let's look at some examples...

![bg right:30%](images/leonardslee_gardens_man_statue.jpg)

<!--
-->

---
## Deny ingress by default
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  namespace: bank-app
  name: default
spec:
  podSelector: {}
  ingress: []

```

<!--
-->

---
## Deny all traffic by default
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  namespace: bank-app
  name: default
spec:
  podSelector: {}
  ingress: []
  egress: []
```

<!--
-->

---
## Deny all traffic except DNS by default
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  namespace: bank-app
  name: default
spec:
  podSelector: {}
  ingress: []
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
```

<!--
-->

---
## Override to allow all traffic (fun/dangerous)
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  namespace: bank-app
  name: override
spec:
  podSelector: {}
  ingress:
    - {}
  egress:
    - {}
```

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rick Massey (CC BY 2.0)" -->
## Quirks and caveats?

![bg right:30%](images/finch_foundry_wheels.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Brocken Inaglory (CC BY-SA 3.0)" -->
While "NetworkPolicy" is a standard
resource type, no built-in component
is responsible for rule enforcement.

Typically (but not necessarily)
handled by the configured CNI.

No standard API or similar to determine
if polices are enforced or not.

![bg right:30%](images/yellowstone_canyon.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Martin Fisch (CC BY 2.0)" -->
No standardized API for reviewing
logs allowed/denied traffic.

![bg right:30%](images/fire_pit_high_flames.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
No built-in feature to define
cluster-wide or default policies
for all/new namespaces.

Work is [being done](https://network-policy-api.sigs.k8s.io/api-overview/) to provide
these features eventually.

Your CNI may already support
similar functionality - like
[Cilium's "ClusterwideNetworkPolicy"](https://docs.cilium.io/en/latest/network/kubernetes/policy/).

![bg right:30%](images/red_bridge_tunnel.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Eric Friedebach (CC BY 2.0)" -->
Only restricts traffic to/from pods,
your nodes are out-of-scope.

Combine with traditional network
and/or host-based firewalls.

"Kubernetes-native" solutions like
[Calico's "GlobalNetworkPolicy"](https://docs.tigera.io/calico/latest/reference/resources/globalnetworkpolicy) exist,
but beware of dependency requirements
for proper enforcement.

![bg right:30%](images/submarine_control_panel_lights.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Eric Chan (CC BY 2.0)" -->
Expected enforcement behavior for
established connections and pods
using "hostNetwork" is undefined.

![bg right:30%](images/neon_inflateable_jellyfish.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas Day (CC BY 2.0)" -->
Wanna practice your skills?

Checkout the lab exercise:
["resources/labs/fix\_net\_policy"](%RESOURCES_ARCHIVE%).

![bg right:30%](images/horizontal_color_glitch.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Helsinki Hacklab (CC BY 2.0)" -->
## Wrapping up

![bg right:30%](images/router_beer_tap.jpg)

<!--
-->
