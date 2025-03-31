<!--
SPDX-FileCopyrightText: © 2025 Menacit AB <foss@menacit.se>
SPDX-License-Identifier: CC-BY-SA-4.0
X-Context: Kubernetes security course
-->

# Lab exercise: "fix\_net\_policy"


## Scenario description
TODO.


## Learning objectives
Practical experience of defining and auditing Kubernetes network policies.


## Lab overview
The lab exercise consists of YAML manifests containing network policy definitions and a comment
describing the intended goal of restricting/permitting traffic ("manifests/*.yaml"). Each policy
contains at least one error that permits unintended network communication. To complete the lab, the
student should modify each network policy manifest to correct the identifies issues. 


## Lab report/documentation
Each student should submit a lab report containing **at least** the following information:
- Descriptions of what was wrong with each provided network policy
- Demonstration that the modified and correct network policy permits intended traffic
  
The lab report should be provided as a plain text file (".txt"), Markdown document or PDF file.
In addition to the report, all files that have been changed (scripts, configuration sets, etc.) or
created to complete the lab exercise should be provided as a ZIP or GZIP archive.  
  
Upload the lab report and archive containing changed files to %REPORT_TARGET%.


## Guidance and resources


### Links
- [Concepts - Network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [GitHub - ahmetb/kubernetes-network-policy-recipes](https://github.com/ahmetb/kubernetes-network-policy-recipes)
