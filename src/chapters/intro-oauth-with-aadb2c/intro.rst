
=============================
Introduction and Key Concepts
=============================

Up until this point all of the endpoints of our Coding Events API have been *publicly accessible*. In this chapter we will introduce **authentication** and **authorization** along with several ubiquitous **protocols** that describe how to perform each of these processes securely on the web.

Web security is inherently a deep topic that spans across both the development and operations side of a system. As a result this chapter is rich with complex concepts and configurations you likely have not encountered before. Fortunately, we will manage this complexity by learning through hands-on application. 

While we will continue to direct our learning towards the operations side, later in this chapter you will get to work with the new development-side changes provided to you in the final branch of the API.

After learning the fundamentals of two *security protocols*, **OAuth** and **OIDC**, we will see how Azure can be used to implement them. Azure Active Directory Business to Customer (**AADB2C**) will be our primary learning focus in this chapter. We will learn how to use it to securely manage interactions between our own applications and user accounts.

.. Because this chapter can be overwhelming we will use diagrams to help build the mental model of how it all works. Let's take a moment to consider what our system looks like currently:

.. diagram - postman (consumer), Azure[VM [API + DB]], API public pass through

Key Concepts
============

The following are the essential concepts and terms we will be using throughout this chapter. While others will be introduced they will all be related to these fundamentals. In the upcoming lessons we will move beyond abstract definitions and explore them in practical settings to make them easier to relate to.

There are many moving parts to keep track of and at times it may seem overwhelming. However, these concepts are essential aspects of modern web development. 

Keep in mind that the goal of this chapter is not to become an expert but to gain functional experience and proficiency in common web security terminology. If you get confused remember that everything we are doing relates back to these fundamentals.

Authentication
--------------

   **Authentication**: the process used by an entity to prove their identity
   
Authentication is a process used in both the physical and digital world. We use the term entity in our context to describe anything on the web that proves its identity as part of interactions with a server.

An entity can be a an application user or even another server that interacts programmatically. Any entity can authenticate as long as it has a means of *uniquely identifying itself to a system*.

A common example of authentication would be logging into your email account. When you make a request to log in the email provider server doesn't know who you are or what emails you are trying to access. This *interaction* begins with the email provider sending you a form to prove your identity.

You have to provide your *credentials*, an email address and a password, to prove your identity to your email provider before they *authorize you* to access your emails. This process of authenticating yourself is how trust is supported in an anonymous digital space. 

Authenticating using *something you know* like credentials is certainly the most common form of authentication. But there are actually *multiple factors of authentication* in the digital world that can be used:

- **Knowledge based**: *something you know* (credentials like a username and password)
- **Possession based**: *something you have* (`a digital certificate <https://www.ssl.com/faqs/what-is-an-x-509-certificate/>`_)
- **Inherent based**: *something you are* (a fingerprint or facial topography)
- **Location based**: *where you are* (geo-location coordinates)

.. admonition:: Note

   Digital interactions can be made more secure by requiring multiple factors of authentication. You can learn more about multi-factor authentication (**MFA**) from `this Microsoft article <https://docs.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks>`_.

Authorization
-------------

   **Authorization**: the permission needed to access a protected resource

Any physical or digital resource can be protected by *restricting access* to it. Only entities that are *granted permission*, or *authorized*, to access the resource are allowed to do so. In the context of digital authorization, **access** means any actions (like reading or writing) that can be taken on a resource. 

Authorization can refer to a permission itself or more broadly to the overall process of verifying a permission. In the digital world an **access control system** define the rules, or **policies**, used for approving or denying access to a resource based on the authorization of the requestor.

.. admonition:: Note

  In most contexts it is understood that authorization is preceded by authentication. However, an organization can also define rules for how the resources in their system can be accessed by *anonymous*, or unauthenticated, entities.

In the simplest case authorization is implied by authentication. After an entity authenticates, or proves their identity, they are authorized to access certain resources based on their identity alone. This sort of authorization would use a policy that states the resources and actions the authenticated entity is allowed to perform.

In the earlier example of checking your email your authorization was *implied* after authenticating. Because *you owned* the collection of emails (the resource) you were *authorized* to access them:

- **resource**: your collection of emails
- **consumer**: you (the authenticated user)
- **policy**: authenticated users are *authorized to access* any collection of emails that they own

