# Week 1: Introduction to Ops With Microsoft Azure

> goal: command line basics, REST API deployment and essential azure services through the web GUI

## day 1: intro to command line with bash and powershell

### conceptual

> goal: understand the similarities and differences between GUI and CLI, fundamental aspects and uses of OS shells

- Fundamental OS Differences (High Level as it relates to this class)
  - Unix
    - Headless / CLI Preference
    - String based
  - Windows
    - GUI Preference
    - Object Oriented based
  - Cross platform tooling
    - Azure CLI
    - Dotnet CLI
    - Git
- shell basics
  - GUI vs CLI
    - similarities: just a change in interface
    - differences: superset of GUI access with higher access
  - terminal emulator (high level: program for interfacing with the shell)
  - scripting languages
    - interacting with the OS
    - REPL
  - file system
    - navigation and management
- Package Managers
  - Installation and Configuration
  - Usage for basic 3rd party package installation
  - Linux: apt
  - Windows: choco
  - PATH
- CLI tools
  - command programs
  - options (configuring commands)
- Piping (combining / controlling commands)
  - passing STDOUT to STDIN between commands
  - BASH: Grep
  - Powershell: Converting strings to objects, filtering, sorting
- scripting
  - configuration of machines
  - automating tasks
  - All 5 programming fundamentals are availble for use (vars, conditionals, loops, functions, data structures)
- remote file editing
  - VIM (high level basic commands)
  - Notepad

### practical

> goals: navigate and manage the file system, install and manage programs, basic scripting

> note: reference guides combined, and individual ref guides w/ isolated atomic exercises at bottom

- fundamentals
  - file system
    - working directory: view and change
    - view and change: working directory
    - files and dirs: create, read, delete, copy and move
  - install CLI tools: dotnet, azure
- scripts
  - create and use variables
  - executing scripts
  - inline evaluation
- windows
  - install powershell core
  - fundamentals and scripts (see above)
  - piping: object conversion, filtering, sorting
- linux
  - setup linux subsystem (ubuntu 18.04 LTS)
  - fundamentals and scripts (see above)
  - piping: filtering via grep

### Walkthrough

- configuring machines
  - install dotnet cli, az cli, and git
- compose multiple commands
- executing scripts
- inline evaulation

### Studio

> developer note: lookup external exercises, and take note of scripting uses throughout the course and mock those here as their final exercises on day 1

## day 2: intro to hosting, azure & VMs

### conceptual

- intro to networking
  - local (loopback), W/LAN, internet
  - addressing (machine IPs, server process ports)
- intro to hosting
  - connecting (URLs, domain IP resolution)
- intro to azure
  - high level (cloud computing, azure services used in the course)
- intro to VMs
  - high level (virtualization, provisioning on-demand, parity)

### practical

- set up azure accounts
- explore azure web portal and available services
- publishing and executing a dotnet core project outside of an IDE
- connecting to a hosted server (local, W/LAN, internet)

### Walkthrough: Setup & Explore Azure

- set up azure accounts and subscriptions
- get familiar with the web portal and available services

### Walkthrough: Running Code From The Command Line

- git clone, setup API project and branch system
- publish, execute, connect (locally)

### Studio: Running Code Anywhere [in person]

- simulating remote machine hosting on a local network
- role playing dev machine and remote hosting machine
- publish, execute, connect (locally) for windows and linux
- instructor-led connecting over LAN to private IP of hosted machine

### Studio: Running Code Anywhere [remote]

- publish, execute, connect (locally) for windows and linux
- simulate remote machine hosting on a local network
- connecting to the host machine by private IP from another device (phone, other computer on network)

## day 3: IaaS, web APIs & REST

### conceptual

- IaaS
  - infrastructure (physical/virtual servers, networks, storage)
  - on-site vs cloud (availability, expenses, management, security)
  - scaling (horizontal, vertical)
- web APIs
  - review essentials (resources, JSON, endpoints)
- REST
  - review essentials (resource organization, methods, status codes)
  - swagger (OpenAPI spec, importance of documentation)

### practical

- dotnet core
  - how an API is configured
- swagger
  - how endpoints are documented
  - how to navigate and use the swagger UI
- using the azure web portal
  - provision and configure a publicly accessible Linux VM
  - use the VM Run Command console
    - configure dependencies
    - clone and publish the 1-sqlite API version
    - run the API
- connect to a hosted project by its public IP

### walkthrough

> **note**: using the azure portal and VM Run Command console

- provisioning a resource group and ubuntu VM
- setup dependencies using the `apt` package manager (dotnet SDK)
- create, publish, and execute a dotnet webapi (default project)
- configuring the NSG for public access
- connect to the hosted project by its public IP
- tearing down resource groups

### studio

> **note**: using the azure portal and VM Run Command console

- provision resource group and ubuntu VM
- setup dependencies using the `apt` package manager (+git)
- configuring the NSG for public access
- clone (delivery), publish, and execute the sqlite API version (`branch: 1-sqlite`)
- connect to the hosted project by its public IP

## day 4: environment configurations & backing services

### conceptual

