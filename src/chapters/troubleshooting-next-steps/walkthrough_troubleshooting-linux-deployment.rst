=====================================================
Group Walkthrough: Troubleshooting a Linux Deployment
=====================================================

.. TAs will have their own login account to the VM that has full permissions

.. students will have a different login account that is read only

This walkthrough is different than any walkthroughs you have done so far. Troubleshooting skills can only be developed through experience. The methodologies and tools can be taught, but the experience is invaluable to your ability to solve real-world problems. You will be working as a group, like you would be on a professional team. Together your group will be troubleshooting a broken deployment. You will need to work together to engage in a troubleshooting discussion to reach a resolution to the issues presented in the deployment.

Each student will be given read-only access to Azure resources and to the VM used in the deployment. Your TA will be the only member of your group with administrative access. For each issue the group encounters your TA will facilitate discussion and take any actions the group agrees upon.

After setting up access of the group members you will have one hour to reach a functional deployment. After the time is up your instructor will walkthrough each issue and it's resolution.

.. admonition:: note

   Take your time on each issue.
   
   The purpose of this exercise is to engage in a dialogue around identifying, isolating, and resolving issues in a live deployment. If you do finish early there is a bonus section your group can work on.

... TODO: VM access can be restricted

.. ::

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

Bonus
=====

Customer Reports Unexpected Bug
-------------------------------

  validation on coding event

A customer opened an issue that they were seeing some unexpected behaviors. The QA team reports that this bug is happening in the model at this line, it is up to us to solve the issue and redeploy the application.

It is up to you on how you approach this, but we recommend using a debugger, and looking into the Microsoft validation module.

Consider taking the same approach you used before, by asking some questions on where this is happening, why, and how to resolve the issue.

If you and your group are able to fix the issue locally let your TA know how it can be fixed, and as a group observe as the TA deploys the fix.
