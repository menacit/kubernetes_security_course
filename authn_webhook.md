---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Webhook authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about webhook authentication in Kubernetes"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Dennis van Zuijlekom (CC BY-SA 2.0)" -->
# Webhook authentication
### External identity validation

![bg right:30%](images/usb_leds.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Dennis van Zuijlekom (CC BY-SA 2.0)" -->
....first
TODO: When all else fails, we can delegate auth decisions

![bg right:30%](images/usb_leds.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Info about how this is configured on the API server

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Code example of JSON sent to webhook

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Code example of expected response

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: Design/deployment considerations,
run in cluster/outside, risks/latency

![bg right:30%](images/.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% " -->
TODO: How do we get users to supply the custom token?
Same as with the refresh token described in OIDC slides

![bg right:30%](images/.jpg)

<!--
-->
