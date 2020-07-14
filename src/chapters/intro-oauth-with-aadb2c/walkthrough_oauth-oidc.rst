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

From the Visual OAuth article we learned about the OAuth authorization code grant flow. The OAuth authorization code grant flow results in a token which represents an identity being shared between applications. Outside of the OAuth authorization code grant flow there are other grant flows.

A **flow** is the process of token management including: requesting tokens, granting tokens and how the token is managed throughout the process.

To learn about OIDC we will need to explore a different type of OAuth grant, the implicit grant flow. This grant has a different flow, a different token, and a different spec.

.. a different type of flow, a different token, and a different spec


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

OAuth Implicit Flow
-------------------

Let's consider the steps of OAuth presented to you in the Visual OAuth walkthrough:

- User Authenticates & Authorizes the Client
- Provider Redirects to Client with Auth Code
- Client Front-end Sends Auth Code to Back-end
- Client Back-end Exchanges Auth Code For Access Token

Now let's look at the OAuth Implicit Grant Flow steps:

- User Authenticates & Authorizes the Client
- Provider Redirects to Client with Access Token
- Client Front-end Sends Provider Token to Back-end
- Client Back-end validates token and grants access

At first glance these two different grant flows may look familiar, however, they have a couple of key differences that have big implications.

The first difference in Implicit Flow is that the Provider Redirects to Client with an *Access Token as a part of the redirect URI instead of an Auth Code*. This token is the identity of the user and would be plainly visible to anyone that can view the network traffic.

The second difference in Implicit Flow is that the Client Back-end does not exchange a code with the provider to receive an Access Token. The Access Token was sent from the Client Front-end so the Client Back-end simply needs to validate that the Access Token matches the one on file for that user. If the tokens match the user is granted access. There is no additional transaction from the Client Back-end to the Provider.

.. admonition:: note

   Since an additional check is not performed by the Provider a compromised Access Token from the Redirect URI can be used to assume another user's identity. This is a security concern and Implicit Flow needs to be handled with care. You can learn more by exploring:

      - `OAuth 2.0 Implicit Grant Flow spec <https://tools.ietf.org/html/rfc6749#section-4.2>`_
      - `Microsoft article about Implicit Flow in AADB2C <https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application>`_

.. :: comment: great video from oauth.net about implicit flow: https://oauth.net/2/grant-types/implicit/

Identity Tokens
---------------

Sharing Identity
----------------

From Microsoft: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

AADB2C uses the OIDC protocol to authenticate users via OAuth. Outside of authentication OIDC gives us the ability to share information between applications because it uses OAuth. 

.. admonition:: note

   We won't explore OIDC as a concept in this class, but learning more about the `Microsoft implementation of the OIDC protocol <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_ may be beneficial. We will see Microsoft's implementation of OIDC through AADB2C.

