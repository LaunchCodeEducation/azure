==========================================================
Studio Part 2: Explore Authorization With the Deployed API
==========================================================

In this studio you will work with a partner to explore the effect of authorization in requests sent to the API. After an initial setup you will explore tasks that will require you both to plan, execute and reflect on the results.

These tasks will require you and a partner to interact using two different user accounts **that are both registered** within a single AADB2C tenant. One of these accounts will be used as the **Owner** of a coding event, and the other will be a **Member** of that coding event. 

Using the two accounts together you can reflect on the authorization process by comparing the similarities and differences between the API responses.

Your learning goals for this studio are:

#. Explore the effect of external (AADB2C) and internal (ABAC) authorization when making requests to the API
#. Apply your knowledge of RESTful interactions to transition and reflect on the state of API resources

Task Roles
==========

The **Owner** will be responsible for providing the **Member** with:

- the public IP of the **Owner's** hosted API
- the **Owner's** Postman client ID

.. admonition:: Note
   
   If you would like to complete this studio on your own you can use two of your email addresses to create the AADB2C user accounts.

In each task the **Owner** and the **Member** will work together to set up an initial state with the API. Then both of you will make requests to complete the task and reflect on the responses and resource state transitions encountered along the way.


Limited Guidance: Completing a Task
===================================

General Steps
-------------

In general, each task will require you and your partner to:

#. plan the requests that will be needed to set up and complete the task
#. make setup requests to establish the initial state of API resources needed to complete the task
#. make the request needed to complete the task
#. reflect on differences in the response status codes and bodies
#. reflect on how the state of the API resources transitioned after the requests

Planning Tips
-------------

In order to coordinate and plan these steps you and your partner will need to consider:

- what is the *current state* of the resources in the API (from previous requests)?
- what *initial state* is needed to accomplish the task?
- what setup requests will be needed to set up the *initial state*?
- what task requests are needed to accomplish the task
- who (**Owner** or **Member**) will need to issue each request?
- what order do the requests need to be issued in?

Setup
=====

There are multiple ways to set up Postman so both you and your partner can request access tokens from the **Owner's** AADB2C service. The simpler mechanism is to share the client ID of the **Owner's** Postman application with the **Member**. 

However, if you are looking for a challenge the bonus section below will have the **Owner** register a new client application with its own client ID for the **Member** to use. Either of these approaches **will require you to update** the ``CodingEventsAPI`` collection in Postman.

Update Postman
--------------

Before you can make requests to the ``CodingEventsAPI`` both you and your partner will need to change the ``baseUrl`` environment variable in the Postman collection. The ``baseUrl`` will need its value updated to point at the public IP address of the **Owner's** deployed API.

.. admonition:: Note

   The **Owner** must send the public IP of their hosted API to the **Member**.

In Postman, edit the collection (using the three dots to the right of its name) and select the **Variables** tab. In the **Current Value** entry on the right side replace the current value, ``https://localhost:5001``, with the public IP address:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_2-aadb2c-explore/postman-update-baseurl.png
   :alt: Postman update the baseUrl variable with the public IP address of the API

In addition to sharing the public IP, the **Owner** will need to provide the client ID of *their Postman application* with the **Member**. The **Member** will then need to select the **Authorization** tab and update their access token form to use the **Owner's** Postman client ID. 

Get Access Tokens
-----------------

The **Owner** should already have an account registered in *their* AADB2C tenant. However, the **Member** will need to register *their own* account in the **Owner's** tenant. As a reminder, the **Member** can use the **sign up now** link at the bottom of the login form. 

.. admonition:: Warning

   Before continuing with the studio make sure that both you and your partner are able to successfully request an access token.
   
   If either of you receive the following message when requesting an access token it indicates that the client ID was not updated correctly:

   .. image:: /_static/images/intro-oauth-with-aadb2c/studio_2-aadb2c-explore/postman-invalid-client-id.png
      :alt: Postman failed access token request due to invalid client ID

Bonus: Multiple Front-end Client Applications
---------------------------------------------

You can simulate a system that has several different client applications that interact with a single API. In this system each client application must register with the AADB2C tenant and identify themselves with their client ID in each request to the protected API. 

For this bonus mission, instead of the **Owner** sharing the client ID of *their* Postman application, they will register a new one in their AADB2C tenant. This will allow you and your partner to simulate a multi-client system using AADB2C.

The **Owner** will register another application in their AADB2C tenant that corresponds to the **Member's** Postman application. The ``<Member Name> Postman`` application will need to be registered and granted access to use the ``user_impersonation`` scope of the API.

After completing the registration and configuration the **Owner** will share the new ``<Member Name> Postman`` client ID with the **Member** so they can update their access token form in Postman. 

