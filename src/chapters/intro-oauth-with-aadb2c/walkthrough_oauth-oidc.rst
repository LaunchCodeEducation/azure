=================================
Walkthrough: Explore OAuth & OIDC
=================================

In this walkthrough, we will begin by exploring OAuth using a visual learning tool. Afterwards, we will introduce the OIDC specification (or spec) which is built as a layer over the OAuth spec.

Both of these specs are designed for a user to *securely coordinate* the exchange of their information between two unrelated services:

- **client service**: *requests* a user to *authorize* access to their identity or data from a provider service
- **Provider service**: *provides* the identity or access to data of a user who *authorizes* a client service

Because OIDC is built over OAuth, their distinction from each other is subtle but important to understand. Throughout this walkthrough, keep in mind the purpose of each of these coordination mechanisms:

- **OAuth**: used for sharing access of a user's data on a provider service to a client service
- **OIDC**: used for a (identity) provider service to *provide the identity* of a user to a client service

How OAuth Works
===============

.. index:: ! Visual OAuth

The first step of this walkthrough will use a tool called Visual OAuth. This tool will introduce you to the key terminology and concepts involved in OAuth. After learning the fundamentals, it will guide you step-by-step through the OAuth mechanism. 

You will run this project locally on your machine. The `Visual OAuth repo <https://github.com/LaunchCodeEducation/visual-oauth>`_ has all of the instructions for setting up and using the tool in its ``README`` file. 

.. admonition:: Note
   
   Follow the repo link and the instructions, then return to this article when you have finished.

How OIDC Works
==============

.. index:: 
   :single: grant flow;authorization code 

From the Visual OAuth article we learned about the OAuth authorization code grant flow. This grant flow results in an access token which authorized the client API to access the user's protected GitHub API data.

.. index:: ! grant flow

An OAuth **grant flow** is the general term for the process of a client obtaining an access token via OAuth.

The next section introduces a new OAuth grant flow called the implicit grant flow.

OAuth Implicit Grant Flow
-------------------------

.. index:: 
   :single: grant flow;implicit

Let's consider the steps of the OAuth authorization code grant flow presented in the Visual OAuth walkthrough:

#. The user authenticates and authorizes the client.
#. The provider redirects to the client with an auth code.
#. The client front-end sends the auth code to the back-end.
#. The client back-end exchanges (by using it's client secret) the auth code for an access token.

This grant flow is the preferred OAuth grant flow for client applications that have a dedicated back-end. 

The implicit grant flow, on the other hand, is suitable for client applications that can *not* securely store the client secret. Recall that this secret is needed in the 4th step of the authorization code grant flow. Typically, this scenario is encountered in client applications that only consist of a front end.

In the implicit grant flow there are only two steps:

#. The user authenticates and authorizes the client.
#. The provider redirects back to the client with an access token.

.. admonition:: Note

   You can learn more about the OAuth implicit grant flow by exploring these resources:

   - `OAuth 2.0 Implicit Grant Flow spec <https://tools.ietf.org/html/rfc6749#section-4.2>`_
   - `Microsoft article about Implicit Flow in AADB2C <https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application>`_

In this course, we will use the implicit flow in AADB2C to simplify the process of gaining tokens that authorize and authenticate our users. So far, you have learned about access tokens for *authorization*. Identity tokens are used for *authentication* and come in a standardized format, JSON.

JSON Web Tokens (JWT)
---------------------

In OAuth there are two types of tokens:

- **access tokens**: credentials that grant access (authorization) to data from a provider API.
- **identity tokens**: a JWT with identity information that can be shared between applications.

.. index:: ! JSON web token

A **JSON web token** (JWT) is a way of securely transferring data over a network. A JWT is made up of 3 components:

#. **Header**: token metadata
#. **Payload**: the JSON data
#. **Signature**: a digital signature of authenticity

The JSON data is `signed for authenticity <https://auth0.com/docs/tokens/guides/validate-jwts#check-the-signature>`_ and Base64 encoded to make even large payloads easy to transport over HTTP.

.. admonition:: Note

   To learn more about JWTs, start with the `jwt.io introduction <https://jwt.io/introduction/>`_.

In our OAuth grant flows, the end result is always an access token which does not necessarily contain information about the user's identity. If our application wants to gain identity information about their user they will need to get their hands on an identity token.

OpenID Connect (OIDC)
---------------------

`From the Microsoft documentation <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_: 

   OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications.

OIDC is an identity management protocol built on top of OAuth. In many ways, it is just a thin *layer* over OAuth. Whereas OAuth is about *delegating access* (authorization) using access tokens, OIDC provides a mechanism for the secure exchange of a user's identity (authentication) with an identity token. 

.. admonition:: Note

   OIDC was developed to standardize the use of OAuth for authentication. 
   
   Before OIDC, developers used `pseudo-authentication with OAuth <https://en.wikipedia.org/wiki/OpenID#OpenID_vs._pseudo-authentication_using_OAuth>`_ which, given that OAuth is an *authorization* protocol, was not an ideal approach.

Consider the steps taken in the Visual OAuth walkthrough. After gaining an access token, the client back end (Visual OAuth API) used the token to access the requesting user's identity information. As an example of access token usage, this process was valid. But as a means of *authenticating* the requesting user it was not!

.. index:: ! claims

OIDC standardizes both this authentication process and what is returned. Rather than relying on each provider to define their own arbitrary user profile endpoint and response body, OIDC establishes a consistent identity endpoint and identity tokens. These *signed* tokens contain **claims** (user identity fields) in the JWT payload. 

.. index:: 
   :single: identity; provider

An organization can use an identity management service like AADB2C to define a consistent set of identity claims across any number of **identity providers**, such as Microsoft, GitHub, or a standard email (and password) provider.

OIDC in AADB2C
==============

.. index:: ! tenant directory

AADB2C uses OIDC to provide a centralized authentication platform that enables `Single Sign On (SSO) <https://docs.microsoft.com/en-us/azure/active-directory-b2c/session-overview>`_. It stores user accounts in a **tenant directory** (an Active Directory instance) and uses:

- **OAuth**: for controlling access to applications that are registered in the tenant
- **OIDC**: for sharing user account identities with registered applications

.. index:: ! user flows

Using AADB2C you can implement **user flows** that bridge the gap between a user, an identity provider, and your registered applications. Upon a successful authentication, the AADB2C service can send an identity token (OIDC) and, in most cases, an access token (OAuth) to your registered application.

.. admonition:: Note

   If you want to learn more about OAuth, OIDC, and AADB2C, the following videos are a great start:

   - `OAuth & OIDC explained simply by Nate Barbettini <https://www.youtube.com/watch?v=996OiexHze0>`_
   - `Microsoft AADB2C overview (YouTube) <https://www.youtube.com/watch?v=GmBKlXED9Ug>`_
