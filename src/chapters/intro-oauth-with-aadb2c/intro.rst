
=============================
Introduction and Key Concepts
=============================

Until this point all of the endpoints of our Coding Events API have been *publicly accessible*. In this chapter we will introduce **authentication** and **authorization** along with several ubiquitous **protocols** that describe how to perform each of these processes securely on the web.

Web security is inherently a deep topic that spans across both development and operations. As a result this chapter is rich with complex concepts and configurations. Fortunately, we will manage this complexity by learning through hands-on application. 

We will learn the fundamentals of two *security protocols*: **Oauth** and **OIDC**. We will then learn how Azure can be used to implement them. We will spend a lot of time learning and configuring Azure Active Directory Business to Customer (**AADB2C**) which we will use to securely manage interactions between our applications and user accounts.

.. Because this chapter can be overwhelming we will use diagrams to help build the mental model of how it all works. Let's take a moment to consider what our system looks like currently:

.. diagram - postman (consumer), Azure[VM [API + DB]], API public pass through

Key Concepts
============

This article will introduce the abstract definitions of the key concepts of this chapter. In the upcoming lessons we will  explore the key concepts in more practical settings.

There are many moving parts to keep track of and at times it may seem overwhelming. However, these concepts are essential aspects of modern web development. 

.. admonition:: note

  Keep in mind that the goal of this chapter is not to become an expert but to gain functional experience and proficiency in common web security terminology.

Authentication
--------------

   **Authentication**: the process used by an entity to prove their identity
   
Authentication is a process used in both the physical and digital world. We use the term entity in our context to describe anything on the web that proves its identity as part of interactions with a server.

An entity can be a an application user or even another server that interacts programmatically. Any entity can authenticate as long as it has a means of *uniquely identifying itself to a system*.

A common example of authentication would be logging into your email account. When you make a request to log in the email provider server doesn't know who you are or what emails you are trying to access. This *interaction* begins with the email provider sending you a form to prove your identity.

You have to provide your *credentials*, an email address and a password, to prove your identity to your email provider before they *authorize you* to access your emails. This process of authenticating yourself is how trust is enabled in an anonymous digital space. 

Authentication Factors
^^^^^^^^^^^^^^^^^^^^^^

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

Any physical or digital resource (data) can be protected by *restricting access* to it. Only entities that are **authorized** to access the resource are permitted to do so. In the context of digital authorization, **access** means any actions (like reading or writing) that can be taken on a resource.

Authorization can refer to a specific permission or to the overall process of verifying a permission. In the digital world an **access control system** defines rules (**policies**). The policies are used for approving or denying access to a resource based on the authorization of the requestor.

.. admonition:: Note

  In most contexts it is understood that authorization is preceded by authentication. However, policies can also define how the resources in a system can be accessed by unauthenticated (*anonymous*) entities.

After an entity authenticates they are authorized to access certain resources based on the relationship between their identity and the resources. This type of authorization would use a policy that states the resources and actions the particular authenticated entity is allowed to perform.

.. admonition:: Tip

  In the previous Secrets Management chapter we created a Key Vault and added a secret to it. However, we also had to grant our Virtual Machine access to the Key Vault. 
  
  To grant access we had to explicitly state the VM had full access to the secrets in the Key Vault. The VM would not have access to any keys, or credentials in the Key Vault.

In the earlier example of checking your email your authorization was *implied* after authenticating. Because *you owned* the collection of emails (the resource) you were implicitly *authorized* to access them. Let's label each element in this scenario:

  - **resource**: your collection of emails
  - **consumer**: you (the authenticated user)
  - **policy**: authenticated users are *authorized to access* any collection of emails that they own

In more generalized terms we can refer to the core elements of authorization as:

  - **resource**: the data to be accessed (an image, video or other application data)
  - **consumer**: an entity that *tries to access* the resource
  - **policy**: one or more rules that define the authorization needed to access the resource

Server Roles
^^^^^^^^^^^^

On the web, a resource is managed by a **resource server** -- like the email provider in the earlier example. In simple cases the logic to enforce policies can be written within the resource server itself. The resource server can take responsibility for both managing resources as well handling authorization.

.. admonition:: Tip

  We label the different servers to indicate their role in the system. Although they may sound fancy they are just an API *with a specialized purpose*.
  
  Our Coding Events API is an example of a resource server because it specializes in managing the resources related to coding events.

Later in this chapter we will use Azure AD B2C as another specialized API called an **authorization server** to protect our API from unauthorized requests. An authorization server separates some or all of the authorization responsibility from the resource server.

In either design, access to resources is controlled by applying logical policy rules based on:
  
  - the resource
  - the consumer's identity
  - the consumer's relationship with the resource
  - what access to the resource is being requested

