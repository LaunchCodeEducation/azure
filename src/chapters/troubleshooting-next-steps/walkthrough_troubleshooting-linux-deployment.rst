===============================================
Walkthrough: Troubleshooting a Linux Deployment
===============================================

In this walkthrough we will explore a broken deployment on a Linux machine.

- separate into TA groups
  - students OBSERVE ONLY
  - discuss and reach consensus
    - NOTE: refer to previous article for tips on your approach
  - TA issues mutating actions
- see if your group is able to troubleshoot and resolve on your own 
  - dont be pressured to resolve it
  - the value is in the exploration
  - afterwards instructor will go through the full solution step by step

LEARNING GOALS  
- exploration
- discussion

.. admonition:: Warning

  You will be collaborating with your group mates and TA. **Make sure you do not change anything in the machine**. Your role is **purely observational**. The TA will perform any mutating actions to ensure a manageable process for everyone in the group.

Taking Inventory
================

...before starting any troubleshooting you must always take inventory...
...in your groups discuss each component and what could break with each of them...

Deployment Components
---------------------

Network Level
^^^^^^^^^^^^^

- NSG rules for controlling access at the network level
- what rules do you expect?
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)

Service Level
^^^^^^^^^^^^^

- KeyVault
  - what configuration is expected?
    - a secret: database connection string
    - an access policy for our VM
- AADB2C
  - what configuration is expected?
    - tenant dir
    - protected API (user_impersonation scope)
    - Postman client application
    - SUSI flow

Hosting Environment Level
^^^^^^^^^^^^^^^^^^^^^^^^^

- VM external configuration
  - what configuration is expected?
    - size
    - image (defines available tools)
    - system assigned identity for KV access
- VM internal configuration
  - what configuration is expected?
    - runtime dependencies (dotnet, mysql, nginx)
    - self-signed SSL cert
  - what services are expected?
    - embedded MySQL
    - NGINX web server (reverse proxy)
    - API service
- MySQL db server
  - user and database for the API
- NGINX
  - RP configuration
  - using SSL cert

Application Level
^^^^^^^^^^^^^^^^^

- appsettings (external configuration)
- source code
  - could have issues but we will assume it is working as expected

Available Tools
---------------

...working in the production environment on a linux machine...
...consider the available tools for this system...
...in addition to standard FS navigation tools...
...these are the tools you will be using...

- ``ssh``: to access the machine remotely
- ``az CLI``: for information about each resource component (or the Azure web portal)
- ``cat`` or ``less``: to inspect configuration files
- ``service``: to view the status of the services
- ``Invoke-RestMethod``: to make network requests from the CLI
- ``browser dev tools``: to inspect response behavior in the browser
- ``journalctl``: to view log outputs

Using ``service``
^^^^^^^^^^^^^^^^

service nginx status

service mysql-server status

service coding-events-api status

Using ``journalctl``
^^^^^^^^^^^^^^^^^^^^

journalctl -fu [service-name]

Using ``Invoke-RestMethod``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

...Use the ``-SkipCertificateCheck`` option when working with self-signed certificates...

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > Invoke-RestMethod -Uri https://<PUBLIC IP> -SkipCertificateCheck

Setup
=====

have students use SSH w/ username/pass

- **username**: ``student``
- **password**: ``LaunchCode-@zure1``

.. sourcecode:: bash

   ssh student@[vm-ip-address]

.. admonition:: Warning

  this is very insecure you should use RSA keys with SSH but PKI is out of the scope of this class

...for each of the following issues use SSH and the tools above to investigate...

Access Troubleshooting Subscription
-----------------------------------

- accept invitation
  - Reader role only
  - create new account (in the TA directory)
    - your email
    - LaunchCode-@zure1
- az account clear
- az login
  - select other account
  - enter your email
  - select the Work or School account created by IT admin (TA email) option
    - (SCREENSHOT)
- az configure -d group=linux-ts-rg vm=broken-linux-vm
- az group show and az vm show
- you now have read access to all resources for investigating

USE NAMES
- rg: linux-ts-rg
- vm: broken-linux-vm

Deployment Issues
=================

.. use GitHub issues to have students engage in a realistic setting 
.. someone raises issue -> people diagnose and work towards solution
  .. TA has a script for responding to student questions / suggestions
  .. no progress TA slips in a breadcrumb

Experiencing a Connection Timeout
---------------------------------

.. browser screenshot of timeout

prompts
- what level is this issue related to?
- what components are involved?
- what tools will you use to identify the issue?
- what action do you suggest should be taken?
- what happened after your TA attempted to fix the issue?

Receiving a 502 Bad Gateway Error
---------------------------------

.. Invoke-RestMethod to check if the connection works

.. todo:: get snippet and output

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > Invoke-RestMethod -Uri https://<PUBLIC IP> -SkipCertificateCheck

    Invoke-RestMethod: 
    502 Bad Gateway
    502 Bad Gateway
    nginx

prompts
- what level is this issue related to?
- what components are involved?
- what tools will you use to identify the issue?
- what action do you suggest should be taken?

.. admonition:: Note

  Remember that fixing one issue may expose another. Through each phase of troubleshooting remember to consider *the new state* of the system and adapt your approach. 

An Unexpected Bug
-----------------

   validation on coding event

When an application is running successfully, but not beahving the way it should it may be a code issue. Maybe there is a coding bug that is causing the improper behavior. To solve this we will need to know what conditions cause the incorrect behavior.

In this case our API is representing date data as null when a user with the proper level of authorization accesses X. Let's look at the code to determine where this error may be occurring.
