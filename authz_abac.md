---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: ABAC authorization"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about ABAC authorization mode in Kubernetes"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Wolfgang Stief (CC0 1.0)" -->
# ABAC authorization
### Somewhat simple access control

![bg right:30%](images/locked_computer.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Wolfgang Stief (CC0 1.0)" -->
**A**ttribute-**B**ased **A**ccess **C**ontrol.

Somewhat rare to see usage these days,
[several attempts to deprecate it](https://github.com/kubernetes/website/pull/48780).

If nothing else, it serves as a stepping
stone for understanding slightly more
complex alternatives like "RBAC".

![bg right:30%](images/locked_computer.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kojach (CC BY 2.0)" -->
Deny everything by default when activated.

A "policy" describes that one subject
(user, group or service account)
should be allowed to perform a
request based on "filters".

Filter on namespace, resource group/kind
and non-resource paths (like "/healthz").

Optionally only permit "read-only access"
(resource verbs "get", "list" and "watch").

Policies are defined in a ["JSONL" file](https://jsonlines.org/)
on the API server's file system.

![bg right:30%](images/punch_cards_backlit.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Martin Fisch (CC BY 2.0)" -->
Let's have a look at some policies
and try to break 'em down!

_(we'll use regular JSON for readability)_

![bg right:30%](images/grey_albatross.jpg)

<!--
-->

---
```json
{
  "apiVersion": "abac.authorization.kubernetes.io/v1beta1",
  "kind": "Policy",
  "spec": {
    "group": "database-maintainers",
    "namespace": "bank-backend",
    "apiGroup": "apps/v1",
    "resource": "statefulsets"
  }
}
```

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Mike Grauer Jr (CC BY 2.0)" -->
```json
{
  "group": "database-maintainers",
  "namespace": "bank-backend",
  "apiGroup": "apps/v1",
  "resource": "statefulsets"
}
```

![bg right:30%](images/pillar_cubes.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Maja Dumat (CC BY 2.0)" -->
```json
{
  "user": "status-monitor-bot",
  "namespace": "*",
  "resource": "pods",
  "readonly": true
}
```

![bg right:30%](images/concret_tunnel_pipe.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Halfrain (CC BY-SA 2.0)" -->
```json
{
  "group": "grumpy-auditors",
  "namespace": "production",
  "apiGroup": "*",
  "resource": "*",
  "readonly": true
}
```

![bg right:30%](images/planetarium_projector.jpg)

<!--
- Permits access to secrets as well
- Reminder that we can only allow, not deny
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Ron Cogswell (CC BY 2.0)" -->
```json
{
  "user": "system:unauthenticated",
  "nonResourcePath": "/healthz",
  "readonly": true
}
```

```json
{
  "group": "system:authenticated",
  "nonResourcePath": "/status/*",
  "readonly": true
}
```

![bg right:30%](images/orange_contrails.jpg)

<!--
-->

---
```json
{
  "user": "system:serviceaccount:kube-system:admin-app",
  "namespace": "*",
  "apiGroup": "*",
  "resource": "*"
}
```

```json
{
  "user": "system:serviceaccount:kube-system:admin-app",
  "nonResourcePath": "*"
}
```

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
## Limitations and downsides
No fine-grained control over request verb,
just read-only or everything.

One policy per resource kind,
which can result in a loooot of polices.  
  
Policies are defined in a file,
requires restart of API server\*.

Policy file isn't automatically synced
between control plane nodes in a cluster...

![bg right:30%](images/outdoors_pcb.jpg)

<!--
-->
