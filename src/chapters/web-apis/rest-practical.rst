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

Recall the hierarchal nature of Resources where **an entity only exists within a collection**. 

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

Suppose we wanted to interact with *an individual* Resource entity. We would need to *identify it within* its collection. 

The path to identify a Resource entity would need to include:

- the collection identifier, or Resource entry-point (``/collection``)
- the unique Resource entity identifier (``/{entityId}``) within the collection

Because the unique identifier of the entity is *variable* we use a **path variable** (``{entityId}``) to describe it in a generic way.

.. admonition:: tip

   The hierarchy of collections and entities is similar to directories and files. To identify an entity is *like identifying a file within a directory*. 
   
   You need both the directory (collection) name and a *sub-path* that uniquely identifies the file (entity).

Consider a request to the following **endpoint** for viewing a single Resource entity:

.. list-table:: Identify the Resource
   :header-rows: 1

   * - Path
     - Noun (subject)
   * - ``/collection/{entityId}``
     - Resource entity

.. list-table:: Interact with its State
   :header-rows: 1

   * - HTTP method
     - Verb (action)
   * - ``GET``
     - view representation of a single entity

Let's take another look at our example API:

.. admonition:: example

   The generic path to identify a ``CodingEvent`` Resource would be described as ``/events/{codingEventId}``.
   
   Let's assume a Coding Event exists with an ``Id`` of ``12``.
   
   We could make a request to the ``GET /events/12`` **endpoint** to **R**\ead its *current State*:

   .. sourcecode:: json
      :caption: response from a GET request to /events/12

      {
         "Id": 12,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls...",
         "Date": "2020-10-31"
      }

CRUD Operations & HTTP Methods
------------------------------

   In a RESTful API the interactions a client takes on a Resource are described using HTTP methods

If the Resource path describes the **noun** (subject) the HTTP method describes the **verb** (action) that is taken on that subject's State. 

As we saw in the previous article, State is something that can be interacted using **CRUD** operations. *By convention*, each of these operations corresponds to an HTTP method:

.. list-table:: HTTP method and corresponding **CRUD** operation
   :stub-columns: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH*``
     - ``DELETE``
   * - CRUD operation
     - **C**\reate
     - **R**\ead
     - **U**\pdate
     - **D**\elete

The use case of an API dictates the design of its contract. This includes which actions the client can take on each Resource. In other words, **not every action must be exposed** for each Resource the API manages.

.. admonition:: note

   If a client tries to take an action on a Resource that is not supported by the API they will receive a ``405`` **status code** or ``Method not allowed`` error response.

Endpoint Behavior
=================

Depending on the endpoint the effect of the request can differ. In other words, the **behavior of an endpoint** is dependent on the subject -- an entity or the collection as a whole.

Operating On Collections
------------------------

.. list-table:: Endpoint behaviors for a Resource collection
   :stub-columns: 1

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

Let's consider a request for creating a Resource entity. Recall that this operation acts on **the State of the collection** by adding a new entity to it.

The ``POST`` endpoint of the collection the entity belongs to can be used with a **request body**. This request body is a **representation of the initial State** the client must provide as **an input** to the API. 

Let's take a look at this request in the context of our example API:

.. admonition:: example

   As we saw earlier, the *input shape* for creating a ``CodingEvent`` only **includes the fields the consumer is responsible for**:

   .. sourcecode:: json
      :caption: 

   After sending this request the response would include:

   - a ``201``, or ``Created``, **status code**
   - a ``Location`` **response header**
   - the representation of the created Resource entity

   .. sourcecode:: json
   
      {

      }

Operating On Entities
---------------------

.. list-table:: Endpoints behaviors for an individual Resource entity
   :stub-columns: 1

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

We can see the behavior of a ``DELETE`` endpoint for a single Resource entity in our example API:

.. admonition:: example

   - DELETE
   - 204 status code and NO response body

Headers & Status Codes
======================

Another aspect of a RESTful API dictates the usage of HTTP response status codes and HTTP request/response headers. 

Response status codes inform the client on if their request was handled successfully. The response status code and the attached message will include the information the client must change to fix the request.

HTTP headers are attached to both requests and responses that include additional information about the request/response. A previous chapter mentioned the ``Content-Type`` header which dictates the format of the attached request/response body. We show additional common headers used in REST.

.. ::

   ...in addition to the req/res bodies each endpoint also has req/res headers and res status codes...
   
   - status codes only responses
   - status code + message + REST meaning
   - headers req/res and either

Status Codes
------------

   Every API response includes a status code that indicates whether the client's request succeeded or failed

Success Status Codes
^^^^^^^^^^^^^^^^^^^^

When a request is successful the ``2XX`` status codes are used. These codes communicate to the consumer the **type of success** relative to the action that was taken. Below is a list of the common success codes you will encounter:

.. list-table:: Common client success status codes for each action
   :header-rows: 1
   :widths: 20 20 20 40

   * - HTTP method
     - Status code
     - Message
     - Response
   * - ``POST``
     - ``201``
     - ``Created``
     - Resource entity and ``Location`` header
   * - ``GET``
     - ``200``
     - ``OK``
     - Resource entity or collection
   * - ``DELETE``
     - ``204``
     - ``No Content``
     - empty response body

Failure Status Codes
^^^^^^^^^^^^^^^^^^^^

Requests can fail. A failed request is due to either the consumer or a bug in the API. Recall the status code groups that categorized the type of failure:

- **client error**: ``4XX`` status code group
- **server error**: ``5XX`` status code group

Server errors are **not something the consumer can control**. However, client errors indicate that the request can be **reissued with corrections**. Each of these status codes and messages notify the consumer of the changes needed for a success.

Let's look at some of the common client error status codes:

.. list-table:: Common client error status codes
   :header-rows: 1
   :widths: 20 30 50

   * - Status code
     - Message
     - Correction
   * - ``400``
     - ``Bad Request``
     - Client must fix errors in their request body
   * - ``401``
     - ``Unauthorized``
     - Client must **authenticate** first*
   * - ``403``
     - ``Forbidden``
     - An authenticated client is **not allowed** to perform the requested action
   * - ``404``
     - ``Not Found``
     - The path to identify the Resource is incorrect or the Resource does not exist

A bad request will include an error message in its response. The response will indicate **what the client must change** in their request body to succeed. This failure is seen when **C**\reating or **U**\pdating a Resource entity:

.. admonition:: example

   In the Coding Events API a ``CodingEvent`` is validated using the following criteria:

   - ``Title``: 10-100 characters
   - ``Description``: less than 1000 characters

   Imagine sending a ``POST`` request with the following **invalid representation of State**:

   .. sourcecode:: json
      :caption: invalid request body for POST /events endpoint
   
      {
      }

   Then the response would have a ``400`` status code and a body indicating what aspects were invalid:

   .. sourcecode:: json
      :caption: 400 failed response body

      {

      }

   Using the hints in the response the client can fix their request body and reissue the request successfully.

.. admonition:: fun fact

   The ``401``, or ``Unauthorized``, status code actually indicates that the consumer is **not authenticated**. This means the consumer has **not proven their identity** to the API.
   
   The ``403``, or ``Forbidden``, status code is a more accurate description of being **unauthorized**. After authenticating, the consumer's **authorization** can determine if they are allowed or **forbidden** from taking the requested action.

Headers
-------

- common both
- common request
- common response

Learning More
=============

list of links

- maturity model
- thesis link 
- resource links
- good examples
   - GitHub
   - stripe