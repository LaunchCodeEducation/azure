=========================================================
Walkthrough: Consuming the Coding Events API With Postman
=========================================================

The UI of a browser is designed to make *simple* ``GET`` requests for URLs entered into its address bar. This design works great for browsing sites but falls short when working with headless APIs. 

Anything beyond a ``GET`` request is handled behind the scenes such as when you ``POST`` a form or through AJAX requests with JavaScript. But before you develop the client-side logic for making background requests you need a way to interact with the API server directly and understand how it works.

When exploring and testing a Web API it is invaluable to have an interactive environment that allows you to fine-tune requests. For example, you may need to configure the HTTP method, headers or body of the request -- all of which the browser does not provide a UI for.

Instead of the browser we can use tools made specifically for interacting with APIs. One of the most popular API tools in the industry is **Postman**. It is a cross-platform tool that puts you in full control of configuring and executing API requests. 

In this walkthrough we will work with Postman to explore how APIs can be consumed.

.. admonition:: warning

   If you have not already installed ``dotnet`` and ``git`` with PowerShell you will need to go back to the previous walkthrough before continuing with this one. 

Setup
=====

Installing Postman
------------------

Installing Postman is easy thanks to its cross-platform nature. You can download the installer on `their downloads page <https://www.postman.com/downloads/>`_. We will show instructions for setting up on Windows but because Postman is cross-platform the other instructions in this walkthrough will apply regardless of your platform.

Select the ``Windows x64`` installer download then run the installer:

.. image:: /_static/images/postman/download-installer.png
   :alt: Download Windows x64 Postman installer

After installation Postman should open automatically. Making an account can be useful but if you do not want to create one you can select the **skip** link in grey at the bottom of the splash screen:

.. image:: /_static/images/postman/account.png
   :alt: Postman splash screen for new account

.. admonition:: tip

   Once installed you can right-click the Postman icon and pin it to your taskbar for easy access in the future:

   .. image:: /_static/images/postman/pin-taskbar.png
      :alt: Pin Postman application to taskbar on Windows

You can leave the Launchpad view open for now. We will explore Postman after setting up our API server.

.. image:: /_static/images/postman/launchpad-view.png
   :alt: Postman Launchpad view

Clone the Coding Events API Source Code
---------------------------------------

Throughout this course we will be using a modified version of the MVC Coding Events application you created. The `Coding Events API <https://github.com/LaunchCodeEducation/coding-events-api/tree/1-sqlite>`_ is designed following the OpenAPI REST specification. Although they are implemented differently you will find that most of the features from the MVC application have been supported through endpoints in the API.

.. admonition:: note

   Our focus in this course is on operations and as such we will not be going into the development of the API. However, feel free to explore the source code if you are curious about the similarities and differences between the .NET MVC and API implementations.

Let's begin by cloning the repo onto our machine:

.. admonition:: note

   If you just opened your PowerShell Terminal then it will default to a CWD of your ``HOME`` directory, ``C:\Users\<username>``. 
   
   If you want to clone the repo somewhere else make sure to change to that directory first.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git clone https://github.com/launchcodeeducation/coding-events-api

For today's studio we will start with the first branch of the API codebase, ``1-sqlite``. This branch has an API with a single (``CodingEvent``) resource and a built-in SQLite database. 

Let's change into the repo and switch to this branch:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # cd is an alias (like a nick-name) for the Set-Location cmdlet in PowerShell
   > cd coding-events-api

   # check out the 1-sqlite branch
   > git checkout 1-sqlite

You can leave this PowerShell Terminal window open, we will return to it in a later step:

.. image:: /_static/images/postman/powershell-in-repo-dir.png
   :alt: PowerShell in coding-events-api repo directory on 1-sqlite branch

Coding Events API
=================

This branch of the API starts things simple by only exposing a single resource and 4 endpoints for interacting with it.

CodingEvent Resource
--------------------

The *shape* of the ``CodingEvent`` resource describes the general form of its properties and value types:

.. sourcecode:: json

   CodingEvent {
      Id: integer
      Title: string
      Description: string
      Date: string (ISO 8601 date format)
   }

