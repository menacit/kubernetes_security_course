---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Authorization introduction"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Introduction to authorization for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Marcin Wichary (CC BY 2.0)" -->
# Authorization options
### A somewhat gentle introduction

![bg right:30%](images/abandoned_factory_bridge.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Marcin Wichary (CC BY 2.0)" -->
Kubernetes supports multiple
authorization modes (AKA "authorizers").  
  
Helps us permit/restrict access to
API server for users and service accounts.  

Designed to fit different needs and
approaches to access control.

![bg right:30%](images/abandoned_factory_bridge.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kuhnmi (CC BY 2.0)" -->
## Available authorizers\*
- **A**ttribute-**B**ased **A**ccess **C**ontrol
- **R**ole-**B**ased **A**ccess **C**ontrol
- "Node"
- External webhook

![bg right:30%](images/bird_orange_black.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Todd Van Hoosear (CC BY-SA 2.0)" -->
To make decisions, authorizers are provided with
information about the user and their request.

Username, group memberships and whatever
extra attributes the authenticator has added.  

For "non-resource requests", HTTP verb and path.

For "resource requests", API verb and
the object's namespace/type/name/UID...

`GET /healthz` VS
`create pod "foobar" in namespace "prod"`  

Decision: allow, deny or "no opinion".

![bg right:30%](images/exposed_engine.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Mauricio Snap (CC BY 2.0)" -->
Users in the group "system:masters"
bypass all authorization checks.  

Designed to prevent lock-out,
but also quite dangerous.  

Avoid usage of it whenever possible,
like [kubeadm](https://raesene.github.io/blog/2024/01/06/when-is-admin-not-admin/) tries to.

![bg right:30%](images/green_eye.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Freed eXplorer (CC BY 2.0)" -->
Since v1.32, options for authorizers
are controllable using a dedicated
"AuthorizationConfiguration" file.

Configure processing order, filtering,
failure polices ("open/closed"), etc.  

File is "hot-reloadable\*" and permits
usage of multiple external webhooks.

![bg right:30%](images/tunnel_train.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Freed eXplorer (CC BY 2.0)" -->
```yaml
---
apiVersion: apiserver.config.k8s.io/v1
kind: AuthorizationConfiguration
authorizers:
  - name: credential-revocation-check
    type: Webhook
    webhook:
      failurePolicy: NoOpinion
      authorizedTTL: 60s
      connectionInfo:
        type: KubeConfigFile
        kubeConfigFile: /etc/a.conf
      [...]
      
  - name: node-validator
    type: Node
  - name: rbac
    type: RBAC

  - name: mfa-method-check
    type: Webhook
    webhook:
      matchConditions:
        - expression: has(request.resourceAttributes)
        - expression: "request.resourceAttributes.verb != get"
      failurePolicy: Deny
      connectionInfo:
        type: KubeConfigFile
        kubeConfigFile: /etc/b.conf
      [...]
```

![bg right:30%](images/tunnel_train.jpg)

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Freed eXplorer (CC BY 2.0)" -->
```yaml
---
apiVersion: apiserver.config.k8s.io/v1
kind: AuthorizationConfiguration
authorizers:
  - name: credential-revocation-check
    type: Webhook
    webhook:
      failurePolicy: NoOpinion
      authorizedTTL: 60s
      connectionInfo:
        type: KubeConfigFile
        kubeConfigFile: /etc/a.conf
      [...]
```

![bg right:30%](images/tunnel_train.jpg)

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Freed eXplorer (CC BY 2.0)" -->
```yaml
[...]

  - name: node-validator
    type: Node
  - name: rbac
    type: RBAC

[...]
```

![bg right:30%](images/tunnel_train.jpg)

---
```yaml
[...]

  - name: mfa-method-check
    type: Webhook
    webhook:
      matchConditions:
        - expression: has(request.resourceAttributes)
        - expression: "request.resourceAttributes.verb != get"
      failurePolicy: Deny
      connectionInfo:
        type: KubeConfigFile
        kubeConfigFile: /etc/b.conf
      [...]
```

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Marcin Wichary (CC BY 2.0)" -->
We shall dig deeper into the available
"authorizers", look at how they work,
their pros/cons and usage considerations.

![bg right:30%](images/abandoned_factory_bridge.jpg)

<!--
-->