.. admonition:: Note

   You can refer to the access token walkthrough as a refresher of this process.

   After completing this bonus mission the **Owner's** AADB2C tenant should have 2 registered front-end client applications (**Owner's** Postman and the new ``<Member Name> Postman``). Each of these should have admin consent for using the ``user_impersonation`` scope to access the protected API.

Completing a Task
=================

Each task will begin with a plain-English action to be performed on the state of one or more resources. Following this prompt will be a series of questions related to the actions and results:

- **Action**: analyzing current state, setting up initial state and required task requests
- **Reflection**: reflect on the differences in responses between the **Owner** and the **Member** along with the final state of the resources

Both the **Owner** and **Member** will attempt to complete each task. However, due to the different authorization attributes (ABAC) that each of you have, not all requests will be successful. It is equally important to consider the response behavior for both successful and unsuccessful requests.

Before you begin working on these tasks let's explore a solution to the first one -- Joining a Coding Event.

Example Solution: Join a Coding Event
-------------------------------------

   Try to join an existing coding event

Action
^^^^^^

**What is the current state of the resources?**

- no coding events
- no members (only 2 authenticated users, the Owner and Member)

**What should be the initial state of the resources to complete this task?**

- 1 coding event
- 1 member of the coding event (Owner)
- 1 authenticated user (Member) that is not *currently* a member of the coding event

**What requests will need to be made, in what order, and who must issue them to achieve this initial state?**

#. Owner: ``POST /api/events/``

**What endpoint will you need to use to complete this task?**

- ``POST /api/events/{CodingEventsId}/members``

Reflection
^^^^^^^^^^

**What was the response when the authenticated user (Member) tried to join the Owner's coding event?**

- status code: 204 No Content
- body: empty

**What was the response when the Owner tried to join their own coding event?**

- status code: 400
- body: Bad Request

.. admonition:: Note

   The actual response body is formatted in a JSON object:

   .. sourcecode:: json
      :caption: response body of failed Owner request

      {
         "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
         "title": "Bad Request",
         "status": 400,
         "traceId": "|239addd7-409244e32d9104cb."
      }

**What is the final state of the API resources after completing the task?**

- 1 coding event
- 2 members (Owner and Member) 

Tasks
=====

Use the example above as a solution template as you work with your partner to complete each task. Before making each request discuss what you expect to happen with your partner based on your respective authorizations.

If the results do not align with your expectations consider:

- was your initial state correct?
- did the order of the requests have an effect?

Join a Coding Event
-------------------

   Try to join an existing coding event

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. What was the response when the authenticated user (Member) tried to join the Owner's coding event?

#. What was the response when the Owner tried to join their own coding event?

#. What is the final state of the API resources after completing the task?

View Coding Event Members
-------------------------

   Try to access the email addresses of coding event members

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. Was the ``email`` field available in the response to the Member?

#. Was the ``email`` field available in the response to the Owner?

#. What other differences were present in the *shape* of the responses?

#. Was there a transition of state for any resources while completing this task?

Add a Tag to a Coding Event
---------------------------

   Try to add a new tag to the coding event

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. What was the response when the Member tried to add the tag to the coding event?

#. What was the response when the Owner tried to add the tag to the coding event?

#. What is the final state of the API resources after completing the task?

Remove a Tag From a Coding Event
--------------------------------

   Try to remove the tag from the coding event

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. What was the response when the Member tried to remove the tag from the coding event?

#. What was the response when the Owner tried to remove the tag from the coding event?

#. What is the final state of the API resources after completing the task?

Remove a Member From a Coding Event
-----------------------------------

   Try to remove a Member from the coding event

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. What was the response when the Member tried to remove thine self from the coding event?

#. What was the response when the Owner tried to remove the Member from the coding event?

#. What is the final state of the API resources after completing the task?

Leave a Coding Event
--------------------

   Try to leave the coding event

.. admonition:: Note

   In the previous task the Member was removed from the coding event. In order for both you and your partner to complete this task the Member will need to re-join the coding event.

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. What was the response when the Member tried to leave the coding event?

#. What was the response when the Owner tried to leave their own coding event?

#. What is the final state of the API resources after completing the task?

Cancel a Coding Event
---------------------

   Try to cancel the coding event

Action
^^^^^^

#. What is the current state of the resources?

#. What should be the initial state of the resources to complete this task?

#. What requests will need to be made, in what order, and who must issue them to achieve this initial state?

#. What endpoint will you need to use to complete this task?

Reflection
^^^^^^^^^^

#. What was the response when the Member tried to cancel the coding event?

#. What was the response when the Owner tried to cancel their coding event?

#. What is the final state of the API resources after completing the task?
