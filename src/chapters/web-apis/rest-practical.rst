============================
REST: Practical Fundamentals
============================

Now that you have an understanding of the more abstract aspects of REST, let's turn our attention to the practical details. The previous section covered the following terms in great depth:

- **State**: data that can change, or transition, through interactions between an API and its client.
- **Representation**: the convertible format that enables state to be transferred and used by the client and API.
- **Resource**: the representation of a type of state (as an entity or collection) that the API exposes to its client for interaction.
- **Entity**: a single resource that is uniquely identifiable in a collection.
- **Collection**: entities of the same resource type treated as a whole.

This section provides a more practical summary.

Shapes
======

.. index:: ! shape

A **shape** is a the blueprint that describes the representation of an input or output of an API.

The shape describes the input or output of an API in terms of its fields and data types. There are no rules for how the shapes should be defined. However, the goal should be to describe the shapes in a way that is *easy to understand*. 

For this reason, they are typically shown in a way that is similar to the representation format. Because we use JSON as the representation format, the `JSON data types <https://json-schema.org/understanding-json-schema/reference/type.html>`_ are used. 

You can think of the shape like a class definition in an object-oriented application:

.. admonition:: Example

   .. sourcecode:: csharp
      :caption: The internal data model class (blueprint) of a ``CodingEvent``

      public class CodingEvent {
         public long Id { get; set; }
         public string Title { get; set; }
         public string Description { get; set; }
         public DateTime Date { get; set; }
      }

   .. sourcecode:: javascript
      :caption: The output resource shape (blueprint) of a ``CodingEvent``

      CodingEvent {
         Id: integer
         Title: string
         Description: string
         Date: string (ISO 8601 date format)
      }

The JSON representation of the resource that the API sends out is then based on the shape. Like an object is based on the blueprint of its class:

.. admonition:: Example
   
   .. sourcecode:: javascript
      :caption: sample Coding Event JSON representation

      {
         "Id": 1,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls to work on GitHub Hacktoberfest contributions",
         "Date": "2020-10-31"
      }

We can think of inputs as a *partial state* provided by the client during create and update interactions. Only some of the fields are included because the API is responsible for providing the others.

Consider the following example of an input shape. Notice that the ``Id`` field is not included:

.. admonition:: Example

   .. sourcecode:: javascript
      :caption: The input shape (blueprint) used to Create a Coding Event

      CodingEvent {
         Title: string
         Description: string
         Date: string (ISO 8601 date format)
      }

   Some of the common fields the API is responsible for managing:

   - The unique identifier (``Id``) .
   - The created or last updated timestamp.
   - Links for relationships between resources.

Endpoints
=========

.. index:: ! endpoint

An **endpoint** consists of the HTTP *path* and *method* that define the location of a resource and the action to take on its state.

An API exposes endpoints to its consumers. Each endpoint is made up of a:

- **Path**: the *noun* that identifies the resource.
- **Method**: the *verb*, or action, to take on the resource's state.

.. They are written using *relative paths*. This approach is more readable and decouples the endpoint from where the API is running (locally or in the cloud).

.. For example consider the two URLs or *absolute paths* to a Pumpkin resource *collection*:

.. - ``http://localhost:5000/pumpkins``
.. - ``https://my-live-site.com/pumpkins``

.. If we describe the endpoint using a relative path of ``/pumpkins`` then it remains valid whether the API is *hosted locally* on our machine or *hosted remotely* in the cloud.

Identifying the Resource
------------------------

.. index:: path

**Paths** are used to identify the resource. Recall the hierarchal nature of resources where *an entity only exists within a collection*. 

RESTful APIs separate the resources they expose into one or more **resource entry-points**. As the name implies, these entry-points are the start of the hierarchy, and they identify each **top-level resource collection**.

Let's consider two resources exposed by a RESTful API:

