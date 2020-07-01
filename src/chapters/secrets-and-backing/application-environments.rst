========================
Application Environments
========================

Consider the application we have been deploying throughout our Operations training: the ``CodingEventsAPI``. We have used different strategies for running this application in different environments. 

When running our application while we are developing it we use ``dotnet run``. When running our application on a VM we first build the project with ``dotnet publish`` and then run the executable build artifact.

Our CodingEventsAPI *behaves* the same when being run on our local machine vs being deployed on a remote machine. However, there are two distinct environments of our application: our local development machine, and an Azure Virtual Machine.

Let's consider some of the differences between our local machine and our VM:

.. list-table:: Differences across local and production environments
   :widths: 15 30 30
   :header-rows: 1

   * - Difference
     - Local
     - Production
   * - OS
     - Windows personal
     - Ubuntu server
   * - Hardware
     - physical hard drive, RAM, CPU
     - virtualized slice of physical machine
   * - Default Shell
     - PowerShell
     - BASH
   * - Networking
     - configured for home/work LAN
     - configured to be accessible via internet

There are a lot of differences between these two environments!

Application Environments
========================

Every project has it's own requirements and may utilize different environments. However, most modern web development projects adopt their environments from the basic pattern:

``Local -> Development -> Production``

.. admonition:: note

   There are two additional common environments: testing and staging. These environments are outside the scope of this class but you can learn more by viewing these sections: `the testing environment <https://en.wikipedia.org/wiki/Deployment_environment#Testing>`_ and `the staging environment <https://en.wikipedia.org/wiki/Deployment_environment#Staging>`_ of the deployment environments wikipedia entry which gives a high level explanation of the purposes of each.

Local
-----

The ``local environment`` is one we are already familiar with, your local development machine! This is the environment in which coding happens. 

In this environment you may be working on a feature branch in which you are the only contributor. As you work on your code you run your application on your local machine to make sure your code behaves the way it should. 

.. admonition:: note

   Checking the behavior of your code usually includes manually running and visually checking the output and running automated tests (which are outside the scope of this course). 

After verifying the behavior of the code for your feature branch you push your code to GitHub and open a *Pull Request* to notify your team that your work is completed, tested, and ready for review.

Think about the ``local environment`` and consider that each contributor to the project has their own unique ``local environment``. Your local machine is probably very different than your teammate's local machine. Even if you have the exact same hardware you probably have different software. 

Luckily the next environment will ensure code that was run in different ``local environments`` is compatible.

Development
-----------

The ``development environment`` is the environment in which all of the work from individual ``local environments`` are combined together. This is a crucial environment that usually runs a huge suite of automated tests. This environment is responsible for verifying that each contribution from a local environment passes its tests, and that the merged code doesn't affect any other code in unintended ways.

Usually this environment is completely automated. After a Pull Request is merged into the development branch automation software automatically pulls the entire development branch, runs the application in a ``development environment``, runs all tests and notifies the team of the test results. If a test fails it can be addressed immediately to keep the incompatible code from ever being deployed to a live environment.

.. admonition:: note

   We will not be using a ``development environment`` in this class, but it is an important environment you will experience throughout your career.

Production
----------

The final environment is the ``production environment`` which is where the deployed live application lives. This is the end goal of the web development code we write. Ultimately our deployed application needs to live in an environment that is accessible via the web so it can be reached by end users. 

.. admonition:: tip

   One of the benefits of passing through the previous environments is so that the deployed live application is relatively bug free when accessed by end users.

Deploying across application environments can create issues as well. You may have experienced a time when you wrote an application and wanted to share it with a friend. But when they ran your application their environment was lacking some of the required tools and the application crashed.

This frustrating problem is emblematic of a big question within operations: How can we ensure our application can be run in different environments?

Managing Application Environments
=================================

One of the best practices for running an application across multiple environments is to make each environment as similar as possible. This similarity is what will give us confidence that the application will work across environments.

Parity
------

**Parity** is the similarity between environments. If your local environment is identical to your production environment we would say those environments have perfect parity. In reality perfect parity is never completely possible, but we still aim for as high of parity as possible.

High Parity Benefits
^^^^^^^^^^^^^^^^^^^^

Outside of confidence that our application will run across environments parity gives us the added benefits of:

- ensure testing data never enters production data stores
- decrease time from development to deployment
- decrease time to re-create environments for testing purposes
- decrease time to onboard a new project contributor

Achieving High Parity
^^^^^^^^^^^^^^^^^^^^^

Examples of things we can do to achieve high parity across environments:

- Use the same database server versions like MySQL version 8.0.20
- Use cross-platform tools like .NET Core
- Load configuration data at runtime

The first two points are simply policies we can adopt across our development team, but the last point is something we have a little experience with already for managing secrets: using external configurations

Externalize Configurations
--------------------------

In achieving a high level of parity we install the same version of MySQL server on both our local machine and our production server. However, our project must know how to connect to a MySQL database. 

When we run our project locally we want our project to connect to our local MySQL server by using this DB connection string: ``server=localhost;port=3306;database=test_car_db;user=test_car_user;password=test_car_pass``. 

When we run our project in a production environment we want to connect using this DB connection string: ``server=172.28.162.111;port=3306;database=car_db;user=car_user;password=7p*RTY5g8i#WB@F8``.

So now our configuration has to change between to two environments. On our local machine we must use the first DB connection string, and on our deployment machine we must use the second DB connection string. We could manually alter the file before we deploy our application, but that would be an easy thing to forget. If you forget the deployed application would no longer work correctly because it won't be able to connect to the production database. Instead of leaving this as a manual task we can externalize the configuration.

With externalizing the configuration we can introduce some logic into our application that detects which environment it is running in and to load the configurations at runtime! We have already seen how to use two different tools that can work with external configurations: ``dotnet user-secrets`` and ``Azure Key vault``. 

Our walkthrough will show us how a .NET application can detect the environment and load from the appropriate external configuration manager.