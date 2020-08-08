===============================
Introduction to Troubleshooting
===============================

Troubleshooting is one of the most important skills to the Operations professional. You will come to find troubleshooting is in large part research. An issue may be first brought to your attention by a ticket, or report from QA or an end user, but they will usually only be able to tell you what odd behavior occurred and some of the conditions that led to the error. The next steps are left up to you.

As a part of your investigation into the issue you may need to answer lots of different questions like:

- what is the issue?
- when does the issue occur?
- where, within the tech stack, does the issue occur?
- is it actually an issue, or simply end user error?
- is the issue reproducible?
- what are the exact conditions that cause the issue to occur?
- is it an issue with the underlying source code of the application?
- is it an issue with the infrastructure or system that supports the application?
- what do common error messages mean?
- how to determine what an obscure error message means?
- has a similar issue occurred in the past?
- who on your team can help you with the issue?

This is just a small sample of some of the questions you may need to answer to diagnose and resolve an issue. At first glance, this may seem overwhelming, however you have lots of tools to assist your investigation, you can adopt a methodology for solving issues, as you gain experience you will gather additional knowledge to assist in your investigation, and you are not alone! You will find that teammates are exceptionally advantageous when troubleshooting. 

They can provide you with new insight, knowledge of new tools, or can act as a sounding board to bounce ideas off of. In addition to your team the internet is filled with people that have may experienced similar, or identical issues to the one you are currently encountering.

In this article we will discuss issues you may have already experienced through this class, talk about a methodology to assist you in researching issues, and talk about some of the basic tools you can use while troubleshooting.

.. admonition:: note

   This article is in way exhaustive, as you continue throughout your career you will learn about new techniques, tools, and solutions to issues.

This article, and the following exercise, will primarily focus on Operations troubleshooting.

.. :: 

   ...troubleshooting is something best learned through experience...
   ...some tips based on what you have learned so far...
   ...not exhaustive but only from what you know right now (fundamentals - rest grows on it)...

   - troubleshooting depending on where in the SDLC
      - ops responsibilities (our focus)
      - dev responsibilities 

What You May Have Experienced Already
=====================================

To start let's talk about some of the issues you may have encountered while deploying the Coding Events API and some of the reasons the issue may have occurred.

Connection Refused
------------------

user receives a connection refused when attempting to access the swagger documentation in browser
    - the VM is being blocked at the network level
        - missing NSG rule for the specific port
        - misconfigured NSG rule

Connection Timeout
------------------

user receives a connection timeout when attempting to access the swagger documentation in browser
    - the web server is NOT running
        - service nginx status

Bad Gateway
-----------

Web Server is not running
^^^^^^^^^^^^^^^^^^^^^^^^^

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

Database is not running
^^^^^^^^^^^^^^^^^^^^^^^

deployed API cannot access database
    - database is not currently running
    - database connection string is not correct
    - database does not have a user and database the DB connection string needs

VM not authorized to access KV
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

deployed API cannot access KV secrets
    - KV does not exist
    - no secrets in KV
    - incorrect secret in KV
    - VM does not have the correct authorization for KV
    - application ``appsettings.json`` does not point to the correct KV

.. :: 

   user receives incorrect behavior when working with API
      - inconsistent behavior is usually a dev issue, but we should be able to identify where it is being caused in the code
            - example: user sends a DELETE request and it returns a success No Content response
               - however, user can still access the resource that was supposedly deleted
               - this means the controller logic for that method/endpoint is incorrect
               - look at the code, is it going to the database and deleting?
               - is it waiting for the response of the DB deletion before sending back a response? (maybe the DB sent back that it could not be deleted, but the API already sent back the response) 

Until this point we have been pretty defenseless when an issue comes up. Frustratingly we would have to scrap our entire deployment so far, and start over. A better solution would be to troubleshoot our issues as they come up. The deployment issues we are about to explore are common across web API deployments.

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

Categorize Issues
=================

A highly beneficial tool when troubleshooting is having a mental model of the deployment. What are the individual components and how might they fail? How do these components fit together, and can we categorize them?

Network Level
-------------

- NSG
- NOTE: future network related pieces

Service Level
-------------

Key Vault (database connection string & has granted access to our VM)
AADB2C

- configuration
- access / authorization

Host Level
----------

- API dependencies (dotnet, mysql, nginx, systemd, unit file)
- delivery mechanism (git)
- folder structure
- file locations

- our db is embedded but typically would be in service level

Application Level
-----------------

- appsettings

How to Troubleshoot
===================

.. build mental modal state of the system
.. sometimes fixing one thing can open an underlying issue
.. peeling back layers of the onion
.. RCA [thwink...?]

Take Inventory
--------------

- form a mental model of the state of the system
- holistic inventory of components to understand what could go wrong
- keep inventory of every individual change you make no matter how trivial
  - each one changes the state of the system and could be a valuable clue

Identify the Issue
------------------

- DO NOT CHANGE ANYTHING
  - keep 
- response behavior
  - timeout
  - connection refused
  - 5XX
  - 4XX

Communicate the Issue
---------------------

Isolate & Resolve the Issue
---------------------------

- even if you cant resolve just going through the previous steps can go a long way in helping towards the resolution
  - pass off to a more senior member who will praise you for your effort
    - you are saving their expert time from doing preliminary steps

Troubleshooting Tools
=====================

.. DEPENDENT ON THE ENVIRONMENT (local/prod and OS/services)

Debugging Requests
------------------

  - browser dev Tools
  - curl
  - Invoke-RestMethod / Invoke-WebRequest
  - postman

Remote Management
-----------------

  - SSH
  - RDP
  - az CLI
  - accessing logs
    - journalctl

Source Code Debugging
---------------------

- debugger

Troubleshooting Levels
======================

.. WHAT CAN CAUSE EACH OF THESE
.. HOW CAN EACH BE IDENTIFIED

Network Level
-------------

- NSG
- NOTE: future network related pieces

Service Level
-------------

- configuration
- access / authorization

Hosting Environment Level
-------------------------

- sizing
- 
- NOTE: our db is embedded but typically would be in service level

Application Level
-----------------

- 
- causes
  - external configuration
  - internal bugs
    - unexpected 4XX and 5XX