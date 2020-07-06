====================
Introduction to REST
====================

In this article we will explore a pattern for organizing the behavior of an API. REST is an **architectural pattern** that provides *uniformity and predictability* to any API that adheres to it. These benefits are seen in both the back-end development of an API as well as by the front-end **client** (the consumer). 

REST is just a set of **constraints**, or guiding principles, for supporting the organization of an API's core responsibilities -- managing and transferring data. Although REST may appear complicated at first, you will find that its underlying pattern is actually logical and easy to understand.

In this course we will only be consuming a REST API, not creating one. For this reason we will focus on the fundamental aspects of REST as it pertains to being used. Although we will not be designing or implementing a RESTful API, learning how to use one will form a foundation that empowers further learning. 

What is REST?
=============

   **RE**\presentational **S**\tate **T**\transfer

Let's explore each of the terms in this acronym. Keep in mind that, like all software patterns, REST is purposefully generic so that it can be applied to any language and framework that the API is implemented in. Whenever possible we will use concrete examples to help tie the abstract concepts to something familiar.

What is State?
--------------

   Transitional data that can be viewed or changed by external interaction

In more relatable terms you can think of State as an abstract way of describing all of the properties (data) of an object. Each property holds some information that is meaningful to describing that object. State can describe a single object or a *collection* of objects as a whole.

The State of an object is just its data in the moment it is requested. It can **transition** depending on how the object is interacted with. 

While State is abstract you can "operate" on it with **CRUD** (Create, Read, Update, Delete) interactions. Imagine viewing, or Reading, the State as it transitions through each of the following interactions:

#. **before Creating**: no State
#. **after Creating**: initial State
#. **after Updating**: new State
#. **after Deleting**: no State

You can see that the **State is defined by how the data exists after its last interaction**. 

   In REST, State is what is **transitioned** and **transferred** by interaction between a client and an API.

Aside from Reading, each other CRUD interaction supported by the API that the client requests causes a *transition to a new State*.

Since State is just an abstract concept what is *actually transferred* between a client and an API is a **Representation** of the current State.

.. admonition:: note

   The concept of State is both the most abstract and most fundamental aspect of REST. All of the following sections will reference the Coding Events MVC project you created to illustrate the concepts in a more relatable way. 

What is a Representation?
-------------------------

   A depiction of data that is usable in the given context

- frontend / View responsible for presentation (NOT OUR CONCERN)
   - representation is used for portability 
   - allows frontend / View to decide how they want to present

Transferring a Representation of State
--------------------------------------

- http is stateless we transfer it to / from the consumer

Recall that HTTP is a *stateless protocol*, meaning that the data sent in a request or received in a response *only exists for that exchange*. This should make sense because transferring data is just sending signals (electrons) through a wire. There is no trace of the data after the signal reaches its destination.

Because of this statelessness it is up to the client or the server to store...

One of the REST pattern's `constraints <>`_ is to think in terms of a transitioning State of data between the API and its client. 

At its core, REST revolves around the **State** of the data an API is responsible for. 

 As a client interacts with an API the State of its data can be Created, Read, Updated or Deleted.  

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