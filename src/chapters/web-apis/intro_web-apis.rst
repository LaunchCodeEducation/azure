========
Web-APIs
========

Recall the high level `definition of APIs <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/introduction.html#api>`_ from an earlier unit: *An API is the interface that allows one application to communicate with another application.*

   **Web-APIs** are how applications communicate with other applications **over a network**. 

Throughout the remainder of this chapter we will explore web-apis and a pattern for organizing them called REST. Although REST may sound complicated, it's very closely related to something you have learned: *MVC*.

MVC Without the V
=================

A good start to thinking about web-apis is that they are similar to MVC web applications with one major distinction:

   Web-apis are not concerned with the presentation of data. 

A web-api is responsible for the Model and Controller, but not responsible for the View. The View is decoupled from the Model and Controller to be developed separately. This separation leads to two different projects a client (front end) and web-api (back-end). 

This separation gives us freedom in the form of:

- platforms (client can be developed for web, mobile, CLI, GUI, etc)
- teams (client and web-api can be developed by different specialized groups)
- scaling (client and web-api can be hosted on separate infrastructure)

Our client application's objective is to present data that meet our end-user needs. 

.. admonition:: note
   
   Presenting data to end-users falls into the category of User Experience (UX) which falls outside the scope of this class.

Client relies on data
---------------------

Even though the client has been separated from the web-API the client still relies on data from the web-API. What good is the styling and user-experience (UX) of a client application if it doesn't contain any data the user needs?

A client must ultimately *present* data to an end-user. This means the client must request a *representation* of the data from the web-API. After the request has been made to the web-API the client can parse the represented data into the presentation for the end-user.

.. admonition:: note

   This client to web-API relationship is crucial to the operation of the client application. A web-API provides representations of data that are *consumed* by the client which presents the data to the end-user.

Responsibilities of a Web API
=============================

Management of Data
------------------

Model

Transference of Data
--------------------

Controller

Representation of Data
======================

Presentation vs Representation
------------------------------

View -- the web-api is not concerned with the presentation of the data, however the view requires a representation of the data for the presentation layer
- AJAX (this is how you consume an API from client)

Universal Representation
------------------------

- apis can be written in any language and framework
- balance between language agnostic & structure

JSON
^^^^

- Representations of data
   - API is about the data so it MUST represent data, but the View dictates the presentation of the represented data
   - JSON
      - tip about XML
   - transference of data segue to HTTP

HTTP as the language of Web-APIs
================================

   - tip:: we refer to web-apis as apis going forward

Bodies
------

Status codes
------------

Headers
-------

- note:: Web APIs can use other protocols (outside scope)
   - XML fits in this note

API Design
==========

Standard-less
-------------

- any way you want as long as it conforms to HTTP, however that isn't following a pattern and will be very difficult to maintain, impossible for people to consume, impossible bring other devs

RESTfulish
----------

- RESTfulish

REST
----

- We need a pattern segue to REST
- necessary for consumers (they get X) and developers (they get Y)
