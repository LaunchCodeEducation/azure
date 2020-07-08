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

   The HTTP **path** and **method** that defines the location for interacting with a Resource

Endpoints are what an API exposes to its consumers. Each endpoint is made up of a:

- **path**: identifies the Resource (collection or entity) 
- **method**: the action to take on the Resource's State

Endpoints are written using *relative paths*. This approach is more readable and decouples the endpoint from where it is hosted.

For example consider the two URLs or *absolute paths* to a Pumpkin Resource *collection*:

   ``http://localhost:5000/pumpkins``

   ``https://my-live-site.com/pumpkins``

If we describe the endpoint using a relative path of ``/pumpkins`` then it remains valid whether the API is *hosted locally* on our machine or *hosted remotely* and accessible on the internet.

Identifying the Resource
------------------------

   Paths are used to identify the Resource State to be interacted with

Recall the hierarchal nature of Resources where an entity only exists within a collection. In order to identify an entity you need to provide both its collection and its unique identifier.

RESTful APIs separate the Resources they expose into one or more **Resource entry-points**. As the name implies these entry-points are the start of the hierarchy and identify the Resource collection.

Let's consider two Resources exposed by a RESTful API:

.. admonition:: example

   The Coding Events API would have the following familiar Resources (among others):

   - ``CodingEvent``
   - ``Tag``

   The entry-points for these two Resources would be:

   - ``CodingEvent``: ``/events``
   - ``Tag``: ``/tags``

Notice that the entry-points are **pluralized**. The pluralized path indicates that the **Resource State of the collection** is the subject of the interaction. For example, consider the response when making a ``GET`` request to them:

.. admonition:: example

   What would the response, or output, of the API be for the following **endpoints** (entry-point path and the ``Get`` method)?

   - ``GET /events``

   .. sourcecode:: json
      :caption: response from a GET request to /events entry-point

      [
         CodingEvent { ... },
         ...
      ]
   
   - ``GET /tags``

   .. sourcecode:: json
      :caption: response from a GET request to /tags entry-point

      [
         Tag { ... },
         ...
      ]

As expected the State of the Resource collection is represented in a JSON array (``[]``).

What if we wanted to interact with *an individual* Resource entity? We would identify it *within* its collection.

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

   The path to identify the State of a Coding Event Resource would be described as ``/events/{eventId}``.
   
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

Organizing Relationships
------------------------

- example of two collection entry points and sub-collection
- keep brief

CRUD Interactions & HTTP Methods
================================

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