.. admonition:: Example

   The ``CodingEventsAPI`` would have the following familiar resources (among others):

   .. list-table:: Resource and corresponding collection entry-point

      * - Resource
        - ``CodingEvent``
        - ``Tag``
      * - Collection entry-point
        - ``/events``
        - ``/tags``

   The name of the path is arbitrary, but should follow these rules of thumb to maintain consistency:

   - The name iss lowercase and separated by underscores if necessary.
   - The name adequately describes the resource in as few characters as necessary.
   - The name *is a noun* (actions are described by the method of the endpoint).

Notice that the entry-points are pluralized. The pluralized path indicates that the *state of the resource collection* is the subject of the interaction. 

Consider a request to the following endpoint (path and method):

.. list-table:: Identify the resource
   :header-rows: 1

   * - Path
     - Noun (subject)
   * - ``/collection``
     - Resource collection

.. list-table:: Interact with its state
   :header-rows: 1

   * - HTTP method
     - Verb (action)
   * - ``GET``
     - view representation of the collection

Let's see this in action with our example API. Using what we have learned so far, we can expect the state of the resource collection to be represented in a JSON array, ``[]``:

.. admonition:: Example

   .. sourcecode:: javascript
      :caption: response from a request to the GET ``/events`` endpoint

      [
         CodingEvent { ... },
         ...
      ]

   The state of the ``CodingEvent`` collection is made up of the *collective state* of each ``CodingEvent`` entity within it.

.. admonition:: Example

   
   .. sourcecode:: javascript
      :caption: response from a request to the GET ``/tags`` endpoint

      [
         Tag { ... },
         ...
      ]

   A request to the endpoint of the ``Tag`` collection would include its respective ``Tag`` entity representations (JSON objects).

Suppose we wanted to interact with an *individual* resource entity. We would need to identify it within its collection. 

The path to identify a resource entity would need to include:

- The collection identifier, or resource entry-point (``/collection``).
- The unique resource entity identifier (``/{entityId}``) within the collection.

.. index::
   :single: path, variable

Because the unique identifier of the entity is *variable* we use a **path variable** (``{entityId}``) to describe it in a generic way.

.. admonition:: Tip

   The hierarchy of collections and entities is similar to directories and files. To identify an entity is *like identifying a file within a directory*. 
   
   You need both the directory (collection) name and a *sub-path* that uniquely identifies the file (entity).

Consider a request to the following endpoint for viewing a single resource entity:

.. list-table:: Identify the resource
   :header-rows: 1

   * - Path
     - Noun (subject)
   * - ``/collection/{entityId}``
     - Resource entity

.. list-table:: Interact with its state
   :header-rows: 1

   * - HTTP method
     - Verb (action)
   * - ``GET``
     - view representation of a single entity

Let's take another look at our example API:

.. admonition:: Example

   The generic path to identify a ``CodingEvent`` resource would be described as ``/events/{codingEventId}``.
   
   Let's assume a Coding Event exists with an ``Id`` of ``12``.
   
   We could make a request to the ``GET /events/12`` endpoint to read its current state:

   .. sourcecode:: javascript
      :caption: response from a GET request to /events/12

      {
         "Id": 12,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls...",
         "Date": "2020-10-31"
      }

CRUD Operations & HTTP Methods
------------------------------

In a RESTful API the *interactions* a client takes on a resource are described using HTTP methods.

If the resource path describes the noun (subject) the HTTP method describes the verb (action) that is taken on that subject's state. 

As we saw in the previous article, state is something that can be interacted using CRUD operations. By convention, each of these operations corresponds to an HTTP method:

.. list-table:: HTTP method and corresponding **CRUD** operation
   :stub-columns: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH*``
     - ``DELETE``
   * - CRUD operation
     - create
     - read
     - update
     - delete

The use case of an API dictates the design of its contract. This includes which actions the client can take on each resource. In other words, *not every action must be exposed* for each resource the API manages.

.. admonition:: Note

   If a client tries to take an action on a resource that is not supported by the API, they will receive a ``405`` status code or ``Method not allowed`` error response.

Endpoint Behavior
=================

Depending on the endpoint, the effect of the request can differ. In other words, the *behavior of an endpoint* is dependent on the subject, an entity or the collection as a whole.

Operating on Collections
------------------------

