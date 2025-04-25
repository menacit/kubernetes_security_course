<!--
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0
X-Context: Kubernetes security course
-->

# Lab exercise: "webhook_authz"


## Scenario description
TODO.


## Learning objectives
Practical experience of developing and configuring usage custom webhook authorizers.


## Lab overview
To complete the lab exercise, the student should develop an authorizer that denies all reviews
from users who are a member of the "catz" group. Any programming language may be used for
development of the authorizer, but it should expose the standard Kubernetes webhook interface.

In addition, the student should configure the API server to utilize the authorizer for all
requests except get and list requests for configuration map resources.


## Lab report/documentation
Each student should submit a lab report containing **at least** the following information:
- Descriptions of steps required develop and configure usage of webhook authorizer
- Demonstration that the webhook authorizer works as intended
  
The lab report should be provided as a plain text file (".txt"), Markdown document or PDF file.
In addition to the report, all files that have been changed or created (scripts, configuration
sets, etc.) to complete the lab exercise should be provided as a ZIP or GZIP archive.  
  
Upload the lab report and archive containing changed files to %REPORT_TARGET%.


## Guidance and resources


### Links
- [Official documentation - "Authorization"](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)
- [Official documentation - "Webhook authorization"](https://kubernetes.io/docs/reference/access-authn-authz/webhook/)
- [API reference - "SubjectAccessReview"](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/subject-access-review-v1/)
- [Official documentation - "CEL in Kubernetes"](https://kubernetes.io/docs/reference/using-api/cel/)
- [Simple example webhook authorizer](https://github.com/menacit/k8s_crlish_authorizer)
- [Emre Savcı - webhook authorization guide](https://mstryoda.medium.com/kubernetes-beyond-rbac-make-your-own-authorization-via-webhook-6b901196591b)
