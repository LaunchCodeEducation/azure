====================
Introduction to Auth
====================

Authentication & Authorization
==============================

Authentication
--------------

   **Authentication** is the process of proving identity.

An example would be logging into your email, you have to provide your email address and a password.

.. admonition:: note

   There are multiple factors of authentication the three most common are:

   - Knowledge based: *something you know* like a username and password
   - Possession based: *something you have* like an ID badge or keycard
   - Inherent based: *something you are* like your fingerprint or face unlock

   An application can be made more secure by requiring multiple factors for authentication.

Authorization
-------------

   **Authorization** is the level of access of a proven identity.

As an example think about a user of a bank. When the user proves their identity (*authentication*) they can access (*authorized*) their account information. However they cannot access (*unauthorized*) any other user's information. *Authorization* is what a user is authorized and unauthorized to access, which is their level of access.

A way to keep them straight:

- *Authentication* is about identity
- *Authorization* is about access

.. admonition:: note

   Authentication and Authorization are important concepts and you can learn more with the `Microsoft Auth documentation <https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization>`_.

.. https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization

OAuth
=====

- light intro to the term as it's explored in the walkthrough

AADB2C
======

- light intro link to the materials