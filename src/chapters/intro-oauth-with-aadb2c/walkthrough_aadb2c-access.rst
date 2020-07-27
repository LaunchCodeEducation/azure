===============================================================
Walkthrough: Set Up Access Token Authorization with Azure ADB2C
===============================================================

In the previous walkthrough we created our AADB2C tenant and configured an identity token flow. These steps integrated our Coding Events API with our AADB2C tenant as a centralized identity manager. At this point the API can use **OIDC** to **authenticate the identity** of users in the AADB2C tenant.

In this walkthrough we will explore the other half of AADB2C -- protecting applications using access tokens. Recall that we can use **OAuth** access tokens as a means of **delegating authorization** for one service to interact with another service on behalf of a user.

Remember that an API, by definition, can only be must consumed by client applications. We can use AADB2C as an **authorization server** to protect our API by restrict access only to *registered applications*. In our case we will use Postman as the consuming client application

Our goal is to configure AADB2C to grant access tokens to the Postman client application. These tokens will need to include a **scope** that **authorizes** Postman (the token *bearer*) to interact with the protected application (Coding Events API) **on behalf of a user**.

To accomplish this task we will need to:

#. Configure and *expose* a ``user_impersonation`` scope for accessing the Coding Events API
#. Register the Postman client application in our AADB2C tenant
#. Configure the Postman client application to enable requests for access tokens with the ``user_impersonation`` scope
#. Configure Postman to request access tokens for interacting with the Coding Events API on behalf of an authenticated user in our tenant

In the following Studio you will then update your Coding Events API source code to integrate with AADB2C and deploy it. Then you will use Postman and an access token to make authorized requests to the final version of the API.

.. admonition:: Note

   This walkthrough will require working in both the Azure Portal on AADB2C as well as Postman to configure its requests for access tokens. We will begin by setting up Postman before switching to the Azure Portal.
   
   After the initial setup each of the subsequent steps will require you to switch between your browser and Postman to copy values from the Azure Portal into Postman.

Set Up Postman
==============

The final branch of the Coding Events API includes many additions to the code base. Beyond the AADB2C integration, the update supports **Role Based Access Control (RBAC)** and **Attribute Based Access Control (ABAC)**. While these industry terms sound complicated they describe how the API will restrict access based on the following roles and attributes:

- **Roles**: ``Public User``, ``Authenticated User``
- **Attributes**: ``Coding Event Membership``, ``Coding Event Ownership``

.. admonition:: Tip

   If you would like to learn more about RBAC and ABAC `this article <https://www.dnsstuff.com/rbac-vs-abac-access-control>`_ provides a great description of their similarities and differences.

In addition to the ``CodingEvent`` resource the API now includes the ``Member`` and ``Tag`` resources. Because there are many more endpoints available in this version of the API you will find a Postman collection file in the that you can import. 

Switch to the ``3-aadb2c`` branch in your forked ``coding-events-api`` repo. In the ``coding-events-api/CodingEventsAPI`` project directory is a Postman collection file called ``Postman_AADB2C-CodingEventsAPI-Collection.json``. Let's import this file into Postman.

Open Postman and select the **Import** button (next to **New**):

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/1import-collection.png
   :alt: Postman import button

Select the **Upload Files** button and navigate to the collection file in your project directory:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/2upload-file.png
   :alt: Postman upload collection file

Select the **Import** button to import the collection:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/3select-import.png
   :alt: Postman import the uploadedthen collection

On the right side of the new collection click the three dots then select **Edit**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/4edit-collection.png
   :alt: Postman edit the collection

From the edit collection modal select the **Authorization** tab:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/5select-authorization-tab.png
   :alt: Postman collection Authorization tab

In addition to all of the endpoints and organizing directories, this imported collection comes with many of the Authorization settings pre-configured for you. From this tab you can see it has already been configured to use OAuth for getting an access token. After getting the access token it will be automatically sent in the ``Authorization`` request header for every request made within the collection.

