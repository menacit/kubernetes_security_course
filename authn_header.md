---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Header authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about header authentication for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Asparukh Akanayev (CC BY 2.0)" -->
# Header authentication
### Access using proxy headers

![bg right:30%](images/mesh_head.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Asparukh Akanayev (CC BY 2.0)" -->
Simplest form of authentication
available in Kubernetes.  

Extract user/group information
from HTTP request headers
to the API server.
  
Delegate responsibility of
validating identity to a
third-party system.  

Somewhat popular solution to
jack into cloud provider IAM.

![bg right:30%](images/mesh_head.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Eric Kilby (CC BY-SA 2.0)" -->
Not activated by default, provide
`--requestheader-username-headers=X-Foo`
and `--requestheader-group-headers=X-Bar`
as startup arguments to the API server.

No built-in default header name,
but the fine documentation suggests
"X-Remote-User", "X-Remote-Group" and
"X-Remote-Extra-*" (key ID, MFA method etc!).

_(a good start for black-box testing)_

![bg right:30%](images/hanging_sloth.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
HTTP clients with API server access could
supply arbitrary request headers and thereby
impersonate any user/group membership.

Obviously a... less than ideal situation.

Can we mitigate this problem?

![bg right:30%](images/abandoned_chimney.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Restrict exposure of API server,
only permitting network access
from the intended proxies.

`--requestheader-client-ca-file=ca.crt`
enforces mutual TLS authentication between
proxies and the API server before parsing
user/group memberships from headers.

`--requestheader-allowed-names=myproxy`
(CNs permitted to provide the headers)
can be used to further restrict parsing. 

![bg right:30%](images/green_rock_wall.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Randy Adams (CC BY-SA 2.0)" -->
Furthermore, the authentication proxy
must filter incoming request headers
carefully - beware of case insensitivity,
ignored header name characters, etc!).

Recommended to drop header prefixes like
"X-Remote-*" instead of exact matches
(remember "X-Remote-Extra-\*"?).

![bg right:30%](images/abstract_pattern_man.jpg)

<!--
-->

---
## Detection recommendation
- Unexpected attempts to bypass authentication proxy by directly communicating with API server
- Attempts to supply user/group/extra headers (post-authentication)
- Unexpected group headers from authentication proxy (like "system:nodes" and "system:masters")

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Asparukh Akanayev (CC BY 2.0)" -->
## Wrapping up
Simple to use, non-trivial to get right.

![bg right:30%](images/mesh_head.jpg)
