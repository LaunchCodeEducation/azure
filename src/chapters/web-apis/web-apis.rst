Web-APIs
========

   - API definition (intro)
   
Interfaces
----------

User
^^^^
      - UI (user interaction)

Application Programming
^^^^^^^^^^^^^^^^^^^^^^^
      - application programming interfaces (programmatic interaction)
         - break down API
            - different types of APIs libraries are all APIs
            - when you have an API that crosses over a network is a web API

Web-application Programming
^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - Web-APIs
      - programmatic interaction over a network

The back-end component of multi-host
====================================

Management of Data
------------------

Model

Transference of Data
--------------------

Controller

Representation of Data
----------------------

- one component of a multi-host (back-end)
   - Model & Controller from MVC
   - concerned with management and transfer of data
   - web-api is not
      - View = data + styling (presentation)
         - View is decoupled
         - View is reliant on data -- it's styling (presentation) and data
            - injecting data into templates
            - injected client-side from a Web-API

Representation of data
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
