---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Admission controller introduction"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Introduction to adminssion controllers for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Scott Merrill (CC BY-SA 2.0)" -->
# Admission controllers
### Validating and manipulating C~~R~~UD

![bg right:30%](images/colorful_pipes.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Scott Merrill (CC BY-SA 2.0)" -->
"Admission controllers" can inspect and
modify requests sent to the API server.

Many of these help us improve security
by preventing dangerous configuration
and enforcing best-practices.

Quite similar to "authorizers",
but only called during resource
creation, updates and deletion.

With RBAC, we can permit _user X_ to
create pods in _namespace Y_, but not
define which image repositories are
considered acceptable.

![bg right:30%](images/colorful_pipes.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Loco Steve (CC BY-SA 2.0)" -->
Admission controllers have access to
the request data and the previous
resource version, if available.

Can reject request or modify
its content before persistence.

Typically categorized as
"validating" or "manipulating".

![bg right:30%](images/allen_garden_graffiti.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jan Bocek (CC BY 2.0)" -->
Includes several ones out-of-the-box,
executed "in-process" on the API server.

Covers many common requirements,
not all enabled/enforced by default.

Customized admission control is
available through "CEL expressions"
and usage of external webhooks.

_(more about these in later presentations)_

![bg right:30%](images/yellow_telephone_pole.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jorge Franganillo (CC BY 2.0)" -->
## Risks and considerations
In-process admission controllers may
slightly increase the API server's
attack surface and stability.

External options, like webhook, may
significantly increase request latency
and be configured to "fail-open".

Faulty handling may affect the
ability to modify cluster resources.

![bg right:30%](images/abandoned_bumper_cars.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Scott Merrill (CC BY-SA 2.0)" -->
We shall dig deeper into some of the
available admission controllers, look at
how they work, their pros/cons
and usage considerations.

![bg right:30%](images/colorful_pipes.jpg)

<!--
-->