In our case the ``CodingEvent`` shape is just the properties and types (using portable `JSON types <https://json-schema.org/understanding-json-schema/reference/type.html>`_) defined in the ``CodingEvents`` Model class.

An example of a real ``CodingEvent`` JSON response would look like this:

.. sourcecode:: json

   {
      "Id": 1,
      "Title": "Consuming the Coding Events API With Postman",
      "Description": "Learn how to use Postman to interact with the Coding Events API!",
      "Date": "2020-10-31"
   }

Notice how this JSON is just a *representation* of an instance of the ``CodingEvent`` Model class. It has been converted from a C# object representation to a JSON string representation so it can be transported over HTTP. Recall that we perform this conversion, or serialization, so that our API can output data in a format that is language-agnostic.

Endpoints
---------

This branch of the API has the following 4 endpoints. Recall that an endpoint is the made up of a **path** (to the resource) and a **method** (action to take on the resource). 

They all share a common *entry point path* of ``/events``. Request and response bodies are all in JSON, or more specifically they have a ``Content-Type`` header value of ``application/json``.

GET Coding Events
^^^^^^^^^^^^^^^^^

Making a ``GET`` request to the entry point of a resource should return a representation of the state of the collection. In our case this representation is a JSON array with ``CodingEvent`` elements:

.. sourcecode:: json

   [
      CodingEvent { ... },
      ...
   ]

If the current state of the collection is empty then we will just get back an empty JSON array:

.. sourcecode:: json

   []

In more terse terms we can describe this endpoint as:

   ``GET /events -> CodingEvent[]``

GET Single Coding Event
^^^^^^^^^^^^^^^^^^^^^^^

If you want to view the representation of a single entity you need to provide information to uniquely identify it in the collection. Since the entry point represents the collection it can be followed by an ``Id`` value in the path to *look inside the collection* and return just the corresponding entity.

.. todo:: directory path analogy, collection/individual or collection/sub-collection/individual etc

When describing entity endpoints we use a path variable notation, ``{variableName}``, to symbolize where the value needs to be put in the path. 

We can describe this ``CodingEvent`` entity endpoint in shorthand as:

   ``GET /events/{codingEventId} -> CodingEvent``

If an entity with the given ``codingEventId`` is found we will get a single ``CodingEvent`` JSON object back. If it is not found we will receive a response with a ``404`` status code to indicate the failed lookup.

Create a Coding Event
^^^^^^^^^^^^^^^^^^^^^

Think about what it means to *create* an entity. You need to provide the *required data* and the *collection it belongs to*. When we want to create a ``CodingEvent`` we are asking the API to *change the state* of the collection (the list of entities) so our path must be ``/events``.

Recall that the **C** in **CRUD** stands for *create* and corresponds to the ``POST`` HTTP method in a RESTful API. Putting the resource and the action together we know we need to ``POST`` to the ``/events`` endpoint.

Finally, as part of our ``POST`` request we will need to send a request body containing the data required to create the entity.

The *shape* of the ``NewCodingEvent`` describes the JSON body that the endpoint expects:

.. sourcecode:: json

   NewCodingEvent {
      Title: string
      Description: string
      Date: string (ISO 8601 date format)
   }

When making a request you would need to send a JSON body like this to satisfy the general shape:

.. sourcecode:: json

   {
      "Title": "Consuming the Coding Events API With Postman",
      "Description": "Learn how to use Postman to interact with the Coding Events API!",
      "Date": "2020-10-31"
   }

.. admonition:: note

   We only provide the *user editable* fields, not the unique ``Id`` which the API handles internally when saving to the database.

Recall that when a ``POST`` request is successful the API should respond with the ``201``, or **Created**, status code. As part of the ``2XX`` *success status codes*, it indicates a particular type of successful response that will have an empty body and a special header.

The OpenAPI REST spec states that when an entity is created the response should include both this status and the ``Location`` header that provides the URI of the new entity:

.. sourcecode:: json

   Location=<server origin>/events/<new entity Id>

As an example:

.. sourcecode:: json

   Location=http://localhost:5000/events/1

