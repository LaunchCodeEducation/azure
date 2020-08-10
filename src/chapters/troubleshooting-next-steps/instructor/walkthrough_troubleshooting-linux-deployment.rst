===============================================
Walkthrough: Troubleshooting a Linux Deployment
===============================================

.. todo:: general checklist of what to do if they get specific issues

.. todo:: add the highlevel issue checklist to the index as it's own resource

.. todo:: import screenshots and complete instructions with TAs

1. accept lab assignment (Troubleshooting - TA)
2. follow picture instructions
3. close out all terminal windows open new one
4. go to az cli instructions

Setting up the Broken Deployment
================================

Before discussing the issues and their solutions each TA must first set up the broken deployment:

Set up ``az CLI``
-----------------

First up we need to clear the AZ CLI cache:

.. sourcecode:: PowerShell

   > az account clear

Now we need to login again which will present us with the form to authenticate:

.. sourcecode:: PowerShell

   > az login

Will print out list of all your subscriptions. Look for the one with the name ``Troubleshooting - TA <Your Name>``. Then copy the ``id`` field value:

.. sourcecode:: json
  :emphasize-lines: 4

  {
    "cloudName": "AzureCloud",
    "homeTenantId": "d61de018-082f-46bb-80e0-bbde4455d074",
    "id": "095dea07-a8e5-4bd1-ba75-54d61d581524",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Troubleshooting - TA <Your Name>",
    "state": "Enabled",
    "tenantId": "d61de018-082f-46bb-80e0-bbde4455d074",
    "user": {
      "name": "paul@launchcode.org",
      "type": "user"
    }
  }

Assign this as the az cli subscription:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > az account set -s "095dea07-a8e5-4bd1-ba75-54d61d581524"

After configuring the AZ CLI to use the new subscription set the defaults for the correct resource group and virtual machine:

.. sourcecode:: PowerShell

  > az configure -d group=linux-ts-rg vm=broken-linux-vm
  > git clone https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment
  > cd powershell-az-cli-scripting-deployment
  > git checkout tps-reports
  > ./full-deployment.ps1
  

Set up the deployment
---------------------

Each TA will need to:

- clone the `powershell-az-cli-scripting-deployment <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_ repository
- switch to the ``tps-reports`` branch
- configure the az CLI to use the troubleshooting lab group subscription
- run the ``full-deployment.ps1`` script in PowerShell

**You will not need to edit the script at all**, it will deploy the application and break a few things that this article will walk your group through fixing.

.. admonition:: Note

  If after following all the solution steps the deployment is still not fixed it means a student must have edited something without your knowledge. You can re-run the script and it will automatically destroy the system and recreate it from scratch. 

General Hints
=============

#. X number of issues
#. 1 network level, 1 app level, 1 VM level
#. help students with diagnosis steps
#. help students with solution steps

Issues
======

This is the logical order starting from the outside and working your way in.

#. NSG 
#. NGINX is down (connection refused)
#. MySQL is down
#. appsettings.json doesn't contain the correct KV name
#. VM no access to KV

As a TA your rule should be whatever they solve you pick the lowest number if they are stuck. Distribute the hints from hardest to easiest.

Assumptions of State
====================

In a live deployment any misconfigured component could be the cause of an issue. It is important to have a mental model of the system and the *current* state of each component in it. To gain an understanding of the deployment and it's state your group should discuss the components and how they could be misconfigured.

.. admonition:: Note

   Due to the introductory nature of this course we will be thinking about our entire deployment. After you gain experience with troubleshooting you may find yourself thinking about one component or layer at a time. 
   
   The ability to look at one component in isolation will come with experience, but when you are just starting out it is beneficial to think about the entire system. 

Deployment Components
---------------------

Let's consider the components in each layer of our system.

.. admonition:: Warning

   Don't have students check each of these things. This is simply a thought exercise for students to have an understanding of the entire system, which will help them troubleshoot.

.. admonition:: Note

   This should be a group discussion. Encourage points that aren't listed below. 

   There isn't an exact script for this section. Encourage students to discuss for up to twenty minutes. At the ten minute mark if you haven't completed half of the different levels move the discussion forward in the following pattern:

   Use the top level bullet as a prompt to start a dialogue around that component. Follow each sub-list down so everything is covered.

Network Level
^^^^^^^^^^^^^

...Network related issues are always based around routing behavior and access rules. As an introductory course we have only explored access rules in the form of our network security groups. To that end consider the three components of an access rule

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
    - status
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

- appsettings.json (external configuration)
- source code
  - could have issues but we will assume it is working as expected

VM is not Running
=================

Diagnosis
---------

#. make an **external** request through: postman, browser, Invoke-RestMethod (network error: connection timeout)
#. try to SSH into the box (timeout)
#. is the VM running (Azure Portal `broken-linux-vm` status: Stopped)

Solution
--------

#. start the vm with ``az vm start``
#. SSH into the box

NSG
===

Diagnosis
---------

#. make an **external** request through: postman, browser, Invoke-RestMethod (network error: connection timeout)
#. check your NSGs (NSG does not contain an inbound rule for port 443)

Solution
--------

#. create a new NSG inbound rule for port 443 

NGINX
=====

Diagnosis
---------

#. make an internal request with curl (network error: connection refused)
#. check the web server from box ``service ngingx status`` (inactive (dead))

Solution
--------

#. ``sudo service nginx start``
#. ``service nginx status`` (active (running))

MySQL
=====

Diagnosis
---------

#. make an internal request with curl (HTTP status: 502 bad gateway)
#. check the mysql service from box ``service mysql status`` (inactive (dead))

Solution
--------

#. ``service mysql start``
#. ``service mysql status`` (active (running))

Wrong KV name
=============

Diagnosis
---------

#. make an internal request with curl (HTTP status: 502 bad gateway)
#. ``journalctl -fu coding-events-api`` (``Unhandled exception. System.UriFormatException: Invalid URI: The hostname could not be parsed.``)
#. research error message
#. ``cat /opt/coding-events-api/appsettings.json`` (notice the value for ``KeyVaultName`` is blank)

Solution
--------

#. get the name for the Key Vault (``az keyvault list --query '[0].name'`` or use the Azure Portal)
#. edit the file (``sudo nano /opt/coding-events-api/appsettings.json``)
#. enter the value for ``KeyVaultName`` you found in step one
#. save the file in ``nano`` editor with ``ctrl+o`` and then hit enter to confirm
#. exit ``nano`` editor with ``ctrl+x``
#. restart the service to reload the ``appsettings.json`` file (``sudo service coding-events-api restart``)

KV access policy
================

Diagnosis
---------

#. make an internal request with curl (HTTP status: 502 bad gateway)
#. ``journalctl -fu coding-events-api`` (``Unhandled exception. Microsoft.Azure.KeyVault.Models.KeyVaultErrorException: Operation returned an invalid status code 'Forbidden'``)
#. research error message
#. check KV access policies for VM (it's missing)

Solution
--------

#. check the help of az keyvault (``az keyvault -h``)
#. check the help of az keyvault set-policy (``az keyvault set-policy -h``, need objectId and Key Vault Name)
#. store object id of VM in variable (``$VmId = az vm show --query 'identity.principalId'``)
#. store Key Vault name in variable (``$KvName = az keyvault list --query '[0].name'``)
#. create new KV secrets access policy for VM (az keyvault set-policy --name $KvName --object $VmId --secret-permissions list get)
