==============================================
Studio: CLI Deployment to Windows Server & IIS
==============================================

In today's studio you will practice deploying the Coding Events API to a Windows Server VM. You will be using the ``az CLI`` and the new tools designed for Windows Server that you learned about. Keep the end goal in mind and abstract the knowledge you gained from the Ubuntu deployment to solve the challenges you are presented with.

Planning
========

Windows and Linux have many fundamental differences between them that stem from their contrasting kernel designs. But in the context of a host machine for web apps the choice of OS is largely arbitrary. The tools and techniques may differ but they both share OS-agnostic requirements that are dictated by the application itself.

Let's consider the general requirements that our API has on its **hosting environment**:

- **.NET SDK**: the SDK is *currently* needed to ``publish`` our API's artifact
- **.NET runtime**: the runtime (included in the SDK) is needed to execute, or ``run``, the artifact
- **MySQL**: our API relies on a MySQL server as a backing service
- **Git**: ``git`` is *currently* used as our tool for delivering the source code to the VM
- **TLS/SSL**: our API must support a secure connection to use ADB2C, it needs an SSL certificate and a way of performing TLS termination using that certificate

Available Tools
===============

Requirements
============

Provision a WS VM
-----------------

Remote Access
-------------

Configure IIS
-------------

Configure the API Environment
-----------------------------

Deploy the API
--------------

Test Your Work
--------------

Next Step
=========