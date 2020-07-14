=====================================
Walkthrough: Setup Azure ADB2C Tenant
=====================================

In this walkthrough we will set up our own identity manager using Azure. The Azure Active Directory B2C (AADB2C) service abstracts away the complexity of setting up and managing a central authentication authority. It allows us to support any number of identity providers (like Microsoft, LinkedIn or GitHub) to connect users to our applications.

In our case we will set up AADB2C using an Email Provider (a generic identity tied to an email address). As an identity management service, AADB2C uses the OIDC protocol that will provide an **identity token** to our application after a user registers or authenticates with their email and password.

When you provision an AADB2C service Azure will create a **tenant directory**. The tenant directory represents the authentication authority *for your entire organization*. Within the tenant you can **register applications** (like our Coding Events API) and configure **identity flows** that users utilize to connect with the registered applications. 

The identity flows allow you to customize the user experience *flows* like creating an account (identity) and signing in or out. Each flow can specify the **claims** (identity fields) that need to be collected from the user and provided in the identity token. We will be configuring a Sign Up / Sign In **(SUSI) flow** for our API users to register and access members-only endpoints.  

Checklist
=========

Setting up our AADB2C authority will involve the following steps:

#. create an AADB2C tenant directory
#. link the tenant directory to an active Azure Subscription
#. register our Coding Events API application
#. configure a SUSI flow using an Email provider

After we have completed these steps we will register an identity, test out the SUSI flow and inspect the resulting JWT (identity token). We will be using the Microsoft `JWT decoder tool <https://jwt.ms>`_ to verify the authenticity of and claims within the identity token.

.. admonition:: note

   The screenshots for this walkthrough use the generic ``student`` name. 
   
   Anywhere you see ``<name>`` or ``student`` you should **replace with your name.**

Set Up AADB2C Tenant Directory
==============================

Create Tenant Directory
-----------------------

From the dashboard of the Azure Portal select the **Create a resource** button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/1create-resource.png
   :alt: Azure Portal create a resource

In the search box enter: ``Azure Active Directory B2C`` then select **create**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/2create-aadb2c.png
   :alt: Azure ADB2C marketplace service

Before linking to a Subscription we have to create the tenant directory, select the first choice:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/3create-aadb2c-tenant-dir.png
   :alt: AADB2C create new tenant

This will present the AADB2C creation form. Enter the following values:

- **Organization name**: ``<name> ADB2C`` (the tenant directory name)
- **Initial domain name**: ``<name>0720tenant`` (subdomain name of your tenant on the ``.onmicrosoft.com`` domain Azure provides)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/4create-aadb2c-form1.png
   :alt: AADB2C create directory form

Select **Review and create** and confirm that your configuration matches the image below. Then create it.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/5create-aadb2c-form2.png
   :alt: AADB2C review configuration

Link tenant directory to your Subscription
------------------------------------------

The new tenant directory is **not usable** until it is linked to an active Azure Subscription.

.. admonition:: tip

   We will not dicuss the relationship between Azure accounts, Subscriptions, and directories. If you are curious, look over  `this forum post has some great discussion and links to further reading <https://techcommunity.microsoft.com/t5/azure/understanding-azure-account-subscription-and-directory/td-p/34800>`_.

After creating the tenant directory you can click the ``Create new B2C Tenant or Link to existing Tenant`` link in the upper-left breadcrumb links. If you are signed into Azure you can `click this link <https://portal.azure.com/#create/Microsoft.AzureADB2C>`_ to navigate directly to it. 

The link will take you back to the initial AADB2C view. This time select the second option to link the tenant:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/6link-to-existing-b2c-tenant.png
   :alt: AADB2C link subscription to tenant

The Subscription linking form will require:

- the tenant (by its subdomain)
- the Subscription to link the tenant to
- a RG for containing the linked tenant directory

.. admonition:: warning

   Make sure you select the correct Subscription. This will be the Azure Labs *Subscription Handout* that you received during initial registration, **not your personal Subscription**. The Subscription name will likely differ from the screenshot below.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/7subscription-linking-form.png
   :alt: AADB2C link Subscription form

For the RG create a new one with the name ``adb2c-deploy-rg``. It will house both this linked tenant as well as the other resources we will provision in the upcoming Studio deployment. 

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/8create-rg.png
   :alt: AADB2C link Subscription form create Resource Group (RG)

Check that your form matches the image below **and that you have chosen the Azure Labs Handout Subscription**, then you can **create** the link:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/9-create-final-review.png

Register & Configure an AADB2C Application
==========================================

Now that our AADB2C tenant is set uup we can register our Coding Events API application. Registering an application is a configuration that takes place *within the tenant*. For this reason we will need to **switch to the tenant directory**. 

Register the Coding Events API application
------------------------------------------

In the search bar at the top of the Azure Portal enter: ``<name>0720`` and select the tenant resource:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/10search-for-tenant-resource.png
   :alt: Azure Portal search for tenant resource

This will send you to the linked ADB2C tenant resource view:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/11tenant-home.png
   :alt: AADB2C tenant resource dashboard

