================
Backing Services
================

A ``backing service`` is any service a deployed application consumes over a network as part of its normal operation. We have worked with MySQL throughout this course as the primary data storage solution for our applications. All business data is stored in this relational database and then is accessed as our application needs it. MySQL will continue to be the primary backing service used throughout this course.

However, MySQL and other 

As applications requirements determine its backing services. In the case of our application throughout this class a single relational database has been sufficient. However, as application requirements changes it may become necessary to change or add additional backing services.

As a best practice a backing service should always be external to the application itself.

Examples of backing services:

- Relational databases like MySQL, PSQL, MSSQL, etc
- Non-relational databases like MongoDB, CouchDB, etc
- Caching services like Redis, Azure Caching, Memcached, etc
- Logging services like Elasticsearch, Kibana, 

.. admonition:: note

    Non-relational databases, caching and logging are outside the scope of this course, but you will probably learn about them later in your career.

External Backing Services
=========================

define in simple terms

go into sub headers

dev env -- application running on your local machine, but it is connected to a DB on some other machine
production env -- application running on a dedicated VM and would be connected a DB on different VM

if the DB and application are running on the same machine it's internal
if the DB and application are running on different machines it's external

Dev
---

Prod
----

.. tip::

    we won't be using any external baking services in this class but learn more here

.. tip::

    all Azure offerings will be external

Internal Backing Services
=========================

define in simple terms

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



tie back into external configs, or secrets -- we can use our secret to protect our connection string which is sensitive data as well as seamlessly transition environments because it's an external config