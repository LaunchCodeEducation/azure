===============================================
Walkthrough: Troubleshooting a Linux Deployment
===============================================

Setting up the Broken Deployment
================================

Before discussing the issues and their solutions each TA must first set up the broken deployment.

Each TA will need to:

- clone the `powershell-az-cli-scripting-deployment <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_ repository
- switch to the ``tps-reports`` branch
- run the ``full-deployment.ps1`` script in PowerShell

**You will not need to edit the script at all**, it will deploy the application and break a few things that this article will walk your group through fixing.

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











.. TAs will have their own login account to the VM that has full permissions

.. students will have a different login account that is read only

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

Scenarios
---------

Throughout this course you may have encountered any of the following while trying to deploy:

user receives a connection refused when attempting to access the swagger documentation in browser
    - the VM is being blocked at the network level
        - missing NSG rule for the specific port
        - misconfigured NSG rule

user receives a connection timeout when attempting to access the swagger documentation in browser
    - the web server is NOT running
        - service nginx status

user receives a bad gateway when accessing the swagger documentation in browser
    - the web server is running
    - the application is NOT running
        - service coding-events-api status
        - did it try to start and crashed?
            - check the logs
            - was it because it cannot connect to:
                - DB
                - KV
                - internal error

deployed API cannot access database
    - database is not currently running
    - database connection string is not correct
    - database does not have a user and database the DB connection string needs

deployed API cannot access KV secrets
    - KV does not exist
    - no secrets in KV
    - incorrect secret in KV
    - VM does not have the correct authorization for KV
    - application ``appsettings.json`` does not point to the correct KV

user receives incorrect behavior when working with API
    - inconsistent behavior is usually a dev issue, but we should be able to identify where it is being caused in the code
        - example: user sends a DELETE request and it returns a success No Content response
            - however, user can still access the resource that was supposedly deleted
            - this means the controller logic for that method/endpoint is incorrect
            - look at the code, is it going to the database and deleting?
            - is it waiting for the response of the DB deletion before sending back a response? (maybe the DB sent back that it could not be deleted, but the API already sent back the response) 

Until this point we have been pretty defenseless when an issue comes up. Frustratingly we would have to scrap our entire deployment so far, and start over. A better solution would be to troubleshoot our issues as they come up. The deployment issues we are about to explore are common across web API deployments.


Tools
=====

.. ::

   have students use SSH w/ username/pass

   .. note this is very insecure you should use RSA keys with SSH but PKI is out of the scope of this class

   ssh

   cat/less

   service nginx status

   service mysql-server status

   service coding-events-api status

   journalctl -fu [service-name]

Walkthrough Issues
==================

We will be walking through some common issues (some of which you may have seen already through this class), and how to troubleshoot the issue.

Setup
-----

Run this script to setup a full-deployment. This will take some time...

.. script link

SSH into the box.

.. sourcecode:: bash

   ssh student@[vm-ip-address]

broken NSG
----------

.. az network nsg update -n student-troubleshoot-vmNSG --remove securityRules 1

   timeout

we removed the inbound port 443 rule

nginx stopped
-------------

   connection refused

stopped NGINX to simulate NGINX failing or something


mysql down
----------

   bad gateway

mysql was down we put it back up, but the gateway is still down

API Broken
----------

   bad gateway

journalctl -fu coding-events-api

.. sourcecode:: none
   :caption: journalctl -fu coding-events-api output

   Jul 20 18:56:45 student-troubleshoot-vm coding-events-api[15449]: Unhandled exception. System.UriFormatException: Invalid URI: The hostname could not be parsed.
   Jul 20 18:56:45 student-troubleshoot-vm coding-events-api[15449]:    at System.Uri.CreateThis(String uri, Boolean dontEscape, UriKind uriKind)
   Jul 20 18:56:45 student-troubleshoot-vm coding-events-api[15449]:    at System.Uri..ctor(String uriString)
   Jul 20 18:56:45 student-troubleshoot-vm coding-events-api[15449]:    at Microsoft.Azure.KeyVault.KeyVaultClient.GetSecretsWithHttpMessagesAsync(String vaultBaseUrl, Nullable`1 maxresults, Dictionary`2 customHeaders, CancellationToken cancellationToken)
   Jul 20 18:56:45 student-troubleshoot-vm coding-events-api[15449]:    at Microsoft.Azure.KeyVault.KeyVaultClientExtensions.GetSecretsAsync(IKeyVaultClient operations, String vaultBaseUrl, Nullable`1 maxresults, CancellationToken cancellationToken)