Select the **Azure ADB2C Settings** icon. This will open a **new tab in the tenant directory**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/12tenant-portal.png
   :alt: AADB2C tenant settings icon

.. admonition:: tip

   In the top-right corner notice that **in this new tab** your Azure directory has been automatically switched. It should now say you are in the ``<Name> ADB2C`` tenant directory rather than your ``Default`` directory.

On the left sidebar select the **App Registration** link. Then select **New registration**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/13new-registration.png
   :alt: AADB2C tenant App Registrations

For this form we will **leave all of the default settings** except for the following:

- **Name**: the name of our application, ``Coding Events API``
- **Redirect URI**: where to redirect the user after authenticating, ``https://jwt.ms``

For the Redirect URI we will provide the URL of the Microsoft JWT tool. After authenticating and being redirected, the tool will automatically extract the identity token and provide a UI for inspecting it. 

Confirm that your configuration matches the screenshot below, then select **Register**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/14new-app-registration-form-final.png
   :alt: AADB2C tenant App Registration completed form


Configure the Coding Events API application registration
--------------------------------------------------------

After registering you will be sent to the Coding Events API application dashboard. Each registered application will have its own dashboard like this one that allows you to configure it independently from the others.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/15app-dashboard.png
   :alt: Coding Events API application registration dashboard

We will need to configure this application to support the **implicit grant OAuth flow** for receiving the identity token of an authenticated user. In the left sidebar select the **Authentication** settings. 

We will leave all defaults except for the **Implicit grant** section. Scroll down to this section then select both checkboxes to enable the implicit grant:

- **Access Tokens**
- **ID tokens**

Confirm your configuration matches the screenshot below then use the **Save** icon at the top:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/16grant-implicit-flow.png
   :alt: Coding Events API application Authentication implicit grant settings

Before continuing to the next step, return to the tenant dashboard. You can use the ``Azure AD B2C | App Registrations`` breadcrumb link at the top as a shortcut.

Set Up the SUSI Flow
====================

The final step of our configuration is to set up a User Flow (SUSI) for registering and authenticating users. User Flows can be configured 

.. admonition:: tip

   User flows are configured **independently from registered applications**. Flows can be *reused* across any number of applications within the organization **that share the same flow requirements**.

   For our purposes we will customize a user flow specific to our Coding Events API application.

In the left sidebar of the **tenant dashboard** switch from App Registrations by selecting the **User Flows** option under *Policies*.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/17select-user-flows.png
   :alt: AADB2C tenant dashboard select User Flows configuration

Create a SUSI flow
------------------

A User 

In the User Flows view select **New User flow**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/18-new-user-flow-select.png
   :alt: AADB2C User Flows select new User flow

Then select the recommended **Sign up and sign in** (SUSI) flow template:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/19select-susi-flow.png
   :alt: select SUSI User Flow template

This will present the SUSI flow form. As mentioned previously we will allow users to register using the generic Email provider.

.. admonition:: note

   The Email provider is available by default. Additional providers can be configured in the **Identity providers** settings on the left sidebar. After they are configured they will be available for use in creating or editing your tenant's User Flows. 

   .. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/fluff-2-identity-providers-show.png
      :alt: Identity provider settings view
   
For the top half of the form (steps 1-3) configure the following settings:

#. **Name**: after the ``B2C_1_`` prefix enter ``coding-events-api-susi``
#. **Providers**: we will use the ``Email signup`` provider
#. **MFA**: leave ``disabled``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/20susi-flow-steps1-3.png

.. note:: click show more

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/21show-more-sidebar.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/22show-more-user-attributes-form1.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/23show-more-user-attributes-form2.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/24create-susi-flow-form-final.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/25after-flow-created.png

click on the created flow

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/26flow-dashboard.png

.. :: comment great place for fluff if we need it a note that says click through here and you can add new ID providers and set attributes

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/27run-user-flow.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/28run-user-flow-sidebar.png

.. :: 

   comment: grab the link as students may need to add that to their source code in studio 

   - link JWTAADB2C metadata address in app settings
   - metadata link: https://student0720tenant.b2clogin.com/student0720tenant.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_coding-events-api-susi
   - authorization URL: https://student0720tenant.b2clogin.com/student0720tenant.onmicrosoft.com/oauth2/v2.0/authorize?p=b2c_1_coding-events-api-susi

click run user flow

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/29user-flow-auth-form.png

your app won't have any users to start so you will have to register one -- this is just like any registration you've used before

click sign up now

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/30signup-email.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/31-signup-email-verification-code.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/32signup-email-password-requirements.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/33signup-email-final.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/34final-token.png

.. :: comment: https://docs.microsoft.com/en-us/azure/active-directory-b2c/tokens-overview summarizes all the tokens link to it, or describe some of it

.. :: comment: link to OIDC https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect

.. :: comment: implicit flow link: https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application

.. :: comment: best practices: https://docs.microsoft.com/en-us/azure/active-directory-b2c/best-practices
