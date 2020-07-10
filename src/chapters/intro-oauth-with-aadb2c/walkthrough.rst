=====================================
Walkthrough: Setup Azure ADB2C Tenant
=====================================

.. the provider is still someone else (MS, Google, Twitter, etc)

.. image:: 1

.. image:: 2

.. image:: 3

.. image:: 4

.. image:: 5

link to ``Create new B2C Tenant or Link to existing Tenant`` which takes them to the next pic

.. image:: 6

note: select link to existing!

.. image:: 7

warning: make sure your subscription matches the lab handout name

.. image:: 8 create-rg

.. image:: 9 create-final

note: click the create button

section: we setup AADB2C, we still have to register an application

.. image:: 10 search-for-tenant-resource

.. image:: 11 tenant-home

click on the Azure AD B2C Settings button (it's giant because it has an image)

.. image:: 12 tenant-portal

note: you are in the student-ADB2C directory (organization name of the tenant)

click on ``App Registration`` under the Manage header in the left sidebar

.. image:: 13 new-registration

.. image:: 14 new-registration-form-final

everything is default except for redirect URI

- redirect URI: https://jwt.ms

click ``Register`` to confirm

.. image:: 15 app-dashboard (Coding Events API)

you will need the app ID

and the tenant ID

.. not sure which one, but the student will need one of app, or tenant ID

select ``Authenticaion`` under Management header

.. image:: 16 grant-implicit-flow

everything default execpt ID tokens, access tokens!

select ID tokens under ``Implicit Grant``
select access tokens

go back to the app registrations

note:: checkout the breadcrumbs for easy access

.. :: comment

   YOU MUST DO THIS! will need new images

   legacy view allow implicit flow switch to true

.. image:: 17 select user flows

.. :: comment

   maybe come back here for setting APP ID

   .. image:: 17!

.. image:: 18 new-user-flow-select

.. image:: 19 select-susi-flow

#. name: coding-events-api-susi
#. select email sign-up
#. no MFA (default)
#. 

.. image:: 20 susi-flow-steps1-3

.. note:: click show more

.. image:: 21 show-more-sidebar

.. image:: 22 show-more-user-attributes-form1

.. image:: 23 show-more-user-attributes-form2

.. image:: 24 create-susi-flow-form-final

.. image:: 25 after-flow-created

click on the created flow

.. image:: 26 flow-dashboard

.. :: comment great place for fluff if we need it a note that says click through here and you can add new ID providers and set attributes

.. image:: 27 run-user-flow

.. image:: 28 run-user-flow-sidebar

.. :: comment grab the link as students may need to add that to their sourcecode in studio

click run user flow

.. image:: 29 user-flow-auth-form

your app won't have any users to start so you will have to register one -- this is just like any registration you've used before

click sign up now

.. image:: 30 signup-email

.. image:: 31 signup-email-verification-code

.. image:: 32 signup-email-password-requirements

.. image:: 33 singup-email-final

.. image:: 34 final-token

.. :: comment: https://docs.microsoft.com/en-us/azure/active-directory-b2c/tokens-overview summarizes all the tokens link to it, or describe some of it

.. :: comment: link to OIDC https://docs.microsoft.com/en-us/azure/active-directory-b2c/openid-connect

.. :: comment: implicit flow link: https://docs.microsoft.com/en-us/azure/active-directory-b2c/implicit-flow-single-page-application

.. :: comment: best practices: https://docs.microsoft.com/en-us/azure/active-directory-b2c/best-practices


.. ::

   how the labs work

   - need to be in their default directory
   - whenever they provision something they must use their HANDOUT subscription
      - HANDOUT subscription is defined as the lab assignment

   - * Whatever you call the HANDOUT that's what becomes their subscription that students should use

   - when adding a student to a lab the handout name is set per student, and the handout is the subscription students should use eto provision resources

   - top right corner and select (switch directory) they have a subscription filter if they unselect everything execpt their handout subscription that will become their default