The ``Bearer`` prefix will be used to indicate that Postman is the *bearer of a token that authorizes its requests* for interacting with the API *on behalf of its* **sub**\ject, the AADB2C user it was created for. The updated API then extracts and validates this token before processing the request using its RBAC and ABAC rules.

Selecting the **Get New Access Token** button will open a modal with a form for configuring the access token request:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/postman/6fill-out-form.png
   :alt: Postman Authorization get new access token button

This form allows you to define all of the information needed to request an access token. At this point it is populated with example entries for the AADB2C access token request.

In the following AADB2C configuration sections you will replace these entries with the values for your own tenant. You will need to update the following fields:

- **Auth URL**: the **authorization URL** for the SUSI User Flow policy we created before
- **Client ID**: the ID of the Coding Events API registered application (the *intended audience*, or recipient, of the access token)
- **Scope**: the ``user_impersonation`` scope exposed by the registered Coding Events API

.. admonition:: Warning

   **Do not modify any other settings besides those listed in the instructions**.

Leave this form open in Postman and switch over to the Azure Portal.

Protect the Coding Events API
=============================

In this step we will configure AADB2C to protect our API. We will be setting up and *exposing* the ``user_impersonation`` scope that Postman will use. At the end of this step you will copy over the URI of this scope into the value for the **Scope** field in the Postman form.

First navigate to your AADB2C tenant directory. Then select the Coding Events API under **App Registrations**.

.. Copy the API Client ID
.. ----------------------

.. From the Coding Events API application dashboard copy the **client ID**:

.. .. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/1set-api-scopes.png
..    :alt: AADB2C expose an API

.. Switch back to Postman and **replace the client ID field** with the copied value.

Expose a user_impersonation Scope for the API
---------------------------------------------

Next select the **Expose an API** settings from the left panel. From this view we can expose controlled access to our API using scopes.

Select the **Add a scope** button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/1set-api-scopes.png
   :alt: AADB2C expose an API

Since this is the first scope exposed for our API we will need to register its **application ID URI**. This is a unique identifier that associates the exposed scopes to this specific registered application. By default it will use the registered application's client ID.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/2set-scope-app-id-uri.png
   :alt: AADB2C set application ID URI for new scope

Select **Save and continue** to proceed to the new scope form. 

We will be exposing a ``user_impersonation`` scope for our API. This scope is what the Postman client application will request access to in order to send requests to the API on behalf of the user. Enter the following values for each of the scope form fields:

- **Scope name**: ``user_impersonation``
- **Admin consent display**: ``User impersonation access to API``
- **Admin consent description**: ``Allows the Client application to access the API on behalf of the authenticated user``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/3set-user-impersonation-scope.png
   :alt: AADB2C add user_impersonation scope to API

After the scope has been registered copy the scope URI (using the blue copy icon next to it):

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/3-5copy-scope-uri.png
   :alt: AADB2C copy scope URI

Switch back to Postman and **replace the Scope field** with the copied value.

.. admonition:: Warning

   Before continuing make sure you have updated the Postman form:

   - **Scope** field: the **scope URI** for the ``user_impersonation`` scope

Register & Configure the Postman Client Application
===================================================

Now that our API has exposed its ``user_impersonation`` scope we will register our Postman client application to consume it. Using the ``Azure AD B2C | App registrations`` breadcrumb link in the top left corner go back to the app registrations view. 

Register the Postman Client Application
---------------------------------------

Select **New registration**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/4new-app-registration.png
   :alt: new registration (for client app)

Just as before **we will leave all the defaults** except for the name and redirect URI. In the app registration form use the following values:

- **Name**: ``Postman``
- **redirect URI**: ``https://jwt.ms``

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5application-completed-registration-form.png
   :alt: Postman client application completed form

We will be registering two redirect URIs for this application. The first will use the Microsoft JWT tool so that we can explore the access token (like we did for the identity token in the previous walkthrough). The second will be the redirect URI used when performing the OAuth flow from Postman. We will register the latter URI in the next section.

