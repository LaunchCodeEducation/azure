===============================================
Walkthrough: Troubleshooting a Linux Deployment
===============================================

Overall Steps
=============

.. admonition:: Note

   Do the discussion before setup.

#. discussion
#. run setup script
#. ask next student in list "what should we do?"
#. promote discussion and coordination of a choice then take the action
#. if student is stuck / nobody knows what to do go to the next available prompt

.. todo:: general checklist of what to do if they get specific issues
.. todo:: add the highlevel issue checklist to the index as it's own resource
.. todo:: add step about creating final coding event for students to join
.. todo:: explicit steps about round robin of students and breadcrumbs
.. todo:: warning / note to provide the minimal amount of information. all observational commands should be issued by students unless they dont know how.
.. todo:: note to students that only you issue mutating actions otherwise lose 10-15 mins restarting

..   - TA steps
..     1. start from first student in list and ask "what should we do next?" as a prompt
..     2a. take the action suggested by the student then GOTO 1
..     2b. go to next available step and read: what to say / do on left (what to point out in parenthesis)

Discussion: Components of a Functioning System
==============================================

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

Setting Up the Shared Subscription
==================================

For the students to get read-only access to the Azure resources you have to share your Troubleshooting Lab subscription with them. This can be done by adding them to your Default Directory with the ``Reader`` role. After inviting them you can move to the next section for configuring the ``az CLI`` and running the broken deployment setup scripts.

Accept the Lab Assignment
-------------------------

Check your email for the invitation to the lab:

- the lab should be titled: ``Troubleshooting - TA``
- your individual subscription handout for the lab should be titled: ``Troubleshooting - TA <Name>``.

Invite Students With ``Reader`` Role
------------------------------------

Go to the Azure dashboard by clicking **Microsoft Azure** in the top left corner of the nav bar:

.. image:: /_static/images/troubleshooting-next-steps/instructor/azure-dashboard-button.png
   :alt: Azure dashboard button in nav bar

.. admonition:: Note

   Make sure you are in your Default Directory (visible in top right):

   .. image:: /_static/images/troubleshooting-next-steps/instructor/confirm-default-dir.png
      :alt: Azure dashboard button in nav bar

.. todo:: fix image

Now go to the Subscriptions resource and select the ``Troubleshooting - TA <Name>`` subscription from the list:

.. image:: /_static/images/troubleshooting-next-steps/instructor/select-access-control-settings.png
   :alt: Select troubleshooting subscription resource

Select the **Access Control (IAM)** settings on the left sidebar:

.. image:: /_static/images/troubleshooting-next-steps/instructor/select-access-control-settings.png
   :alt: Select access control (IAM) subscription settings

Then select the **Add role assignment** at the top left:

.. image:: /_static/images/troubleshooting-next-steps/instructor/select-add-role-assignment.png
   :alt: Subscription access control select add role assignment

Choose the ``Reader`` role from the list:

.. image:: /_static/images/troubleshooting-next-steps/instructor/select-reader-role.png
   :alt: Subscription role assignment select Reader role

Then in the **Select** section add in the email addresses of each student in your group (**they have to be done one at a time unfortunately**):

.. image:: /_static/images/troubleshooting-next-steps/instructor/add-student-emails.png
   :alt: Subscription role assignment add student emails

Confirm that the **Selected Members** section has all the student emails for your group then hit **Save**:

.. image:: /_static/images/troubleshooting-next-steps/instructor/confirm-student-emails.png
   :alt: Subscription role assignment confirm student emails and save

In the top right you should get popups for each student who is invited. Instruct them to click the link and follow the Setup instructions (in the walkthrough itself). If they cant find the email you can click the notification and copy the invite link directly for them:

.. image:: /_static/images/troubleshooting-next-steps/instructor/student-invite-notification.png
   :alt: Student invite notification with manual join link

Now you can switch to the **Role Assignments** tab and use the refresh button to confirm all your students joined successfully:

.. image:: /_static/images/troubleshooting-next-steps/instructor/monitor-role-assignments.png
   :alt: View role assignments to monitor students joining

Setting Up the Broken Deployment
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
  
Set up the deployment
---------------------

.. admonition:: Warning

   **You will not need to edit the scripts at all**. They will deploy the application and break a few things that this article will walk your group through fixing.

Clone the setup scripts repo and switch to the ``tps-reports`` branch:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git clone https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment
   > cd powershell-az-cli-scripting-deployment
   > git checkout tps-reports

Then run the script:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ./full-deployment.ps1

.. admonition:: Note

  If after following all the solution steps the deployment is still not fixed it means a student must have edited something without your knowledge.
  
  You can re-run the script and it will:
  
  - automatically destroy the system
  - recreate the broken deployment from scratch. 

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
#. check the web server from box ``service ngin x status`` (inactive (dead))

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
