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

From the Visual OAuth article we learned about the OAuth authorization code grant flow. This grant flow results in an Access token which authorized the Client API to access the user's protected GitHub API data.

   An OAuth **grant flow** is the general term for the process of a Client obtaining an Access token via OAuth

In this section we will be learning about a new OAuth grant flow called the Implicit grant flow.

OAuth Implicit Grant Flow
-------------------------

Let's consider the steps of the OAuth authorization code grant flow presented in the Visual OAuth walkthrough:

#. User Authenticates & Authorizes the Client
#. Provider Redirects to Client with Auth Code
#. Client Front-end Sends Auth Code to Back-end
#. Client Back-end Exchanges (by using it's client secret) Auth Code For Access Token

This grant flow is the preferred OAuth grant flow for Client applications that have a dedicated back-end. 

The implicit grant flow is suitable for Client applications that can not securely store the **client secret**. Recall that this secret is needed in the 4th step of the authorization code grant flow. Typically this scenario is encountered in Client applications that only consist of a front end.

In the implicit grant flow there are only two steps:

#. User Authenticates & Authorizes the Client
#. Provider Redirects to Client with Access Token

.. admonition:: note

   You can learn more about the OAuth Implicit Grant Flow by exploring:

   - `OAuth 2.0 Implicit Grant Flow spec <https://tools.ietf.org/html/rfc6749#section-4.2>`_
   - `Microsoft article about Implicit Flow in AADB2C <https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application>`_

In this course we will use the implicit flow in AADB2C to simplify the process of gaining tokens that authorize and authenticate our users. So far you have learned about Access Tokens for *authorization*. Identity Tokens are used for *authentication* and come in a standardized format, JSON.

JSON Web Tokens (JWT)
---------------------

In OAuth there are two types of tokens:

- **Access Tokens**: credentials that grant access (authorization) to data from a provider API
- **Identity Tokens**: a JWT with identity information that can be shared between applications

A **JSON Web Token** (JWT) is a way of securely transferring data over a network. A JWT is made up of 3 components:

#. **header**: token metadata
#. **payload**: the JSON data
#. **signature**: a digital signature of authenticity

The JSON data is `signed for authenticity <https://auth0.com/docs/tokens/guides/validate-jwts#check-the-signature>`_ and Base64 encoded to make even large payloads easy to transport over HTTP.

.. admonition:: note

   To learn more about JWTs start with the `jwt.io introduction <https://jwt.io/introduction/>`_.

In our OAuth grant flows the end result is always an Access Token which does not necessarily contain information about the user's identity. If our application wants to gain identity information about their user they will need to get their hands on an Identity Token.

OpenID Connect (OIDC)
---------------------

`From the Microsoft documentation <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

OIDC is an identity management protocol built on top of OAuth. In many ways it is just *a thin layer* over OAuth. Whereas OAuth is about *delegating access* (authorization) using Access Tokens, OIDC provides a mechanism for the secure exchange of a user's identity (authentication) with an Identity Token. 

.. admonition:: note

   OIDC was developed to **standardize the use of OAuth for authentication**. Before OIDC, developers used `pseudo-authentication with OAuth <https://en.wikipedia.org/wiki/OpenID#OpenID_vs._pseudo-authentication_using_OAuth>`_ which, given that OAuth is an *authorization protocol*, was considered a "hacky" approach.

Consider the steps taken in the Visual OAuth walkthrough. After gaining an Access Token the Client back end (Visual OAuth API) used the token to access the requesting user's identity information. As a demonstration of using an Access Token this process was valid -- but as a means of *authenticating the requesting user* it was not!

OIDC standardizes both this authentication process and what is returned. Rather than each provider defining their own arbitrary "user profile" endpoint and response body, OIDC establishes a consistent identity endpoint and Identity Tokens. These *signed* tokens contain **claims** (user identity fields) in the JWT payload. 

An organization can use an identity management service like AADB2C to define a consistent set of identity claims across any number of **identity providers** like Microsoft, GitHub or a standard Email (and password) provider.

OIDC in AADB2C
--------------

AADB2C uses OIDC to provide a centralized authentication platform that enables `Single Sign On (SSO) <https://docs.microsoft.com/en-us/azure/active-directory-b2c/session-overview>`_. It stores user accounts in a **tenant directory** (an Active Directory instance) and uses:

- **OAuth**: for controlling access to applications that are registered in the tenant
- **OIDC**: for sharing user account identities with registered applications

Using AADB2C you can implement **User Flows** that bridge the gap between a user, an identity provider and your registered applications. Upon a successful authentication, the AADB2C service can send an Identity Token (OIDC) and, in most cases, an Access Token (OAuth) to your registered application.
