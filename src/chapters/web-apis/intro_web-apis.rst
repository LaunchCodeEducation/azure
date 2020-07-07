========
Web-APIs
========

Recall the high level `definition of APIs <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/introduction.html#api>`_ from an earlier unit: *An API is the interface that allows one application to communicate with another application.*

   **Web-APIs** are how applications communicate with other applications **over a network**. 

Throughout the remainder of this chapter we will explore Web-APIs and a pattern for organizing them called REST. Although REST may sound complicated, it is just another pattern like MVC.

MVC Without the V
=================

A good start to thinking about Web-APIs is that they are similar to MVC web applications with one major distinction:

   Web-apis are **not concerned with the presentation** of data. 

A web-api encompasses the Model and Controller aspects of MVC but is not responsible for the View layer. In a web-api the View, or presentation of data, is decoupled from the Model and Controller that manage and transfer data. This separation leads to the development of two different applications, a **client (front end)** and **web-api (back-end)**. 

The separation between client and web-api gives us freedom in the form of:

- **platforms**: client can be developed for web, mobile, CLI, GUI, etc
- **teams**: client and web-api can be developed by different specialized groups
- **scaling**: client and web-api can be hosted on separate infrastructure

.. admonition:: fun fact

   Client applications involves User Interface (UI) and User Experience (UX) development.

Client interacts with data
--------------------------

Even though the front-end has been separated from the back-end it still interacts with data from the web-API.

A client must ultimately *present* data to an end-user. This means the client must request a *representation* of the data from the web-API. After the client receives the representation it is styled and displayed to the user. 

In addition a user may create, update, or delete their data leading the client application to send a representation back to the web-API dictating the changes that need to be made to the underlying data.

.. admonition:: note

   A web-API provides representations of data that are *consumed* by the client which then decides how that data should be presented.

Responsibilities of a Web API
=============================

   The chief responsibility of a web-API is to provide **representations of data** that are usable to the client. 

Data Delivery
-------------

Think about how a View works in MVC. Data is *injected* into a *template* file that is **rendered into HTML** in the Controller before being sent back to the user. We call this approach **server-side rendering**.

A client and web-API work in a similar way. However, instead of injecting the data into a template it is transferred over the network through AJAX requests. When the client application receives the **data** it uses JavaScript to inject it into the HTML. This approach is called **client-side rendering** because the web-API only sends data, not HTML.

.. admonition:: example

   For example, consider requesting the ``/events`` path of your MVC project. The response was an HTML *presentation of the data*. In other words, the **data was already included** in the presentation.

      **MVC**: ``GET /events -> HTML with data``

   In a web-API analog the ``/events`` path would return **just the underlying data**. It is then the client application's responsibility to inject the received data into its presentation.

      **web-API**: ``GET /events -> just data``

Management of Data
------------------

A web-API manages data by modeling objects that line up with the underlying business data. This should seem familiar as it's the exact same process we saw in MVC. Our *Models* are class files that drive the interactions in our codebase.

Web-APIs often take advantage of ORMs just like MVC applications do. If you have underlying classes that can be mapped to data in a database you can easily make data available for use within the web-API codebase.

Transference of Data
--------------------

Outside of managing the data a web-API is concerned with transferring data. 

A client application will make a request for some data. Our web-API must contain *Controller* files that can handle the requests. As a part of handling the request the *Controller* file must understand the request, access the requested data, package the data in an accepted format and send the package as a response to the client application.

Consider the steps of a hypothetical web-API using an ORM:

#. a request from a client application for data comes in
#. a controller file catches the request
#. the controller file determines if the request is valid
#. the controller file transfers data from the database to an object via the ORM
#. the controller transforms the object into a package the client application can work with
#. the controller responds to the client with the packaged data

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

It is necessary to adopt a *universal representation* because web-APIs and client applications may be written in two different programming languages. Your web-API may be written in ASP.NET whereas the client application may be written in React. These languages are different, however they both support JSON.

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

HTTP As the Language of Web-APIs
================================

   HTTP is the protocol used for communication between a web-API and a client application.

Web-APIs communicate over a network, the most common protocol of the internet is HTTP so it comes as no surprise that HTTP is the language of web-APIs. 

Similarly our MVC applications used HTTP as the protocol for an end-user to access the application. Web-APIs go a step further in that HTTP also facilitates the communication between client application and web-API.

.. admonition:: tip

   We will refer to Web-APIs as apis going forward since HTTP will facilitate the communication between client application and web-API.

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

In this class you have seen a ``Content-Type`` HTTP header that has been set to ``text/html``.

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
 
APIs send representations of data in the format of JSON requiring the header ``Content-Type`` to be ``application/json`` which allows us to pass the state of the data as the HTTP body.

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

`HTTP response status codes <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>`_ are a part of the HTTP spec and their usage goes beyond API design, however many of their codes have been adopted as a standard within API design.

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

The final HTTP component that transfers state are the HTTP headers. Every HTTP request and response contain at least one header. However, as many headers as necessary can be added to a given request or response.

Above we saw the ``Content-Type`` header. This is the header that allows us to inform the API or client application of the format of the data included in the body. Throughout our API design we will typically be setting this header to ``application/json`` to pass JSON representations of data.

.. admonition:: note

   As mentioned earlier there are multiple MIME types and other options for data formats besides JSON. The ``Content-Type`` header must match the data format of attached HTTP bodies or the recipient of the request/response will be unusable.

API Design
==========

   The design of an API is **a contract that defines how the client and API interact with data**. 

The API is responsible for **upholding** the data management and transfer **behaviors** of the **contract**.

The client application is responsible for **consuming** (AJAX requests) an API according to the **contract**.

As long as both sides of the *interface* (client and API logic) uphold the contract then front and back-end teams experience the following freedoms:

- Front-end developers can choose or change the internal styling, libraries, frameworks and design patterns
- Back-end developers can choose or change the internal server language, libraries, frameworks and design patterns
- Both sides can choose or change their external hosting infrastructure at any time without affecting the other
- Both sides can make and deploy changes to their code bases at any time without needing to coordinate with or wait for the other

Only when a change must be made to either the client AJAX requests or API behavior do the two teams need to communicate and agree upon a new contract.

REST
----

Fully adopting the `OpenAPI REST spec <https://swagger.io/specification/>`_ into an API would allow you to classify your API as a REST API.

Much like following the patterns of MVC allows other developers to easily understand your code, following REST gives other developers the benefit of understanding how your REST API is structured and behaves.

As an added bonus a REST API also gives the client application a base-line understanding on how to interact with your API. REST has benefits for both API developers (providers), and client developers (consumers)!

The next article will dive much deeper into the concept of REST.