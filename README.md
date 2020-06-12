# Azure Course Overview

## Week 1: Introduction to Ops With Microsoft Azure

> **topics**: command line fundamentals, REST API deployment on linux and managing azure services through the web GUI

> **note**: deployments on linux VM this week

### day 1: intro to command line with bash and powershell

> **conceptual goals**: understand the similarities and differences between GUI and CLI, fundamental aspects and uses of OS shells, understanding piping

> **practical goals**: (bash and powershell) navigate and manage the file system, install and manage programs, basic scripting, ability to pipe STDOUT to additional shell commands

### day 2: intro to hosting, azure & VMs

> **conceptual goals**: introduction to hosting, basic networking, azure and VMs

> **practical goals**: practicing publishing, executing and connecting to remote (W/LAN) machines, set up their Azure accounts and explore the Azure Portal

### day 3: IaaS, web APIs & REST

> **conceptual goals**: understand purpose and differences between IaaS and on-prem, review web APIs, REST and swagger

> **practical goals**: explore dotnet web API structure and deploy a basic sqlite backed API to azure linux VM through the Azure Portal

### day 4: environment configurations & backing services

> **conceptual goals**: learn about backing services, methods of external configurations and secrets management

> **practical goals**: learn how to use local user-secrets and remote keyvault and deploy an API backed by an embedded mysql container to an azure linux VM through the Azure Portal

### day 5: OAuth, OIDC, azure ADB2C

> **conceptual goals**: learn about OAuth, OIDC, JWTs and azure ADB2C service

> **practical goals**: explore OAuth, setup ADB2C tenant, deploy ADB2C API version with nginx reverse proxy for self-signed TLS termination through the Azure Portal

# Week 2: Automated Ops & Troubleshooting With Azure

> **topics**: managing and automating azure deployment to a windows server VM from the command line, automated scripting, dev and ops troubleshooting, conceptual overview of out-of-scope ops topics

> **note**: deployments on windows server VM this week

### day 1: introduction to azure CLI and windows server deployment

> **conceptual goals**: learn about the az CLI and manual deployment to IIS on a windows server VM

> **practical goals**: how to provision and configure a windows server VM and keyvault using the az CLI, install and configure IIS over RDP, deploy the ADB2C API version manually

### day 2: automated script deployments to linux and windows server

> **conceptual goals**: continued exposure to powershell and bash scripting to automate provisioning and configuration using the az CLI, introduction to SSH and SCP for interfacing with headless linux VMs, comparing and contrasting windows (powershell) and linux (bash) based automations

> **practical goals**: write automation scripts for provisioning and configuring windows server (powershell) and ubuntu (bash) VMs, using openssl to provision self-signed certs, use SSH and SCP to configure and deliver to the linux VM

> **note**: windows server delivery with git over RDP, linux delivery via SSH and SCP

### day 3: introduction to CI/CD with Azure DevOps Pipelines

> **conceptual goals**: learn the fundamentals of continuous integration, delivery, and deployment, introduction to Azure DevOps Pipelines, conceptual overview of pipeline stages and use cases

> **practical goals**: understanding YML syntax and pipeline configuration directives, provision and configure two Azure DevOps Pipelines to automate build, publish, and deployment stages to a windows server VM and linux VM

### day 4: (devops troubleshooting) identifying, isolating, communicating and potential solutions

> **conceptual goals**: gaining independence with application-level troubleshooting and root cause analysis. gaining independence with ops-level troubleshooting and root cause analysis from the VPC to the VM

> **practical goals**: understanding timeouts and 5XX status codes, VPC-level issues, VM-level issues, communicating and implementing solutions. hands-on troubleshooting by accessing and analyzing logs, tracing 4XX/500 status codes, communicating and implementing solutions

### day 5: next steps

> **conceptual goals**: closing exposure to other ops terminology, services, and best practices
