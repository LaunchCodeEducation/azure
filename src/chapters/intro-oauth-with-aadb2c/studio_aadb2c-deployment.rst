============================================
Studio: Deploy Coding Events API with AADB2C
============================================

In this studio your mission is to practice accessing protected resources in the final version of the Coding Events API. You will begin by working with the API locally to make sure that the latest updates are functioning properly. Afterwards, you will deploy the API to Azure to be served securely over HTTPS.

Before we continue let's consider what we have already configured:

- An AADB2C tenant for managing user accounts
- two registered applications -- the Coding Events API and its consumer, the Postman desktop client application
- A configuration for access tokens with a ``user_impersonation`` scope to protect the API by only allowing requests from the registered Postman application
- A configuration for the Postman application to request an access token and use it for making requests to the new endpoints available in the Coding Events API collection

At a high level this studio will require you to:

- Update the Coding Events API source code with settings to integrate with your AADB2C tenant and validate the access tokens it receives from Postman
- Deploy the API to Azure with the correct VM, Key vault and security configurations that you have seen in previous deployments
- Run two new setup scripts that configure the VM to serve the API over a secure connection as a *background service*
- Test out the protected endpoints on your own or with a partner

Setup
=====

Before you deploy the API you will set up a local environment to test it in. For this setup you will need to:

#. set up a local MySQL ``coding_events`` database
#. update your Coding Events API ``appsettings.json`` to integrate with AADB2C
#. get an access token through Postman

Set Up Local MySQL
------------------

You will use the MySQL Workbench GUI program you installed in the previous unit to run the user and database setup script. This is the same script you have seen in previous deployments:

.. sourcecode:: mysql
   :caption: Coding Events API MySQL database setup script

   CREATE DATABASE coding_events;
   CREATE USER 'coding_events'@'localhost' IDENTIFIED BY 'launchcode';
   GRANT ALL PRIVILEGES ON coding_events.* TO 'coding_events'@'localhost';
   FLUSH PRIVILEGES;

First open the MySQL Workbench application by searching for it in your taskbar:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/mysql-open-workbench.png  
   :alt: Windows search for MySQL Workbench application

Then log in to your local server instance:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/mysql-login-local-instance.png  
   :alt: MySQL Workbench log in to local server instance

In the script area paste in the setup script from above:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/mysql-paste-setup-script.png  
   :alt: MySQL Workbench paste in setup script

You can run the script using the lightning icon, ``ctrl+shift+enter`` or using the menu option at the top:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/mysql-run-setup-script.png  
   :alt: MySQL Workbench paste in setup script

You should then see a success output from the executed script like the image below:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/mysql-setup-script-success.png  
   :alt: MySQL Workbench paste in setup script

Update the Coding Events API
----------------------------

.. admonition:: Warning

   Before continuing make sure you are working from inside **your forked repo directory** on the ``3-aadb2c`` branch.

In the ``appsettings.json`` project configuration file you will notice some familiar fields as well as a few new ones: 

.. sourcecode:: json
   :caption: coding-events-api/CodingEventsAPI/appsettings.json

   {
      "Logging": {
         "LogLevel": {
            "Default": "Information",
            "Microsoft": "Warning",
            "Microsoft.Hosting.Lifetime": "Information"
         }
      },
      "AllowedHosts": "*",
      "ServerOrigin": "",
      "KeyVaultName": "",
      "JWTOptions": {
         "Audience": "",
         "MetadataAddress": "",
         "RequireHttpsMetadata": true,
         "TokenValidationParameters": {
            "ValidateIssuer": true,
            "ValidateAudience": true,
            "ValidateLifetime": true,
            "ValidateIssuerSigningKey": true
         }
      }
   }

To complete this studio you will need to update the following fields before deploying the API:

- ``KeyVaultName``: you can populate this field *after provisioning your resources* used in the deployment
- ``ServerOrigin``: a new field (discussed below)
- ``JWTOptions``: a new object field (discussed below)

``ServerOrigin``
^^^^^^^^^^^^^^^^

The ``ServerOrigin`` field is used to define the the **origin** of a server. The API has been configured to use this origin for creating resource links (for actions or relations to other resources). The term origin is defined by the **where the server is hosted** and is comprised of:

- the protocol (``http`` or ``https``)
- the `Fully Qualified Domain Name (FQDN) <>`_
- the port (if it differs from the implicit port derived from the protocol)

Locally, your API ``ServerOrigin`` will be:

- ``https://localhost:5001`` (as seen in the ``appsettings.Development.json`` file).

However, **after you deploy the API** the ``ServerOrigin`` will **need to be updated** to reference the new location it is hosted from (the VM host's public IP address):

- ``https://<public IP>`` (where port ``443`` is *implied* by the ``https`` protocol in the origin)

``JWTOptions``
^^^^^^^^^^^^^^

The ``JWTOptions`` are used to configure the `JWT authentication middleware <https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.jwtbearer?view=aspnetcore-3.0>`_ used by the API to validate the access tokens it receives. The two fields in this object entry that you will need to update are:

- ``MetadataAddress``: the URL of the JSON metadata document that describes the OIDC capabilities and endpoints for your AADB2C service
- ``Audience``: the application ID (client ID) of the **intended audience** for the token

You may need to refer to your notes or previous walkthroughs to get these values.

.. admonition:: Tip

   Be careful with the ``Audience`` field. Consider which registered application client ID is appropriate, that of your Postman client application or of the Coding Events API.

Run Locally
===========

Checklist
---------

- set up your ``coding_events`` database locally
- update the AADB2C fields of your ``appsettings.json`` file
- request a valid access token (refer to the previous walkthrough for a refresher on this process)

Viewing Documentation
---------------------

Make Requests to Protected Endpoints
------------------------------------

- run the API
- use access token to hit protected endpoints
- endpoints / instructions
   - create event
   - create tag
   - add tag to event
   - delete coding event
- tip: try without access token and see errors
   - add screenshot of 401
      - expired or missing token

Limited Guidance
================

Gotchas
-------

- expired or missing access token
- incorrect configuration in appsettings
- must open the correct HTTPS port

Provision Resources
-------------------

- same as you have seen
- runcommand has the following two new scripts
   - will be exploring and using these in upcoming lessons
- after setting up:
   - update KV name
   - update server origin

Configure the VM
----------------

- `link to script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/deliver-deploy.sh>`_
- this script is setting up a background service using a `unit file <>`_
   - sets up a service user (for security)
   - sets up working directories and permissions
      - link permissions from bash article
- otherwise similar to what you have seen
- feel free to explore it on your own or just use it brah

Configure Nginx for TLS Termination
-----------------------------------

- `link to script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/vm-configuration-scripts/2configure-ssl.sh>`_
- nginx alternative to kestrel
   - will learn about web servers in upcoming WS / IIS chapter
   - used for TLS termination in a `reverse proxy arrangement <https://www.cloudflare.com/learning/cdn/glossary/reverse-proxy/>`_
- openssl used to provision the self-signed cert
   - link to HTTPS / TLS termination
   - like the cert they have set up locally w dotnet
   - must be accepted in the browser
      - screenshot (from WS / IIS chapter)

Deliver & Deploy the Coding Events API
--------------------------------------

- `link to script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/vm-configuration-scripts/1configure-vm.sh>`_

Interact With the Deployed API
==============================

Setup
-----

- two email addresses
- partner with other student
- show how to update the public IP for ``baseURL``

Make Requests to Protected Endpoints
------------------------------------

Deliverable
===========

- public IP
- the state of the resources should be (at minimum)
   - one owner
   - one member
   - one coding event
   - one tag (associated w coding event)


