===============================================
Walkthrough: Troubleshooting a Linux Deployment
===============================================

.. ::

    what we can simulate:

    - NSG port issue
    - web server wrong port binding
    - misconfigured app
    - app bug


Take stock of our deployment. We have a Virtual Machine and a Key Vault each with their own contents.

Our VM has:

- a deployed API
- a web server: NGINX
- a MySQL Database
- a NSG with various inbound/outbound rules

Our KV has:

- a secret: database connection string
- an access policy for our VM

If any of these resources are not running, or misconfigured our deployment may be broken.

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

When an application is running successfully, but not beahving the way it should it may be a code issue. Maybe there is a coding bug that is causing the improper behavior. To solve this we will need to know what conditions cause the incorrect behavior.

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


