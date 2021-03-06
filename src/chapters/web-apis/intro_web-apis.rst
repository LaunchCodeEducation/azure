========
Web APIs
========

.. index:: ! web API

Recall the high level `definition of APIs <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/introduction.html#api>`_ from an earlier unit: *An API is the interface that allows one application to communicate with another application.*

   **Web APIs** are how applications communicate with other applications **over a network**. 

.. index:: REST

Throughout the remainder of this chapter we will explore web APIs and a pattern for organizing them called REST. Although REST may sound complicated, it is just another pattern like MVC.

MVC Without the V
=================

A good start to thinking about web APIs is that they are similar to MVC web applications with one major distinction:

   Web APIs are **not concerned with the presentation** of data. 

A web API encompasses the Model and Controller aspects of MVC but is not responsible for the View layer. In a web API, the View, or presentation of data, is decoupled from the Model and Controller that manage and transfer data.

This separation leads to the development of two separate applications, a **client (front end)** and **web API (back-end)**. 

The separation between client and web API provides the following benefits:

- **Platforms**: A different client can be developed for each platform (web, mobile, CLI, GUI, etc) using the same back end.
- **Teams**: The client and web API can be developed by different specialized groups of developers.
- **Scaling**: The client and web API can be hosted on separate infrastructure.

.. admonition:: Fun Fact

   Client applications involve User Interface (UI) and User Experience (UX) development.

Client Interacts With Data
--------------------------

Despite being separated from each other, the client application still relies on *interactions with the data* through the web API.

A front-end client must ultimately *present* data to an end user. This means the client must request a *representation* of the data from the web API. After the client receives the representation it is parsed, styled and rendered to the user. 

.. admonition:: Note

   A web API and is interacted with, or **consumed**, by a client application. This process involves transferring data representations and instructions like create, read, update and delete.

Responsibilities of a Web API
=============================

The chief responsibility of a web API is to provide *interactions with* and exchange *representations of data* with its client application.

Data Delivery
-------------

.. index:: ! server-side rendering, ! client-side rendering

Think about how a View works in MVC: Data is injected into a template file that is rendered into HTML in the Controller before being sent back to the user. We call this approach **server-side rendering**.

A client application and web API work in a similar way. However, instead of injecting the data into a template on the server it is transferred over the network via requests made by the client.

When the client application receives the data it uses JavaScript to inject it into the HTML, all from within the browser. This approach is called **client-side rendering** because the web API only sends data, while the HTML is assembled on the user's end.

.. admonition:: Example

   Consider requesting the ``/events`` path of your MVC project. The response was an HTML *presentation of the data*. In other words, the data was already included in the presentation.

      **MVC**: ``GET /events`` -> HTML with data

   In a web API analog, the ``/events`` path would return just the underlying data. 

      **web API**: ``GET /events`` -> just data

   It is then the client application's responsibility to integrate the received data into its presentation.

Management of Data
------------------

.. index:: ORM

A web API manages data by using objects that represent the underlying business data. This should seem familiar, as it's the exact same process we saw in MVC. Our models are class files that drive the interactions in our codebase.

Web APIs often take advantage of object-relational mappers (ORMs) just like MVC applications do. If you have underlying classes that can be mapped to data in a database then you can easily make data available for use within the web API codebase.

Transferring Data
--------------------

In addition to managing the data, a web API is concerned with transferring data. 

A client application will make a request for some data. Our web API must contain controller classes that can handle these requests. As a part of handling the request, a controller must inspect the request, access the requested data, package the data in an acceptable format, and send the response to the client.

Here are the steps of a hypothetical web API using an ORM:

#. A request from a client application for is received by the application.
#. The appropriate controller method is called to process the request.
#. The controller determines if the request is valid.
#. The controller retrieves data using an ORM system.
#. The controller transforms the object into a format that the client application can work with.
#. The controller responds to the client with the packaged data.

Representation of Data
======================

Presentation Vs. Representation
-------------------------------

.. index:: ! presentation, ! representation

As mentioned above, the client application presents the data to the end user. However, the client must consume a representation of data from the web API. 

**Presentation** is the rendered combination of data and visual styling intended for end users. The client application needs to know what format the data is in so that it can be transformed into a human readable presentation (HTML/CSS) of the data.

Since the presentation is handled by the client application, the web API's responsibility is to package the data into a format the client application is expecting. The client application team and the web API team must agree to the underlying data format. The specific data format that is used is a **representation** of the data.

Universal Representation
------------------------

.. index::
   single: representation; universal

It is necessary to adopt a **universal representation** because web APIs and client applications may be written in two different programming languages. Your web API may be written in C#/ASP.NET while the client  may be written using JavaScript and React.

While there are many languages and frameworks available in web development they all support the creation and parsing of JSON. JSON is a standard in web development because it is simple to process in any language, compatible with HTTP, and seamlessly represents the structure of data objects.

JSON
^^^^

.. index:: ! JSON

We have already `worked with JSON <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/data-formats-json.html#json>`_ in this course.

