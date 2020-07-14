=================================
Walkthrough: Explore OAuth & OIDC
=================================

In this walkthrough we will begin by exploring OAuth using a visual learning tool. Afterwards we will introduce the OIDC specification (spec) which is built as a layer over the OAuth spec.

Both of these specs are designed for a **user to securely coordinate** the exchange of their information between two unrelated services:

- **client service**: *requests* a user to *authorize access* to their identity or data from a provider service
- **provider service**: *provides* the identity or access to data of a user who **authorizes** a client service

Because OIDC is built over OAuth their distinction from each other is subtle but important to understand. Throughout this walkthrough keep in mind the **purpose** of each of these coordination mechanisms:

- **OAuth**: used for sharing access of a user's data on a provider service to a client service
- **OIDC**: used for a (identity) provider service to **provide the identity** of a user to a client service

How OAuth Works
===============

The first step of this walkthrough will use a tool called Visual OAuth. This tool will introduce you to the key terminology and concepts involved in OAuth. After learning the fundamentals it will guide you step-by-step through the OAuth mechanism. 

You will run this project locally on your machine. The `Visual OAuth repo <https://github.com/LaunchCodeEducation/visual-oauth>`_ has all of the instructions for setting up and using the tool in its ``README`` file. 

.. admonition:: note
   
   Follow the repo link and the instructions **then return to this article** when you have finished.

How OIDC Works
==============

From the Visual OAuth article we learned about the OAuth authorization code grant flow. This grant flow results in an Access token which authorizes a user to access data, or an API.

   A **grant flow** is the process of a client obtaining an Access token via OAuth.

.. ::

   A **flow** is the process of obtaining an Access token using OAuth. This includes requesting and granting tokens.

   A **grant** is the act of providing an an Access token to the client.

In this section we will be learning about a new OAuth grant flow, OAuth Implicit grant flow. This grant flow has a different process, a different token, and a different spec.

OAuth Implicit Grant Flow
-------------------------

Let's consider the steps of the OAuth authorization code grant flow presented in the Visual OAuth walkthrough:

- User Authenticates & Authorizes the Client
- Provider Redirects to Client with Auth Code
- Client Front-end Sends Auth Code to Back-end
- Client Back-end Exchanges (by using it's client secret) Auth Code For Access Token

This grant flow is the preferred OAuth grant flow for applications that have a dedicated back-end. However, for applications that only contain a front-end like a Single Page Applications (SPA) the OAuth authorization code grant flow will not work!

A new grant flow will need to be used for the SPA to gain an Access Token. Enter the OAuth Implicit Grant Flow:

- User Authenticates & Authorizes the Client
- Provider Redirects to Client with Access Token

This flow is simple in comparison to the authorization code grant flow. The Client consists of only a front-end application all of it's code will be plainly visible to end users. There is no way a client secret could be privately stored, therefore an Auth Code could not be securely exchanged for an Access Token. For this reason the Provider sends the Access Token directly to the Client front-end (as a part of the redirect URI).

The OAuth Implicit Grant Flow has a glaring vulnerability in that anyone that can view the network traffic would be able to plainly see the Access Token as a part of the Redirect URI. Malicious actors could take this Access Token and use it giving them access to information not meant for them! For this reason it is recommended to use the OAuth authorization code grant flow whenever possible.

.. admonition:: note

   You can learn more about the OAuth Implicit Grant Flow by exploring:

      - `OAuth 2.0 Implicit Grant Flow spec <https://tools.ietf.org/html/rfc6749#section-4.2>`_
      - `Microsoft article about Implicit Flow in AADB2C <https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application>`_

The end result of every OAuth grant flow is to provide an Access token to the client. The token contains data and therefore must have a data format, luckily a familiar format: JSON.

JSON Web Tokens (JWT)
---------------------

A **JSON Web Token** (JWT) is a way of securely transferring data over a network. The data is encrypted, signed, represented by JSON, and can be attached to an HTTP header. 

In OAuth there are two types of tokens:

- Access Tokens: credentials that grant access (authorization) to data, or an API
- Identity Tokens: container of identity information that can be shared between applications

In our OAuth grant flows the end result was always an Access Token, however these tokens do not contain information about the user. If our application wants to gain identity information about their user they will need to get their hands on an Identity Token.

.. admonition:: note

   To learn more about JWTs start with the `jwt.io introduction <https://jwt.io/introduction/>`_.

OpenID Connect (OIDC)
---------------------

From Microsoft: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

OIDC is an identity manager built on top of OAuth. OAuth grants an Access token that represents authorization. OIDC is a reusable authentication platform that can provide Identity Tokens. Since OIDC is built over OAuth using an OIDC service, like AADB2C, allows you grant both Access Tokens, and Identity Tokens!

.. go further by mentioning provider vs identity provider

.. bring in the idea of SSO?

.. admonition:: note

   Checkout the `Microsoft implementation of the OIDC protocol <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_ to learn more about OIDC. We will see Microsoft's implementation of OIDC through AADB2C in our upcoming walkthrough.

.. :: comment

   - learned
      - define flow
      - define grants
         - an alternative flow (implicit)
      - access tokens for delegating access / management of user data
         - JWT
         - identity tokens for sharing the identity of a user
   - sharing identity
      - OIDC
         - built over oauth to navigate around pseudo-authentication with OAuth (link)
            - https://developer.okta.com/blog/2017/06/21/what-the-heck-is-oauth#pseudo-authentication-with-oauth-20
      - special type of provider service called identity provider
         - can be both a provider (OAuth) and identity provider or standalone
            - plug AADB2C as an identity manager of multiple identity providers
            - for sharing SSO across multiple providers and applications in your organization
      - sharing the identity session of a user for SSO