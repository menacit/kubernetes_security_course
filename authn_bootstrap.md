---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Bootstrap authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about bootstrap authentication mode for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Pumpkinmook (CC BY 2.0)" -->
# Bootstrap authentication
### ....

![bg right:30%](images/glitch_face.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Pumpkinmook (CC BY 2.0)" -->
....first
TODO: explain the need

![bg right:30%](images/glitch_face.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Similar to simple tokens,
except stored as objects, configurable expiry (controller must be enabled)

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Intended workflow, post CSR

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Risk mitigation, require exp with VAP/detect when not submitted,
max expiry (get time in CEL? or exp - submission time?)

![bg right:30%](images/.jpg)

<!--
-->
