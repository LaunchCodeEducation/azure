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

   Understanding and correctly implementing Authentication and Authorization are imperative to the security of your application.You can learn more with the `Microsoft Auth documentation <https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization>`_.

.. https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization

OAuth
=====

   **OAuth** is the specification of sharing access between two unrelated applications.

You have probably used OAuth without realizing it. When you create, or sign into, an account on an application and you prove your identity (authentication) by signing into a separate unrelated application you are using OAuth. 

For example when you are signing into your Spotify account it may redirect you to Facebook. You prove your identity (authentication) to Facebook and then it sends a notification to Spotify that you are who you claim to be. This is what grants you access to the Spotify platform. 

During this OAuth process Spotify may access some of your data from Facebook, like your friends-list allowing you to connect with your Facebook friends on the Spotify platform.

.. admonition:: note

   The following walkthrough will give a much deeper explanation of OAuth as well as a way OAuth is implemented. If you require more information checkout the `Microsoft OAuth technical guide <https://docs.microsoft.com/en-us/advertising/guides/authentication-oauth?view=bingads-13>`_.

AADB2C
======

- light intro link to the materials