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

AADB2C uses the implicit grant flow for providing the identity token of our users. The token must have a data format, luckily the accepted format is a familiar one: JSON.

JSON Web Tokens (JWT)
---------------------

In OAuth there are two types of tokens:

- Access Tokens: credentials that grant access (authorization) to data from a provider API
- Identity Tokens: a JWT with identity information that can be shared between applications

A **JSON Web Token** (JWT) is a way of securely transferring data over a network. A JWT is made up of 3 components:

#. **header**: token metadata
#. **payload**: the JSON data
#. **signature**: a digital signature of authenticity

The JSON data is `signed for authenticity <https://auth0.com/docs/tokens/guides/validate-jwts#check-the-signature>`_ and Base64 encoded for being transported. The token is then attached to the ``Authorization`` HTTP header. 

.. admonition:: note

   To learn more about JWTs start with the `jwt.io introduction <https://jwt.io/introduction/>`_.

In our OAuth grant flows the end result was always an Access Token, however these tokens do not contain information about the user. If our application wants to gain identity information about their user they will need to get their hands on an Identity Token.

OpenID Connect (OIDC)
---------------------

From Microsoft: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

OIDC is an identity manager built on top of OAuth. OIDC provides a reusable authentication platform that can provide Identity Tokens across any number of your applications. The authentication platform uses the underlying authentication from a connected provider like an email account, or a Microsoft account.

Using OIDC you can quickly implement a Sign Up Sign In (SUSI) authentication form that can be tied to a third party provider. When a user needs to authenticate with your application they are sent to the OIDC SUSI form to authenticate with the third party provider. Upon a successful authentication the OIDC platform sends an Access Token (OAuth) and can send an Identity Token to your application as well. 

The same OIDC login flow and provider can be used to authenticate users for any number of applications you develop that utilize the same grant flow.

With OIDC your application can gain access to the Access Tokens (via OAuth) it needs. OIDC is also an identity manager so your application can also gain access to the Identity Tokens it needs. OIDC provides one simple form, connected to a provider, that allows your application to access both Access Tokens and optionally Identity Tokens.

In the walkthrough we will use AADB2C as the implementation of OIDC.

.. admonition:: note

   Checkout the `Microsoft implementation of the OIDC protocol <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_ to learn more about OIDC. We will see Microsoft's implementation of OIDC through AADB2C in our upcoming walkthrough.

.. :: comment

   From Microsoft:

      "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

   OIDC is an identity manager built on top of OAuth. OAuth grants an Access token that represents authorization. OIDC is a reusable authentication platform, connected to an underlying provider, that can provide Identity Tokens to a client application. Since OIDC is built over OAuth the Client can grant permissions for both Access Tokens, and Identity Tokens!

   In the walkthrough we will use AADB2C as the implementation of OIDC.

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