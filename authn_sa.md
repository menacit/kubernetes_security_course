---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Service account authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about service account authentication for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Bixentro (CC BY 2.0)" -->
## Service account authentication

![bg right:30%](images/pcb_baby.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Bixentro (CC BY 2.0)" -->
....first
TODO: Identity for workloads

![bg right:30%](images/pcb_baby.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Created as namespace-bound objects,
always one named "default", create more as needed for workloads

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Identified using a JWT,
signed using RSA or ECDSA by API server,
if not specified uses TLS key (bad),
key from file or ExternalServiceAccountTokenSigner feature gate

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Legacy long-lived tokens VS new time-bound tokens

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Legacy tokens, token generated and stored as secret,
default enabled until X, still usable by adding annotation

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Downsides with legacy tokens

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Intro to new kind of tokens

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Remember "--service-account-max-token-expiration",
legacy tokens can't be disabled by an option,
using VAP to disallow it/audit logging to detect it,


![bg right:30%](images/.jpg)

<!--
-->
