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

.. :: comment: students will need NPM installation instructions these should probably be added to visual oauth repo

.. :: comment: put NPM installation steps here? keep it out of visual-oauth

.. admonition:: warning

   **Complete the** `Visual OAuth walkthrough <https://github.com/LaunchCodeEducation/visual-oauth>`_ **before moving forward.**

OAuth Implicit Flow
===================

- how it's different from the OAUTH the learned in the walkthrough

.. :: comment: implicit flow link: https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application

.. :: comment: OAuth 2.0 implicit grant link: https://tools.ietf.org/html/rfc6749#section-4.2

OIDC
====

From Microsoft: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

AADB2C uses the OIDC protocol to authenticate users via OAuth. Outside of authentication OIDC gives us the ability to share information between applications because it uses OAuth. 

.. admonition:: note

   We won't explore OIDC as a concept in this class, but learning more about the `Microsoft implementation of the OIDC protocol <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_ may be beneficial. We will see Microsoft's implementation of OIDC through AADB2C.
