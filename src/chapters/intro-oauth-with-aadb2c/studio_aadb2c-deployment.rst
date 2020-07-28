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

Set Up Local MySQL
------------------

- what mysql GUI are they using?
- how to enter script? (screenshot)
- mysql setup script

Update the Coding Events API
----------------------------

You will need to update the ``appsettings.json`` file of your Coding Events API. It will need to include:

- Your Key vault name
- Your AADB2C metadata URL
- Your registered Coding Events API client ID 

After getting the information you need from the Azure Portal about these resources, and updating your source code make sure you have pushed your code back to GitHub so you can pull the correct code for your deployment.

.. admonition:: note

   Make sure you have provisioned your Key vault before you update your source code. Remember that key vault names are globally unique!

- switch final branch
- update appsettings
   - describe (high level) what the fields are used for
- note / tip about where in codebase to see
   - jwt business
   - RBAC/ABAC (in model DTO methods)

Get an Access Token
-------------------

- copy from end of access walkthrough
- note on refreshing

Run Locally
===========

Checklist
---------

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

Deploy the Coding Events API
----------------------------

- same as you have seen
- runcommand has the following two new scripts
   - will be exploring and using these in upcoming lessons

Configuring the VM
------------------

- `link to script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/deliver-deploy.sh>`_
- this script is setting up a background service using a `unit file <>`_
   - sets up a service user (for security)
   - sets up working directories and permissions
      - link permissions from bash article
- otherwise similar to what you have seen
- feel free to explore it on your own or just use it brah

Configuring Nginx for TLS Termination
-------------------------------------

- `link to script <https://raw.githubusercontent.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment/master/vm-configuration-scripts/2configure-ssl.sh>`_
- nginx alternative to kestrel
   - will learn about web servers in upcoming WS / IIS chapter
   - used for TLS termination in a `reverse proxy arrangement <https://www.cloudflare.com/learning/cdn/glossary/reverse-proxy/>`_
- openssl used to provision the self-signed cert
   - link to HTTPS / TLS termination
   - like the cert they have set up locally w dotnet
   - must be accepted in the browser
      - screenshot (from WS / IIS chapter)

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