- backing services
  - external application dependency
    - examples: db, logging, caching
- application environment configs
  - parity and portability across environments (dev, test, staging, prod)
- version control
  - committed (source, public config)
  - ignored (derived, sensitive config)
- external configuration (public, secret)
  - public
    - appconfig, environment variables
  - secret (secrets managers)
    - local: dotnet user-secrets
    - remote: keyvault

### practical

- configuring API to use MySQL
  - configuring appsettings.json
  - configuring Startup.cs for secrets access
- local
  - storing and managing secrets access
    - configuring dotnet user-secrets
    - storing db connection string secret
- remote
  - provisioning KeyVault
  - configuring VM-KeyVault permissions
  - storing db connection string secret
  - update VM deploymeny
    - use azure cloudshell
    - install and configure MySQL backing service
    - run MySQL version of API

### walkthrough: Secrets App

> **note**: using the azure portal and VM Run Command console

- basic API for storing and exposing a secrets echo endpoint
- provisioning and configuring use of a secrets manager
  - local: setup dotnet user-secrets
  - remote: setup azure keyvault
    - provision keyvault
    - add mysql connection string secret
    - grant VM identity and keyvault access
- running app locally and in a VM to show succesful secrets access

### studio: Deploy MySQL Backed API

> **note**: using the azure portal and VM Run Command console

- destroy previous VM (keep RG get rid of VM)
- provision and configure a new ubuntu linux VM
  - extend previous VM configuration to include docker for the embedded db
- provision and configure keyvault for the API
  - store MySQL connection string secret
  - add VM identity
  - grant VM access to keyvault
- clone, publish, execute MySQL backed API version (`branch: 2-mysql-solution`)
- connect to the hosted project by its public IP
- show need for linux system services
  - manually vs automatically starting the API on linux VM startup
  - describe and provide unit file and sysctl commands for running the API as a system service

## day 5: OAuth, OIDC, azure ADB2C

### conceptual

- JWT
  - a verifiable transport medium
  - format (header, signature, payload)
  - authenticity signatures
  - decoding JWT (jwt.io, jwt.ms)
- oauth
  - fundamentals (authentication, authorization, delegation)
  - oauth flows (security, use cases)
- oidc
  - fundamentals (oauth extension spec, id tokens)
  - implicit flow
- Azure ADB2C
  - fundamentals (tenant, providers, scopes, flows)
- authorization
  - external (ops) vs embedded (dev)
  - RBAC vs ABAC

### practical

- API ADB2C integration
  - configuring appsettings.json for ADB2C
  - how to use the swagger UI to make authenticated requests
  - exploring embedded roles and authorization
- ADB2C setup
  - provision and configure ADB2C tenant directory
    - connect ADB2C directory to primary subscription
  - configure API application
    - redirect URIs
    - API access and published scopes
    - local identity provider
    - SUSI flow (provider and claims)
- update deployment with ADB2C API
  - install and configure nginx RP and openSSL self-signed cert
  - update and run latest API version
  - connect to hosted swagger UI

### studio: Visual Oauth

