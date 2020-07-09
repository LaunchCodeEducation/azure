============================
REST: Practical Fundamentals
============================

Now that you have an understanding of the more abstract aspects of REST let's turn our attention to the practical details. The previous article covered the following terms in great depth -- below is a *practical summary*:

   **State**: data that can change (transition) through interactions between an API and its client

   **Representation**: the convertible format that enables State to be transferred and used by the client and API

   **Resource**: the Representation of a type of State (as an entity or collection) that the API exposes to its client for interaction

   **Entity**: a single resource that is uniquely identifiable in a collection

   **Collection**: entities of the same resource type treated as a whole

Shapes
======

   **Shape**: the blueprint that describes the Representation of an input or output to an API

The shape describes the input or output of an API in terms of its fields and data types. There are no rule for how the shapes should be defined. However, the goal should be to describe the shapes in a way that is **easy to understand**. 

For this reason they are typically shown in a way that is similar to the Representation format. Because we use JSON as the Representation format the `JSON data types <https://json-schema.org/understanding-json-schema/reference/type.html>`_ are used. 

You can think of the shape like a Class definition in an object-oriented codebase:

.. admonition:: example

   .. sourcecode:: csharp
      :caption: The internal data Model Class (blueprint) of a Coding Event

      public class CodingEvent {
         public long Id { get; set; }
         public string Title { get; set; }
         public string Description { get; set; }
         public DateTime Date { get; set; }
      }

   .. sourcecode:: json
      :caption: The output Resource shape (blueprint) of a Coding Event

      CodingEvent {
         Id: integer
         Title: string
         Description: string
         Date: string (ISO 8601 date format)
      }

The JSON Representation of the Resource that the API sends out is then based on the shape. Like an object is based on the blueprint of its Class:

.. admonition:: example
   
   .. sourcecode:: json
      :caption: sample Coding Event JSON Representation

      {
         "Id": 1,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls to work on GitHub Hacktoberfest contributions",
         "Date": "2020-10-31"
      }

We can think of inputs as a *partial State* provided by the client during **C**\reate and **U**\pdate interactions. Only some of the fields are included because the API is responsible for providing the others.

Consider the following example of an input shape. Notice that the ``Id`` field is not included:

.. admonition:: example

   .. sourcecode:: json
      :caption: The input shape (blueprint) used to Create a Coding Event

      CodingEvent {
         Title: string
         Description: string
         Date: string (ISO 8601 date format)
      }

   Some of the common fields the API is responsible for managing:

   - the unique identifier (``Id``) 
   - the created or last updated timestamp
   - links for relationships between Resources

Endpoints
=========

   The HTTP **path** and **method** that defines the location of a Resource and the action to take on its State

Endpoints are what an API exposes to its consumers. Each endpoint is made up of a:

- **path**: the **noun** that identifies the Resource
- **method**: the **verb**, or action, to take on the Resource's State

.. They are written using *relative paths*. This approach is more readable and decouples the endpoint from where the API is running (locally or in the cloud).

.. For example consider the two URLs or *absolute paths* to a Pumpkin Resource *collection*:

.. - ``http://localhost:5000/pumpkins``
.. - ``https://my-live-site.com/pumpkins``

.. If we describe the endpoint using a relative path of ``/pumpkins`` then it remains valid whether the API is *hosted locally* on our machine or *hosted remotely* in the cloud.

Identifying the Resource
------------------------

   Paths are used to identify the Resource

Recall the hierarchal nature of Resources where **an entity only exists within a collection**. In order to *identify an entity* you need to provide both:

- its collection (``/collection``)
- its unique identifier (``/collection/{entityId}``)

RESTful APIs separate the Resources they expose into one or more **Resource entry-points**. As the name implies these entry-points are the start of the hierarchy and identify each **top-level Resource collection**.

Let's consider two Resources exposed by a RESTful API:

.. admonition:: example

   The Coding Events API would have the following familiar Resources (among others):

   .. list-table:: Resource and corresponding collection entry-point

      * - Resource
        - ``CodingEvent``
        - ``Tag``
      * - Collection entry-point
        - ``/events``
        - ``/tags``

   The name of the path is arbitrary but should follow these rules of thumb to *maintain consistency*:

   - is lowercase and separated by underscores if necessary
   - adequately describes the Resource in as few characters as necessary
   - **is a noun** (actions are described by the method of the endpoint)

Notice that the entry-points are **pluralized**. The pluralized path indicates that the **State of the Resource collection** is the subject of the interaction. 

Consider a request to the following **endpoint** (path and method):

.. list-table:: Identify the Resource
   :header-rows: 1

   * - Path
     - Noun (subject)
   * - ``/collection``
     - Resource collection

.. list-table:: Interact with its State
   :header-rows: 1

   * - HTTP method
     - Verb (action)
   * - ``GET``
     - view representation of the collection

