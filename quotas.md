---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Quotas feature"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about \"quotas\" feature for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Martin Fisch (CC BY 2.0)" -->
# "ResourceQuota" feature
### Abusing quotas for security

![bg right:30%](images/negative_seal.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Martin Fisch (CC BY 2.0)" -->
Administrators can define "ResourceQuota"
objects in a namespace to restrict the
amount/count of available resources.
  
Cap total memory usage to 90GB ("amount")
and eight persistent volume claims ("count").

Setting `count/pods=0` would disable
ability to create new pods in a namespace.

Besides potentially improving availability,
can we utilize the feature for security?

_(I say "can", not "should" hehe)_

![bg right:30%](images/negative_seal.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Egill Egilsson (CC BY 2.0)" -->
## Restricting service types
Services of type "NodePort" and "LoadBalancer"
are used to provide external access to
services running inside the cluster.

Easy mistake to make, especially compared to
explicit creation of "ingress" resources.

Configuration of external components using
annotations on "LoadBalancer" services may
enable privilege escalation.

Restrict usage by `services.nodeports=0`
and `services.loadbalancers=0`

![bg right:30%](images/esbjerg_low.jpg)

<!--
-->
