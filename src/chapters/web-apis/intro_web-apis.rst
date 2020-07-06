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
- the controller file determines if the request is valid
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

Since the presentation is handled by the client application the web-APIs responsibility is to package the representations into a format the client application is expecting. The client application team and the web-API team must agree to the underlying data format, however a best practice is to use a *universal representation* widely accepted by client applications.

.. admonition:: note

   A web client application will use AJAX as the means of making requests to a web-API.

Universal Representation
------------------------

.. Although there are many different formats of data one format has risen to prominence within the realm of web-APIs: **JSON**.

It is necessary to adopt a *universal representation* because web-APIs and client applications may be written in two different programming languages. Your web-API may be written in ASP.NET whereas the client application may be written in React. These languages are very different, however they both support JSON.

   JSON has risen to prominence within the realm of web-APIs and has become the *universal representation* for data formatting.

Adopting JSON as the *universal representation* allows us to move data between the client application and web-API easily as JSON is supported by a huge number of modern programming languages. This *universal representation* allows the web-API to be developed before the client application has been designed as both teams already know what data format will be provided by the underlying web-API.

JSON
^^^^

We have already `worked with JSON <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/data-formats-json.html#json>`_ throughout this course.

JSON is the universal representation of data accepted by client applications. This means our web-API must package the data requested by the client application as JSON and attach it to the response.

Let's examine the steps we looked at earlier:

- a request from a client application for data comes in
- a controller file catches the request
- the controller file determines if the request is valid
- the controller file transfers data from the database to an object via the ORM
- the controller transforms the object into a JSON representation
- the controller responds to the client with the JSON representation

.. admonition:: tip

   `XML <https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction>`_ is another popular data format, however it is used less commonly than JSON for web-API to client application data formatting.

In the next section we will discuss exactly how a client application makes a request and how a web-API responds.

HTTP as the language of Web-APIs
================================

   HTTP is the protocol used for communication between a web-API and a client application.

Web-APIs communicate over a network, the most common protocol of the internet is HTTP so it comes as no surprise that HTTP is the language of Web-APIs. 

Similarly our MVC applications also used HTTP as the protocol for an end-user to access the application. Web-APIs go a step further in that HTTP also facilitates the communication between client application and web-API.

.. admonition:: tip

   We will refer to web-apis as apis going forward since HTTP will facilitate the communication between client application and web-API.

Luckily we have already worked with `HTTP in this class <https://education.launchcode.org/intro-to-professional-web-dev/chapters/http/how-the-internet-works.html#http>`_ as it is a very important protocol to understand when working with web applications.

As a primer recall HTTP:

- is a stateless request/response protocol
- requests and responses **may** include HTTP bodies
- responses always contain a three digit HTTP status code
- requests and responses **always** include HTTP headers

Since HTTP is a stateless request/response protocol **every request and response must transfer the necessary state** required by the client application or API. State is transferred via HTTP in the form of HTTP bodies, HTTP Status Codes, and HTTP Headers.

Bodies
------

The HTTP body is part of how we express state through the stateless HTTP protocol. An HTTP body can contain a large number of different media types know as `MIME types <https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types>`_. 

A MIME type is associated with the HTTP header ``Content-Type`` which is what instructs the recipient of the HTTP request/response on what MIME type the HTTP body contains.

You have seen a ``Content-Type`` header that has been set to ``text/html``.

.. sourcecode:: html
   :caption: Example from `HTML chapter <https://education.launchcode.org/intro-to-professional-web-dev/chapters/html/structure.html#structure-rules>`_

   <!DOCTYPE html>
   <html>
      <head>
         <title>My Web Page</title>
         content
      </head>
      <body>
         content
      </body>
   </html>

This is the header set for HTML documents and is used throughout the web. However, we will be sending representations of data in the format of JSON requiring the header ``Content-Type`` with ``application/json``.

.. sourcecode:: json
   :caption: Example from `JSON chapter <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/data-formats-json.html#json>`_

   {
      "title": "An Astronaut's Guide to Life on Earth",
      "author": "Chris Hadfield",
      "ISBN": 9780316253017,
      "year_published": 2013,
      "subject": ["Hadfield, Chris", "Astronauts", "Biography"],
      "available": true
   }

The HTTP body **may** include JSON that represents the data being passed between API and client application. In the following article you will learn about which HTTP requests/responses will include HTTP bodies.

Status codes
------------

The next HTTP component that transfers state is the HTTP status code. The HTTP status code is included as a part of **every** HTTP response. The status code is the API's way of telling the client application how their initial request was handled. 

`HTTP response status codes <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>`_ are a part of the HTTP spec and their usage goes beyond API design, however many of their codes have been adopted as a part of API design.

.. list-table:: Common HTTP status codes in API design
   :widths: 25 20 60
   :header-rows: 1

   * - Status Code Group
     - Commonly Used
     - Description
   * - 2XX
     - 200, 201, 204
     - request was successful 
   * - 3XX
     - 301, 302
     - request was redirected
   * - 4XX
     - 400, 401, 403, 404, 405
     - client error
   * - 5XX
     - 500, 502, 504
     - server error

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
