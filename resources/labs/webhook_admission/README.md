<!--
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0
X-Context: Kubernetes security course
-->

# Lab exercise: "webhook\_admission"


## Scenario description
TODO.


## Learning objectives
Practical experience of developing and configuring usage custom webhook admission controller.


## Lab overview
To complete the lab exercise, the student should develop an admission controller that modifies
pod creation requests by adding the label "suspicious=indeed" if the following criteria are met:

- Submitter is a member of the "officehours" group
- Request was performed outside the time window 07:00 UTC to 19:00 UTC

Any programming language may be used for development of the admission controller, but it should
expose the standard Kubernetes webhook interface. In addition, the student should configure the
API server to utilize the admission controller for all requests.


## Lab report/documentation
Each student should submit a lab report containing **at least** the following information:
- Descriptions of steps required develop and configure usage of webhook admission controller
- Demonstration that the webhook admission controller works as intended
  
The lab report should be provided as a plain text file (".txt"), Markdown document or PDF file.
In addition to the report, all files that have been changed or created (scripts, configuration
sets, etc.) to complete the lab exercise should be provided as a ZIP or GZIP archive.  
  
Upload the lab report and archive containing changed files to %REPORT_TARGET%.


## Guidance and resources


### Links
- [Official documentation - "Admission controllers"](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
- [Official documentation - "Dynamic admission control"](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)
- [API reference - "Admission v1"](https://kubernetes.io/docs/reference/config-api/apiserver-admission.v1/)
