
=============================
Introduction and Key Concepts
=============================

Up until this point all of the endpoints of our Coding Events API have been *publicly accessible*. In this chapter we will introduce **authentication** and **authorization** along with several ubiquitous **protocols** that describe how to perform each of these processes securely on the web.

Web security is inherently a deep topic that spans across both the development and operations side of a system. As a result this chapter is rich with complex concepts and configurations you likely have not encountered before. Fortunately, we will manage this complexity by learning through hands-on application. 

While we will continue to direct our learning towards the operations side, later in this chapter you will get to work with the new development-side changes provided to you in the final branch of the API.

After learning the fundamentals of two security protocols, OAuth and OIDC, we will see how Azure can be used to implement them to manage interactions between our own applications and user accounts. The new Azure service, **Azure Active Directory Business to Customer (AADB2C)**, will be the primary focus of our learning. 

Because this chapter can be overwhelming we will use diagrams to help build the mental model of how it all works. Let's take a moment to consider what our system looks like currently:

.. diagram - postman (consumer), Azure[VM [API + DB]], API public pass through

Concepts & Terminology
======================

The following are the concepts and terms we will be using throughout this chapter. In the upcoming lessons we will continue to explore them in practical settings that will make them easier to relate to.

There are many moving parts to keep track of and at times it may seem overwhelming. However, these concepts are essential aspects of modern web development. Keep in mind that the goal of this chapter is not to become an expert but to gain a practical understanding.

If you get confused remember that everything we are doing relates back to these fundamentals.

Authentication
--------------

   **Authentication**: the process used by an entity to prove their identity
   
Authentication is a process used in both the physical and digital world. We use the term entity in our context to describe anything on the web that proves its identity as part of interactions with a server. An entity can be a an application user or even another server that interacts programmatically. 

A common example of authentication would be logging into your email account. When you make a request to log in the email provider server doesn't know who you are or what emails you are trying to access. This *interaction* begins with the email provider sending you a form to prove your identity.

You have to provide your *credentials*, an email address and a password, to prove your identity to your email provider before they *authorize you* to access your emails. This process of authenticating yourself is how trust is supported in an anonymous digital space. 

Authenticating using *known* credentials is certainly the most common form of authentication. But there are actually *multiple factors* of digital authentication that can be used:

- **Knowledge based**: *something you know* (credentials like a username and password)
- **Possession based**: *something you have* (`a digital certificate <https://www.ssl.com/faqs/what-is-an-x-509-certificate/>`_)
- **Inherent based**: *something you are* (a fingerprint or face unlock)
- **Location based**: *where you are* (geo-location coordinates)

.. admonition:: Note

   Interactions between applications and users can be made more secure by requiring **Multiple Factors of Authentication (MFA)**. You can learn more about MFA from `this Microsoft article <https://docs.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks>`_.

Authorization
-------------

   **Authorization**: the process of determining what a proven identity can access. 

As an example think about a user of a bank site. When the user proves their identity with their username and password (*authentication*) they **can access** (*authorized*) **their** account information. However they **cannot access** (*unauthorized*) any **other** user's information. 

.. admonition:: Note

   Understanding and correctly implementing Authentication and Authorization are imperative to the security of your application and business data. You can learn more with the `Microsoft Auth documentation <https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization>`_.

Azure Active Directory B2C
==========================

We will explore a new Azure service called...

At the end of this chapter this is what our system will look like:

.. diagram - with aadb2c and showing the flow from postman -> AADB2C and postman (with token) -> API

Key Terminology
---------------

In this class we will use Azure Active Directory Business to Customer (AADB2C) service as our Customer Identity Access Manager (CIAM). According to the `Microsoft AADBDC documentation <https://docs.microsoft.com/en-us/azure/active-directory-b2c/overview>`_,

   "[AADB2C is] capable of supporting millions of users and billions of authentications per day. It takes care of the scaling and safety of the authentication platform ..."

AADB2C provides identity as a service. It acts as a bridge between your application and the identity of a user that is shared from an **identity provider** like Microsoft, GitHub or a generic Email and password provider.

It uses a protocol called **OIDC** (built over OAuth) that allows for the exchange of user **identity tokens**. We will learn more about OAuth, OIDC and identity tokens in the upcoming lessons.

Afterwards, in the AADB2C walkthrough we will learn how it works by configuring it to manage Email-based identities for our Coding Events API.



AADB2C uses OIDC to provide a centralized authentication platform that enables `Single Sign On (SSO) <https://docs.microsoft.com/en-us/azure/active-directory-b2c/session-overview>`_. It stores user accounts in a **tenant directory** (an Active Directory instance) and uses:

- **OAuth**: for controlling access to applications that are registered in the tenant
- **OIDC**: for sharing user account identities with registered applications

Using AADB2C you can implement **User Flows** that bridge the gap between a user, an identity provider and your registered applications. Upon a successful authentication, the AADB2C service can send an Identity Token (OIDC) and, in most cases, an access token (OAuth) to your registered application.

.. admonition:: Note

   If you want to learn more about OAuth, OIDC and AADB2C the following videos are a great start:

   - `OAuth & OIDC explained simply by Nate Barbettini <https://www.youtube.com/watch?v=996OiexHze0>`_
   - `Microsoft AADB2C overview (YouTube) <https://www.youtube.com/watch?v=GmBKlXED9Ug>`_
