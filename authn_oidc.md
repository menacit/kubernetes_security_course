---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: OpenID Connect authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about OIDC authentiation in Kubernetes"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Brendan J (CC BY 2.0)" -->
# OIDC authentication
### Access using OpenID Connect

![bg right:30%](images/security_gate.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Brendan J (CC BY 2.0)" -->
....first
TODO: Intro, most orgs have an IdP supporting OIDC

![bg right:30%](images/security_gate.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Benefits over other mechanisms

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: API server configuration

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: mayhaps demo?

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Limitation, no browser, based flow
....new

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Options, service to distribute
kubeconfigs with refresh token, alt.
command to update that with kubectl,
tool that generates kubeconfig,
using the "exec" credential type...

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Demo of exec kubeconfig

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Using kubelogin with exec credential

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: exploiting kubeconfig,
link to example.

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: A note about raw JWT + StructuredAuthenticationConfiguration

![bg right:30%](images/.jpg)

<!--
-->
