

- API definition (intro)
   - interface (what do we mean by interface)
      - break down API
         - different types of APIs libraries are all APIs
         - when you have an API that crosses over a network is a web API
   - Web-APIs

- one component of a multi-host (back-end)
   - Model & Controller from MVC
   - concerned with management and transfer of business data
- View = data + styling (presentation)
   - View is decoupled
   - View is reliant on data -- it's styling (presentation) and data
      - injecting data into templates
      - injected client-side from a Web-API
         - AJAX (this is how you consume an API from client)
- Representations of data
   - API is about the data so it MUST represent data, but the View dictates the presentation of the represented data
   - JSON
      - tip about XML
- HTTP (language the Web-API understands) it has components (status codes, headers, bodies)
   - introduce status codes, headers, and bodies (VERY LIGHT)
   - note Web APIs can use other protocols (outside scope)
- Design
   - any way you want as long as it conforms to HTTP, however that isn't following a pattern and will be very difficult to maintain, impossible for people to consume, impossible bring other devs
   - RESTfulish
   - We need a pattern segue to REST
      - necessary for consumers (they get X) and developers (they get Y)


HTTP
====

Status Codes
------------

Headers
-------

Bodies
------

JSON
====

Design
======
