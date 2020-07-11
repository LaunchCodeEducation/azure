=====================================
Walkthrough: Setup Azure ADB2C Tenant
=====================================

.. the provider is still someone else (MS, Google, Twitter, etc)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/1directory-subscription.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/2create-resource.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/3create-aadb2c.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/4create-aadb2c-form1.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/5create-aadb2c-form2.png

link to ``Create new B2C Tenant or Link to existing Tenant`` which takes them to the next pic

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/6link-to-existing-b2c-tenant.png

note: select link to existing!

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/7subscription-linking-form.png

warning: make sure your subscription matches the lab handout name

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/8create-rg.png

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough/9-create-final-review.png

note: click the create button

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

.. :: comment: best practices: https://docs.microsoft.com/en-us/azure/active-directory-b2c/best-practices
