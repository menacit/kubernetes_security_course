---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Pod security standards"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about pod security admission for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Jeena Paradies (CC BY 2.0)" -->
# Pod security admission
### Enforcing hardening/isolation

![bg right:30%](images/frosty_lion.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jeena Paradies (CC BY 2.0)" -->
Kubernetes provides the ability to tweak
options for container isolation/hardening.  
  
Many of these can be abused to
(intentionally) break out of pods
and/or escalate cluster privileges.

"Pod security standards" can be used in unison
with the "pod security admission controller"
to limit/control usage of these options.

Replaces the "pod security policy" feature
removed in version 1.25.

![bg right:30%](images/frosty_lion.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
Pod security standards define three different
profiles which specify acceptable values
for configuration options in a pod.

"Setting X may be set to Y or Z".

"Setting X may not be set to Y or Z".

Ain't much fancier than that.

![bg right:30%](images/rogers_place_truss.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
**Name:** Host namespaces.  
**Description:**  
Sharing the host namespaces must be disallowed.

**Restricted fields:**
- spec.hostNetwork
- spec.hostPID
- spec.hostIPC
  
**Allowed values:**
- false
- Undefined/nil

![bg right:30%](images/rogers_place_truss.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
### "privileged" profile
No disallowed settings. May be suitable for
pods that need access to underlying node's
filesystem, kernel configuration, network,
or raw access to hardware like NPUs.

### "baseline" profile
Restricts known breakout techniques while
trying to maintain "compatibility".

### "restricted" profile
Aims to follow security best-practices,
may block undiscovered breakout techniques.

![bg right:30%](images/rogers_place_truss.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
Profiles are versioned and may be updated
during minor upgrades of Kubernetes
(like "v1.32", not "v1.32.2").

Updates may fix newly identified
breakout techniques, yay!

Updates may break existing workloads
in your cluster, nay!

Profile configuration permits
"latest" or a specific version.

![bg right:30%](images/rogers_place_truss.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rod Waddington (CC BY-SA 2.0)" -->
Validation against one or more profiles
can be configured using namespace labels.

For each profile, we may define a
"validation mode"...

![bg right:30%](images/yemen_mountain_fort.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rod Waddington (CC BY-SA 2.0)" -->
### "audit" mode
Profile violations are logged server-side.

### "warn" mode
Warning message is returned to the submitter.

### "enforce"
Pod creation/update is rejected.

![bg right:30%](images/yemen_mountain_fort.jpg)

<!--
-->

---
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: alpha-frontend
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
```

<!--
-->

---
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: bravo-backend
  labels:
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/audit-version: latest
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/warn-version: latest
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/enforce-version: v1.32
```

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rod Waddington (CC BY-SA 2.0)" -->
Let's see it in action, shall we?

![bg right:30%](images/mauritius_forest.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fritzchens Fritz (CC0 1.0)" -->
The admission controller may be configured
by configuration file on API server node.

Default profile/validation modes for
namespaces without appropriate labels.

Ability to exclude specific namespaces,
runtime classes (be careful) and
users (not groups, sadly).

May not be available in clusters
with a "managed control plane".

![bg right:30%](images/chip_closeup_side.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fritzchens Fritz (CC0 1.0)" -->
```yaml
---
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
  - name: PodSecurity
    configuration:
      apiVersion: pod-security.admission.config.k8s.io/v1
      kind: PodSecurityConfiguration
      defaults:
        enforce: "baseline"
        enforce-version: "latest"
        audit: "restricted"
        audit-version: "latest"
        warn: "restricted"
        warn-version: "latest"
      exemptions:
        usernames:
          - ada
          - bob
        runtimeClasses:
          - super-restricted-runtime
        namespaces:
          - kube-system
          - cilium
```

![bg right:30%](images/chip_closeup_side.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% M. Zamani, ESO (CC BY 2.0)" -->
## Usage recommendations
Start with "audit: baseline", observe logs,
"enforce: baseline" and "audit: restricted".

Implement process of rolling pod
restarts/rescheduling in order
to detect breaking workloads
after profile updates.

Consider risks of (not) excluding
"infrastructure namespaces",
like "kube-system".

Make sure that users aren't permitted
to manipulate namespace labels...

![bg right:30%](images/la_silla_at_night_closeup.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jeena Paradies (CC BY 2.0)" -->
## Wrapping up

![bg right:30%](images/frosty_lion.jpg)

<!--
-->
