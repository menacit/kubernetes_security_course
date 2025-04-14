---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Simple token authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about simple token authentication in Kubernetes"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Guilhem Vellut (CC BY 2.0)" -->
## Simple token authentication

![bg right:30%](images/abandoned_door.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Guilhem Vellut (CC BY 2.0)" -->
By specifying `--token-auth-file=users.csv`
as an argument to the API server, we can
define users in a simple text file:

> token,user,uid,"group-1,group-2"

Trivial to add users and revoke access.  
  
Provided as a "bearer token" by clients.

![bg right:30%](images/abandoned_door.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Johan Neven (CC BY 2.0)" -->
# The downsides
You'll have to generate the tokens.

No hashing of stored tokens,
increased risk of leakage.

Not hot-reloadable, requires restart
of the API server (not so scalable).

![bg right:30%](images/rusty_guard.jpg)

<!--
-->