After registering the Postman application it will send you to its application dashboard. Copy the **client ID** to your clipboard using the copy icon to the right of it:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5-1copy-postman-client-id.png
   :alt: copy Postman client ID

Switch back to Postman and **replace the Client ID field** with the copied value.

.. admonition:: Warning

   Before continuing make sure you have updated the Postman form:

   - **Client ID** field: the **client ID** of your registered **Postman application**

Configure Authentication
------------------------

We will now configure the Postman application to use the **OAuth implicit flow** and set the redirect URI. On the left sidebar select the **Authentication** settings.

In the **Web - Redirect URIs** add a new entry under the existing one. Select **add URI** and paste in the following value which Postman uses for handling OAuth redirects:

- ``https://www.postman.com/oauth2/callback``

Then scroll down to the **Implicit grant** section and, just as before, select the checkboxes **for both**:

- **Access tokens**
- **Identity tokens**

Check that your configuration matches the picture below then select **Save**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/5-2postman-authentication-configuration-complete.png
   :alt: Postman Authentication configuration completed view

Grant Admin Permissions for Using the Scope
-------------------------------------------

In this step we will configure the Postman application to use the ``user_impersonation`` scope exposed by the Coding Events API application. To do this we will need to grant admin permissions for this scope.

In the sidebar select the **API permissions** settings. Then select the **Add a permission** button:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/7add-permission.png
   :alt: Postman add an API permission

This will open a sidebar for configuring the permissions. Select the **My APIs** tab on the right side then select the **Coding Events API** application from the list:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/8my-apis.png
   :alt: Postman grant My APIs - Coding Events API permission

From here we can select the scopes for the selected API (Coding Events API) that we would like to grant permissions for *this application* (Postman) to use. Select the ``user_impersonation`` scope then select **Add Permission**:

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/9select-user-impersonation-permission.png
   :alt: add Coding Events API user_impersonation permission to Postman

This scope **is not valid** until an admin has granted permission for the Postman application to use it. Select the **Grant admin consent for <Name> ADB2C** button to grant it. 

.. admonition:: Note
   
   This is a **tenant-wide** permission that will apply to *your* AADB2C tenant. ``Student`` is used as a generic placeholder in the image below.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/10grant-admin-consent.png
   :alt: grant admin permission to user_impersonation scope for Postman

After confirming your decision your configuration should match the image below. If it does not, you may need to select the **Refresh** button in the top corner after confirmation or refresh the page entirely.

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/11admin-grant-success.png
   :alt: granted admin permission success

Test the User Flow for Access Tokens
====================================

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

Get the Authorization URL
-------------------------

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/15user-flow-metadata-document-link.png
   :alt: OIDC metadata document select authorization URL

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/16metadata-authorization-endpoint.png
   :alt: OIDC metadata document copy the authorization endpoint URL

Switch back to Postman and **replace the Auth URL field** with the copied value.

.. admonition:: Warning

   Before continuing make sure you have updated the Postman form:

   - **Auth URL** field: the **authorization_endpoint** entry in the linked metadata document

Explore the Access Token
------------------------

- show steps of selecting just user_impersonation scope and running flow for jwt.ms
- break down 

.. todo:: replace image below with new one (just user_impersonation)

.. image:: /_static/images/intro-oauth-with-aadb2c/walkthrough_aadb2c-access/15user-flow-final.png
   :alt:

.. todo:: screenshot of jwt.ms access token exploration claims

- break down scp, azp and aud

.. admonition:: note

   We are just showing them 

   ideally we would hit copy and paste in the authorization URL, but it doesn't work that way, we will just grab the Auth URL, but it would be helpful to students to see how we selected the resource they requested access, and here is the scopes and then copy that URL and breakdown that URL. if you feel it is beneficial to breakdown that URL

   code block split it into multiple lines, and explain each line

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
