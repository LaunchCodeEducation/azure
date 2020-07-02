================
Backing Services
================

We have worked with MySQL throughout this course as the primary database for our previous MVC applications. We used these databases to persist the business data that our applications operated on. In other words, we could say our MVC applications *required a database* to function. 

In operations the general term used to describe any service an application needs to function is a ``backing service``.

.. admonition:: note

    The `12 Factor Manifesto defines <https://12factor.net/backing-services>`_ it as
        
        "A ``backing service`` is any service the app consumes over the network as part of its normal operation."

Choosing ``backing services`` is determined by an application's requirements. For example, in our next deployment our application will require a MySQL database. In other cases a project may require multiple different types of ``backing services``.

Examples of backing services:

- Relational databases like MySQL, PSQL, MSSQL, etc
- Non-relational databases like MongoDB, CouchDB, etc
- Caching services like Redis, Azure Caching, Memcached, etc
- Secrets management like Azure Key vault

External Backing Services
=========================

As the name implies, an **external backing service** is a dependent service that runs *external* to the application. In other words, the backing service and the application run on different host machines and communicate over an *external network*. An example of this would be to provision two VMs:

Let's explore examples of what the infrastructure of using an **external** backing service would look like over the three application environments we discussed in the previous article.

.. list-table:: External Backing Services
   :widths: 20 30 50
   :header-rows: 1

   * - Environment
     - Application Host
     - Database Host
   * - Local
     - contributor's local machine
     - a shared development database
   * - Development
     - CI controlled VM
     - A high parity Azure Managed Database
   * - Production
     - Load balanced Azure VM
     - A scalable Azure Managed Database

Internal Backing Services
=========================

An **internal backing service** is hosted on the same machine as the running application. In this class we have only used internal ``backing services``. An application running in a ``local environment`` almost always uses an internal ``backing service``.

Let's look at a few examples of internal backing services.

.. list-table:: Internal Backing Services
   :widths: 30 30 30
   :header-rows: 1

   * - Environment
     - Application Host
     - Database Host
   * - Local
     - contributor local machine
     - local Database service
   * - Development
     - CI controlled VM
     - Database embedded in the CI VM
   * - Production (education purposes only)
     - Azure VM 
     - Database embedded in the Azure VM

Application Environment Best Practices
======================================

In the previous tables you saw example configurations with both internal and external ``backing services``. Let's explore the best practices behind those examples.

Local
-----

    a local environment should use an *internal* ``backing service``

Local environments go through rapid change. As developers write code it is imperative for them to have immediate feedback from the ``backing services`` of the application. Keeping the ``backing service`` internal gives them full control over the service such as resetting a database or seeding test data.

Development
-----------

    a development environment should use an *internal* ``backing service``

Development environments are fully automated and only generate reports. Due to this automation an internal backing service makes more sense. Every time code gets merged into this environment the automation software (CI) sets up and runs the automated tools. Part of the CI responsibilities are to create and manage any necessary ``backing services``. Using an internal backing service increases the speed at which the automated tests complete. In addition an internal backing service is less expensive than one managed by a Cloud Service Provider.


With heavy data processing projects it may make sense to use external ``backing services`` for your development environment. Since the nature of the project relies on knowing exactly how the ``backing services`` behave, the higher parity may be worth the increases in cost and speed. Like most best practices this is a trade off and not a concrete rule.

Production
----------

    a production environment should use *external* ``backing service``

Production environments are live environments. The production environment needs to be accessible to end users, sensitive data must be secured and infrastructure failure must be avoided at all costs. For these reasons it makes sense to separate our backing service from our deployed application. Now if there is infrastructure failure of the VM hosting the application the data stored in the ``backing service`` is safe from harm.


.. admonition:: note

    To achieve high parity one environment must setup all ``backing services`` in the exact same way as the production environment. Usually the environment at the highest level of parity is the staging environment. The staging environment will have an internal ``backing service`` only if the production environment also has an internal ``backing service``.

.. tip::

    all dedicated Azure offerings will be external

.. tip::

    In a testing environment you would usually have an internal backing service so everything needed to run the tests exists in the same location

.. tip::

    Internal backing services are called *sidecars* in the Ops industry
    
.. note::

    Internal is not scalable -- what are other pros and cons

tie back into external configs, or secrets -- we can use our secret to protect our connection string which is sensitive data as well as seamlessly transition environments because it's an external config