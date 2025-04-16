---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Testing methodology"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Introduciton to testing methodology for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% William Warby (CC BY 2.0)" -->
# Testing methodology
### Structuring security assessments

![bg right:30%](images/test_dummy.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% William Warby (CC BY 2.0)" -->
Kubernetes is a complex system that provides
many opportunities to expose vulnerabilities.

Performing security assessments before
trusting a cluster with all your
precious data makes sense.

The following slides will try to provide
guidance for structuring such assessments.

![bg right:30%](images/test_dummy.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Sbmeaper1 (CC0 1.0)" -->
## Scope and limitations
Primarily focus on "white-box" assessments.

Many things to consider that ain't
Kubernetes-specific - won't talk about that.

Specific tools and techniques will be
covered in-depth in other presentations.

![bg right:30%](images/tree_pillar_island.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Halfrain (CC BY-SA 2.0)" -->
Purpose of assessment - CIS compliance,
detection-response training, due diligence, etc.?

What are you end-goals? Access to a sensitive
data store? IaaS environment breakout?
system:masters for the fun of it?

Who are you trying to defend against? Are all
cluster users fully or equally trusted?

Multitenancy requirements ("soft" VS "hard")?

![bg right:30%](images/cherry_trees_white.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jonathan Brandt (CC0 1.0)" -->
What's the assessments starting point?
("realism" VS "cost-efficiency/depth")

Some reasonable options are...

- "External assessment"
- "Compromised pod"
- "Compromised user"
- "Configuration review"

![bg right:30%](images/neon_voxel.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fredrik Rubensson (CC BY-SA 2.0)" -->
## "External assessment"
Ye' good old penetration test, can be
performed more or less "black-box".

Need to dig up some node and/or
load-balancer addresses.

Gain an initial foothold using a
compromised pod, node or user account.

![bg right:30%](images/factory_fence.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fredrik Rubensson (CC BY-SA 2.0)" -->
Exploiting application vulnerabilities
in intentionally exposed applications,
providing shell or service account token.

Gaining access through accidentally
exposed applications via a NodePort.  
  
Exploiting administration/monitoring
services running on nodes.

Gaining access to the Kubelet API.

Phishing or guessing of user credentials
trusted by an API server authenticator.

![bg right:30%](images/factory_fence.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Milan Bhatt (CC BY-SA 2.0)" -->
## "Compromised pod"
Very sensible starting point for
an "assume breach" scenario.

Enumerate isolation, hardening
and detection capabilities.

Escalate privileges by lateral movement
and container/cluster breakout.
  
Typically provides (limited) access to
API server through a service account token.

![bg right:30%](images/whale_tail.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Milan Bhatt (CC BY-SA 2.0)" -->
How do we setup a "source pod" for testing?

We could `kubectl exec` into an existing
container, but that... has some downsides.  
  
Some reasonable options are...

- "Purpose-built pod"
- "Cloned pod"
- "Ephemeral container"

![bg right:30%](images/whale_tail.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Thierry Ehrmann (CC BY 2.0)" -->
## "Purpose-built pod"
Define a dedicated pod as a stable base
point for your hacking adventures!

Don't worry about breaking it
or unexpected termination.  
  
Container image of your own choosing -
doctor-love's ["k8s\_assessment\_tools"](https://github.com/Doctor-love/k8s_assessment_tools)
may serve as an inspiration.  
    
Simple and straight forward, right?

![bg right:30%](images/forest_wheel_core.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Thierry Ehrmann (CC BY 2.0)" -->
There are some complicating factors,
the "real" cluster pods may have...

- Labels used by network policies
- Service account tokens providing access
- Mounted juicy secrets/configmaps/volumes
- Been scheduled on an interesting node
- A securityContext/image making usage tricky

Which will you mimic? What level of
realism are you aiming for?

![bg right:30%](images/forest_wheel_core.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kristina Hoeppner (CC BY-SA 2.0)" -->
## "Cloned pod"
Let's avoid making the hard decisions
by copying an existing pod definition!

Optionally override image in source pod
for your own convenience/efficiency.

In theory, fairly trivial:

```
$ kubectl debug \
    source-pod --copy-to=hack-pod \
    --same-node=true \
    --set-image='*=hacking_image:v1'
```

![bg right:30%](images/metal_sheep.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kristina Hoeppner (CC BY-SA 2.0)" -->
Unsurprisingly, this approach has
a few of its own drawbacks...

Labels are not only used by to restrict
network traffic, but also route it.

Some volume types are only available
to one consumer at a time.

If image is changed, we'll likely need
to tweak readiness probes and similar.

Beware of "peer discovery", etc!  
  
![bg right:30%](images/metal_sheep.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Micah Elizabeth Scott (CC BY-SA 2.0)" -->
## "Ephemeral containers"
Feature introduced in v1.23 to spawn
temporary containers into running pods.  
  
Live with the same network restrictions,
scheduling, single-consumer volumes...

Same network namespace, listen to traffic!

Not everything is shared automatically
by containers in a pod, for good/bad.

A tool like [k8s\_ephemeral\_mimic](https://github.com/menacit/k8s_ephemeral_mimic) can
help bridge the gap and find a balance.

![bg right:30%](images/solder_pcb.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Micah Elizabeth Scott (CC BY-SA 2.0)" -->
While neat, even this approach
comes with some downsides.

Usage counts against the pod's
resource allocation ("requests/limits").

With shared namespaces/volume mounts,
risk of accidental disruption increases.

Execution tied to the pod's lifecycle.

![bg right:30%](images/solder_pcb.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kenny Cole (CC BY 2.0)" -->
Regardless of which approach is chosen,
it's probably a good idea to perform
assessment from multiple pods with
different access/hardening levels.

Which apps/pods are most likely hacked?

Which may have "special access"?

![bg right:30%](images/satellites_cartoon.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Shannon Kringen (CC BY 2.0)" -->
## "Compromised user"
Assessment performed with access to valid
user credentials for the API server.  
  
Should _user X_ be able to access
resources belonging to _team Y_?

What could happen if _user Z_ became
evil or were infected by malware?

Bear in mind: not only humans have
credentials to Kubernetes...

![bg right:30%](images/turtle_friends.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Shannon Kringen (CC BY 2.0)" -->
With access to valid credentials,
we could also (partly) simulate...

- Container breakout/node compromise
- Compromise of pod/service account
- Hack of administration/monitoring tool

![bg right:30%](images/turtle_friends.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
## "Configuration review"
Access to cluster configuration for review.

No need to worry about breaking stuff
or guessing how it's setup.

Doesn't require direct access,
decent option for über sensitive
and/or network-isolated clusters.

Two broad categories of data:
"external configuration" and
"cluster resources".

![bg right:30%](images/habitat_67.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
## "External configuration"
Configuration sets used to get
Kubernetes up and running.

Control plane components,
container runtime, node components,
administration/monitoring tools, etc.

May be hard to get if the cluster is manually
setup or relies on a "managed control plane".

Perhaps a DaemonSet with access to
the node's file system could help?

![bg right:30%](images/habitat_67.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
## "Cluster resources"
Configuration of environment based on
resources defined through the API server.

RBAC roles, network policies,
securityContext of pod containers...

Easy to extract, granted that you have
adequate privileges to read everything.

A tool like [k8s\_resource\_audit](https://github.com/menacit/k8s_resource_audit) could
be executed by the auditor or a
paranoid system administrator
to collect the information.

![bg right:30%](images/habitat_67.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% William Warby (CC BY 2.0)" -->
## Wrapping up

![bg right:30%](images/test_dummy.jpg)

<!--
-->