- Error: ``Invalid URI: The hostname could not be parsed``

- The entry for KeyVaultName does not exist in ``appsettings.json``

API Broken
----------

   bad gateway

journalctl -fu coding-events-api

.. sourcecode:: none
   :caption: journalctl -fu coding-events-api output

   Aug 04 18:58:58 student-troubleshoot-vm coding-events-api[16141]: Unhandled exception. System.Net.Http.HttpRequestException: Name or service not known
   Aug 04 18:58:58 student-troubleshoot-vm coding-events-api[16141]:  ---> System.Net.Sockets.SocketException (0xFFFDFFFF): Name or service not known
   Aug 04 18:58:58 student-troubleshoot-vm coding-events-api[16141]:    at System.Net.Http.ConnectHelper.ConnectAsync(String host, Int32 port, CancellationToken cancellationToken)

- Error: ``Name or service not known``

- The value of KeyVaultName is not valid -- either misspelled or blank

API Broken
----------

   bad gateway

journalctl -fu coding-events-api

.. sourcecode:: none
   :caption: journalctl -fu coding-events-api output

   Unhandled exception. Microsoft.Azure.KeyVault.Models.KeyVaultErrorException: Operation returned an invalid status code 'Forbidden'
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Azure.KeyVault.KeyVaultClient.GetSecretsWithHttpMessagesAsync(String vaultBaseUrl, Nullable`1 maxresults, Dictionary`2 customHeaders, CancellationToken cancellationToken)
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Azure.KeyVault.KeyVaultClientExtensions.GetSecretsAsync(IKeyVaultClient operations, String vaultBaseUrl, Nullable`1 maxresults, CancellationToken cancellationToken)
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Extensions.Configuration.AzureKeyVault.AzureKeyVaultConfigurationProvider.LoadAsync()
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Extensions.Configuration.AzureKeyVault.AzureKeyVaultConfigurationProvider.Load()
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Extensions.Configuration.ConfigurationRoot..ctor(IList`1 providers)
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Extensions.Configuration.ConfigurationBuilder.Build()
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Extensions.Hosting.HostBuilder.BuildAppConfiguration()
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at Microsoft.Extensions.Hosting.HostBuilder.Build()
   Jul 20 18:30:53 adb2c-deploy-vm coding-events-api[27497]:    at CodingEventsAPI.Program.Main(String[] args) in /tmp/coding-events-api/CodingEventsAPI/Program.cs:line 11
   Jul 20 18:30:53 adb2c-deploy-vm systemd[1]: coding-events-api.service: Main process exited, code=dumped, status=6/ABRT
   Jul 20 18:30:53 adb2c-deploy-vm systemd[1]: coding-events-api.service: Failed with result 'core-dump'.

- Error: ``Operation returned an invalid status code 'Forbidden'``

- The KeyVaultName value was valid, but this resource (VM) is not authorized to access the KV name in ``appsettings.json``.

Was the VM granted access to the KeyVault secrets?

API Improper Behavior
---------------------

   validation on coding event

When an application is running successfully, but not behaving the way it should it may be a code issue. Maybe there is a coding bug that is causing the improper behavior. To solve this we will need to know what conditions cause the incorrect behavior.

In this case our API is representing date data as null when a user with the proper level of authorization accesses X. Let's look at the code to determine where this error may be occurring.

.. sourcecode:: csharp
   :caption: CodingEventsAPI/Models/CodingEvent.cs
   :lineno-start: 30
   :emphasize-lines: 16

   public class NewCodingEventDto {
      [NotNull]
      [Required]
      [StringLength(
         100,
         MinimumLength = 10,
         ErrorMessage = "Title must be between 10 and 100 characters"
      )]
      public string Title { get; set; }

      [NotNull]
      [Required]
      [StringLength(1000, ErrorMessage = "Description can't be more than 1000 characters")]
      public string Description { get; set; }

      [Required] [NotNull] public DateTime Date { get; set; }
   }

- Error: line 45










Bonus
=====

nginx.conf
----------

    502 bad gateway

- upstream api port to 6000 (configure-ssl.sh) [any port the application isn't running on]
    - GIVES A BAD GATEWAY

- could also break the proxy_pass http://api


