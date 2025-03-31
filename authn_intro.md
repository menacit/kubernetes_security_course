---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Authentication introduction"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Introduction to authentication options for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Adam Lusch (CC BY-SA 2.0)" -->
# Authentication options
### A somewhat gentle introduction

![bg right:30%](images/rusty_x_chain.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Adam Lusch (CC BY-SA 2.0)" -->
....first
....TODO: Slide about almost everything going through API server.

That will be our focus for these slides

![bg right:30%](images/rusty_x_chain.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Slide about Users and ServiceAccounts,

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: ServiceAccounts are created in a namespace,
no group memberships, exists as objects in Kubernetes,
meant for workloads running inside the cluster that
needs access to the API server or third-party services
that rely on it for authentication, always a 
service account called "default" in each namespace,
if you remove it is recreated


![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: slide about users.
Nodes/control plane components are also users,
Users have a name and can be a member of multiple groups,
No inherited group membership,
no difference between user between authenticators - but authenticators can add "extras",
like a fingerprint/ID for token used etcd.


![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Slide about unauthenticated requests
being done with the user "system:anonymous" and
the group "system:unauthenticated". Access /healthz


![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
## Available authenticators\*
- Proxy request headers
- Simple tokens
- Mutual TLS ("client certificate")
- OpenID Connect
- External webhook
- Bootstrap tokens
- Service account tokens


![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Outro, dig into pros/cons


![bg right:30%](images/.jpg)

<!--
-->
