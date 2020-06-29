========================================
Application Environments & Configuration
========================================

Consider the application we have been deploying through out our Operations training: the CodingEventsAPI. We have used different strategies for running this application. On our local machines we run the application with ``dotnet run``. When we deploy the application to a VM we first run ``dotnet publish`` to create build artifacts and then deploy them.

Our CodingEventsAPI *behaves* the same when being run vs being deployed however, there are two distinct environments our application is run in. The first is our development environment when using ``dotnet run`` this environment exists on our local machine. The second environment is our production environment when using ``dotnet publish`` and hosting the application on a VM.

Think about how very different your local machine is from a VM. You may be using a Windows OS for your development environment, but our production environment is a Linux based OS. Your development environment exists in only a few places your machine and any of your collaborators machines, the production environment may exist across multiple VMs across multiple servers across multiple data centers. These different environments have different software, different OS kernels, different shells, different hardware, different network configurations, etc.

In this article we will explore different application environments and how to manage them.

Common Application Environments
===============================

- Development
- Testing
- Staging
- Production

Parity & Portability
====================

Parity
------

Portability
-----------

- Dev
- Test
- Prod
- Why the different envs?
- Why do they have different configs?
- How can we manage their configs?

Sensitive Data
==============

External Configuration
======================

- public configs
- secret configs

Version Control
===============

Commit to VCS
-------------

- source
- public configs

.gitignore
----------

- derived
- sensitive configs

Secrets Management
==================

- dotnet tooling
- local: user-secrets
- remote: key-vault