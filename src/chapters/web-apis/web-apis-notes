========
Web APIs
========

We have learned about Application Programming Interfaces in previous sections of this book, but since we will be deploying an API we want to review the major concepts.

API Review
==========

An Application Programming Interface is an interface that can be used by other applications, or services.

Throughout this course we have predominately built web applications, so we will mainly talk about APIs as web APIs.

A resource is a piece of business data that is necessary for a user to utilize our API. A bank account could be an example of a resource. A user wants to access their bank account to view their current funds.

An endpoint is a URI that represents the location of a given resource. With a web API our URI becomes a URL so a user can find their bank account by making a request to ``/user/{user_id}/account``. This URL would refer to one user's bank account as referenced by the user's id.

JSON stands for JavaScript Object Notation which is one of the popular data formats of the web. When a user requests their bank account we may use JSON as the data transfer format.

.. sourcecode:: js

   {
       "id": 123456789,
       "account": {
           "type": "checking":,
           "amount": 250.00
       }
   }

JSON is a representation of the user's data that can be understood by any programming language.

HyperText Transfer Protocol is the medium we use to transfer our data. HTTP uses port 80, and can be consumed by web browsers, and various web frameworks.

HTTP request Methods include ``GET``, ``POST``, ``HEAD``, etc. They simply define the behavior of the requested resource.