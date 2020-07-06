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

The chief responsibility of a web-API is to provide representations of data, it builds to the representation by first managing and transferring data.

Management of Data
------------------

A web-API manages data by modeling objects that line up with the underlying business data. This should seem familiar as it's the exact same process we saw in MVC. Our *Models* are class files that drive the interactions in our codebase.

Web-APIs often take advantage of ORMs just like MVC applications do. If you have underlying classes that can be mapped to data in a database you can easily make data available for use within the web-API codebase.

Transference of Data
--------------------

Outside of managing the data a web-API is concerned with transferring data. 

A client application will make a request for some data. Our web-API must contain *Controller* files that can handle the requests. As a part of handling the request the *Controller* file must understand the request, access the requested data, package the data in an accepted format and send the package as a response to the client application.

Consider the steps of a hypothetical web-API using an ORM:

- a request from a client application for data comes in
- a controller file catches the request
- the controller file determines the request is valid
- the controller file transfers data from the database to an object via the ORM
- the controller transforms the object into a package the client application can work with
- the controller responds to the client with the packaged data

Representation of Data
======================

Presentation vs Representation
------------------------------

As mentioned above the client application presents the data to the end-user. However, the client relies on consuming a representation of data from the web-API.

   Presentation is a representation of data intended for end-users.

The client application needs to know what format the representation is in so that it can be transformed into a human readable presentation (HTML/CSS) of the data.

Since the presentation is handled by the client application the web-APIs responsibility is to package the representations in a format the client application is expecting. You can discuss with the client application team to determine data format expectations, however a best practice is to use a *universal representation* widely accepted by client applications.

.. admonition:: note

   A web client application will use AJAX as the means of making requests to a web-API.

Universal Representation
------------------------

Although there are many different formats of data one format has risen to prominence within the realm of web-APIs: **JSON**.

It is necessary to adopt a *universal representation* (JSON) data format because web-APIs and client applications may be written in two completely tech stacks. Your web-API may be written in ASP.NET whereas the client application may be written in React. These technologies are very different, however they both support JSON. So adopting JSON as the universal representation allows us to move data between the client application and web-API easily.

Having a universal representation ensures the freedoms of separating client from web-APIs listed earlier in this article.

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
