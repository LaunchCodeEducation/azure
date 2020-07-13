===================
Visual OAuth & OIDC
===================

This article will link out to a GitHub project that will show you how to setup a project that will take you through the steps of OAuth in a visual setting from your browser.

As a reminder: 

   **OAuth** is the specification of sharing access of an identity between two unrelated applications.

.. admonition:: note

   We will be using `OAuth 2.0 <https://oauth.net/2/>`_ throughout this class. `Auth 1.0 <https://oauth.net/core/1.0/>`_ is still used in some applications, but will not be discussed as it is out of scope.

.. :: comment:: warn about the difference between 1.0 and 2.0 and implicit flow, put this at the end, or remove

Walkthrough: Visual OAuth
=========================

This section will be completed in your browser away from the curriculum of this class, in which you host a small project that will show how OAuth works, as well as introducing the terms that are commonly used in the OAuth spec.

.. admonition:: warning

   **Complete the** `Visual OAuth walkthrough <https://github.com/LaunchCodeEducation/visual-oauth>`_ **before moving forward.**

OAuth Implicit Flow
===================

Let's consider the steps of OAuth presented to you in the walkthrough:

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

OIDC
====

From Microsoft: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

AADB2C uses the OIDC protocol to authenticate users via OAuth. Outside of authentication OIDC gives us the ability to share information between applications because it uses OAuth. 

.. admonition:: note

   We won't explore OIDC as a concept in this class, but learning more about the `Microsoft implementation of the OIDC protocol <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_ may be beneficial. We will see Microsoft's implementation of OIDC through AADB2C.
