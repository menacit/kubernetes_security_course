---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Node authorization"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about node authorization module for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Cory Doctorow (CC BY-SA 2.0)" -->
# Node authorization
### Restricting node privileges

![bg right:30%](images/houses_art.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Cory Doctorow (CC BY-SA 2.0)" -->
By default, all worker nodes are
equally trusted and have access
to all workload-related resources
(pod definitions, secrets, PVs, etc!).

A hacked node could compromise
the whole cluster's security.

Especially bad considering lacking
credential revocation checking.

"Node authorizer" to the rescue!

![bg right:30%](images/houses_art.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Charles Hoisington, GSFC (CC BY 2.0)" -->
## Node authorizer
Special purpose authorizer to restrict
cluster access for "node users".

Nodes are only permitted to query the
API server for pods that are assigned
to themselves and their associated
"pod-bound" resources, like secrets.

Limits which request verbs can be used
to interact with resources: a node has
no business changing configuration maps.

Minimize the "blast radius".

![bg right:30%](images/satellite_dish_sunset.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Charles Hoisington, GSFC (CC BY 2.0)" -->
Sounds quite neat -
any usage considerations or gotchas?

![bg right:30%](images/satellite_dish_sunset.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Edenpictures (CC BY 2.0)" -->
Not enabled by default.

Only applies to users with membership
in the group "system:nodes" and with 
the username "system:node:\$NODE\_NAME".

![bg right:30%](images/abstract_blue_house.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Theo Crazzolara (CC BY 2.0)" -->
[Hard-coded list of resource kinds](https://github.com/kubernetes/kubernetes/blob/233ebd69ad98951776c48f98606dfa9e5fde2ab8/plugin/pkg/auth/authorizer/node/node_authorizer.go#L83-L96) that
are validated for "node-binding".  

Must still combined with RBAC or
similar to restrict access for
other cluster resources/APIs.

Restricting verbs for resource
interaction only gets you so far,
should be utilized in unison with the
["NodeRestriction" admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#noderestriction)
to limit which properties can be modified.  

(more about admission control and
privilege escalation tricks later)

![bg right:30%](images/sad_bird.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Cory Doctorow (CC BY-SA 2.0)" -->
## Wrapping up

![bg right:30%](images/houses_art.jpg)

<!--
-->
