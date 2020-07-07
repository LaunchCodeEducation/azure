====================
Introduction to REST
====================

In this article we will explore a pattern for organizing the behavior of an API. REST is an **architectural pattern** that provides *uniformity and predictability* to any API that adheres to it. These benefits are seen in both the back-end development of an API as well as by the front-end **client** (the consumer). 

REST is just a set of **constraints**, or guiding principles, for supporting the organization of an API's core responsibilities -- managing and transferring data. Although REST may appear complicated at first, you will find that its underlying pattern is actually logical and easy to understand.

In this course we will only be consuming a REST API, not creating one. For this reason we will focus on the fundamental aspects of REST as it pertains to being used. Although we will not be designing or implementing a RESTful API, learning how to use one will form a foundation that empowers further learning. 

What is REST?
=============

   **RE**\presentational **S**\tate **T**\transfer

Let's explore each of the terms in this acronym. Keep in mind that, like all software patterns, REST is purposefully abstract so that it can be applied to any language and framework that an API following its constraints is implemented in. 

Whenever possible we will use concrete examples to help tie the abstract concepts to something familiar.

What is State?
--------------

   Transitional data that can be viewed or changed by external interaction

In more relatable terms you can think of State as an abstract way of describing all of the properties (data) of an object. Each property holds some information that is meaningful to describing that object. 

State can describe a single object or a *collection* of objects as a whole. For example, a single object's State would be its property values while the State of a collection of these objects would be described by the count and contents of the objects it is holding.

The State of an object is just its data in the moment it is requested. It can **transition** depending on how the object is interacted with. 

While State is abstract you can "operate" on it with **CRUD** (Create, Read, Update, Delete) interactions. Imagine viewing, or Reading, the State as it *transitions* through each of the following interactions:

#. **before Creating**: no State
#. **after Creating**: initial State
#. **after Updating**: new State
#. **after Deleting**: no State

You can see that the State is defined by how the data exists after its latest interaction. 

   In REST, State is what is **transitioned** and **transferred** by interaction between a client and an API.

Aside from Reading, each other CRUD interaction supported by the API can be requested by a client to cause a *transition to a new State*.

Since State is just an abstract concept what is *actually transferred* between a client and an API is a **Representation** of the current State.

.. admonition:: note

   The concept of State is both the most abstract and most fundamental aspect of REST. All of the following sections will reference the Coding Events MVC project you created to illustrate the concepts in a more relatable way. 

What is a Representation?
-------------------------

   A depiction of State that is usable in a given context

Representations are a way of working with State in different contexts. Think about the difference in Representation between the State stored in a database row and an object in your code *representing* that row. 

First, consider how we *represent* State in a database row. Traditionally the *Representation of a row* is visualized as a table with columns listing the properties and values of the State:

.. admonition:: example

   .. list-table:: CodingEvent State represented as a database row
      :widths: 10 30 30 30
      :header-rows: 1

      * - Id
        - Title
        - Description
        - Date
      * - ``1``
        - ``"Halloween Hackathon"``
        - ``"A gathering of nerdy ghouls to..."``
        - ``2020-10-31``
      
Recall that the raw State held in a database row was not *usable in the context of our application code*. Instead we used an ORM to *represent* the State as an object that was suitable for our application's object-oriented context. 

The ``toString()`` method is used to visualize the *Representation as an object* that looks something like this:

.. admonition:: example


   .. sourcecode:: js
      :caption: CodingEvent State represented as an object

      CodingEvent {
         Id: 1
         Title: "Halloween Hackathon!"
         Description: "A gathering of nerdy ghouls..."
         Date: 2020-10-31
      }

In both cases the **State was the same** and the difference was in the **Representation that made it usable in its context**. 

   In REST, State must be **represented** in a way that is both **portable and usable** to the client and API

With the two abstract concepts of State and Representation explored we can complete our understanding of the REST acronym.

Transferring a Representation of State
--------------------------------------

Recall that HTTP is a *stateless protocol*, meaning that the data sent in a request and received in its response *is independent of any other exchange*. In other words, every request-response cycle operates independently of others.

..  This should make sense because transferring data is just sending signals (electrons) through a wire. There is no trace of the data in the wire after the signal reaches its destination.

Because HTTP is stateless it is up to the client or the server to store the State *between each request-response cycle*. The client can hold State in memory (JavaScript) or persist it in the browser (cookies or local storage). While the server would typically persist State in a database.

The server can hold State in its own memory (`server-side sessions <>`_) or persist the State data in a database. In modern development **servers should never have stateful sessions**.

.. admonition:: note


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