.. list-table:: Endpoint behaviors for a resource collection
   :stub-columns: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH``
     - ``DELETE``
   * - Behavior with resource state
     - create a new entity in the collection
     - view the *current* list of all entities in the collection
     - bulk update of entities in the collection
     - remove all entities in the collection

.. admonition:: Note

   Exposing the ability to modify or delete *all* of the entities in a collection at once can be risky. In many cases, the design of a RESTful API will only support ``GET`` and ``POST`` endpoints for collections. 

Let's consider a request for creating a resource entity. Recall that this operation acts on the *state* of the collection by adding a new entity to it.

The ``POST`` endpoint of the collection, that the entity belongs to, can be used with a request body. This request body is a *representation* of the initial state the client must provide as an *input* to the API. 

Let's take a look at a request in the context of our example API:

.. admonition:: Example

   As we saw earlier, the *input shape* for creating a ``CodingEvent`` only includes the fields the consumer is responsible for. The ``Id`` field is then managed internally by the API.
   
   We refer to this shape as a ``NewCodingEvent`` to distinguish it from the ``CodingEvent`` resource shape:

   .. sourcecode:: javascript

      NewCodingEvent {
         Title: string
         Description: string
         Date: string (ISO 8601 date format)
      }

   We can describe this request in a shorthand. This shorthand includes the endpoint, input, and outputs:

      ``POST /events (NewCodingEvent) -> 201, CodingEvent``

   After sending this request, the response would include:

   - A ``201``, or ``Created``, status code
   - A ``Location`` response header
   - The representation of the created resource entity state (including an assigned ``Id`` field)

Operating on Entities
---------------------

.. list-table:: Endpoints behaviors for an individual resource entity
   :stub-columns: 1

   * - HTTP method
     - ``POST``
     - ``GET``
     - ``PUT/PATCH``
     - ``DELETE``
   * - Behavior with resource state
     - N/A (created inside a collection)
     - view the *current* entity state
     - update the entity state
     - remove the entity from the collection

.. admonition:: Note

   Updating using ``PUT`` or ``PATCH`` in REST is a choice left to the API designer. If you're curious about the considerations involved, read a great `breakdown of the subject <https://restfulapi.net/rest-put-vs-post/>`_.

   In this course, we will follow the convention that ``PATCH`` is used to update the state of a resource entity. 

When removing a resource the client is requesting a *transition to an empty state*. This means that *both* the request and response body that are transferred---*the representations of state*---are empty.

We can see this behavior in action with a request to the ``DELETE`` endpoint for a single resource entity in our example API:

.. admonition:: Example

   Let's once again assume a ``CodingEvent`` resource exists with an ``Id`` of ``12``. If we want to remove this entity we need to issue a request to its *uniquely identified* ``DELETE`` endpoint:

      ``DELETE /events/12 -> 204``
   
   In this shorthand you can see that this request has an *empty* request body. This is the empty state we are requesting a transition to. 
   
   The ``204``, or ``No Content``, status code in the response indicates that the action was successful and that the response body is empty. The API transfers back a *representation of empty state* (no response body) to the client. 

.. admonition:: Example

   What would happen if we made another request to the endpoint of a resource entity that doesn't exist, such as ``DELETE /events/999``?

   We would receive a ``404``, or ``Not Found``, status code that lets us know the request failed because of a client error (providing an ``Id`` for a nonexistent resource).

Headers & Status Codes
======================

Another aspect of a RESTful API dictates the usage of HTTP response status codes and HTTP request and response headers. 

Response status codes inform the client about how the request was handled, including whether it was handled successfully or not. In the case of an unsuccessful request, the response status code and the attached message will include the information the client must change to fix the request.

HTTP headers are used to communicate additional information (aka metadata) about a request or response. We will explore some common HTTP headers and their usage in RESTful design.

Status Codes
------------

.. index::
   :double: HTTP, status code

Every RESTful API response includes a status code that indicates whether the client's request succeeded or failed.

Success Status Codes
^^^^^^^^^^^^^^^^^^^^

When a request is successful, a ``2XX`` status code is used. These codes communicate to the consumer the *type* of success relative to the action that was taken. Here are some of the most common success codes you will encounter:

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

