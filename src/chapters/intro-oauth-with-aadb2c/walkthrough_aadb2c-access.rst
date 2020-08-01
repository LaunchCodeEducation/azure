===============================================================
Walkthrough: Set Up Access Token Authorization with Azure ADB2C
===============================================================

In the previous walkthrough, we created our AADB2C tenant and configured an identity token flow. These steps integrated our ``CodingEventsAPI`` with our AADB2C tenant as a centralized identity manager. At this point the API can use OIDC to *authenticate* the identity of users in the AADB2C tenant.

In this walkthrough, we will explore the other half of AADB2C, protecting applications using access tokens. We can use OAuth access tokens as a means of *delegating authorization* for one service to interact with another service on behalf of a user.

.. index:: 
   :single: authorization; server

An API can only be consumed by client applications. We can use AADB2C as an **authorization server** to protect our API by restricting access to only *registered* applications. In our case, we will use Postman as the consuming client application.

.. index:: ! scope

The goal of this walkthrough is to configure AADB2C to grant access tokens to the Postman client application. These tokens will need to include a **scope** that authorizes Postman (the token *bearer*) to interact with the protected application (``CodingEventsAPI``) on behalf of a user.

To accomplish this task we will:

#. Configure and *expose* a ``user_impersonation`` scope for accessing the ``CodingEventsAPI``.
#. Register the Postman client application in our AADB2C tenant.
#. Configure the Postman client application to enable requests for access tokens with the ``user_impersonation`` scope.
#. Configure Postman to request access tokens for interacting with the ``CodingEventsAPI`` on behalf of an authenticated user in our tenant.

In the following studio, you will update your ``CodingEventsAPI`` source code to integrate with AADB2C and deploy it. Then you will use Postman and an access token to make authorized requests to the final version of the API.

Set Up Postman
==============

This walkthrough will require working in both the Azure Portal on AADB2C as well as Postman to configure its requests for access tokens. We will begin by setting up Postman before switching to the Azure Portal.

After the initial setup, each of the subsequent steps will require you to switch between your browser and Postman to copy values from the Azure Portal into Postman.

The Final ``CodingEventsAPI`` Version
-------------------------------------

.. index::
   :single: access control; role-based
   :single: access control; attribute-based

The final branch of the ``CodingEventsAPI`` includes many additions to the code base. Beyond the AADB2C integration, the update supports **role-based access control (RBAC)** and **attribute-based access control (ABAC)**. These industry terms describe patterns that are used for organizing logical rules that enforce authorization. 

.. admonition:: Tip

   If you would like to learn more about RBAC and ABAC `this article <https://www.dnsstuff.com/rbac-vs-abac-access-control>`_ provides a great description of their similarities, differences, and usages.

This version of the ``CodingEventsAPI`` includes logic that restricts access to resources based on the following:

- **Roles**: ``Public User``, ``Authenticated User``, ``Member``, ``Owner``
- **Attributes**: ``Coding Event Membership``, ``Coding Event Ownership``

In addition to this authorization logic and the ``CodingEvent`` resource you saw before, the API now includes the ``Member`` and ``Tag`` resources. Because there are many more endpoints available in this version of the API you will find a Postman collection file in the repo that you can import. 

Switch to the ``3-aadb2c`` branch in your forked ``coding-events-api`` repo. In the ``coding-events-api/CodingEventsAPI`` project directory is a Postman collection file called ``Postman_AADB2C-CodingEventsAPI-Collection.json``. Let's import this file into Postman.

Open Postman and select the *Import* button (next to *New*):

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/1import-collection.png
   :alt: Postman import button

Select the *Upload Files* button and then navigate to the collection file in your project directory:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/2upload-file.png
   :alt: Postman upload collection file

Select the *Import* button to import the collection:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/3select-import.png
   :alt: Import the Postman collection

On the right side of the new collection click the three dots then select *Edit*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/4edit-collection.png
   :alt: Postman edit the collection

From the edit collection modal select the *Authorization* tab:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/5select-authorization-tab.png
   :alt: Postman collection Authorization tab

In addition to the endpoints and organizing directories, this imported collection comes with many of the authorization settings pre-configured for you. From this tab, you can see it has already been configured to use OAuth for obtaining an access token. After obtaining the access token, it will be automatically sent in the ``Authorization`` request header for every request made within the collection.

The ``Bearer`` prefix will be used to indicate that Postman is the *bearer* of a token that *authorizes its requests* for interacting with the API. It does this *on behalf of* its subject, the AADB2C user it was created for. The updated API then extracts and validates this token before processing the request using its RBAC and ABAC rules.

Selecting the *Get New Access Token* button will open a modal with a form for configuring the access token request:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/6fill-out-form.png
   :alt: Postman Authorization get new access token button

