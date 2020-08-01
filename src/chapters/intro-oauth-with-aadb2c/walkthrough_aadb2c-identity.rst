========================================================
Walkthrough: Set Up Azure ADB2C Tenant & Identity Tokens
========================================================

.. index:: ! tenant directory

Azure Active Directory B2C (AADB2C) is a service that manages user identities and coordinates their access across the different applications in your organization.  When provisioning an AADB2C service, Azure will create a **tenant directory**. 

The tenant directory is an Active Directory instance that centralizes user identities for a single sign on (SSO) experience across your organization. This means that a user can have a *single identity* they create and access through multiple identity providers like Microsoft, GitHub, or an email and password.

.. index:: ! user identity flow

Each AADB2C tenant uses **user identity flows**, or policies, that customize how a user registers and manages their identity in your organization. These user accounts can be used to authenticate and interact with your organization's registered applications. 

In this walkthrough, we will register the ``CodingEventsAPI`` application and create a user account in our AADB2C tenant directory. We will then inspect the **identity token** received after completing the OIDC flow for our registered API.

.. admonition:: Note

   Azure ADB2C is a multi-faceted service. In this walkthrough, we will focus only on the authentication configuration using identity tokens.  

   In the next walkthrough, we will extend this behavior to protect our registered API by configuring its own access tokens. We will use these tokens for authorization of requests sent from the Postman client application.

.. AADB2C can be used for **bi-directional authorization** with your organization's web applications. For example, if a user's identity is linked to a GitHub account your application can request their GitHub access token without ever communicating directly with GitHub. AADB2C would manage the OAuth exchange between the user and GitHub and provide the access token transparently to your application.

.. We say bi-directional because the inverse scenario can be used as well. AADB2C can be used to **protect access** to your applications through the use of *their own* access tokens. AADB2C abstracts the process of managing access tokens for other client applications to use on behalf of your tenant's users.

Components of AADB2C
====================

Checklist
=========

.. index:: SUSI flow

Setting up our AADB2C service will involve the following steps:

#. Create an AADB2C tenant directory.
#. Link the tenant directory to an active Azure subscription.
#. Register our ``CodingEventsAPI`` application.
#. configure a **sign up and sign in** (SUSI) flow using an email provider

After we have completed these steps, we will register an identity using the SUSI flow and inspect the resulting JWT (identity token). We will be using the Microsoft `JWT decoder tool <https://jwt.ms>`_ to verify the authenticity of and claims within the identity token.

.. admonition:: Note

   The screenshots for this walkthrough use the generic ``student`` name. 
   
   Anywhere you see ``<name>`` or ``student`` you should *replace with your name*.

Set Up AADB2C Tenant Directory
==============================

Create Tenant Directory
-----------------------

From the dashboard of the Azure Portal select the *Create a resource* button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/1create-resource.png
   :alt: Azure Portal create a resource

In the search box enter "Azure Active Directory B2C," then select *Create*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/2create-aadb2c.png
   :alt: Azure ADB2C marketplace service

Before linking to a subscription we have to create the tenant directory. Select the first choice:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/3create-aadb2c-tenant-dir.png
   :alt: AADB2C create new tenant

This will present the AADB2C creation form. Enter the following values:

- **Organization name**: ``<name> ADB2C`` (the tenant directory name)
- **Initial domain name**: ``<name>0720tenant`` (subdomain name of your tenant on the ``.onmicrosoft.com`` domain Azure provides)

.. admonition:: Note

   The pattern for the subdomain is: ``<name><MMYY>tenant``. To ensure the subdomains are unique, use the current month and year.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/4create-aadb2c-form1.png
   :alt: AADB2C create directory form

Select *Review and create* and confirm that your configuration matches the image below. Then create it.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/5create-aadb2c-form2.png
   :alt: AADB2C review configuration

Link Tenant Directory to Your subscription
------------------------------------------

The new tenant directory is *not* usable until it is linked to an active Azure subscription.

