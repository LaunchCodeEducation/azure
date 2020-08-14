===========================
REST: Abstract Fundamentals
===========================

.. index:: ! REST

This section explores a pattern for organizing the behavior of an API. REST is an architectural pattern, which means it is a general approach to designing an application that can be implemented in a wide variety of languages and frameworks. REST provides provides uniformity and predictability to any API that adheres to it. The same benefits are experienced by the API consumer.

**REST** is a set of guiding principles for supporting the organization of an API's core responsibilities---managing and transferring data. Its pattern organizes the *external* interface (contract) and does not concern itself with the *internal* implementation of the API. 

In this course we will only be consuming a REST API, not creating one. For this reason, we will focus on the external fundamentals of REST. Although we will not be designing or implementing a RESTful API, learning how to use one will form a foundation that empowers further learning. 

What is REST?
=============

REST stands for **RE**\presentational **S**\tate **T**\ransfer. We will explore each of the terms in this acronym in detail.

.. admonition:: Tip

   The topics of state and representation are *purposefully abstract* in REST so that they can be applied to any API. This means they can be hard to digest initially. Don't get overwhelmed!
   
What is State?
==============

.. index:: ! state

**State** refers to transitional data that can be viewed or changed by external interaction.

While state is abstract, you can *interact* with it using CRUD (create, read, update, delete) operations. 

Imagine viewing, or reading, the state as it *transitions* through each of the following interactions:

#. **Before creating**: empty state
#. **After creating**: initial state
#. **After updating**: new state
#. **After deleting**: empty state

You can see that the state is defined by how the data exists *after* its latest interaction. 

.. admonition:: Note

   The concept of state is both the most abstract and most fundamental aspect of REST. All of the following sections will reference the ``CodingEvents`` MVC project you created to illustrate the concepts in a more relatable way. 

What is a Representation?
=========================

.. index:: ! representation

**Representation** is a depiction of state that is usable in a given context.

Representations are a way of working with state in different contexts. Think about the difference in representation between the state stored in a database row and an object in your code *representing* that row. 

First, consider how we represent state in a database row. Traditionally the representation of a row is visualized as a table with columns listing the properties and values that make up the state:

.. admonition:: Example

   .. list-table:: CodingEvent state represented as a database row
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
      
Recall that the raw state held in a database row is not usable in the context of our application code. Instead we used an ORM to represent the state as an object that was suitable for our application's object-oriented context. 

In the object-oriented context, the ``toString()`` method is used to visualize the representation as an object that looks something like this:

.. admonition:: Example

   .. sourcecode:: js
      :caption: CodingEvent state represented as an object

      CodingEvent {
         Id: 1
         Title: "Halloween Hackathon!"
         Description: "A gathering of nerdy ghouls..."
         Date: 2020-10-31
      }

In both cases, the *state* was the same. The difference was in the *representation* that made it usable in its context. 

In REST, state must be represented in a way that is *portable and compatible* with both the client and API.

Consider a third representation: JSON. Recall that JSON is a format that provides structure, portability and compatibility. For these reasons, JSON is the standard representation used when transferring state between a client application and an API. 

.. admonition:: Example

   The state of a single ``CodingEvent`` entity would be represented as a single JSON object:

   .. sourcecode:: js
      :caption: CodingEvent state represented as a JSON object

      {
         "Id": 1,
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls...",
         "Date": "2020-10-31"
      }

   The state of a *collection* of ``CodingEvents`` would be represented by a JSON array of objects:

   .. sourcecode:: js
      :caption: The state of a collection of CodingEvents represented as a JSON array

      [
         {
            "Id": 1,
            "Title": "Halloween Hackathon!",
            "Description": "A gathering of nerdy ghouls...",
            "Date": "2020-10-31"
         },
         ...
      ]

   Notice that the state here is represented as the *collective state* of all the ``CodingEvents`` in the list.

.. index:: ! serialization

.. admonition:: Tip

   The process of converting an object representation to a JSON representation is called **JSON serialization**.
   
   The inverse process where JSON is parsed, or converted back to an object representation, is called **JSON deserialization**.

Transferring a Representation of state
======================================

.. index:: 
   single: state, transition

.. index:: ! transfer (REST)

In REST, state is **transitioned** by interactions between a client and an API. Aside from deleting, all other interactions involve **transferring** a representation of state.
   
A RESTful API is designed to be stateless. This has the following implications:

- The state of data is maintained by the client application and the database that are on either side of the interface.
- Its transitions are driven by the client and facilitated by the API which send or receive representations of the desired state.

In order to maintain portability between the different client and API contexts, we transfer representations of state. These representations can then be converted between the *portable representation* (JSON) and the representation that fits the context (a JavaScript or C# object).

Recall that state is defined by its latest interaction. Because every interaction is initiated by the client we consider the client to be *in control of state*.

This means that the client can:

- **Read**: *request* the current representation of state.
- **Create** and **Update**: *transition* to a new state by sending a new representation of state.
- **Delete**: *transition* to an empty state by requesting its removal>

However, it is up the API to define the contract, or *expose*:

- The types of state, or resources, the client can interact with.
- Which (CRUD) interactions are *supported* for each resource .

These decisions are what drive the design of the contract. 
   
Resources
=========

A **resource** is the representation of a *specific type of state* that a RESTful API exposes for a client to interact with. 

While state is an abstract concept, a resource is something more tangible. In simple terms, a resource is like a type of object that an API allows clients to interact with. Resources are categorized as an individual entity or a collection:

- **Entity**: a single resource that is *uniquely identifiable* in a collection.
- **Collection**: entities of the same resource type *treated as a whole*.

We refer to "the state of a resource" in terms of a single entity or the *collective state* of a collection.

.. admonition:: Note
   
   Initially, a collection's state is *empty*.
   
   If you were to read the collection's state it would be represented as an empty JSON array, ``[]``.

In RESTful design, an individual entity *only exists as part of a collection*. A change to the state of an entity inherently changes the state of the collection it is a part of.

When creating an entity you are operating on the *state* of the collection. In order to create it you must know:

- Which collection the entity belongs to.

When reading, updating, or deleting an entity, you are *directly* operating on the state of the entity and *indirectly* operating on the state of its collection.

In order to fulfill these operations you need to know:

- Which collection the entity belongs to.
- How to uniquely identify the entity within the collection.

.. index:: endpoint

This hierarchal relationship between collections and the entities within them is an integral aspect of RESTful design. The contract of a RESTful API defines the *shape*, or structure, of its resources. It also specifies the hierarchal organization of the **endpoints**---generally, the locations at which they can be accessed---used for interacting with them.