You could then issue a ``GET`` request to the ``Location`` header value and view the new entity! In shorthand format this endpoint can be described as:

   ``POST /events (NewCodingEvent) -> 201``

If the request fails because of a *user error* then it will respond with a ``400`` status code and a message about what went wrong. In ths case of ``CodingEvent`` entities the following validation criteria must be met:

- ``Title``: 10-100 characters
- ``Description``: less than 1000 characters

Delete a Coding Event
^^^^^^^^^^^^^^^^^^^^^

Deleting a ``CodingEvent`` resource means to operate on a single entity. This should make sense as it would be too powerful to expose the ability to delete the entire collection. Just like the endpoint for getting a single entity, this endpoint requires a ``codingEventId`` path variable.

When an resource is deleted the OpenAPI spec expects the API to respond with a ``204`` status code. Similar to the ``201`` status, this code indicates a success with no response body or special headers. 

The deletion endpoint can be described in shorthand as:

   ``DELETE /events/{codingEventId} -> 204``

If you attempt to delete a resource that doesn't exist (with an incorrect ``codingEventId``) then the endpoint will respond with an expected ``404`` status and message.

Summary
^^^^^^^

Two endpoints at the entry point path, ``/events``, to interact with the collection as a whole:

- **list Coding Events**: ``GET /events -> CodingEvent[]``
- **create a Coding Event**: ``POST /events (NewCodingEvent) -> 201``

And two that require a sub-path variable, ``/events/{codingEventId}``, to interact with a single entity:

- **delete a Coding Event**: ``DELETE /events/{codingEventId} -> 201``
- **find single Coding Event**: ``GET /events/{codingEventId} -> CodingEvent``

Making Requests to the Coding Events API
========================================

Start the API Server
--------------------

In your PowerShell Terminal enter the following commands to run the API from the command-line. We will learn more about the ``dotnet`` tool in later lessons:

.. admonition:: note

   If you didn't leave your PowerShell window open make sure to navigate back to the ``coding-events-api`` repo directory before issuing the following commands.

We will need to change to the ``CodingEventsAPI`` project directory (in the repo directory) to run the project. 

If you cloned the repo into your ``HOME`` directory then the absolute path will be ``C:\Users\<username>\coding-events-api\CodingEventsAPI``.

.. sourcecode:: powershell
   :caption: Windows/PowerShell, run from coding-events-repo directory

   # change to the CodingEventsAPI project directory
   > cd CodingEventsAPI

   # run the project
   > dotnet run

   info: Microsoft.Hosting.Lifetime[0]
      Now listening on: https://localhost:5001
   info: Microsoft.Hosting.Lifetime[0]
         Now listening on: http://localhost:5000
   info: Microsoft.Hosting.Lifetime[0]
         Application started. Press Ctrl+C to shut down.
   info: Microsoft.Hosting.Lifetime[0]
         Hosting environment: Development
   info: Microsoft.Hosting.Lifetime[0]
         Content root path: C:\Users\<username>\coding-events-api\CodingEventsAPI

List the Coding Events
----------------------

Setting the URL
^^^^^^^^^^^^^^^

Setting the Method
^^^^^^^^^^^^^^^^^^

Setting the Headers
^^^^^^^^^^^^^^^^^^^

Setting the Request Body
^^^^^^^^^^^^^^^^^^^^^^^^

Viewing the Response
^^^^^^^^^^^^^^^^^^^^

Create a Coding Event
---------------------

Send a bad body
^^^^^^^^^^^^^^^

Regular create
^^^^^^^^^^^^^^

Checking the Response headers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get a Single Coding Event
-------------------------

Re-list the Coding Events
-------------------------

Delete a Coding Event
---------------------

Find a Missing Coding Event 404
-------------------------------

Bonus
=====

Continue Creating, Finding, Deleting
------------------------------------

From CLI
--------

You can do this from the command line ``Invoke-RestMethod/Invoke-WebRequest`` and ``curl``.

``Invoke-WebRequest`` similar to beautiful soup overwhelming for students

``Invoke-RestMethod`` less output easier for students