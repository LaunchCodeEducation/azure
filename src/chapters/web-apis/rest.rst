====================
Introduction to REST
====================

   INTRO SECTION
- REST (simple definition of key terms)
   - explore throughout article
- what are we organizing?
   - HTTP components
- HTTP components
   - HTTP is stateless
   - HTTP is a client-server model (req-res)
   - HTTP relies on headers, bodies, status codes
- running example of Coding Events MVC to REST API
   - each section have an example admonition 

REST Pattern Constraints
========================

- (callback to pattern article) purposefully generic
   - will keep things light and see examples in subsequent sections
- teaching consumption not design
- some overlap but focusing on consumption constraints

Uniform Interface
-----------------
- consistency of discovery and consumption

Client-Server (HTTP)
--------------------

- teams can operate independently by maintaining the consistent interface
   - walkthrough consuming with postman
   - can be consumed from command line, or eventually in a frontend client

Stateless
---------

- no memory between each req-res cycle

Other Constraints
-----------------

- about design not consumption
- cacheable
- layered system
- code on demand
- tip
   - https://restfulapi.net/rest-architectural-constraints/
   - those related to consuming
   - tip link for others

What is REST?
=============

What is a Representation?
-------------------------

- frontend / View responsible for presentation (NOT OUR CONCERN)
   - representation is used for portability 
   - allows frontend / View to decide how they want to present

What is State?
--------------

.. admonition:: example

Transferring State
------------------

- http is stateless we transfer it to / from the consumer

Specifications
--------------

- practical rules for an abstract pattern
- openAPI + swagger

Resources
=========

Collections
-----------

Entities
--------

- something contained in a collection
- note: sub-collections 
   - something belonging to the parent path collection/entity

Schemas
=======

- blueprint to define the representations
   - representation like an object
   - schema like a class
- example
   - shape
   - class
   - representation

Inputs
------

Outputs
-------

- inputs / outputs
- segue interactions

Endpoints
=========

- tip: endpoints are just the path and the method
   - relative paths (relative to the hosted server origin)

Paths (resource subject)
-----

Methods (action to take on resource)
-------

Endpoint Behavior
=================

Bodies
-------

Status Codes
------------

- status code groups table
   - commons

Headers
-------

- common both
- common request
- common response

Documentation
=============

Shorthand
---------

Swagger
-------

- tip more than docs, link to codegen

Learning More
=============

list of links

- origin in a doctoral thesis
   - made even MORE generic to apply to software architecture as a whole
   - in practice we focus on the web based implementation
- maturity model
- good examples