=================================
Walkthrough: Explore OAuth & OIDC
=================================

In this walkthrough we will begin by exploring OAuth using a visual learning tool. Afterwards we will introduce the OIDC specification (spec) which is built as a layer over the OAuth spec.

Both of these specs are designed for a **user to securely coordinate** the exchange of their information between two unrelated services:

- **client service**: *requests* a user to *authorize access* to their identity or data from a provider service
- **provider service**: *provides* the identity or access to data of a user who **authorizes** a client service

Because OIDC is built over OAuth their distinction from each other is subtle but important to understand. Throughout this walkthrough keep in mind the **purpose** of each of these coordination mechanisms:

- **OAuth**: used for **authorizing** access of a user's data on a provider service to a client service
- **OIDC**: used for a (identity) provider service to **provide the identity** of a user to **authenticate** with a client service

How OAuth Works
===============

   **OAuth** is a mechanism for a user to *securely* share access to their data that exists on one service with another service. 

For example, when you are registering for a Spotify account you can choose to create it using your Facebook account. First you **authenticate** with Facebook. Then you *grant access* to your Facebook profile data so Spotify can create a profile using that information. 

OAuth can also be used to grant *management access* of your data between services. If you allow Spotify to *manage* your Facebook data it can automatically post the music you are listening to *on your behalf*.

Explore OAuth
-------------

The first step of this walkthrough will use a tool called Visual OAuth. This tool will introduce you to the key terminology and concepts involved in OAuth. After learning the fundamentals it will guide you step-by-step through the OAuth mechanism. 

You will run this project locally on your machine. The `Visual OAuth repo <https://github.com/LaunchCodeEducation/visual-oauth>`_ has all of the instructions for setting up and using the tool in its ``README`` file. 

.. admonition:: Note
   
   Follow the repo link and the instructions **then return to this article** when you have finished.

OAuth Grant Flows
=================

From the Visual OAuth article we learned about the OAuth authorization code grant flow. This grant flow results in an Access token which authorized the Client API to access the user's protected GitHub API data.

   An OAuth **grant flow** is the general term for the process of a Client obtaining an Access token via OAuth

In this section we will be learning about a new OAuth grant flow called the Implicit grant flow.

Authorization Code Grant Flow
-----------------------------

Let's consider the steps of the OAuth authorization code grant flow presented in the Visual OAuth walkthrough:

.. turn into diagram

#. User Authenticates & Authorizes the Client
#. Provider Redirects to Client with Auth Code
#. Client Front-end Sends Auth Code to Back-end
#. Client Back-end Exchanges (by using it's client secret) Auth Code For access token

This grant flow is the preferred OAuth grant flow for Client applications that have a dedicated back-end that can securely manage the client secret used in the final exchange. However, for desktop applications (like Postman) or those with only a front-end we use the simpler Implicit Grant Flow. 

Implicit Grant Flow
-------------------

The implicit grant flow is suitable for Client applications that can not securely store the **client secret**. Recall that this secret is needed in the 4th step of the authorization code grant flow. Typically this scenario is encountered in Client applications that only consist of a front end.

In the implicit grant flow there are only two steps:

.. turn into diagram

#. User Authenticates & Authorizes the Client
#. Provider Redirects to Client with access token

.. admonition:: Note

   You can learn more about the OAuth Implicit Grant Flow by exploring:

   - `OAuth 2.0 Implicit Grant Flow spec <https://tools.ietf.org/html/rfc6749#section-4.2>`_
   - `Microsoft article about Implicit Flow in AADB2C <https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application>`_

.. rewrite segue below to reflect JWT used for both access and identity tokens

In this course we will use the implicit flow in AADB2C to simplify the process of gaining tokens that authorize and authenticate our users. So far you have learned about access tokens for *authorization*. Identity Tokens are used for *authentication* and come in a standardized format, JSON.

JSON Web Tokens (JWT)
---------------------

In OAuth there are two types of tokens:

- **access tokens**: credentials that grant access (authorization) to data from a provider API
- **Identity Tokens**: a JWT with identity information that can be shared between applications

A **JSON Web Token** (JWT) is a way of securely transferring data over a network. A JWT is made up of 3 components:

#. **header**: token metadata
#. **payload**: the JSON data
#. **signature**: a digital signature of authenticity

The JSON data is `signed for authenticity <https://auth0.com/docs/tokens/guides/validate-jwts#check-the-signature>`_ and Base64 encoded to make even large payloads easy to transport over HTTP.

.. admonition:: Note

   To learn more about JWTs start with the `jwt.io introduction <https://jwt.io/introduction/>`_.

In our OAuth grant flows the end result is always an access token which does not necessarily contain information about the user's identity. If our application wants to gain identity information about their user they will need to get their hands on an Identity Token.

OpenID Connect (OIDC)
=====================

`From the Microsoft documentation <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

OIDC is an **authentication protocol** built as a thin layer over the OAuth protocol. Whereas OAuth is about *delegating access* (authorization) using access tokens, OIDC provides a mechanism for the secure exchange of a user's identity (authentication) with an Identity Token. 

.. admonition:: Note

   OIDC was developed to **standardize the use of OAuth for authentication**. Before OIDC, developers used `pseudo-authentication with OAuth <https://en.wikipedia.org/wiki/OpenID#OpenID_vs._pseudo-authentication_using_OAuth>`_ which, given that OAuth is an *authorization protocol*, was considered a "hacky" approach.

Consider the steps taken in the Visual OAuth walkthrough. The Client back-end (Visual OAuth API) used the access token to request the user's private profile data:

.. diagram showing process of exchanging access token for user data to authenticate

As a demonstration of using an access token this process was valid -- but as a means of *authenticating the requesting user* it was not!

OIDC standardizes both this authentication process and what is returned. Rather than each provider defining their own arbitrary "user profile" endpoint and response body, OIDC establishes a standard identity endpoint that uses Identity Tokens to share identity information.

These *signed* tokens contain **claims** (user identity fields) in the JWT payload that the client service can use for authentication of its users. An organization can use an identity management service like AADB2C to define a consistent set of identity claims across any number of **identity providers** like Microsoft, GitHub or a standard Email (and password) provider.

How AADB2C Uses OAuth & OIDC
============================

before you used github as the authorization server to get access tokens. now we will work behind the scenes on creating our own authorization and identity management service that:

- manages user accounts in the directory
- provides SSO with OIDC
- authorizes applications to access user data within the organization

.. diagram: visual oauth and github

.. diagram: postman, API and AADB2C

What we will be setting up

.. diagram - with aadb2c and showing the flow from postman -> AADB2C and postman (with token) -> API

How AADB2C Is Used For Authentication
-------------------------------------

How AADB2C Is Used For Authorization
------------------------------------