.. admonition:: Tip

   We will not discuss the relationship between Azure accounts, subscriptions, and directories. If you are curious, `this forum post has some great discussion and links to further reading <https://techcommunity.microsoft.com/t5/azure/understanding-azure-account-subscription-and-directory/td-p/34800>`_.

After creating the tenant directory, you can click the *Create new B2C Tenant or Link to existing Tenant* link in the upper-left breadcrumb links. If you are signed into Azure, you can `click this link <https://portal.azure.com/#create/Microsoft.AzureADB2C>`_ to navigate directly to it. 

The link will take you back to the initial AADB2C view. This time, select the second option to link the tenant:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/6link-to-existing-b2c-tenant.png
   :alt: AADB2C link subscription to tenant

The Subscription Linking form will require:

- The tenant (by its subdomain)
- The subscription to link the tenant to
- A resource group for containing the linked tenant resource

.. admonition:: Warning

   Make sure you select the correct subscription. This will be the Azure Labs Handout subscription that you received during initial registration, *not* your personal subscription.
   
   The subscription name will likely differ from the screenshot below.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/7subscription-linking-form.png
   :alt: AADB2C link subscription form

For the resource group, create a new one with the name ``adb2c-deploy-rg``. It will house both this linked tenant as well as the other resources we will provision in the upcoming studio deployment. 

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/8create-rg.png
   :alt: AADB2C link subscription form create Resource Group (RG)

Check that your form matches the image below *and* that you have chosen the Azure Labs Handout subscription, then you can create the link:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/9-create-final-review.png

Register & Configure an AADB2C Application
==========================================

Now that our AADB2C tenant is set up, we can register our ``CodingEventsAPI`` application. The AADB2C accounts we create exist as part of the tenant directory. Each application that is registered with the tenant directory allows it to integrate with the identities of those user accounts.

As a result, registering an application is a configuration that takes place *within* the tenant. For this reason we will need to switch to the tenant directory. 

Register the ``CodingEventsAPI`` application
--------------------------------------------

In the search bar at the top of the Azure Portal, enter ``<name>0720`` and select the tenant resource:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/10search-for-tenant-resource.png
   :alt: Azure Portal search for tenant resource

This will send you to the linked ADB2C tenant resource view:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/11tenant-home.png
   :alt: AADB2C tenant resource dashboard

Select the *Azure ADB2C Settings* icon. This will open a new tab in the tenant directory:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/12tenant-portal.png
   :alt: AADB2C tenant settings icon

.. admonition:: Tip

   In the top-right corner notice that *in this new tab* your Azure directory has been automatically switched. It should now say you are in the ``<Name> ADB2C`` tenant directory rather than your ``Default`` directory.

On the left sidebar, select the *App Registration* link. Then select *New Registration*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/13new-registration.png
   :alt: AADB2C tenant App Registrations

For this form, we will leave all of the default settings *except* for the following:

- **Name**: the name of our application, ``CodingEventsAPI``
- **Redirect URI**: where to redirect the user after authenticating: ``https://jwt.ms``

For the Redirect URI, we are using the URL of the Microsoft JWT tool. After authenticating and being redirected, the tool will automatically extract the identity token and provide a UI for inspecting it. 

Confirm that your configuration matches the screenshot below, then select *Register*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/14new-app-registration-form-final.png
   :alt: AADB2C tenant App Registration completed form

Configure the ``CodingEventsAPI`` Application Registration
----------------------------------------------------------

After registering, you will be sent to the ``CodingEventsAPI`` application dashboard. Each registered application will have its own dashboard like this one that allows you to configure it independently from the others.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/15app-dashboard.png
   :alt: ``CodingEventsAPI`` application registration dashboard

We need to configure this application to support the implicit grant OAuth flow for receiving the identity token of an authenticated user. In the left sidebar select the *Authentication* settings. 

We will leave all defaults except for the *Implicit grant* section. Scroll down to this section, then select both checkboxes to enable the implicit grant:

- *Access Tokens*
- *ID tokens*

Confirm that your configuration matches the screenshot below, then use the *Save* icon at the top:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/16grant-implicit-flow.png
   :alt: ``CodingEventsAPI`` application Authentication implicit grant settings

Before continuing to the next step, return to the tenant dashboard. You can use the *Azure AD B2C | App Registrations* breadcrumb link at the top as a shortcut.

Set Up the SUSI Flow
====================

.. index:: ! SUSI flow

The final step of our configuration is to set up a user flow for registering and authenticating users in our AADB2C tenant directory. We will be configuring a **Sign Up / Sign In (SUSI) flow** with an email provider to manage these identifies with an email and password. 

After users have created accounts in the tenant directory, our registered application (the ``CodingEventsAPI``) will be able to use their identities.

A user flow (or identity flow) allows you to customize the user *processes* for interacting with their AADB2C account. This includes creating an account and signing in or out. 

.. index:: claim

For each user flow, you can configure:

- The identity provider(s) that the flow will allow
- The appearance of the AADB2C account UI (like a registration form)
- The **claims** collected during registration and returned in the identity tokens

Each flow can specify the claims (user attributes) that need to be *collected* from the user during registration and *returned* in the identity token. 

Claims are used to standardize the identity data that is collected across the identity providers used in a flow. Some examples of claims include common built-in claims like:

- ``Job Title``
- ``Legal Age Group Classification``

You can also define `custom claims <https://docs.microsoft.com/en-us/azure/active-directory-b2c/user-profile-attributes>`_ that apply to more specific use cases.

In the left sidebar of the tenant dashboard, switch from App Registrations by selecting the *User Flows* option under *Policies*.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/17select-user-flows.png
   :alt: AADB2C tenant dashboard select user flows configuration

Create a SUSI flow
------------------

In the user flows view, select *New User Flow*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/18-new-user-flow-select.png
   :alt: AADB2C user flows select new User flow

Then select the recommended *Sign up and sign in* (SUSI) flow template:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/19select-susi-flow.png
   :alt: select SUSI user flow template

This will present the SUSI flow form. As mentioned previously, we will allow users to register using the generic email provider.

.. admonition:: Note

   The email provider is available by default. Additional providers can be configured in the *Identity Providers* settings on the left sidebar. After they are configured, they will be available for use in creating or editing your tenant's user flows. 

   .. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/fluff-2-identity-providers-show.png
      :alt: Identity provider settings view
   
For the top half of the form (steps 1-3) configure the following settings:

#. **Name**: after the ``B2C_1_`` prefix enter ``susi-flow``
#. **Providers**: we will use the ``email signup`` provider
#. **MFA**: leave ``disabled``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/20susi-flow-steps1-3.png
   :alt: SUSI flow steps 1-3 completed

Scrolling down to the bottom half of the form, you will see a section for configuring the claims. Claims are separated into **collected** (during registration) and **returned** (in the identity token).

For our SUSI flow we will use the following **collected claims**:

- ``Display Name`` (username)
- ``Email Address``

And the following **returned claims**:

-  ``Display Name``
-  ``Email Addresses``
-  ``User's Object ID``

.. admonition:: Note

   The ``User's Object ID`` (**OID** field) is the unique identifier for each user within the AADB2C tenant. It can be found at the *end* of the claims sidebar.

Click the *Show More* link to open the full claims selection panel. Select each collected and returned claim, then close the panel. 
   
.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/22show-more-user-attributes-form1.png
   :alt: SUSI flow claims sidebar (top)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/23show-more-user-attributes-form2.png
   :alt: SUSI flow claims sidebar (bottom with OID)

After setting the claims you can *Create* the SUSI flow. This will send you back to the user flows view:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/25after-flow-created.png
   :alt: user flows settings view with new SUSI flow

Test the User Flow
==================