- **Client error**: ``4XX`` status code group
- **Server error**: ``5XX`` status code group

Server errors are not something the consumer can control. However, client errors indicate that the request can be *reissued* with corrections. Each of these status codes and messages notify the consumer of the changes needed for a success.

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
     - Client must authenticate first
   * - ``403``
     - ``Forbidden``
     - An authenticated client is *not allowed* to perform the requested action
   * - ``404``
     - ``Not Found``
     - The path to identify the resource is incorrect or the resource does not exist

A bad request will include an error message in its response. The response will indicate *what the client must change* in their request body to succeed. This failure is seen when creating or updating a resource entity:

.. admonition:: Example

   In the ``CodingEventsAPI``, the *state* of a ``CodingEvent`` is validated using the following criteria:

   - ``Title``: 10-100 characters
   - ``Description``: less than 1000 characters

   Imagine a client sending a ``PATCH`` request to update the ``CodingEvents`` resource entity with an ``Id`` of ``6``. 

      ``PATCH /events/6 (PartialCodingEvent) -> CodingEvent``
   
   If their request body contained the following *invalid* representation of partial state (due to a ``Title`` field that is too short):

   .. sourcecode:: javascript
      :caption: invalid representation in request to ``PATCH /events/6`` endpoint
   
      {
         "Title": "short"
      }

   The API response would have a ``400`` status code alerting the client that they must *correct their representation*. The response body would be used to communicate which aspects were invalid:

   .. sourcecode:: javascript
      :caption: 400 failed response body

      {
         "error": "invalid fields",
         "fields": [
            {
               "Title": "must be between 10 and 100 characters in length"
            }
         ]
      }

   Using the hints in the response, the client can fix their request body and reissue the request successfully.

.. admonition:: Fun Fact

   The ``401``, or ``Unauthorized``, status code actually indicates that the consumer is *not authenticated*. This means the consumer has not proven their identity to the API.
   
   The ``403``, or ``Forbidden``, status code is a more accurate description of being unauthorized. After authenticating, the consumer's authorization can determine if they are *allowed* or *forbidden* from taking the requested action.

Headers
-------

.. index::
   :double: HTTP, headers

In RESTful design **headers** are used to communicate metadata about each interaction with a resource.

.. list-table:: Common request/response headers in REST
   :header-rows: 1
   :widths: 20 20 40 20

   * - Request/Response
     - Header
     - Meaning
     - Example
   * - Both
     - ``Content-Type``
     - The attached body has the following media type
     - ``application/json``
   * - Request
     - ``Accept``
     - The client expects the requested resource representation in the given media type
     - ``application/json``
   * - Response
     - ``Location``
     - The created resource representation can be found at the given URL value
     - ``/resources/{id}``

.. admonition:: Tip

   The ``Authorization`` request header is also commonly used. Later in this course we will learn about authenticating with an API using this header and a `JWT access token <https://auth0.com/docs/protocols/oidc>`_.

Learning More
=============

This book has covered the fundamental aspects of the RESTful mental model and practical usage. However, RESTful design is a deep topic that even extends *beyond the web and use of HTTP*! 

If you want to learn more, the following resources are a good start:

Practical Understanding
-----------------------

- `Craig Dennis: APIs for beginners (YouTube) <https://www.youtube.com/watch?v=GZvSYJDk-us&t=0s>`_
- `REST sub-collections, relationships and links <https://restful-api-design.readthedocs.io/en/latest/relationships.html>`_
- `OpenAPI specification & Swagger REST tools <https://swagger.io/specification/>`_
- The `GitHub API <https://developer.github.com/v3/>`_ and `Stripe (payment processing) API <https://stripe.com/docs/api>`_ are excellent examples of RESTful design (and fantastic documentation)

Deep Understanding
------------------

- The `REST constraints <https://www.restapitutorial.com/lessons/whatisrest.html>`_
- The `The Richardson REST maturity model <https://www.martinfowler.com/articles/richardsonMaturityModel.html>`_
- The original `REST doctoral thesis by Roy Fielding <https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm>`_