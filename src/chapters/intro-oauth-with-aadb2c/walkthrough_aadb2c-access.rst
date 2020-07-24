===============================================================
Walkthrough: Set Up Access Token Authorization with Azure ADB2C
===============================================================

In the previous walkthrough we created our AADB2C tenant and configured an identity token flow. These steps enabled our Coding Events API to integrate with AADB2C as an identity manager using OIDC to **authenticate the identity** of our application's users.

In this walkthrough we will explore the other half of AADB2C -- protecting applications using access tokens. Recall that we can use OAuth access tokens as a means of **delegating authorization** for one service to act on behalf of a user when interacting with another service.

Our goal is to configure AADB2C to grant access tokens to a client application (Postman) with a **scope** that **authorizes** it to interact with a protected application (Coding Events API) **on behalf of a user**. To accomplish this task we will need to:

#. Configure a ``user_impersonation`` scope for accessing the Coding Events API
#. Register the Postman client application
#. Configure the Postman client application to request access tokens with the ``user_impersonation`` scope
#. Configure Postman to request access tokens for interacting with the Coding Events API on behalf of an authenticated AADB2C user

In the following Studio you will then update your Coding Events API source code to integrate with AADB2C. Then you will use Postman and an access token to make authorized requests to the final version of the API.

Set Up Postman
==============

- import this collection into postman
- all of the postman photos to the authorization section form (postman/6fill-out-form.png)
- up to editing the authorization section (picture that shows the form for putting in the client id and auth url, etc)

- import a new collection

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/1import-collection.png
   :alt: 

- open an import popup select upload files
- navigate to the file (coding-events-api/CodingEventsAPI/Postman_AADB2C-CodingEventsAPI-Collection.json)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/2upload-file.png
   :alt:

- select import

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/3select-import.png
   :alt:

- 3 dots on collection click edit

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/4edit-collection.png
   :alt:

- select the authorization tab

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/5select-authorization-tab.png
   :alt:

- click get new access token button
- a window will pop up
- for auth URL

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/6fill-out-form.png
   :alt:

- token name: access token
- grant type: choose implicit
- callback URL: https://www.postman.com/oauth2/callback
  - warning DO NOT SELECT AUTHORIZE USING BROWSER
- auth URL: click your meta data endpoint (AADB2C portal)

Leave Postman open on this form, and go to the Azure Portal where we will gather the information we need

Set Up API Authorization
========================

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/1set-api-scopes.png
   :alt: set api scope

- sidebar will pop open to set application ID URI (just save and continue)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/2set-app-id-uri.png
   :alt: set application uri id

- set-user-impersonation-scope
- user_impersonation
- User impersonation access to API
- Grant access for client application to impersonate a user in requests to the API

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/3set-user-impersonation-scope.png
   :alt: add user_impersonation scope to API

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/3-5copy-scope-uri.png
   :alt: add user_impersonation scope to API

Copy the ``Scope`` and ``Client ID`` to the Postman form.

Register the Postman Client Application
=======================================

- go back to app registrations
- click new registration

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/4new-app-registration.png
   :alt: new registration (for client app)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5application-completed-registration-form.png
   :alt:

- leave defaults except for name & redirect URI
- name: Postman
- redirect URI: https://www.postman.com/oauth2/callback
- click the authentication settings and then click implicit flow

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5-5postman-implicit-flow.png
   :alt:

- sends you back to the new application dashboard
- select API permissions

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/6api-permissions.png
   :alt:

- click add a permission

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/7add-permission.png
   :alt:

- opens a sidebar select my apis tab and select the codingeventsapi app

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/8my-apis.png
   :alt:

- select the user_impersonation permission

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/9select-user-impersonation-permission.png
   :alt:

- click add permission

- grant admin consent for ADB2C

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/10grant-admin-consent.png
   :alt:

- select yes

- after you select yes you will see:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/11admin-grant-success.png
   :alt:

Get the Authorization URL
=========================



- click the breadcrumb link (takes you to app registrations)
- select user flows

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/12select-user-flows.png
   :alt:

- select your flow

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/13select-susi-flow.png
   :alt:

- click run user flow

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/14run-user-flow.png
   :alt:

- in the sidebar click access tokens, click resource, choose codingeventsAPI, scopes are already selected, 

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/15user-flow-final.png
   :alt:

.. admonition:: note

   We are just showing them 

   ideally we would hit copy and paste in the authorization URL, but it doesn't work that way, we will just grab the Auth URL, but it would be helpful to students to see how we selected the resource they requested access, and here is the scopes and then copy that URL and breakdown that URL. if you feel it is beneficial to breakdown that URL

   code block split it into multiple lines, and explain each line

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/7metadata-authorization-endpoint.png
   :alt:

grab that URL paste it into postman

Get the Postman Access Token
============================

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/8postman-adb2c-form-signin.png
   :alt:

- remind default password

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/9postman-access-token-success.png
   :alt:

- click use token

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/10postman-auth-tab-complete.png
   :alt:

- click the update button

- switch back to client auth aadb2c

Next Steps
==========

.. lead in to studio