This form allows you to define all of the information needed to request an access token. At this point, it is populated with example entries for the AADB2C access token request.

In the following AADB2C configuration sections you will replace these entries with the values for your own tenant. You will need to update the following fields:

.. index:: ! authorization URL, ! authorized party

- **Auth URL**: the **authorization URL** for the SUSI user flow policy we created before
- **Client ID**: the ID of the new Postman client application we will be registering with AADB2C in this walkthrough (the *authorized party*, or bearer, of the access token)
- **Scope**: the ``user_impersonation`` scope exposed by the registered ``CodingEventsAPI``

.. admonition:: Warning

   Do NOT modify any other settings besides those listed in the instructions.

Leave this form open in Postman and switch over to the Azure Portal.

Protect the ``CodingEventsAPI``
===============================

In this step, we will configure AADB2C to protect our API. We will be setting up and *exposing* the ``user_impersonation`` scope that Postman will use. At the end of this step, you will copy over the URI of this scope into the value for the *Scope* field in the Postman form.

First navigate to your AADB2C tenant directory. Then select the ``CodingEventsAPI`` under *App Registrations*.

.. Copy the API Client ID
.. ----------------------

.. From the ``CodingEventsAPI`` application dashboard copy the **client ID**:

.. .. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/1set-api-scopes.png
..    :alt: AADB2C expose an API

.. Switch back to Postman and **replace the client ID field** with the copied value.

Expose a ``user_impersonation`` Scope for the API
-------------------------------------------------

Next select the *Expose an API* settings from the left panel. From this view, we can expose controlled access to our API using scopes.

Select the *Add a scope* button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/1set-api-scopes.png
   :alt: AADB2C expose an API

Since this is the first scope exposed for our API, we will need to register its *application ID URI*. This is a unique identifier that associates the exposed scopes to this specific registered application. By default it will use the registered application's client ID.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/2set-scope-app-id-uri.png
   :alt: AADB2C set application ID URI for new scope

Select *Save and continue* to proceed to the new scope form. 

We will be exposing a ``user_impersonation`` scope for our API. This scope is what the Postman client application will request access to in order to send requests to the API on behalf of the user. Enter the following values for each of the scope form fields:

- **Scope name**: ``user_impersonation``
- **Admin consent display**: ``User impersonation access to API``
- **Admin consent description**: ``Allows the Client application to access the API on behalf of the authenticated user``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/3set-user-impersonation-scope.png
   :alt: AADB2C add user_impersonation scope to API

After the scope has been registered, copy the scope URI using the blue copy icon next to it:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/3-5copy-scope-uri.png
   :alt: AADB2C copy scope URI

Switch back to Postman and replace the *Scope* field with the copied value.

.. admonition:: Warning

   Before continuing, make sure you have updated the Postman form:

   - **Scope** field: the *scope URI* for the ``user_impersonation`` scope

Register & Configure the Postman Client Application
===================================================

Now that our API has exposed its ``user_impersonation`` scope, we will register our Postman client application to consume it. Using the *Azure AD B2C | App registrations* breadcrumb link in the top left corner go back to the app registrations view. 

Register the Postman Client Application
---------------------------------------

Select *New registration*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/4new-app-registration.png
   :alt: new registration (for client app)

Just as before we will *leave all the defaults* except for the name and redirect URI. In the app registration form use the following values:

- **Name**: ``Postman``
- **redirect URI**: ``https://jwt.ms``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5application-completed-registration-form.png
   :alt: Postman client application completed form

We will be registering two redirect URIs for this application. The first will use the Microsoft JWT tool so that we can explore the access token (like we did for the identity token in the previous walkthrough). The second will be the redirect URI used when performing the OAuth flow from Postman. We will register the latter URI in the next section.

After registering the Postman application it will send you to its application dashboard. Copy the *client ID* to your clipboard using the copy icon to the right of it:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5-1copy-postman-client-id.png
   :alt: copy Postman client ID

Switch back to Postman and replace the *Client ID* field with the copied value.

.. admonition:: Warning

   Before continuing make sure you have updated the Postman form:

   - **Client ID** field: the *client ID* of your registered Postman application.

Configure Authentication
------------------------

We will now configure the Postman application to use the OAuth implicit flow and set the redirect URI. On the left sidebar select the *Authentication* settings.

In the *Web - Redirect URIs* add a new entry under the existing one. Select *Add URI* and paste in the following value, which Postman uses for handling OAuth redirects:

- ``https://www.postman.com/oauth2/callback``

Then scroll down to the *Implicit grant* section and, just as before, select the checkboxes for *both*:

- *Access tokens*
- *Identity tokens*

Check that your configuration matches the picture below, then select *Save*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5-2postman-authentication-configuration-complete.png
   :alt: Postman Authentication configuration completed view