Our final step is to test out the SUSI flow we created. We will register our first user accounts in the new AADB2C tenant using this flow. After registering, we will inspect the identity token and the returned claims that were included in it.

From the user flows view, select the new flow, ``B2C_1_susi-flow``. This will take you to the SUSI flow dashboard where you can modify and test the flow:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/26flow-dashboard.png
   :alt: SUSI flow dashboard view

.. admonition:: Note

   For our purposes, we used the built-in claims and default UI styling provided by AADB2C. However, from this dashboard you can modify the flow's:

   - Identity providers (to add additional providers like Microsoft or GitHub)
   - User attributes (previously referred to as collected claims)
   - Application claims (previously referred to as the returned claims)
   - `Page layouts <https://docs.microsoft.com/en-us/azure/active-directory-b2c/customize-ui-overview>`_ (the styling of the UI)

Run the SUSI flow
-----------------

In the top-left corner of the SUSI flow dashboard, select the *Run user flow* button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/27run-user-flow.png
   :alt: SUSI flow dashboard Run user flow button

This will open the flow sidebar panel:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/28run-user-flow-sidebar.png
   :alt: SUSI flow sidebar panel to configure and initiate the flow

At the top of the panel you will see the `OIDC metadata URL <https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc#fetch-the-openid-connect-metadata-document>`_. 

.. admonition:: Note

   This document provides metadata with the OIDC endpoints for using the AADB2C identity management service. Although it is human-readable, it is meant for programmatic access by applications to integrate into the AADB2C system.

The run flow panel allows you to test out the flow with a specific application and reply (redirect) URL. In our case, we only have a single application and reply URL to choose from. Select the **Run user flow** button to open a new tab with the AADB2C tenant login page:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/29user-flow-auth-form.png
   :alt: AADB2C login page

Register a User Account
-----------------------

Initially, the AADB2C tenant directory will not have any user accounts in it. Let's create a new account by selecting the *Sign up now* link at the bottom. 

You will need to provide *and* verify your email address. 

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/30signup-email.png
   :alt: AADB2C registration email verification

Azure will email you a temporary verification code which you need to enter:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/31-signup-email-verification-code.png
   :alt: AADB2C enter email verification code

After verifying your email address, you need to provide a username and password. The password has default security constraints that require a relatively complex value:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/32signup-email-password-requirements.png
   :alt: AADB2C password constraints

As with other passwords in this course, we will all use the same one to make troubleshooting more consistent:

- **Password**: ``LaunchCode-@zure1``

The username field is presented because we chose the ``Display Name`` collected field when configuring the SUSI flow. You can enter your name here (in place of ``student`` in the screenshot):

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/33signup-email-final.png
   :alt: AADB2C registration final form

After registering you will be *redirected* to the redirect URL (``https://jwt.ms``). This tool will capture the JWT identity token and decode it for inspection.

Inspect the identity token
--------------------------

Congratulations! You now have your first managed user identity.

As a reminder, the redirect will provide the identity token as a query parameter (``id-token``) which you can view in the URL bar. The Microsoft JWT tool will automatically extract this token from the URL and decode it.

From within the tool, you can view the decoded JWT:

- **Header**: highlighted in red
- **Payload**: highlighted in purple
- **Signature**: highlighted in green

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/34final-token.png
   :alt: decoded identity token

Selecting the *Claims* tab will switch to a breakdown of the claims in the payload. For each claim, you can view a description of its meaning and usage:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/35final-token-claims.png
   :alt: decoded identity token claims

Notice that these claims describe the relationship between the user (you), the AADB2C tenant (the identity manager), and the registered application that receives the token:

- **iss[uer]**: the AADB2C tenant is the *issuer* of the identity token while behaving (in this context) as the identity management server
- **sub[ject]**: the subject of the token is your OID (unique identifier of your account in the AADB2C tenant directory)
- **aud[ience]**: the audience, or *intended recipient*, of the token is the ``CodingEventAPI`` application identifier (Client ID)
