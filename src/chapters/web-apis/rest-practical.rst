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

You can think of the shape like a Class definition in an object-oriented codebase. It describes the input or output of an API in terms of its fields and data types. There are no rule for how the shapes should be defined.

However, the goal should be to describe the shapes in a way that is **easy to understand**. For this reason they are typically shown in a way that is similar to the Representation format.

.. admonition:: note

   Because we use JSON as the Representation format the `JSON data types <https://json-schema.org/understanding-json-schema/reference/type.html>`_ are used. These data types provide the best balance between structure and portability across JavaScript and the numerous languages an API can be implemented in.

Below is a general example of what a shape looks like. Notice that it is not *actual* JSON but a sort of pseudocode that is a balance between readable and descriptive:

.. sourcecode:: json

   ResourceName {
      fieldName: string
      otherFieldName: integer
      ...
   }

The naming convention for the fields is an implementation detail. REST does not define a rule for this either but you may see ``camelCase``, ``snake_case``, ``PascalCase`` or the ``wHyArEyOuLiKeThIsCaSe``.

Resource Shapes
---------------

To understand a Resource shape let's first take a look at an example:

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
      :caption: The external Resource shape (blueprint) of a Coding Event

      CodingEvent {
         Id: integer
         Title: string
         Description: string
         Date: string (ISO 8601 date format)
      }

   A JSON Representation of a Coding Event, based on the Resource shape:

   .. sourcecode:: json
      :caption: sample Coding Event JSON Representation

      {
         "Id": 1,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls to work on GitHub Hacktoberfest contributions",
         "Date": "2020-10-31"
      }

When we refer to the *type of Resource* exposed by an API we are referring to its **Resource shape**. One of the first steps in designing an API is to define the Resources and their shapes. For a consumer, knowing the Resource shape allows them to plan how they will use and interact with the State of each Resource.

Recall that *internally* the API uses data Model Classes to *represent State* as objects that are *usable in its context*.

In simple cases the *external* Resource shape is 1:1 with the properties of this *internal* data Model blueprint (Class definition). 

Input Shapes
------------

When a client *transfers a Representation of State* to the API we consider this an API **input**. Just like with Resources we can define **input shapes** that describe the Representation the API expects from the client.

Consider the **C**\reate interaction. The client must transfer a Representation of the Resource they want to create. We distinguish between Resource and input shapes because some fields are left to the API to manage. These fields are managed by the API internally to ensure consistent behavior or provide computed values.

Some of the other common fields the API is responsible for managing:

- the unique identifier (``Id``) 
- the created or last updated timestamp
- links for relationships between Resources

We can think of inputs as a *partial State* provided by the client. The input shape could then be defined as:

   The partial shape of a Resource used in **C**\reate and **U**\pdate interactions

.. admonition:: example

   For example, if a client were to request that a Coding Event be **C**\reated it would need to provide 

- segue interactions

Endpoints
=========

- tip: endpoints are just the path and the method
   - relative paths (relative to the hosted server origin)

Paths (resource subject)
-----

- entrypoint
- collection/{identifier}
- collection/{identifier}/sub-collection

Methods (action to take on resource)
-------

Links
=====

- sub-collections
- links
- 

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