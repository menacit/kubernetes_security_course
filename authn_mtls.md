---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Mutual TLS authentication"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Presentation about mTLS authentication for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Kristina Hoeppner (CC BY-SA 2.0)" -->
# mTLS authentication
### Access using "client certificates"

![bg right:30%](images/metal_sheep.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kristina Hoeppner (CC BY-SA 2.0)" -->
Simple-to-use authentication mechanism
based on X.509 certificates and mutual TLS.  

Commonly used for control plane components and
node services (kubelet, kube-proxy, etc.).  
  
May be utilized for human users as well,
as demonstrated by kubeadm.

![bg right:30%](images/metal_sheep.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
Once a certificate has been validated
against a CA specified by `--client-ca-file`,
a user is extract from the "common name" field
and group(s) from the "organization" field(s).

_(not from the OU fields, as one might expect)_

![bg right:30%](images/biosphere_at_night.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% William Warby (CC BY 2.0)" -->
Since version 1.32 of Kubernetes,
the X.509 authorizer also adds a
"credential ID" to the user object.  

Basically a SHA-2 256 hex digest of
the certificate in DER format.

```
$ openssl \
    x509 -in cert.pem -outform der \
  | sha256sum | cut -d ' ' -f 1
```

Accessible in API server audit logs
and for (custom) authorizers.

![bg right:30%](images/grey_monkey.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Andrew Hart (CC BY-SA 2.0)" -->
No support for revocation checking,
neither CRL nor OCSP! :-/  

Requires swapping out `--client-ca-file`.  

Known issue [since at least 2015](https://github.com/kubernetes/kubernetes/issues/18982).

![bg right:30%](images/broken_glass.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Any mitigations?

![bg right:30%](images/abandoned_factory_fence.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Minimize usage, especially for humans and
non-control plane components.  

Avoid reusing usernames,
don't tie authorization rules to
groups used in certificates.  

Define short expiry dates.

![bg right:30%](images/abandoned_factory_fence.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Configure monitoring and alerting of
X.509 authenticated users with...

- Unexpected username prefix
- Unexpected group membership
- Known compromised credential ID

![bg right:30%](images/abandoned_factory_fence.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Utilize a reverse proxy enforcing mTLS
and provide user/group(s) through headers.  

Deploy and configure usage of a custom
authorizer like ["k8s\_crlish\_authorizer"](https://github.com/menacit/k8s_crlish_authorizer).  

_(neither option is however perfect_)

![bg right:30%](images/abandoned_factory_fence.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kristina Hoeppner (CC BY-SA 2.0)" -->
## Wrapping up

![bg right:30%](images/metal_sheep.jpg)

<!--
-->
