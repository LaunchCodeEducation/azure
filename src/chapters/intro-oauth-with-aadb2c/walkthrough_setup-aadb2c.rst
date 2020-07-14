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

Register an AADB2C Application
==============================

section: we setup AADB2C, we still have to register an application

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/10search-for-tenant-resource.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/11tenant-home.png

click on the Azure AD B2C Settings button (it's giant because it has an image)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/12tenant-portal.png

note: you are in the student-ADB2C directory (organization name of the tenant)

click on ``App Registration`` under the Manage header in the left sidebar

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/13new-registration.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/14new-app-registration-form-final.png

everything is default except for redirect URI

- redirect URI: https://jwt.ms

click ``Register`` to confirm

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/15app-dashboard.png

you will need the app ID

and the tenant ID

.. not sure which one, but the student will need one of app, or tenant ID

select ``Authentication`` under Management header

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/16grant-implicit-flow.png

everything default except ID tokens, access tokens!

select ID tokens under ``Implicit Grant``
select access tokens

go back to the app registrations

note:: checkout the breadcrumbs for easy access

.. :: comment

   YOU MUST DO THIS! will need new images

   legacy view allow implicit flow switch to true

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/17select-user-flows.png

.. :: comment

   maybe come back here for setting APP ID

   .. image:: 17!

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/18-new-user-flow-select.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/19select-susi-flow.png

#. name: coding-events-api-susi
#. select email sign-up
#. no MFA (default)
#. 

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
