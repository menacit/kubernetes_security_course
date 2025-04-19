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
When we talk about authentication
in Kubernetes, we primarily refer
to authentication in the API server.  

Developers/administrators use it
to create and query resources.  

Control plane components like the
scheduler use it to find workloads
for... well, scheduling.  

The kubelet, kube-proxy and other
node components talk to it as well.  

_(more about authentication against the
kubelet's own API in another chapter)_

![bg right:30%](images/rusty_x_chain.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Gobi (CC BY 2.0)" -->
There exist two identity subject types:
**"users"** and **"service accounts"**.  

![bg right:30%](images/neon_cyborg.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rod Waddington (CC BY-SA 2.0)" -->
Service accounts are primarily\* used to
provide API server access for workloads
running on top of Kubernetes.  

An application running in a pod may
want to query available services.  

Created as a namespace-bound object.  

Always exist at least one called
"default" in each namespace.  
  
_(shouldn't be used by humans)_

![bg right:30%](images/robot_streetart.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Stig Nygaard (CC BY 2.0)" -->
Every other authentication subject
is simply a "user".

No difference if user is a human,
a CI/CD tool, the kublet on a node
or a control plane component.  

A user can be member of multiple groups.  

_(no support for nested groups)_

![bg right:30%](images/little_tilde.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Torkild Retvedt (CC BY-SA 2.0)" -->
## Available authenticators\*
- Proxy request headers
- Simple tokens
- Mutual TLS ("client certificates")
- OpenID Connect
- External webhook
- Bootstrap tokens
- _Service account tokens_

![bg right:30%](images/curious_cameleon.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Halfrain (CC BY-SA 2.0)" -->
Beside a name and group memberships,
the authenticator can add arbitrary
attributes to the "UserInfo" object
("extra" list property).  

Fingerprint/Serial of used certificate,
information about which methods were
used multifactor authentication,
device attestation status, etc!

Available in audit logs and for
(custom) authorization modules.

![bg right:30%](images/vintage_machine.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Randy Adams (CC BY-SA 2.0)" -->
All successfully authenticated users become
members of the "system:authenticated" group.

Requests without authentication information
are assigned the user "system:anonymous" and
a group membership in "system:unauthenticated".  

Useful for providing access to endpoints
like "/healthz" and "/metrics", but scary.

[KEP #4633](https://github.com/kubernetes/enhancements/issues/4633) aims to minimize
the risk of this foot-gun.

![bg right:30%](images/abstract_pattern_grey.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% George N (CC BY 2.0)" -->
Clients with access to credentials can
query the ["SelfSubjectReview" API](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/self-subject-review-v1/) to
get their name, groups and whatever
else the authenticator provided.

Users (with adequate privileges) may
supply "impersonation headers" to
override information provided by
the authenticator - useful for
debugging and escalation,
checkout ["kubectl-sudo"](https://github.com/postfinance/kubectl-sudo).
  
_(usage of both features can and
probably should be logged)_

![bg right:30%](images/neon_and_laser.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Randy Adams (CC BY-SA 2.0)" -->
## Limitations and gotchas
Users don't exist as API resources.  

Not possible to query users with access,
group memberships and similar.

No difference between user "ada" from
the mTLS authenticator and "ada"
from the OIDC authentication\*.

![bg right:30%](images/abandoned_car_window.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Adam Lusch (CC BY-SA 2.0)" -->
We shall dig deeper into the available
authenticators, look at how they work,
their pros/cons and usage considerations.

![bg right:30%](images/rusty_x_chain.jpg)

<!--
-->
