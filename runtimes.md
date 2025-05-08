---
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0

title: "Kubernetes security course: Runtimes"
author: "Joel Rangsmo <joel@menacit.se>"
footer: "© Course authors (CC BY-SA 4.0)"
description: "Runtimes presentation for Kubernetes security course"
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
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
# Container runtimes
### Usage and security considerations

![bg right:30%](images/black_and_white_dome.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
Kubernetes does not run
pods/containers by itself.  
  
When a pod has been scheduled,
the kublet forwards the definition
to a container runtime using... ehm,
the **C**ontainer **R**untime **I**nterface.
  
Your choice of runtime may affect
security and break-out risks.

Let's have a look at some runtimes
and discuss their pros/cons!

![bg right:30%](images/black_and_white_dome.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Rod Waddington (CC BY-SA 2.0)" -->
Unfortunately, the term "container runtime"
is a bit overloaded.  

**High-level** VS **Low-level**.

High-level exposes CRI over UNIX socket or
"named pipe", downloads/verifies images,
handles status monitoring, etc.
  
Low-level takes a file system root,
sets up namespaces/isolation and
starts the container.

High-level runtime calls one or
more low-level runtimes.

![bg right:30%](images/ayeaye.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
## High-level runtimes
The two most popular options are
[containerd](https://containerd.io/) and [CRI-O](https://cri-o.io/).

containerd is a Swiss army knife.

CRI-O is minimal and specifically
designed for usage with Kubernetes.

Not huge impact on security, but more
features/complexity increases risks of flaws.

Checkout [Nokia's "containerd-bench-security"](https://github.com/nokia/containerd-bench-security).

![bg right:30%](images/gas_refinery_orange.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Miguel Discart (CC BY-SA 2.0)" -->
## Low-level runtimes
The two most popular options are
[runc](https://github.com/opencontainers/runc) (Go) and [crun](https://github.com/containers/crun) (C).

Both utilize sandboxing features on Linux
to provide "OS-level virtualisation".

Low performance and resource overhead,
but relatively weak security isolation.

_(security considerations associated
with OS-level virtualisation are
out-of-scope for this course)_

![bg right:30%](images/led_triangle_bars.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Thierry Ehrmann (CC BY 2.0)" -->
Alternatives exist, yay!

Most aim to improve isolation and/or
security of the workload.

Let's have a closer look at:

- [Kata Containers](https://katacontainers.io/)
- [gVisor](https://gvisor.dev/)
- [runwasi](https://runwasi.dev/)

![bg right:30%](images/rusty_shed.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Dennis van Zuijlekom (CC BY-SA 2.0)" -->
## Kata Containers
Runs each pod in a dedicated and
slimmed-down virtual machine.

Pods are isolated by HW-level
virtualisation, not OS kernel.
  
Minimize risk of breakout and
bugs affecting node stability.

Supports several different VMMs,
like QEMU and Firecracker.

![bg right:30%](images/brown_orange_pdp.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Dennis van Zuijlekom (CC BY-SA 2.0)" -->
Requires "nested virtualisation" support
or bare-metal worker nodes.

Significantly higher overhead compared
to OS-level virtualisation.

Trickier to access shared hardware and
accelerators, like GPUs.

Increased operational complexity.

![bg right:30%](images/brown_orange_pdp.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Edenpictures (CC BY 2.0)" -->
## gVisor
Provides "isolation layer" between
containers and the underlying OS.

Uses emulation and filtered proxying
of system calls in user space to
limit Linux kernel access.

Minimizes the risk of breakouts
without requiring support for
(nested) HW-level virtualisation.

![bg right:30%](images/abstract_building_orange.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Edenpictures (CC BY 2.0)" -->
Doesn't perfectly imitate a real
Linux kernel, affects compatibility.

May significantly impact performance,
depending on workload characteristics.

Weaker isolation boundary compared 
to HW-level virtualisation.

![bg right:30%](images/abstract_building_orange.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fritzchens Fritz (CC0 1.0)" -->
## runwasi
Helps running ["**W**eb **as**se**m**bly"](https://webassembly.org/) applications
in a similar fashion to Linux containers.

Provides an execution sandbox that is
simple, well-defined and restrictive.

Supports several different
underlying WASM "hosts/runtimes".

![bg right:30%](images/chip_closeup_orange_green.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Fritzchens Fritz (CC0 1.0)" -->
Applications must be specifically
built/compiled against WASM target,
significantly affecting compatibility.

Potentially decreased performance
compared to native binaries.

Less mature ecosystem.

![bg right:30%](images/chip_closeup_orange_green.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
Ain't all or nothing - thanks to
the ["RuntimeClass" feature](https://kubernetes.io/docs/concepts/containers/runtime-class/) we can
utilize different low-level runtimes
for our pods depending on their needs.  
  
How do we get started?

![bg right:30%](images/abandoned_half_car.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
## Node preparation
Installation/configuration of
low-level runtime software on
all or a subset of worker nodes.

Configuration of high-level runtime
to expose low-level runtime as a
"named" or default handler:

```toml
[crio.runtime.runtimes.example]
  runtime_path = "/bin/myexample"
```

Utilize configuration management tool
or manage setup using DaemonSets.

![bg right:30%](images/abandoned_half_car.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
```yaml
---
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: custom
handler: example 
scheduling:
  nodeSelector:
    kubernetes.io/os: linux
    host-type: bare-metal
```

![bg right:30%](images/abandoned_half_car.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Nicholas A. Tonelli (CC BY 2.0)" -->
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: example
spec:
  runtimeClassName: custom
[...]
```

![bg right:30%](images/abandoned_half_car.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Kurayba (CC BY-SA 2.0)" -->
Beware that there is no built-in way
to configure a default/list of permitted
runtimes per namespace, user, group, etc.

(custom admission controllers/policies
could help you - more about those later!)

![bg right:30%](images/boarded_brick_windows.jpg)

<!--
-->

---
<!-- _footer: "%ATTRIBUTION_PREFIX% Jason Thibault (CC BY 2.0)" -->
## Wrapping up

![bg right:30%](images/black_and_white_dome.jpg)

<!--
-->
