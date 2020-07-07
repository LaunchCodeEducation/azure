====================
Introduction to REST
====================

In this article we will explore a pattern for organizing the behavior of an API. REST is an **architectural pattern** that provides *uniformity and predictability* to any API that adheres to it. These benefits are seen in both the back-end development of an API as well as by the front-end **client** (the consumer). 

   REST is just a set of guiding principles for supporting the organization of an API's core responsibilities -- managing and transferring data.
   
   Its pattern organizes the **external interface** (contract) and does not concern itself with the *internal implementation* of the API . 

In this course we will only be consuming a REST API, not creating one. For this reason we will focus on the external fundamentals of REST. Although we will not be designing or implementing a RESTful API, learning how to use one will form a foundation that empowers further learning. 

What is REST?
=============

   **RE**\presentational **S**\tate **T**\transfer

.. admonition:: tip

   The topics of State and Representation are *purposefully abstract* in REST so that they can be applied to any API. Don't get overwhelmed!
   
   We will introduce them briefly before spending the majority of the article on practical aspects and examples of REST in action.

What is State?
--------------

   Transitional data that can be viewed or changed by external interaction

While State is abstract you can "interact" with it using **CRUD** (Create, Read, Update, Delete) operations. 

Imagine viewing, or **R**\eading, the State as it *transitions* through each of the following interactions:

#. **before Creating**: no State
#. **after Creating**: initial State
#. **after Updating**: new State
#. **after Deleting**: no State

You can see that the State is defined by how the data exists **after its latest interaction**. 

.. admonition:: note

   The concept of State is both the most abstract and most fundamental aspect of REST. All of the following sections will reference the Coding Events MVC project you created to illustrate the concepts in a more relatable way. 

What is a Representation?
-------------------------

   A depiction of State that is usable in a given context

Representations are a way of working with State in different contexts. Think about the difference in Representation between the State stored in a database row and an object in your code *representing* that row. 

First, consider how we *represent* State in a database row. Traditionally the *Representation of a row* is visualized as a table with columns listing the properties and values that make up the State:

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
      
Recall that the raw State held in a database row was not *usable in the context of our application code*. Instead we used an ORM to *represent the State as an object* that was suitable for our application's object-oriented context. 

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

In both cases the **State was the same**. The difference was in the **Representation that made it usable in its context**. 

   In REST, State must be **represented** in a way that is **portable and compatible** with both the client and API.

Consider a third Representation -- JSON. Recall that JSON is a format that provides *structure, portability and compatibility*. For these reasons JSON is the standard Representation used when transferring State between a client application and an API. 

.. admonition:: example

   The State of a *single* ``CodingEvent`` **entity** would be represented as a *single JSON object*:

   .. sourcecode:: js
      :caption: CodingEvent State represented as a JSON object

      {
         "Id": 1
         "Title": "Halloween Hackathon!"
         "Description": "A gathering of nerdy ghouls..."
         "Date": "2020-10-31"
      }

   Whereas the State of a **collection** of ``CodingEvents`` would be represented by a *JSON array of objects*.

   .. sourcecode:: js
      :caption: The State of a collection of CodingEvents represented as a JSON array

      [
         {
            "Id": 1
            "Title": "Halloween Hackathon!"
            "Description": "A gathering of nerdy ghouls..."
            "Date": "2020-10-31"
         },
         ...
      ]

   Notice that the State here is represented as the *collective State* of all the ``CodingEvents`` in the list.

.. admonition:: tip

   The process of converting an object Representation to a JSON Representation is called **JSON serialization**.
   
   The inverse process where JSON is parsed, or converted back to an object Representation, is called **JSON deserialization**.

Transferring a Representation of State
--------------------------------------

   In REST, a **Representation** of **State** is what is **transitioned** and **transferred** by **interaction** between a client and an API.

A RESTful API is designed to be stateless, just like the HTTP protocol used for communicating with its client application. How can REST be stateless if we have been harping about State this whole time?

Conceptually, REST considers State something that **transitions** throughout the interactions between the API and a client. Both HTTP and the RESTful API server are stateless. 

It is up to the client maintain the *current State*. If the client wants to *transition to a new State* it interacts with the API which then *persists the latest State after the transition* in a database. 

In order to maintain portability between the different client and API contexts we transfer Representations of State. These Representations can then be converted between the *portable Representation* (JSON) and the representation that fits the context (a JavaScript or C# object).

Recall that State is defined by its latest interaction. Because every interaction is initiated by the client we consider the **client to be in control of State**.

What this means is that the client can:

- *request the current* Representation of State be sent to it (**R**\ead)
- *transition to a new State* by sending a new Representation of State (**C**\reate, **U**\pdate)
- *transition to an empty State* by requesting a removal (**D**\elete)

However, it is up the API to define the contract, or **expose**:

- the types of State, or **resources**, the client can interact with
- which (CRUD) interactions are *supported* for each resource 

In some cases it makes sense for an API to expose a resource with any CRUD interaction. Whereas in other cases a resource may be restricted to only being **C**\reated and **R**\ead. These decisions are what drive the design of the contract. 
   
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