- (https://github.com/launchcodeeducation/visual-oauth)[Visual Oauth]

### walkthrough: Setup ADB2C

- setup ADB2C directory
- link to main subscription
- configure API application
  - redirect URIs
  - API access and published scopes
  - local identity provider
  - SUSI flow (provider and claims)
- test SUSI flow using jwt.ms reply URL

### studio: Deploy ADB2C Integrated API

- configure appsettings.json for ADB2C tenant (commit and push)
- update existing VM
  - stop API service
  - run script for configuring nginx reverse-proxy and cutting a self-signed cert
  - replace with final API version (`branch: 4-member-roles`)
  - restart API service
- connect and explore the final API

# Week 2: Automated Ops & Troubleshooting With Azure

> goals: managing and automating azure deployment to a windows server VM from the command line, automated scripting, dev and ops troubleshooting, conceptual overview of out-of-scope ops topics

## day 1: introduction to azure CLI and windows server deployment

> **goals**: learn about the az CLI and use it to manually deploy to IIS on windows server VM

### conceptual

- introduction to the azure CLI
  - parallels with the azure web portal GUI
  - greater access and management of resources
    - not limited by developing GUI components
  - core patterns
    - groups
      - service / resource management
    - subgroups
      - related service / resource / configuration
    - declarative commands
      - create
      - delete
      - show
      - list
        - list-X
      - group / subgroup specific
    - help system
    - query filtering
- windows server
  - a more powerful enterprise-grade variant of consumer windows OS
  - key additions
    - server manager
    - administrative control
    - RDP access
- RDP
  - protocol for remote access to windows server
  - GUI-based full desktop experience
  - mstsc tool for RDP management
- IIS
  - web server implementation
    - what is a web server and what role does it play?
      - diagram: where web application code sits relative to the web server container
  - capabilities
    - serving static sites
    - executing and interfacing with embedded web apps
      - replaces built-in kestrel server of dotnet web apps
        - single vs multi-site management
        - TLS termination
        - better performance
    - can also behave as a reverse proxy
  - tool for optimized handling of HTTP
    - excels at low level networking management and performance concerns
    - deals with routing logic to static sites or web apps
    - manages execution and
    - leaves high level application logic to the web app

### practical

> **goals**: how to provision and configure a windows server VM and keyvault using the az CLI, install and configure IIS over RDP, deploy the ADB2C API version manually

### walkthrough: explore the az CLI

- install and configure az CLI
  - log in / link account
  - set defaults
  - use the `-h` help option to view available groups, subgroups, and related commands
  - explore groups used in this course
    - group (rg)
    - vm
    - keyvault
    - network
- query filtering basics with JMESPath
  - extracting relevant data
    - working with lists
    - working with objects
  - practical usage
    - inline evaluation
    - storing in variables for reuse

### walkthrough: deploying a dotnet core app to windows server

> note: uses a starter API and a shared resource group so the instructor can wipe out and have them start from scratch in the studio

- use az CLI
  - VM
    - listing
      - images
      - sizes
    - create
      - configure VM
      - set default
    - show
      - identity
      - public IP
  - network
    - configure NSG rule to lock down RDP
- configure VM over RDP
  - mstsc tool usage
  - install IIS
  - install chocolatey package manager
  - use choco to install dependencies
    - dotnet SDK
    - dotnet hosting bundle
- configure IIS
  - explore interface
  - default site exercise
    - run default site and connect on the remote machine
    - try connecting from local machine
      - fail (VM default port 80 closed)
      - open port using az cli
      - connect!
  - replace the default site
    - create dotnet core starter web api
    - configure IIS to serve the starter api
      - CLR reuse
      - site directory / publishing
      - port binding
    - test locally

### studio: deploying the coding events API on windows server

- use az CLI
  - group
    - create windows resource group
      - set default
  - keyvault
    - create
    - set secrets
      - db connection string
      - server origin
    - set access by vm
  - open port
    - 443 this time but leave vague to let students apply knowledge
- RDP into the vm
  - mstsc using inline eval / var for vm public ip
  - use choco to install dependencies
    - git (for "delivery")
    - mysql (embedded backing service)
  - setup mysql db / user / permissions
  - IIS
    - provision a self-signed cert
    - configure web app serving to replace default site
      - correct port binding (443)
      - use shared CLR
      - use self-signed cert for TLS termination by IIS
    - publish to the IIS serving directory
      - use correct architecture and output dir
- local
  - test final deployment!
  - segue into thinking about how these steps could be automated with scripting (lead-in to day 2)

## day 2:

> goal: continued powershell scripting and service management with az CLI, introduction to az CLI for Linux Servers

### practical

- ops: deploy API to both Windows Server, and Ubuntu
  - manual
    - CLI provisioning
      - KeyVault
      - VM
      - ADB2C
    - CLI deployment of API
      - RDP for Windows Server via powershell
      - SSH & SCP for Ubuntu via bash
  - scripting
    - Powershell
    - Bash
  - set up nginx in Ubuntu

## day 3: Introduction to CI/CD with Azure Pipeline

> goal: understand basic steps of CI/CD and basic Azure Pipeline tasks

### conceptual

- CI/CD basics & Pipeline Tasks

  - VCS connection
  - Build
  - Deliver
  - Deploy(?)

### practical

- Azure Pipeline
  - Windows Server
    - VCS connection
    - Build
    - Deliver
    - Deploy
  - Ubuntu
    - VCS connection
    - Build
    - Deliver
    - Deploy(?)

## day 4: (devops) identifying, isolating, communicating and potential solutions

> goal: gaining independence with devops troubleshooting

### conceptual

- logging
  - VPC and VM
- root cause analysis (interpreting failure)
  - connection timeout
  - 5XX status codes
  - VPC
    - network security groups
    - RP / load balancer / gateway
  - VM
    - application security groups
    - firewalls
- communicating
  - phrasing and terminology
- logging
  - understanding exceptions and stack traces
- root cause analysis (interpreting failure)
  - 4XX/500 status codes
  - narrowing the scope of your questions
    - alternating question terms
  - trusting sources
- communicating
  - phrasing and terminology

### practical

- logging
  - viewing logs from az CLI
- analysis
  - az CLI debugging
- reproducing
  - prove isolation
- communicating
  - opening issues
- logging
  - viewing logs from az CLI
  - CRD logs to Blob Storage (using Powershell piping to analyze)
- analysis
  - google search operators
  - browser dev tools (network, console for CORS)
  - IDE debugging (application)
- reproducing (proving isolation)
  - codebases
    - API (familiar)
    - lc101 app (foreign)
- communicating
  - opening issues

## day 5: next steps

> goal: closing exposure to other ops terminology, services, and best practices

### conceptual

- next steps
  - decoupling services (managed databases, subnets)
  - load balancing
  - security (firewalls, vulnerabilities)
  - CI/CD (automation, code quality, testing)
  - application environments (dev, test, staging, prod)
  - monitoring (logging, notifications, automation)
  - docker containerization
  - PKI
  - 12 factor apps (cloud-native devops)
  - IAC (Infrastructure as Code)
