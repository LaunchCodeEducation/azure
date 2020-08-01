==================================
OAuth & Azure Active Directory B2C
==================================

.. :: comment: diagrams in intros how adding in this thing affects the greater system

Authentication
==============

.. index:: ! authentication

**Authentication** is the process of proving identity.

An example is logging into your email. You must provide your email address and a password to prove your identity.

There are multiple aspects of authentication. The three most common are:

- **Knowledge based**: something you *know* (a username and password)
- **Possession based**: something you *have* (`a digital certificate <https://www.ssl.com/faqs/what-is-an-x-509-certificate/>`_)
- **Inherent based**: something you *are* (a fingerprint or face unlock)
- **Location based**: *where* you are (geo-location coordinates)

.. index::
   :single: authentication; multi-factor

.. admonition:: Note

   An application can be made more secure by requiring **multiple factors for authentication (MFA)**. Learn more about `MFA from Microsoft <https://docs.microsoft.com/en-us/azure/active-directory/authentication/concept-mfa-howitworks>`_.

Authorization
=============

.. index:: ! authorization

**Authorization** is the process of determining which resources a proven identity can access. 

As an example, think about a user of a banking site. When the user proves their identity with their username and password (i.e. they are authenticated), they can *access* (i.e. they are authorized) *their* account information. However they *cannot* access (i.e. they are unauthorized) any *other* user's information. 

.. admonition:: Note

   Understanding and correctly implementing authentication and authorization are imperative to the security of your application and business data. You can learn more from the `Microsoft auth documentation <https://docs.microsoft.com/en-us/azure/active-directory/develop/authentication-vs-authorization>`_.

OAuth
=====

.. index:: ! OAuth

**OAuth** is a mechanism for a user to *securely* share access to their data that exists on one service with another service. 

For example, when you are registering for a Spotify account you can choose to create it using your Facebook account. First you *authenticate* with Facebook. Then you *grant access* to your Facebook profile data so Spotify can create a profile using that information. 

OAuth can also be used to grant *management access* of your data between services. If you allow Spotify to *manage* your Facebook data it can automatically post the music you are listening to *on your behalf*.

.. admonition:: Note

   The upcoming walkthrough will explore how OAuth works from a more detailed perspective. If you require more information, take a look at the `Microsoft OAuth technical guide <https://docs.microsoft.com/en-us/advertising/guides/authentication-oauth?view=bingads-13>`_.

Azure Active Directory B2C
==========================

In this class, we will use the Azure Active Directory Business to Customer (AADB2C) service as our customer Identity access manager (CIAM). According to the `Microsoft AADBDC documentation <https://docs.microsoft.com/en-us/azure/active-directory-b2c/overview>`_,

   [AADB2C is] capable of supporting millions of users and billions of authentications per day. It takes care of the scaling and safety of the authentication platform...

.. index:: ! identity provider

AADB2C provides identity as a service. It acts as a bridge between your application and the identity of a user that is shared from an **identity provider** like Microsoft, GitHub or a generic email and password provider.

.. index:: ! OIDC, ! identity tokens

It uses a protocol called **OIDC** (built over OAuth) that allows for the exchange of user **identity tokens**. We will learn more about OAuth, OIDC and identity tokens in the upcoming lessons.

Afterwards, in the AADB2C walkthrough, we will learn how it works by configuring it to manage email-based identities for our ``CodingEventsAPI``.