Grant Admin Permissions for Using the Scope
-------------------------------------------

In this step, we will configure the Postman application to use the ``user_impersonation`` scope exposed by the ``CodingEventsAPI`` application. To do this, we will need to grant admin permissions for this scope.

In the sidebar select the *API permissions* settings. Then select the *Add a permission* button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/7add-permission.png
   :alt: Postman add an API permission

This will open a sidebar for configuring the permissions. Select the *My APIs* tab on the right side, then select the ``CodingEventsAPI`` application from the list:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/8my-apis.png
   :alt: Postman grant My APIs - ``CodingEventsAPI`` permission

From here, we can select the scopes for the selected API (``CodingEventsAPI``) that we would like to grant permissions for *this* application (Postman) to use. Select the ``user_impersonation`` scope then select *Add Permission*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/9select-user-impersonation-permission.png
   :alt: add ``CodingEventsAPI`` user_impersonation permission to Postman

This scope *is not valid* until an admin has granted permission for the Postman application to use it. Select the *Grant admin consent for <Name> ADB2C* button to grant it. 

.. admonition:: Note
   
   This is a *tenant-wide* permission that will apply to *your* AADB2C tenant. ``Student`` is used as a generic placeholder in the image below.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/10grant-admin-consent.png
   :alt: grant admin permission to user_impersonation scope for Postman

After confirming your decision, your configuration should match the image below.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/11admin-grant-success.png
   :alt: granted admin permission success

.. If it does not match, you may need to select the **Refresh** button in the top corner after confirmation or refresh the page entirely.

Test the User Flow for Access Tokens
====================================

Let's take stock of what we have done so far. We have:

- configured the ``user_impersonation`` scope for access tokens used to protect our ``CodingEventsAPI``,
- registered the Postman client application used to interact with the API, and
- configured the Postman application to allow it to use the ``user_impersonation`` scope in the access tokens it will use in requests sent to the API.

In parallel with this setup, we have also been configuring the Postman form with the values it needs to request an access token from *your* AADB2C service. The final field we need to update is the authorization URL (*Auth URL* in the form). In this step we will copy over this URL and then test out the access token process using the Microsoft JWT explorer tool (``jwt.ms``).

We can get the URL and test out the process in the *User Flows* section of our AADB2C service. In the top-left corner use the *Azure AD B2C | App registrations* breadcrumb link to go back to the app registrations view. 

Select *User Flows*:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/12select-user-flows.png
   :alt: Navigate from App Registrations to User Flows

Select the SUSI flow we configured in the previous walkthrough:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/13select-susi-flow.png
   :alt: Select SUSI flow

Get the Authorization URL
-------------------------

From the SUSI flow dashboard, select the *Run user flow* button to open the sidebar:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/14run-user-flow.png
   :alt: Select Run user flow

At the top of the sidebar is the *metadata document* link. Recall that this is the standard OIDC document that formally describes the capabilities and endpoints used to interact with the AADB2C service.

Select this link to open the JSON metadata document:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/15user-flow-metadata-document-link.png
   :alt: OIDC metadata document select authorization URL

From the metadata document copy the ``authorization_endpoint`` URL to your clipboard:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/16metadata-authorization-endpoint.png
   :alt: OIDC metadata document copy the authorization endpoint URL

Switch back to Postman and replace the *Auth URL* field with the copied value to complete the form.

.. admonition:: Warning

   Before continuing make sure you have updated the Postman form:

   - *Auth URL* field: the ``authorization_endpoint`` entry in the linked metadata document

Explore the Access Token
------------------------

With the SUSI flow sidebar open, let's configure an *access token request* that is sent to the Microsoft JWT tool, just like we did in the previous walkthrough. However, this time we will use it to inspect the *claims* in the access token rather than an identity token.

First make sure that the following fields are selected:

- **Application**: ``Postman``
- **Reply URL**: ``https://jwt.ms``

Then open the *Access Tokens* section by clicking on it. We will now define the resource (our protected API) and the scopes (``user_impersonation``) to request for the access token. Configure the following settings:

- **Resource**: ``CodingEventsAPI``
- **Scopes**: select *only* the ``user_impersonation`` scope

.. admonition:: Warning

   Make sure that you *unselect* the identity token (``openid``) scope. Only the ``user_impersonation`` scope should be selected.

Check that your configuration matches the image below:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/17user-flow-final.png
   :alt: Configure the access token 

Click the *Run user flow* button to begin the access token flow.

After authenticating with your AADB2C tenant account, you will be redirected to the ``jwt.ms`` page. Notice that this time the query parameter is ``access_token`` rather than ``identity_token``, which we saw last time.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/18decoded-access-token.png
   :alt: Microsoft JWT tool with decoded access token 

