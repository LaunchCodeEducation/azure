===================================
Azure AD B2C Practical Fundamentals
===================================

.. STAY PRACTICAL. NO GENERIC EXAMPLES - ALL IN REFERENCE TO AADB2C, API AND POSTMAN

As you may have come to realize OAuth and OIDC are relatively heavy concepts. However, being able to securely authenticate and authorize your end users is a necessary part of any web applications that contain data with restricted access.

Manually creating your own service for authenticating and authorizing is something that is possible, but *risky*. No matter how talented you and your team may be it is difficult to compete with a company that dedicates as many resources to security as Microsoft does. By using Microsoft Azure AD B2C the risk of implementing authentication or authorization incorrectly is mitigated completely.

Entities of Our System
======================

Let's consider the different entities involved in the system we will be building and using:

- **client**: an application that consumes data from a provider
- **provider**: a resource server that provides data
- **user**: an authenticated resource owner that delegates access to the client

The client, provider and user interactions are managed by a special kind of entity called an **authority**. The authority in this case is Azure AD B2C which acts as the bridge between a client, a provider and a user. 

Azure AD B2C is the authority over all authentication and authorization in the system. AADB2C can manage customer identities for authentication as well as securing interactions between registered applications. In the latter case two applications are registered, one as a client and the other as a provider that is protected by AADB2C.

.. ::

  Registered applications can be configured for AADB2C to provide:

  - identity tokens to an application *behaving as a client* that needs to authenticate a user 
  - access tokens to a client application that make requests on behalf of a user


In the examples throughout this chapter the entities we will be working with are:

- **client**: Postman
- **provider**: Coding Events API
- **user**: an identity managed by AADB2C
- **authority**: AADB2C issuing access tokens to Postman for making requests to the API on behalf of the user

.. ::

  Benefits
  --------

  Client
  ^^^^^^

  Resource Server
  ^^^^^^^^^^^^^^^

  Authority
  ^^^^^^^^^

  User
  ^^^^

  Developer
  ^^^^^^^^^

  Roles
  -----

  Using a service like AADB2C also affords benefits to everyone involved in the process.



  - what are the benefits: WHY ARE WE DOING THIS
    - for each player what is their role
    - benefit
      - client: can provide a service that utilizes another service's resources
      - resource server: 
        - flexibility for their users (allow others to derive value from your core operations)
        - promotes innovation and collaborative growth of your service
        - while doing so securely
      - authority:
        - MS: make money by abstracting a complex system as a service
        - dev: save time to focus on your business edge in exchange for money
          - provide a secure and seamless experience to users
      - user:
        - SSO (signup fatigue)
        - motivated to stay and continue to build data with provider service because of extensibility
        - can use client services to find new uses for their provider data
      - developer:
        - OIDC and benefits of standardization (REST?)
        - abstraction from handrolling
          - less responsibility
          - diffusion of responsibility
          - place trust in the hands of the party that specializes in it
            - FOCUS ON YOUR BUSINESS EDGE

  Recap
  =====

  - before we start learning about aadb2c
  - take stock of what learned so far

  Authentication & Authorization
  ------------------------------

  - delegation



  - what protocol is used
  - **OAuth**: for controlling access to applications that are registered in the tenant

  - what protocol is used
  - **OIDC**: for sharing user account identities with registered applications

  - tokens...

  Tokens
  ------

  - **identity claims**: information about the user
  - **authorization claims**: information about what the Client is authorized to access 

  Validation Claims
  ^^^^^^^^^^^^^^^^^

  - authenticity
  - who is checking what
    - label the units in our system
      - some intended recipient
      - some intended **bearer**
        - how does it get there
      - user subject
      - some authority signing off on the operation

  Identity Token Path
  ^^^^^^^^^^^^^^^^^^^

  Access Token Path
  ^^^^^^^^^^^^^^^^^

  - the path from the user to the api and back



  before you used github as the authorization server to get access tokens. now we will work behind the scenes on creating our own authorization and identity management service that:

  - manages user accounts in the directory
  - provides SSO with OIDC
  - authorizes applications to access user data within the organization

Components of Azure AD B2C
==========================

Let's cover some of the essential components we will be using to configure our AADB2C service. You will hear about these components many times in the upcoming lessons. You can read a more detailed coverage of AADB2C in `this Microsoft article <https://docs.microsoft.com/en-us/azure/active-directory-b2c/technical-overview>`_.

.. admonition:: Note

  A confusing aspect of AADB2C is that it can behave as two different roles depending on the interaction it is managing:

  - **identity provider**: when acting as a resource server that manages account (identity) data
  - **authorization server**: when managing how *applications registered in your organization* can interact with user identities *and each other*

Tenant Directory
----------------

The tenant directory is the central component of an AADB2C service. The tenant is an `Active Directory (AD) <https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-whatis>`_ instance that can be used to manage both identity (authentication) and access (authorization). You can think of the Active Directory side of AADB2C as a *resource server for identity resources*.

The Business to Customer (B2C) aspect of AADB2C relates to how the AD instance supports an organization comprised of both customer and business accounts. In AADB2C customers can create accounts using different **provider services** like Microsoft, GitHub or LinkedIn. 

.. admonition:: Note

  Because AADB2C is designed to integrate with customers it also supports a **local account provider** that allows customer to create accounts with their own username or email and password. This is how we will be using AADB2C in the upcoming lessons.

Registered Applications
-----------------------

Within a tenant directory you can **register applications** that you allow to integrate with your organization. Registered applications can include applications within your organization or those from a trusted third party. 

The role (identity or authorization) that AADB2C will assume is based on how the application is configured. An application can be configured as:

- **client**: an application **that requests access to identity resources** from AADB2C
- **provider** (resource server): an application that is *protected by* AADB2c which *other registered applications* request access to

An application configured as a client is *a consumer* of the user's identity data. For example, in our first walkthrough we will register the Coding Events API to be a client application that uses AADB2C as an *identity provider* to authenticate users with OIDC. 

A provider application is configured to *receive requests for its own resources* and requires authorized requests containing an access token. AADB2C manages the OAuth process of granting an access token to another registered client application which authorizes it to consume resources from the provider.

.. admonition:: Note

  A registered application can be configured to act as *both a client and provider*. For example, our Coding Events API will act as both a:
  
  - **client** when authenticating user identities managed by AADB2C
  - **provider** when receiving an access token that authorizes *another application* (Postman) to make requests to it on behalf of a user

Scopes
------

In the OAuth walkthrough you consented the Visual OAuth application to use the ``read:user`` scope and access your private GitHub user data. When configuring a provider application in your AADB2C service you will *expose scopes* for it. These scopes control how other registered client applications can access the underlying data.

In the upcoming access token walkthrough you will get a chance to work behind the scenes to define your own scope. We will configure a ``user_impersonation`` scope that the Postman client application will use to make authorized requests on behalf of a user. 

.. ::

  How AADB2C Is Used For Authentication
  =====================================

  - purpose of tbhe walkthrough
  - how we are setting it up
    - describe each component used

  How AADB2C Is Used For Authorization
  =====================================

  - purpose of the walkthrough
  - how we are setting it up
    - describe each component used
  