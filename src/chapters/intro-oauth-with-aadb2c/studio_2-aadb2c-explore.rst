==========================================================
Studio Part 2: Explore Authorization With the Deployed API
==========================================================

.. studio lead in

These tasks will require you and a partner to interact using two different user accounts **that are both registered** within a single AADB2C tenant. One of these accounts will be used as the **Owner** of a coding event, and the other will be a **Member** of that coding event. Using the two accounts together you can reflect on the authorization process by comparing the similarities and differences between the API responses.

Task Roles
==========

The **Owner** will be responsible for providing the **Member** with:

- the public IP of the **Owner's** hosted API
- the **Owner's** Postman client ID

.. admonition:: Note
   
   If you would like to complete this studio on your own you can use two of your email addresses to create the AADB2C user accounts.

In each task the **Owner** and the **Member** will work together to set up an **initial state** with the API. Then both of you will make requests to complete the task and reflect on the responses and state transitions encountered along the way.

Each task will require you and your partner to:

#. plan the requests that will be needed to complete the task
#. make requests to set up the initial state
#. make task requests and compare the response status code, headers and bodies
#. reflect on how the state transitioned from the requests

Planning
========

While planning out how you and your partner will complete each task consider the following:

- which endpoints will be used
- what order the requests need to be made in
- which of you (**Owner** or **Member**) will need to make each request

.. turn into checkbox form for submission

.. - ``POST /api/events``
.. - ``GET /api/events/{codingEventId}``
.. - ``GET /api/events/{codingEventId}/members
.. - ``POST /api/tags``
.. - ``PUT /api/events/{codingEventId}/tags/{tagId}``
.. - ``DELETE /api/events/tags/{tagId}``
.. - ``DELETE /api/events/{codingEventId}/members/{memberId}``
.. - ``GET /api/events``
.. - ``GET /api/events/{codingEventsId}``
.. - ``GET /api/events/{codingEventsId}/members``
.. - ``POST /api/events/{codingEventsId}/members``
.. - ``POST /api/tags``
.. - ``PUT /api/events/{codingEventId}/tags/{tagId}``
.. - ``DELETE /api/events/tags/{tagId}``
.. - ``DELETE /api/events/{codingEventId}``
.. - ``DELETE /api/events/{codingEventId}/members/{memberId}``

Setup
=====

Their are multiple ways to set up Postman. The simpler mechanism is to share the client ID of the **Owner's** Postman application with the **Member**. However, if you are looking for a challenge the Bonus below will have the **Owner** register an independent client application for the **Member** to use.

Both of these approaches will require you to update the Coding Events API collection in Postman.

Update Postman
--------------

Before you can make requests to the deployed Coding Events API you will both need to change the ``baseUrl`` environment variable to point to the public IP address of the **Owner's** deployed API. Whoever is the **Owner** should send the public IP of the API to the **Member**.

In Postman, edit the collection (using the three dots to the right of its name) and select the **Variables** tab. In the **Current Value** entry on the right side replace ``https://localhost:5001`` with the public IP address:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_2-aadb2c-explore/postman-update-baseurl.png
   :alt: Postman update the baseUrl variable with the public IP address of the API

In addition to sharing the public IP, the **Owner** will need to provide the client ID of their Postman application with the **Member**. The **Member** will then need to select the **Authorization** tab and update their access token form to use the **Owner's** Postman client ID. 

.. admonition:: Warning

   Before continuing with the studio make sure that both you and your partner are able to successfully request an access token.
   
   If either of you receive the following message when requesting an access token it indicates that the client ID was not updated correctly:

   .. image:: /_static/images/intro-oauth-with-aadb2c/studio_2-aadb2c-explore/postman-invalid-client-id.png
      :alt: Postman failed access token request due to invalid client ID

Bonus: Multiple Front-end Client Applications
---------------------------------------------

You can simulate a system that has several different client applications that interact with a single API. In this system each client application must register with the AADB2C tenant and identify themselves with their client ID in each request to the protected API. 

For this bonus mission, instead of the **Owner** sharing the client ID of *their* Postman application, they will register a new one. This will simulate a multi-client system using AADB2C.

The **Owner** will register another application in their AADB2C tenant that corresponds to the **Member's** Postman application. The ``Member Client`` application will need to be registered and granted access to use the ``user_impersonation`` scope of the API.

After completing the registration and configuration the **Owner** will share the ``Member Client`` client ID with the **Member** so they can update their access token form in Postman. You can refer to the access token walkthrough as a refresher of this process.

Tasks
-----

Compare the headers, status codes, and bodies you get in the responses between the Coding Event Owner, Coding Event Member, and Coding Event non member.

View Member
^^^^^^^^^^^

Add Tags
^^^^^^^^

Remove Tags
^^^^^^^^^^^

Remove Members
^^^^^^^^^^^^^^

Leave Event
^^^^^^^^^^^


Member Steps
^^^^^^^^^^^^

.. get a partner (one of you is owner, and one of you is the member and then swap positions)

.. will need public IP and update the base_url in postman to reflect that new IP address

- two email addresses
- partner with other student
- show how to update the public IP for ``baseUrl``

Make Requests to Protected Endpoints
------------------------------------

- show how to update the baseUrl 