============================================
Studio: Deploy Coding Events API with AADB2C
============================================

In this studio your mission is to practice accessing protected resources in the final version of the Coding Events API. You will begin by working with the API locally to make sure that the latest updates are functioning properly. Afterwards, you will deploy the API to Azure to be served securely over HTTPS.

Before we continue let's consider what we have already configured:

- An AADB2C tenant for managing user accounts
- Two registered applications: the Coding Events API and its consumer, the Postman desktop client application
- A configuration for access tokens with a ``user_impersonation`` scope to protect the API by only allowing requests from the registered Postman application
- A configuration for the Postman application to request an access token and use it for making requests to the new endpoints available in the Coding Events API collection

At a high level this studio will require you to:

- Update the Coding Events API source code with settings to integrate with your AADB2C tenant and validate the access tokens it receives from Postman
- Deploy the API to Azure with the correct VM, Key vault and security configurations that you have seen in previous deployments
- Run setup scripts that configure the VM and serve the API over a secure connection as a *background service*
- Test out the protected endpoints on your own or with a partner

Setup
=====

Before you deploy the API you will set up a local environment to test it in. For this setup you will need to:

#. set up a local MySQL ``coding_events`` database
#. update your Coding Events API ``appsettings.json`` to integrate with AADB2C

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

.. admonition:: Warning

   Recall that the Key vault that provides the database connection string to the API is **used only** in the ``Production`` environment. 
   
   When *working locally* (in the ``Development`` environment) your API will expect the default connection string to be available via the ``dotnet user-secrets``. Refer to your notes or the secrets management chapter for a refresher of how to configure this.

Update the Coding Events API
----------------------------

.. admonition:: Warning

   Before continuing make sure you are working from inside **your forked repo directory** on the ``3-aadb2c`` branch.

In the ``appsettings.json`` project configuration file you will notice some familiar fields as well as a few new ones: 

.. sourcecode:: json
   :caption: coding-events-api/CodingEventsAPI/appsettings.json
   :emphasize-lines: 10,13,14

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

The ``ServerOrigin`` field is used to define the the **origin** of a server. The API has been configured to use this origin for creating resource links (for actions or relations to other resources). The term origin is defined by **where the server is hosted** and is comprised of:

- the protocol (``http`` or ``https``)
- the `Fully Qualified Domain Name (FQDN) <https://networkencyclopedia.com/fully-qualified-domain-name-fqdn/>`_
- the port (if it differs from the implicit port derived from the protocol)

Locally, your API ``ServerOrigin`` will be:

- ``https://localhost:5001`` (as seen in the ``appsettings.Development.json`` file).

