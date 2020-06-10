====
REST
====

We learned about REST in an earlier lesson, so this is just a short review, since we will be deploying a RESTful API.

Review
======

A Resource is a piece of business data, it may be represented as a Model in your application. A Resource could be a user, or a paystub, or a car, or a transaction, etc. In REST a resource is a noun. It's some tangible piece of business data your application needs to function.

Resources are identified by a unique URL in REST. ``/api/dog/{dog_id}`` would reference one single dog as identified by the dog_id. A collection of resource can be requested as well ``/api/dog`` would be requesting a collection of all the dog resources that exist in our backing service.

In REST HTTP Request Methods determine the behavior that should be acted upon a resource.

- GET -> a request for a copy of the resource
- POST -> create a new resource of this type
- PUT -> update an existing resource of this type with this id
- DELETE -> remove an existing resource of this type with this id

A RESTful HTTP Response will always contain an HTTP status code. The HTTP status code let's the user know the result of their request and follow a certain pattern:
    - 100 level responses indicates a request was received, but is still being processed
    - 200 level responses indicate a successful request (200 for success, 201 for successfully created or updated, etc)
    - 300 level responses indicates a response had to be redirected 
    - 400 level responses indicate a request that couldn't be handled because of user error (404 for resource doesn't exist, 403 for user unauthorized)
    - 500 level responses indicate a request that couldn't be handled because of a server error


Examples
--------

A RESTful API for a veterinary hospital that tracks the records of pets may behave in the following ways.

A new patient brings their dog in for their first round of vaccinations. A new dog needs to be added to the API, so an HTTP POST request is sent to ``/api/dog`` with the following JSON body:

.. sourcecode:: js

   {
        "name": "Roy",
        "age": "4 months",
        "breed": "Labrador Retriever",
        "microchipped": false,
        "weight": "33.2",
        "owner": "Fred Smith"
   }

A new Dog will be created with the information included in the JSON.

When the customer returns and they are checking in for the next round of shots the person accessing the RESTful API makes the following HTTP GET request: ``/api/dog?name=Roy``.

This request uses a query parameter to filter down the results of all the dogs that match the name "Roy". This may return more than one resource, but the user should be able to look through them to match the owner.

After they know which dog they are looking for they can find the exact resource by sending an HTTP GET request with the id of the dog: ``/api/dog/{roy_id}``.

When Roy comes in for his next round of shots in 2 months his age will have changed so the person interfacing with the RESTful API will send an HTTP PUT request to ``/api/dog/{roy_id}`` with the following JSON:

.. sourcecode:: js

   {
       "age": "6 months"
   }

This simple PUT request informs the RESTful API that the underlying resource has changed and anything included in the JSON should be reflected by the resource.

As a final example let's say Fred Smith, and Roy move to another state and start seeing another vet. They inform their old vet that they have moved, and the user of the API can send an HTTP DELETE request to ``/api/dog/{roy_id}`` which tells the RESTful API to delete the resource from the underlying backing service.

Swagger
=======

We will be using Swagger as the front end to our RESTful API to illustrate what our API does. You will not be responsible for knowing Swagger at the end of this class, but it is a very useful tool.

Swagger is a tool to assist in the documentation and creation of RESTful APIs across various tech stacks.

After adding Swagger, and configuring it in a project it will generate HTML/CSS that will explain your RESTful API. It will show which resources exist, and the URLs, and HTTP Methods that can be used to interface with the RESTful API.

.. TODO: Add a couple of images of what Swagger looks like