JSON is the universal representation of data accepted by client applications. This means our web API must package the data requested by the client application as JSON and attach it to the response.

Let's examine the steps we looked at earlier, with the final two steps modified slightly:

#. A request from a client application for is received by the application.
#. The appropriate controller method is called to process the request.
#. The controller determines if the request is valid.
#. The controller retrieves data using an ORM system.
#. The controller transforms the object into a JSON representation.
#. The controller responds to the client with the JSON representation.

.. admonition:: Tip

   `XML <https://developer.mozilla.org/en-US/docs/Web/XML/XML_introduction>`_ is another popular data format, however it is used less commonly than JSON by web APIs.

In the next section, we will discuss exactly how a client application makes a request and how a web API responds.

HTTP As the Language of Web APIs
================================

.. index:: ! HTTP

**Hypertext Transfer Protocol (HTTP)** is the protocol used for communication between a web API and a client application.

Web APIs communicate over a network. The most common protocol of the internet is HTTP, so it comes as no surprise that HTTP is the language of web APIs. 

Similarly, our MVC applications used HTTP as the protocol for an end user to access the application. Web APIs go a step further in that HTTP also facilitates the communication between client application and web API.

.. admonition:: Tip

   We will refer to web APIs as APIs going forward since the web prefix is implied.

Luckily we have already worked with `HTTP in this class <https://education.launchcode.org/intro-to-professional-web-dev/chapters/http/how-the-internet-works.html#http>`_ as it is a very important protocol to understand when working with web applications.

As a primer, recall that HTTP:

- Is a stateless request/response protocol.
- Requests and responses *may* include HTTP bodies but are not required to.
- Responses always contain a three-digit HTTP status code.
- Requests and responses *always* include HTTP headers.

Since HTTP is a stateless request/response protocol *every request and response must transfer the necessary state* required by the client application or API. State is transferred via HTTP in the form of HTTP bodies, HTTP status codes, and HTTP headers.

HTTP Body
---------

.. index:: 
   single: HTTP; body

The HTTP body is part of how we express state through the stateless HTTP protocol. An HTTP body can contain a varity of different media types, known as `MIME types <https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types>`_. 

.. index:: ! MIME type

A **MIME type** is associated with the HTTP header ``Content-Type``, which is what specifies which content type the HTTP body contains.

In this class, you have seen a ``Content-Type`` HTTP header that has been set to ``text/html``.

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

This is the header for HTML documents and is used throughout the web.
 
APIs sending representations of data in JSON format require the header ``Content-Type`` to be ``application/json``.

.. sourcecode:: javascript
   :caption: Example from `JSON chapter <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/data-formats-json.html#json>`_

   {
      "title": "An Astronaut's Guide to Life on Earth",
      "author": "Chris Hadfield",
      "ISBN": 9780316253017,
      "year_published": 2013,
      "subject": ["Hadfield, Chris", "Astronauts", "Biography"],
      "available": true
   }

The HTTP body *may* include JSON that represents the data being passed between API and client application. In the following article you will learn about which HTTP requests/responses will include HTTP bodies.

HTTP Status Codes
-----------------

.. index::
   single: HTTP; status codes

The next HTTP component that transfers state is the **HTTP status code**. The HTTP status code is included as a part of *every* HTTP response. The status code is the API's way of telling the client application how their request was handled. 

`HTTP response status codes <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>`_ are a part of the HTTP spec and their usage goes beyond API design. However, many of these codes have been adopted as a standard within API design.

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

HTTP Headers
------------

.. index::
   single: HTTP; headers

The final HTTP component that transfers state is the **HTTP header**. Any `number of headers <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers>`_ can be included in a request or response.

Above we saw the ``Content-Type`` header. This is the header that allows us to inform the API (request header) or client application (response header) of the format of the data included in the body. There are many additional headers, but this is the most important one to us currently.

.. admonition:: Tip

   A client can specify which ``Content-Type`` they want to receive in the API response using the ``Accept`` request header.

API Design
==========

The design of an API is a contract that defines how the client and API interact with data. 

The API is responsible for *upholding* the data management and transfer *behaviors* of the *contract*.

The client application is responsible for *consuming* (AJAX requests) an API according to the *contract*.

As long as both sides of the *interface* (the client and API logic) uphold the contract, then front and back-end teams can operate independently. This provides the following freedoms:

- Front-end developers can choose or change the internal styling, libraries, frameworks and design patterns.
- Back-end developers can choose or change the internal server language, libraries, frameworks and design patterns.
- Both sides can choose or change their external hosting infrastructure at any time without affecting the other.
- Both sides can make and deploy changes to their code bases at any time without needing to coordinate with or wait for the other.

Only when a change must be made to either the client requests or API behavior do the two teams need to communicate and agree upon a new contract.

REST
----

.. index:: REST

Adopting the REST specification into the design of an API provides consistency during development and consumption. The two sections explore REST in detail.

Much like following the patterns of MVC allows other developers to easily understand your code, following REST gives other developers the benefit of understanding how your API is structured and behaves.

As an added bonus, a REST API also gives the client application a base-line understanding on how to interact with your API.