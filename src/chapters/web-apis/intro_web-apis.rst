========
Web-APIs
========

Recall the high level `definition of APIs <https://education.launchcode.org/intro-to-professional-web-dev/chapters/fetch-json/introduction.html#api>`_ from an earlier unit. Web-APIs are how programs to other programs over a network. Throughout the remainder of this chapter we will explore web-apis and a pattern for organizing them called REST.

Although REST may look complicated, it's very closely related to something you have learned.

MVC Without the V
=================

- View = data + styling (presentation)
   - View is reliant on data -- it's styling (presentation) and data
      - injecting data into templates
      - injected client-side from a Web-API
   - made with JS (vanilla or FEF [links to React, Vue]
- View is decoupled
   - benefits of doing so
- only Model & Controller from MVC
- segue: only concerned with management and transfer of data

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