The access token is provided in the same *signed* JWT format and in many ways is similar to an identity token. However, it contains several *different claims* that can be used to verify the authorization of anyone who *bears it* (Postman client application), rather than just the identity claims.

Select the *Claims* tab to switch to the detailed breakdown. You will notice three familiar claims, ``iss``, ``aud`` and ``sub``. Recall that these claims indicate:

- **iss[uer]**: the AADB2C tenant is the *issuer* of the access token while behaving (in this context) as the authorization server
- **sub[ject]**: the subject of the token is your OID (unique identifier of your account in the AADB2C tenant directory)
- **aud[ience]**: the audience, or intended recipient, of the token is the Coding Event API application identifier (Client ID)

In addition to these claims that the two tokens have in common, there are several others that are *only* present in an access token:

- **scp (scope)**: the scope(s) that have been authorized, ``user_impersonation`` in this context
- **azp (authorized party)**: the Postman client application that has been *authorized to bear* this token

These claims are each used to prove the authenticity and validity of the token when it is used. In practice, the authorized party (Postman) sends this access token to the intended audience (``CodingEventsAPI``) for each request to a protected endpoint.

The API is then responsible for validating the claims in the token before processing the RBAC and ABAC rules associated with the **sub**\ject (the user that Postman acts on behalf of). 

.. admonition:: Note

   Access tokens are purposefully **short-lived** to limit potential abuse if a malicious party gets hold of one. By default, the access tokens we receive through AADB2C have a 1-hour lifetime before they expire (visible in the **exp[iration]** claim). 
   
   Because we are using the implicit OAuth flow, we do not have access to `refresh tokens <https://developer.okta.com/docs/guides/refresh-tokens/overview/>`_. If an access token received using an implicit flow expires during use, you will need to request a new one by repeating the access token request process.

.. explain how the full URL that Postman builds from the form fields is used in a web client like a SPA. too deep for now but worth discussing in actual class

Get the Postman Access Token
============================

In the next studio, you will deploy the final version of the ``CodingEventsAPI`` that integrates with your AADB2C tenant. You will be using Postman to request an access token to test out the protected endpoints of the API. Let's explore this process together so you are prepared to make use of it in your studio tasks.

Switch back to the Postman access token form you have been updating throughout the walkthrough. There is one final field that needs to be updated, the *State* field. This field can be any arbitrary value but should be *unique to each access token request*. It is used to protect against `CSRF attacks <https://auth0.com/docs/protocols/oauth2/oauth-state>`_.

Typically, this parameter is used to store the state of a user on a site (like a page to send them back to) or some other unguessable value. In this case, you can enter anything *random* you would like for the *State* field:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/7-1postman-set-state-field.png
   :alt: Complete the access token request form by setting a random value for the State field

Before issuing the request check that you have updated all of the following fields:

- **Callback URL**: ``https://www.postman.com/oauth2/callback``
- **Auth URL**: the ``authorization_endpoint`` from the JSON metadata document
- **Client ID**: your client application identifier from the registered Postman application dashboard
- **Scope**: the ``user_impersonation`` scope URI you exposed for your registered ``CodingEventsAPI`` application
- **State**: any random string of your choice

.. admonition:: Warning

   Make sure you have left the defaults for the remaining fields and that you do NOT select the option to *authorize using browser*.

If everything has been updated properly, you are ready to request your first access token! Select the *Request Token* button. This will open a popup to authenticate with your AADB2C tenant. Recall that your password should be:

- ``LaunchCode-@zure1``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/8postman-adb2c-form-signin.png
   :alt: AADB2C tenant sign in

After successfully authenticating, Postman will receive and store the access token in its tokens list. Select the *Use Token* button to designate the token Postman should use when making requests to the API:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/9postman-access-token-success.png
   :alt: Select *Use Token* for the new access token

Finally you will be returned to the *Authorization* tab in Postman. This time your access token will be populated:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/10postman-auth-tab-complete.png
   :alt: Completed Authorization tab in Postman

Select the *Update* button to save the changes you have made to the collection. As soon as your API is live, you will be able to use Postman to make authorized requests to it using the access token.

Replacing an Expired Access Token
---------------------------------

As a reminder you will need to request a new access token *after one hour* due to its expiration. If a request fails during the studio, it will likely be due to an expired token. 

Postman can detect when a token has expired and will cross it out in the tokens list when it can no longer be used. These tokens can be discarded using the trash icon next to them:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/11postman-expired-token.png
   :alt: Postman expired token

However, now that you have everything configured it will be a quick process to request a new access token:

#. Open the collection settings (three dots next to the collection name)
#. Switch to the *Authorization* tab and select *Get New Access Token*
#. Select *Request Token* to re-authorize and receive a new one
#. Select *Use Token* (and discard any expired ones)
#. Select *Update* to save the changes to the collection

You should then be able to reissue the requests using the valid access token.
