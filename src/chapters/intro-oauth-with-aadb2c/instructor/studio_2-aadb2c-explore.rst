==============================================================================
Instructor Solution Studio Part 2: Explore Authorization With the Deployed API
==============================================================================

Join Event
----------

prompt: try to join an existing coding event

Planning
^^^^^^^^

What is the current state?

- 2 authenticated users (Owner & Member)
- no coding events

What should the initial state be for this task?

#. 1 coding event with an Owner
#. 1 authenticated user (Member) that is not currently a member of the coding event

What requests were fired, in what order, and who issued them to achieve the initial state?

#. owner: ``POST /api/events/``

State
^^^^^

Prompt: try to join an existing coding event

- what request is used to completed the task?

#. authenticated user (Member): ``POST /api/events/{CodingEventsId}/members``
#. Owner: ``POST /api/events/{CodingEventsId}/members``

- what is the final state after completing the task?

#. 1 coding event with 2 members (Owner & Member)

Authorization
^^^^^^^^^^^^^

.. turn these into tables

what happened when the authenticated user (Member) tried to join the coding event?

- status code: 204 No Content
- body: empty

what happened when the Owner tried to join the coding event?

- status code: 400
- body: JSON object describing the error

.. sourcecode:: json
   :caption: body of Owner request

   {
      "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
      "title": "Bad Request",
      "status": 400,
      "traceId": "|239addd7-409244e32d9104cb."
   }

Add a Tag to a Coding Event
---------------------------

prompt: try to add a tag to an existing coding event

Planning
^^^^^^^^

What is the current state?

- 1 Coding Event with 2 members (Owner, Member)
- No tags

What should the initial state be for this task?

#. 1 coding event with 2 members
#. 1 unattached tag

Steps to achieve initial state:

#. owner: ``POST /api/tags

State
^^^^^

Prompt: try to add a tag to an existing coding event

What requests were fired, and by who, after achieving the initial state?

#. Member: ``PUT /api/events/{CodingEventsId}/tags/{tagId}``
#. Owner: ``PUT /api/events/{CodingEventsId}/tags/{tagId}``

What is the final state after firing these new requests?

#. 1 coding event with 2 members and 1 attached tag

Authorization
^^^^^^^^^^^^^

.. turn these into tables

What happened when the Member tried to add a tag?

- status code: 403 Forbidden
- body: Not an owner of the Coding Event

What happened when the Owner tried to add a tag?

- status code: 204
- body: No content success

Remove a Tag from a Coding Event
--------------------------------

prompt: remove a tag from an existing coding event

Planning
^^^^^^^^

What is the current state?

- 1 Coding Event with 2 members (Owner, Member) and 1 attached tag

What should the initial state be for this task?

#. 1 coding event with 2 members and 1 attached tag

Steps to achieve initial state:

#. None

State
^^^^^

Prompt: remove a tag from an existing coding event

What requests were fired, and by who, after achieving the initial state?

#. Member: ``DELETE /api/events/{CodingEventsId}/tags/{tagId}``
#. Owner: ``DELETE /api/events/{CodingEventsId}/tags/{tagId}``

What is the final state after firing these new requests?
 
#. 1 coding event with 2 members and 0 attached tags

Authorization
^^^^^^^^^^^^^

.. turn these into tables

What happened when the Member tried to remove a tag?

- status code: 403 Forbidden
- body: Not an owner of the Coding Event

What happened when the Owner tried to remove a tag?

- status code: 204
- body: No content success

Remove a Member from a Coding Event
-----------------------------------

prompt: try to remove a member from an existing coding event

Planning
^^^^^^^^

What is the current state?

- 1 Coding Event with 2 members (Owner, Member)

What should the initial state be for this task?

#. 1 coding event with 2 members (Owner, Member)

Steps to achieve initial state:

#. None

State
^^^^^

Prompt: try to remove a member from an existing coding event

What requests were fired, and by who, after achieving the initial state?

#. Member: ``DELETE /api/events/{CodingEventsId}/members/{memberId}``
#. Owner: ``DELETE /api/events/{CodingEventsId}/members/{memberId}``

What is the final state after firing these new requests?

#. 1 coding event with 1 member (Owner)

Authorization
^^^^^^^^^^^^^

.. turn these into tables

What happened when the Member tried to remove a member?

- status code: 403 Forbidden
- body: Not an owner of the Coding Event

What happened when the Owner tried to remove a member?

- status code: 204 No content
- body: empty

Leave a Coding Event
--------------------

prompt: try to leave an existing coding event

Planning
^^^^^^^^

What is the current state?

- 1 Coding Event with 1 member (Owner)

What should the initial state be for this task?

#. 1 coding event with 2 members (Owner & Member)

Steps to achieve initial state:

#. Member: ``POST /api/events/{CodingEventsId}/members``

State
^^^^^

Prompt: try to leave an existing coding event

What requests were fired, and by who, after achieving the initial state?

#. Member: ``DELETE /api/events/{CodingEventsId}/members``
#. Owner: ``DELETE /api/events/{CodingEventsId}/members``

What is the final state after firing these new requests?

#. 1 coding event with 1 member (Owner)

.. admonition:: Note

   What happens if the Owner issues the request before the Member?

Authorization
^^^^^^^^^^^^^

.. turn these into tables

What happened when the Member tried to leave the event?

- status code: 204 No Contnet
- body: empty

What happened when the Owner tried to leave the event?

- status code: 400
- body: JSON object describing the error

Cancel a Coding Event
---------------------

prompt: try to cancel an existing coding event

Planning
^^^^^^^^

What is the current state?

- 1 Coding Event with 1 member (Owner)

What should the initial state be for this task?

#. 1 coding event with 2 members (Owner & Member)

Steps to achieve initial state:

#. Member: ``POST /api/events/{CodingEventsId}/members``

State
^^^^^

Prompt: try to cancel an existing coding event

What requests were fired, and by who, after achieving the initial state?

#. Member: ``DELETE /api/events/{CodingEventsId}``
#. Owner: ``DELETE /api/events/{CodingEventsId}``

What is the final state after firing these new requests?

#. 0 coding events

Authorization
^^^^^^^^^^^^^

.. turn these into tables

What happened when the Member tried to cancel the event?

- status code: 403 Forbidden
- body: JSON object describing the error

What happened when the Owner tried to cancel the event?

- status code: 204 No content
- body: empty