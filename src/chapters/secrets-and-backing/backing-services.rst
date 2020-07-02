================
Backing Services
================

A ``backing service`` is any service a deployed application consumes over a network as part of its normal operation. We have worked with MySQL throughout this course as the primary ``backing service`` for our applications. All business data is stored in this relational database and then is accessed as our application needs it. We will continue to use MySQL throughout this course however it is necessary to learn about ``backing services`` as a greater concept and to learn about some other options.

Choosing a ``backing service`` is determined by application requirements. In some instances a project may require multiple or different types of ``backing services``. In the case of the application we have been deploying in this class a single relational database has been sufficient.

As a best practice in a ``production environment`` a backing service should be external to the deployed application.

Examples of backing services:

- Relational databases like MySQL, PSQL, MSSQL, etc
- Non-relational databases like MongoDB, CouchDB, etc
- Caching services like Redis, Azure Caching, Memcached, etc
- Logging services like Elasticsearch, Kibana, etc

.. admonition:: note

    Non-relational databases, caching and logging are outside the scope of this course, but you will probably learn about them later in your career.

External Backing Services
=========================

Simply stated an external ``backing service`` is a ``backing service`` hosted on a separate machine from the running application. An example of this would be to provision two VMs:

- first VM: only hosts the ``backing service``
- second VM: only hosts the running application

The VMs would need to be able to communicate and therefore the running application would need to know the IP address and port of the VM hosting the ``backing service`` as well as any required credentials to gain access to the ``backing service``.

Let's explore further examples of what the infrastructure of using an external backing service would look like over the three application environments we disucssed in the previous article.

Local
-----



Development
-----------

Production
----------

dev env -- application running on your local machine, but it is connected to a DB on some other machine
production env -- application running on a dedicated VM and would be connected a DB on different VM

if the DB and application are running on the same machine it's internal
if the DB and application are running on different machines it's external

.. tip::

    we won't be using any external baking services in this class but learn more here

.. tip::

    all dedicated Azure offerings will be external

Internal Backing Services
=========================

In this class we have only used internal ``backing services`` which is a ``backing service`` that is hosted on the same machine as the deployed application. An example of this would be running a C#.NET web application which connects to a MySQL database both of which are running on your local machine. A local application environment almost always uses an internal ``backing service``.

go into sub headers

dev env -- familiar with both exist on your local machine
production env -- exists on the same VM

You have already been exposed to a local backing service with ``MySQL server 8.0.20``. It runs on your local machine and is always listening for requests on port 3306. So all of your applications simply need to know 

It runs on the same machine in parallel to the running application.

Consider the information necessary for your application to access MySQL server:

- IP address: *localhost*
- DB name: *coding-events*
- DB user: *coding_events_user

Dev
---

Prod
----

.. tip::

    In a testing environment you would usually have an internal backing service so everything needed to run the tests exists in the same location

.. tip::

    Internal backing services are called *sidecars* in the Ops industry
    
.. note::

    Internal is not scalable -- what are other pros and cons

tie back into external configs, or secrets -- we can use our secret to protect our connection string which is sensitive data as well as seamlessly transition environments because it's an external config