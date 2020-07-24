========================
Application Environments
========================

Consider the application we have been deploying throughout our Operations training: the ``CodingEventsAPI``. We have used different strategies for running this application in different environments. 

When running our application while we are developing it we use ``dotnet run``. When running our application on a VM we first build the project with ``dotnet publish`` and then run the executable build artifact.

To the end user our CodingEventsAPI *behaves the same way* wether it is run on our local machine or hosted on a remote machine. However, there are two distinct environments of our application: our local development machine, and an Azure Virtual Machine.

Let's consider some of the differences between our local machine and our VM:

.. list-table:: Differences across local and production environments
   :widths: 15 30 30
   :header-rows: 1

   * - Difference
     - Local
     - Production
   * - OS
     - Windows PC
     - Ubuntu Server
   * - Hardware
     - physical hard drive, RAM, CPU
     - virtualized slice of physical machine
   * - Login Shell
     - PowerShell
     - Bash
   * - Networking
     - configured for home/work LAN
     - configured to be accessible via internet
   * - Secrets Manager
     - dotnet user-secrets
     - Azure Key vault

Application Environments
========================

Every project has it's own requirements and may utilize different environments. However, most modern web development projects adopt their environments from the basic pattern:

``Local -> Development -> Production``

.. admonition:: Note

   There are two additional common environments: ``Testing`` and ``Staging``. These environments are outside the scope of this class but you can learn more by viewing these sections: `the testing environment <https://en.wikipedia.org/wiki/Deployment_environment#Testing>`_ and `the staging environment <https://en.wikipedia.org/wiki/Deployment_environment#Staging>`_ of the deployment environments wikipedia entry which gives a high level explanation of the purposes of each.

Local
-----

The ``local environment`` is one we are already familiar with, your local development machine! This is the environment in which coding happens. 

In this environment you may be working on a feature branch in which you are the only contributor. As you work on your code you run your application on your local machine to make sure your code behaves the way it should. 

.. admonition:: Note

   Checking the behavior of your code usually includes: automated testing and limited manual Quabity Assuance. 

   .. that's not it, but we're close!

After verifying the behavior of the code for your feature branch you push your code to GitHub and open a *Pull Request* to notify your team that your work is completed, locally tested and ready for review.

Think about the ``local environment`` and consider that each contributor to the project has their own unique ``local environment``. Your local machine is probably very different than your teammate's local machine. Even if you have the exact same hardware you probably have different software. 

Luckily the next environment will ensure code that was run in different ``local environments`` is compatible with the final ``production environment``.

Development
-----------

The ``development environment`` is the environment in which all of the work from individual ``local environments`` are combined together. The ``local environment`` is where you test the change you made whereas this environment ensure your changes integrate with the entire codebase. This is a crucial environment that runs the full suite of automated tests.

This environment is completely automated in a process called `Continuous Integration (CI) <https://www.atlassian.com/continuous-delivery/continuous-integration>`_. After a Pull Request is merged into the development branch automation software pulls the entire development branch, runs the automated tests in a ``development environment`` and generates test results. If any incompatibilities are found they can be stopped and corrected before reaching a live environment.

.. admonition:: Note

   We will not be using ``CI`` in this class, but it is worth exploring as you will encounter it throughout your career. Effective use of ``CI`` is a modern best practice to prevent regression which enables fast development.

Production
----------

The final environment is the ``production environment`` which is where the deployed application lives. This is the end goal of the web development code we write. Ultimately our deployed application needs to live in an environment that is accessible via the web so it can be reached by end users. 

The ``production environment`` is directly tied to the success of the business. This high stakes environment deals with live data and infrastructure. Failure with either can be catastrophic to a business. Every environment leading to production is an opportunity to catch issues early and prevent their propagation.

Managing Application Environments
=================================

A best practice for running an application across multiple environments is to put great emphasize making each environment similar. This similarity is what will give us confidence that the application will work in the production environment.

Parity
------

**Parity** is the similarity between environments. If your local environment is identical to your production environment we would say those environments have perfect parity. In reality perfect parity is never completely possible, but we should still aim to get to close it.

Achieving High Parity
^^^^^^^^^^^^^^^^^^^^^

Parity is achieved via reproducible environments here are some things we can do to enable reproducibility:

- Use the same database server versions like MySQL version 8.0.20
- Use cross-platform tools like .NET Core
- Writing dynamic code that can be configured at runtime

The first two points are simply policies we can adopt across our development team. The last point is something we have already experienced from managing secrets. If you recall the secrets were loaded at runtime from the external secret stores.

Externalize Configurations
--------------------------

In achieving a high level of parity we install the same version of MySQL server on both our local machine and our production server. However, our project must know how to connect to a MySQL database. 

When we run our project locally we want our project to connect to our local MySQL server by using a DB connection string that pointed at the locally hosted database.

Traditionally when we run our project in a production environment it should consume an external data store. In that case the connection string would point at the IP address of the remotely hosted database.

.. admonition:: Note

  Because of our simple context we are using a locally hosted database in our production environment achieving near perfect parity. This parity is driven by the cross-platform nature of .NET Core, MySQL and Azure Key vault.