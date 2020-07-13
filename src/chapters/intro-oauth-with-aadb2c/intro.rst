====================
Introduction to Auth
====================

.. :: comment: diagrams in intros how adding in this thing affects the greater system

Authentication & Authorization
==============================

Authentication
--------------

   **Authentication** is the process of proving identity.

An example would be logging into your email, you have to provide your email address and a password to prove your identity.

.. admonition:: note

   There are multiple factors of authentication the three most common are:

   - Knowledge based (*something you know*): a username and password
   - Possession based (*something you have*): an ID badge or keycard
   - Inherent based (*something you are*): a fingerprint or face unlock

   An application can be made more secure by requiring Multiple Factors for Authentication (MFA). Learn more about `MFA from Microsoft <https://docs.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks>`_.

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

   **OAuth** is the specification of sharing access of an identity between two unrelated applications.

You have probably used OAuth without realizing it. When you create, or sign into, an account on an application and you prove your identity (authentication) by signing into a separate unrelated application you are using OAuth. 

For example when you are signing into your Spotify account it may redirect you to Facebook. You prove your identity (authentication) to Facebook and then it sends a notification to Spotify that you are who you claim to be. This is what grants you access to the Spotify platform. 

During this OAuth process Spotify may access some of your data from Facebook, like your friends-list allowing you to connect with your Facebook friends on the Spotify platform.

.. admonition:: note

   The following walkthrough will give a much deeper explanation of OAuth as well as a way OAuth is implemented. If you require more information checkout the `Microsoft OAuth technical guide <https://docs.microsoft.com/en-us/advertising/guides/authentication-oauth?view=bingads-13>`_.

AADB2C
======

In this class we will use Azure Active Directory Business to Customer (AADB2C) as our Customer Identity Access Manager (CIAM). 

This tool provides identity as a service. In essence AADB2C provides the bridge for allowing OAuth between user accounts (Google, Microsoft, Twitter, Facebook, Amazon, etc) known as providers to applications you develop and deploy.

We will create and configure an AADB2C tenant that is connected to an email address of users. We will have to set which information is shared from the provider like their email address, and name. This information will be available to us in our application.

So users when they first sign up or login to our application they will be routed to a third party AADB2C page which is where the user will authenticate. AADB2C will then pass the user information to our application letting us know the user has been authenticated, and giving us the information we need in our application.

.. admonition:: note

   OAuth, and CIAMs can be difficult to setup, configure, and use. We will be setting up a very simple provider and tenant example in our walkthrough to illustrate how it can be done. However, to continue your own learning checkout the `Microsoft AADBDC overview <https://docs.microsoft.com/en-us/azure/active-directory-b2c/overview>`_ you can find even more information by looking over the other links in that article.