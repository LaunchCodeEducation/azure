================
Backing Services
================

A ``backing service`` is any service a deployed application consumes over a network as part of its normal operation. We have worked with MySQL throughout this course as the primary data storage solution for our applications. All business data is stored in this relational database and then is accessed as our application needs it. MySQL will continue to be the primary backing service used throughout this course.

However, MySQL and other 

As applications requirements determine its backing services. In the case of our application throughout this class a single relational database has been sufficient. However, as application requirements changes it may become necessary to change or add additional backing services.

As a best practice a backing service should always be external to the application itself.

Examples of backing services:

- Relational databases like MySQL, PSQL, MSSQL, etc
- Non-relational databases like MongoDB, CouchDB, Elasticsearch, etc
- Caching services like Redis, Azure Caching, Memcached, etc

.. admonition:: note

    Both non-relational databases and caching are outside the scope of this course, but you will probably learn about them later in your career.


Local Backing Services
======================

Remote Backing Services
=======================

Azure DB Options
----------------

VM embedded Database
^^^^^^^^^^^^^^^^^^^^

- what we will use in this class
- pros: easily setup, no need for additional networking
- cons: on the same infrastructure
    - breaks SRP of infrastructure best practice
    - if the infrastructure fails both the application and it's data fail
    - VM cannot be disposed until SQL data is extracted
- cons: not accessible outside of the VM
- cons: you are completely responsible for the data


Azure SQL Databases
^^^^^^^^^^^^^^^^^^^

- primary solution for DB management with Azure
- pros: live on own infrastructure
- pros: Azure backed for data backup
- pros: highly configurable
- pros: can be reachable from anywhere with internet connection, including other Azure resources
- cons: more setup time than other Azure DB options

Other Azure DB Options
^^^^^^^^^^^^^^^^^^^^^^

Azure dedicated MySQL, MSSQL, or PostgreSQL
    - pros: very quick setup
    - pros: accessible via internet, and to all Azure resources
    - cons: less configuration
various Azure dedicated NoSQL DBs
    - pros: very quick setup
    - 