Let's see this in action with our example API. Using what we have learned so far we can expect the State of the Resource collection to be represented in a JSON array, ``[]``:

.. admonition:: example

   .. sourcecode:: json
      :caption: response from a request to the GET ``/events`` endpoint

      [
         CodingEvent { ... },
         ...
      ]

   The State of the ``CodingEvent`` collection is made up of the **collective State** of **each** ``CodingEvent`` **entity** within it.

.. admonition:: example

   
   .. sourcecode:: json
      :caption: response from a request to the GET ``/tags`` endpoint

      [
         Tag { ... },
         ...
      ]

   A request to the endpoint of the ``Tag`` collection would include its respective ``Tag`` **entity representations** (JSON objects).

What if we wanted to interact with *an individual* Resource entity? We would need to identify it *within* its collection.

.. admonition:: tip

   The hierarchy of collections and entities is similar to directories and files. To identify an entity is *like identifying a file within a directory*. 
   
   You need both the directory (collection) name and a *sub-path* that uniquely identifies the file (entity).

The path to interact with the State of the entity would need to include:

- the collection identifier, or Resource entry-point (``/collection``)
- the unique identifier of the entity within the collection

Because the unique identifier of the entity is *variable* we use a **path variable** to describe it:

   ``/collection/{entityId}``

Let's take another look at our example API:

.. admonition:: example

   The path to identify the State of a Coding Event Resource would be described as ``/events/{codingEventId}``.
   
   Let's assume a Coding Event exists with an ``Id`` of ``12``.
   
   We could make a request to the ``GET /events/12`` **endpoint** to **R**\ead its *current State*:

   .. sourcecode:: json
      :caption: response from a GET request to /events/12

      {
         "Id": 12,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls to work on GitHub Hacktoberfest contributions",
         "Date": "2020-10-31"
      }

CRUD Operations & HTTP Methods
------------------------------

In a RESTful API the interactions a client takes on the State of a Resource are described using HTTP methods. If the Resource path describes the **noun**, or subject, the HTTP method describes the **verb**, or action, that is taken on that subject's State. 

As we saw in the previous article, State is something that can be interacted with using CRUD operations. *By convention*, each of these operations corresponds to an HTTP method:

.. list-table::
   :header-rows: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH``
     - ``DELETE``
   * - CRUD operation
     - **C**\reate
     - **R**\ead
     - **U**\pdate*
     - **D**\elete

The use case of an API dictates the design of its contract. This includes which actions the client can take on each Resource State. In other words, **not every action must be exposed** for each Resource the API manages.

.. admonition:: note

   If a client tries to take an action on a Resource that is not supported by the API they will receive a ``405`` **status code** or ``Method not allowed`` error response.

Endpoint Behavior
=================

Depending on the endpoint (the Resource path and the method) the effect of the request can differ. In other words, the **behavior of an endpoint** is dependent on the subject -- an entity or the collection as a whole.

Operating On Collections
------------------------

.. list-table:: Resource collection
   :header-rows: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH``
     - ``DELETE``
   * - Behavior with Resource State
     - create a new entity in the collection
     - view the **current** list of all entities in the collection
     - bulk update of entities in the collection
     - remove all entities in the collection

.. admonition:: note

   Exposing the ability to modify or delete *all of the entities in a collection* at once can be risky. In many cases the design of a RESTful API will only support ``GET`` and ``POST`` endpoints for collections. 

.. admonition:: example

   - GET example
   - POST example
   - show bodies (request, response)

Operating On Entities
---------------------

.. list-table:: Individual Resource entity
   :header-rows: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH``
     - ``DELETE``
   * - Behavior with Resource State
     - N/A (created inside a collection)
     - view the **current** entity State
     - update the entity State
     - remove the entity from the collection

.. admonition:: note

   **U**\pdating using ``PUT`` or ``PATCH`` in REST is a choice left to the API designer. This article has a great `breakdown of the subject <https://restfulapi.net/rest-put-vs-post/>`_.

   In this course we will follow the convention that ``PATCH`` is used to **U**\pdate the **State of a Resource entity**. 

.. admonition:: example

   - GET
   - DELETE
   - show req/res bodies

Headers & Status Codes
======================

...in addition to the req/res bodies each endpoint also has req/res headers and res status codes...

Status Codes
------------

- status code groups table
   - commons

Headers
-------

- common both
- common request
- common response

Learning More
=============

Organizing Relationships
------------------------

Suppose you have two Resources that are related to each other:

.. admonition:: example

   In the Coding Events API the following relationships exist:``Category`` can have **many** ``CodingEvent`` can have many ``Tags``

- example of two collection entry points and sub-collection
- keep brief

list of links

- maturity model
- thesis link 
- resource links
- good examples
   - GitHub
   - stripe