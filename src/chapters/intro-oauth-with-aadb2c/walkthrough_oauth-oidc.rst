===================
Visual OAuth & OIDC
===================

This article will link out to a GitHub project that will show you how to setup a project that will take you through the steps of OAuth in a visual setting from your browser.

As a reminder: 

   **OAuth** is the specification of sharing access of an identity between two unrelated applications.

.. :: comment:: warn about the difference between 1.0 and 2.0 and implicit flow, put this at the end, or remove

Visual OAuth
============

This section will be completed in your browser away from the curriculum of this class, in which you host a small project that will show how OAuth works, as well as introducing the terms that are commonly used in the OAuth spec.

.. :: comment: students will need NPM installation instructions these should probably be added to visual oauth repo

.. :: comment: put NPM installation steps here? keep it out of visual-oauth

**Complete the** `Visual OAuth walkthrough <https://github.com/LaunchCodeEducation/visual-oauth>`_ **before moving forward.**

OAuth Implicit Flow
===================

- how it's different from the OAUTH the learned in the walkthrough

.. :: comment: implicit flow link: https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application

OIDC
====

From Microsoft: 

   "OpenID Connect (OIDC) is an authentication protocol, built on top of OAuth 2.0, that can be used to securely sign users in to web applications."

AADB2C uses the OIDC protocol so that users are authenticated, and can share information between applications. We won't explore OIDC in any depth in this class, but learning more about the `Microsoft implementation of the OIDC protocol <https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect>`_ may be beneficial.