However, **after you deploy the API** the ``ServerOrigin`` will **need to be updated** to reference the new location it is hosted from (the VM host's public IP address):

- ``https://<public IP>`` (where port ``443`` is *implied* by the ``https`` protocol in the origin)

``JWTOptions``
^^^^^^^^^^^^^^

The ``JWTOptions`` are used to configure the `JWT authentication middleware <https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.authentication.jwtbearer?view=aspnetcore-3.0>`_ used by the API to validate the access tokens it receives. The nested ``TokenValidationParameters`` object set the boolean flags for controlling which claims in the token should be validated.

The two fields within the ``JWTOptions`` object entry that you will need to update are:

- ``MetadataAddress``: the URL of the JSON metadata document that describes the OIDC capabilities and endpoints for your AADB2C service
- ``Audience``: the application ID (client ID) of the **intended audience** for the token.

You may need to refer to your notes or previous walkthroughs to get these values.

.. admonition:: Tip

   Be careful with the ``Audience`` field. Consider which registered application client ID is appropriate, that of your Postman client application or of the Coding Events API.
   
   Hint -- look at the claims on the access token from the previous walkthrough. One of these client IDs refers to the **authorized party** while the other is the **audience** you are after.

Run Locally
===========

Checklist
---------

- set up your ``coding_events`` database locally
- update the AADB2C fields (``JWTOptions``) of your ``appsettings.json`` file
- request a valid access token (refer to the previous walkthrough for a refresher on this process)

Viewing Documentation
---------------------

The API serves documentation from the Swagger UI page at the root of the server. This time you will notice that the endpoints have been separated into the respective Roles (RBAC) and Attributes (ABAC) used for authorization of requests. Although you will be using Postman to issue requests, the Swagger UI is a helpful resource for exploring the endpoints and resource schemas.

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/swagger-ui-overview.png
   :alt: Swagger UI for final version of Coding Events API

Make Requests to Protected Endpoints
------------------------------------

Before you deploy the API you should practice making a few requests to ensure that you have configured everything properly. It is much easier to debug and fix issues locally than wasting time and resources troubleshooting a deployed application.

For this step make sure the API is listening on ``https://localhost:5001`` (to match the pre-configured ``baseUrl`` variable in the Postman collection)

After getting everything running make requests to the following endpoints:

- ``POST /api/events``
- ``POST /api/tags``
- ``PUT /api/events/{codingEventId}/tags/{tagId}``
- ``DELETE /api/events/{codingEventId}``

Limited Guidance
================

The majority of this deployment will be familiar to you based on your previous learning. However, the setup scripts will be new to you.

The scripts will be responsible for:

- ``configure-vm.sh``: similar to the script you wrote in your most previous deployment
- ``configure-ssl.sh``: installs and configures the NGINX web server and provisions a `self-signed certificate <https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates>`_
- ``deliver-deploy.sh``: creates a unit file for the Coding Events API, delivers, and deploys the source code as a `Systemd unit <https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files>`_

Provision Resources
-------------------

For this deployment you will need to provision all of the same resources as you have in the previous studio. Configuring these resources will be similar as well with the exception of the three new scripts that must be executed using the RunCommand console.

.. admonition:: Note

   After setting up the VM and Key vault you will need to update the entries in your ``appsettings.json``. **Don't forget to commit and push** these changes before deploying!

Configuration Scripts
---------------------

Some of the code for the scripts are provided for you, but you are responsible for finishing the scripts before running them. Take time to look over and discuss these scripts with your classmates and TA to decipher what they are doing. We will explore these in more detail in upcoming scripting lessons.

Take some time to look over and discuss them with your classmates to decipher what they are doing. Even if you don't believe that *currently* you are capable of writing them, you will surprise yourself with how much you are able understand. We will explore these in more detail in upcoming scripting lessons.

Configure the VM
^^^^^^^^^^^^^^^^

The `configure-vm.sh script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/vm-configuration-scripts/1configure-vm.sh>`_ should look familiar to you based on the script you wrote in the previous deployment. It is designed to:

#. install the runtime dependencies of the API
#. set up the MySQL backing service

- `link to script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/deliver-deploy.sh>`_
- this script is setting up a background service using a `unit file <>`_
   - sets up a service user (for security)
   - sets up working directories and permissions
      - link permissions from bash article
- otherwise similar to what you have seen

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

- 

Interact With the Deployed API
==============================

Setup
-----

- two email addresses
- partner with other student
- show how to update the public IP for ``baseURL``

Make Requests to Protected Endpoints
------------------------------------

- show how to update the baseURL 

Gotchas
=======

Expired or Missing Access Token
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If your request fails due to a missing access token you will, expectedly, receive a ``401`` (failed authentication) response:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman-401-missing-token.png
   :alt: Postman failed authentication due to missing token

Similarly if your access token has expired you will receive a ``401`` response indicating this failure in the `WWW-Authenticate (challenge) header <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/WWW-Authenticate>`_.

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman-401-expired-token.png
   :alt: Postman failed authentication due to expired token

Refer to your notes or the previous walkthrough for a solution to this issue.

Incorrect Configuration in ``appsettings.json``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The JWT authentication middleware is fickle. As it should be -- there is no margin for error in the security space of a project. In addition to the JWT settings the API will crash if the Key vault and origin values are not configured correctly. 

Make sure that all of the following fields are updated before deploying the API:

- ``ServerOrigin``: available after provisioning your Azure VM
- ``KeyVaultName``: available after provisioning your Azure Key vault
- ``JWTOptions:Audience``: available in the AADB2C tenant, updated in the local steps
- ``JWTOptions:MetadataAddress``: available in the AADB2C tenant, updated in the local steps

Opening the Correct Port
^^^^^^^^^^^^^^^^^^^^^^^^

For this deployment the API will be served over ``https``. For security reasons AADB2C does not support authentication over insecure connections. You will need to open the correct port for your deployed API to function properly.

Deliverable
===========

At the end of this studio you will need to provide your TA with the public IP address of your deployed API. Before submitting the IP, you will need to have made requests to the deployed API to prove that everything was configured and deployed properly. 

Your TA will check that the **minimum state** of the resources includes:

- one coding event with two members
- one owner of a coding event
- one member in a coding event
- one tag that is associated with a coding event