Access control systems can define policies associated with other consumer attributes beyond just ownership. For example, there could be policies based on the consumer's role in an organization or membership to a specific group.

.. admonition:: Tip

  If the authorization server determines the consumer is *unauthorized to access the resource* then it will send back a ``403 Forbidden`` response.

Delegation
----------

  **Delegation**: authorization for an entity to act on behalf of another

When a third party needs access to a resource the *authorization to do so must be granted* from the owner of the resource to the external entity. We say the third party is external because it *neither owns nor manages* the resource. The only way for the external entity to access the resource is to do so *on behalf of* the owner. 

Delegation is used when an application asks for the **consent** of a user (owner) to access a resource managed by another entity *on the owner's behalf*.

We refer to these entities as:

  - **client**: the *requesting entity* (the third party)
  - **resource owner**: the *consenting entity* (a user)

Delegation Between Two Entities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A common example of delegation between just these two entities is a desktop or mobile application requesting consent from a user to access some data on the device. For example, an application might request the photos *that are managed by* a user's device.

Because the user (resource owner) is in control of the device that manage the photos (resource) they are *in direct control* of the resource itself. This contrasts with a *remote resource* on the web where a user controls resources *indirectly through the resource server*.

Delegation Across Three Entities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When an entity *other than the resource owner* is in direct control of the resource we can refer to it generally as the **resource manager**. Because the resource owner is *not in direct control of the resource* they need a mechanism for granting the client authorization to access resource *on their behalf*.

Consider the process of opening a new credit card. Your credit score is a resource that you *manage indirectly* through a credit agency. The credit card company is *not authorized* to access your credit score without *proof of your permission*. As the *owner of the credit score resource* you can choose to *delegate authorization* to the credit card company or deny their request.

You can **grant permission** for the credit agency to share your score by *consenting to* the credit card company's request. The credit card company can then provide the physical or digital proof of your consent as a *token that authorizes them* to access your credit score. The credit agency accepts the token and authorizes the credit card company to access your data on your behalf.

Let's consider the three entities involved in the delegation of your credit score *resource*:

  - **resource manager**: the credit agency manages your credit score resource
  - **client**: the credit card company *requests authorization to access* your credit score
  - **resource owner**: you choose to *delegate authorization* for the client to access your credit score

In more general terms we can describe the entities involved in this delegation as:

  - **resource manager**: an entity that manages the owner's data
  - **client**: an entity that needs authorization to access an owner's data
  - **resource owner**: the entity that can authorize the resource manager to grant access to the client

OAuth & OIDC
------------

Delegation across these three entities on the web is slightly more complex due to the inherent anonymity. In order for the client to access the resources on behalf of the owner they need way to *assume the owner's identity*. A resource owner could provide their credentials to the client so it can authenticate as the owner but that would be terribly insecure!

The industry standard that enables the *secure delegation of access* across a resource owner, client and resource server is the **OAuth protocol**. 

.. admonition:: Note

  As mentioned previously the resource server can be, and often is, distinct from an authorization server that handles OAuth. Generally speaking we refer to the OAuth authorization server as an **OAuth provider** such as Microsoft, GitHub or LinkedIn.

In OAuth a user (resource owner) **delegates authorization** to a client through the use of a digital token. The client uses this **access token** to prove that they are authorized to access resources according to permissions granted by the user. If you have ever accepted a consent screen for a client service requesting access to your data on your behalf you were using OAuth!

OIDC
^^^^

We will also explore another protocol called **OIDC** which is built over OAuth. Rather than delegating authorization, OIDC is used to **delegate authentication** through the use of an **identity token**. This is another mechanism you have likely used before which allowed you to sign in to one service using *your identity* that was managed by another service.

Rather than carrying proof of authorization for a client, an identity token *proves the identity* of the user (the owner of the account resource). In relatable terms, OIDC is what enables `Single Sign On (SSO) <https://auth0.com/docs/api-auth/tutorials/adoption/single-sign-on>`_ on the web. SSO is what allows you to log in to many different client services using a single identity account. 

.. admonition:: Note

  Because OIDC is built over OAuth the authorization server provides both access and identity tokens depending on the type of request it receives. When an authorization server is exchanging an identity token it is sometimes referred to as an **identity provider**.

Learn More
==========

OAuth, OIDC and the Azure AD B2C service that we will use to implement them can be confusing to understand. While we will work with each of these in the upcoming lessons you can seek out other learning resources to help solidify your understanding. The following two videos offer a great overview and introduction to these protocols and AADB2C:

- `OAuth & OIDC explained simply by Nate Barbettini (YouTube) <https://www.youtube.com/watch?v=996OiexHze0>`_
- `Microsoft AADB2C overview (YouTube) <https://www.youtube.com/watch?v=GmBKlXED9Ug>`_