In more generalized terms we can refer to the core elements of authorization as:

- **resource**: the subject of an action
- **consumer**: an entity that *tries to access* the resource
- **policy**: one or more rules that define the authorization needed to take an action on the resource

In web development the logic to enforce policies is written in an application server. This server programmatically controls access to resources by applying policy rules relevant to the consumer's request for access. If the server determines the consumer is *unauthorized to access the resource* then it will send back a ``403, Forbidden`` response.

Delegation
----------

  **Delegation**: the act of one entity authorizing resource access to another entity

In more complex cases authorization to access a resource can be *delegated* to another entity. Delegation is used when three entities need to coordinate authorization for accessing a resource.

Consider the process of opening a new credit card. Your credit score is a resource managed by a credit agency. The credit card company is *not authorized* to access your credit score without *your permission*. As the *owner of the credit score resource* you have choose to *delegate authorization* to the credit card company or deny their request.

You can accept the request by notifying the credit agency that you would like to *delegate access* of your credit score to the credit card company. Afterwards the credit agency will *authorize the credit card company to access* the credit score *on your behalf*. 

Let's consider the three entities involved in the delegation of your credit score *resource*:

- **provider**: the credit agency manages your credit score resource
- **client**: the credit card company *requests authorization to access* your credit score
- **resource owner**: you choose to *delegate authorization* for the client to access your credit score

In more general terms we can describe the entities involved in delegated authorization:

- **provider**: an entity that manages the resource
- **client**: an entity that needs authorization to access a resource
- **resource owner**: the entity that authorizes the provider to grant access to the resource with the client

Much of this chapter will revolve around the **OAuth protocol** which defines a series of steps a user can take to **securely delegate authorization of access** to their provider resources with a client. If you have ever accepted a consent screen for a service requesting access to your data you were using OAuth!

.. admonition:: Note

..   We will also explore another protocol called **OIDC** which is built over OAuth. Rather than delegating authorization, OIDC is used to **delegate authentication**. This is another mechanism you have likely used before which allowed you to sign in to one service using *your identity* that was managed by another service.

.. Azure Active Directory B2C
.. ==========================

.. We will explore a new Azure service called...

.. At the end of this chapter this is what our system will look like:

.. .. diagram - with aadb2c and showing the flow from postman -> AADB2C and postman (with token) -> API

.. Key Terminology
.. ---------------

.. In this class we will use Azure Active Directory Business to Customer (AADB2C) service as our Customer Identity Access Manager (CIAM). According to the `Microsoft AADBDC documentation <https://docs.microsoft.com/en-us/azure/active-directory-b2c/overview>`_,

..    "[AADB2C is] capable of supporting millions of users and billions of authentications per day. It takes care of the scaling and safety of the authentication platform ..."

.. AADB2C provides identity as a service. It acts as a bridge between your application and the identity of a user that is shared from an **identity provider** like Microsoft, GitHub or a generic Email and password provider.

.. It uses a protocol called **OIDC** (built over OAuth) that allows for the exchange of user **identity tokens**. We will learn more about OAuth, OIDC and identity tokens in the upcoming lessons.

.. Afterwards, in the AADB2C walkthrough we will learn how it works by configuring it to manage Email-based identities for our Coding Events API.



.. AADB2C uses OIDC to provide a centralized authentication platform that enables `Single Sign On (SSO) <https://docs.microsoft.com/en-us/azure/active-directory-b2c/session-overview>`_. It stores user accounts in a **tenant directory** (an Active Directory instance) and uses:

.. - **OAuth**: for controlling access to applications that are registered in the tenant
.. - **OIDC**: for sharing user account identities with registered applications

.. Using AADB2C you can implement **User Flows** that bridge the gap between a user, an identity provider and your registered applications. Upon a successful authentication, the AADB2C service can send an Identity Token (OIDC) and, in most cases, an access token (OAuth) to your registered application.

.. .. admonition:: Note

..    If you want to learn more about OAuth, OIDC and AADB2C the following videos are a great start:

..    - `OAuth & OIDC explained simply by Nate Barbettini <https://www.youtube.com/watch?v=996OiexHze0>`_
..    - `Microsoft AADB2C overview (YouTube) <https://www.youtube.com/watch?v=GmBKlXED9Ug>`_
