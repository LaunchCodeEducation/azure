============================================
Studio: Deploy Coding Events API with AADB2C
============================================

In this chapter we have:

#. created an AADB2C tenant
#. registered and exposed our Coding Events API
#. created a SUSI user flow for our Coding Events API that can provide identity tokens
#. created scopes that protect the Coding Events API that grant a client application ``user_impersonation`` delegation available as access tokens
#. Used access tokens from Postman to access our locally hosted application

For our studio we will be using access tokens from a deployed Coding Events API. Instead of running our Coding Events API locally and consuming it with Postman, we will be deploying our Coding Events API to an Azure VM and then consuming the deployed API with Postman.

Luckily this deployment will not include anything we haven't seen from previous deployments.

Remote Deployment
=================

Checklist
---------

#. Provision RG
#. Provision VM
#. Provision KV
#. Grant VM access to KV
#. Add database connection string to KV
#. Configure VM using RunCommand (dependencies, setup MySQL)
#. Update source code to include KV name and AADB2C information
#. Deliver source code to VM using git
#. Build source code on VM using dotnet publish
#. Deploy artifacts
#. Open NSG
#. Update Postman to consume remote Coding Events API
#. Test endpoints with Postman

Gotchas
-------

Limited Guidance
----------------

Provision Resources
^^^^^^^^^^^^^^^^^^^

You have provisioned multiple RGs, VMs and KVs at this point in the class. If you need a refresher check out the previous chapter walkthroughs and studios.

Update Source Code
^^^^^^^^^^^^^^^^^^

You will need to update the ``appsettings.json`` file of your Coding Events API. It will need to include:

- Your Key vault name
- Your AADB2C metadata URL
- Your registered Coding Events API client ID 

After getting the information you need from the Azure Portal about these resources, and updating your source code make sure you have pushed your code back to GitHub so you can pull the correct code for your deployment.

Prepare VM
^^^^^^^^^^

We are not configuring the VM in any new or different ways. You will be able to use the deployment script you created in the Deploy CodingEventsAPI with KeyVault studio.

Double check that the script you will send to your VM via the RunCommand covers the following:

- sets environment variables
- updates apt-get
- download and installs MySQL
- creates a MySQL database and user
- downloads and installs the dotnet SDK
- clones your updated code
- publishes your updated code
- deploys your published artifacts

Deliverable
===========

Upon completing the deployment and Postman testing of your Coding Events API. Send the public IP address of your deployed Coding Events API, and the link to the code you deployed to your TA.