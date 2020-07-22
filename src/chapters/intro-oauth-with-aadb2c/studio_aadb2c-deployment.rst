==========================================
Studio: Deploy CodingEventsAPI with AADB2C


.. ::

   - everything in the RG from the walkthrough ``aadb2c-deploy-rg``
   - reuse the tenant from the walkthrough
   - all values will come from the tenant configuration
      - app registration
      - user flows
   - this deployment is over HTTPS because AADB2C only works over secure connections


   #. provision VM (previous walkthroughs for help)
      - this is where they will get the server origin (VM public IP)
      - open NSG port 443
   #. provision KV (previous walkthroughs for help)
      - configure VM to access KV
      - setup connection string secret
   #. modify source code ``4-member-roles`` appsettings.json
      - public IP address
      - kv name
      - aadb2c config stuff
         - set the redirect URL for this new application (app registrations > authentication > add URI button
            - it needs to be the swagger redirect URL // this needs to be looked up
   #. setup VM
      - TODO script
         - give them NGINX and SSL script with comments
         - their tasks
            - merge in the script from previous studio (mysql, runtime dependencies)
      - run script
   #. test it out
      - public endpoints
      - login via SUSI
      - hit the protected owner endpoints
      - notify your TA and they will act as the member

- first attempt: valid audience is clientID of the API


.. comment: split this part into a walkthrough (setup) and studio (deploy/fire postman requests)

# start images/steps

- go to home page tenant dashboard (AADB2C) (in the tenant directory)

- go to app registrations

- select the CodingEventsAPI app

- get the Client ID (jwt.adb2c.tokenValidationParameters.validAudience)

- go to expose an API on the sidebar

- click add a scope

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/1set-api-scopes.png
   :alt: set api scope

- sidebar will pop open to set application ID URI (just save and continue)

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/2set-app-id-uri.png
   :alt: set application uri id

- set-user-impersonation-scope
- user_impersonation
- User impersonation access to API
- Grant access for client application to impersonate a user in requests to the API

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/3set-user-impersonation-scope.png
   :alt: add user_impersonation scope to API


.. comment: EVERYTHING ABOVE THIS POINT IS CORRECT below subject to change

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/3-5copy-scope-uri.png
   :alt: add user_impersonation scope to API

- go back to app registrations
- click new registration

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/4new-app-registration.png
   :alt: new registration (for client app)

.. comment: start postman

- import a new collection

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/1import-collection.png
   :alt: 

- open an import popup select upload files
- navigate to the file (coding-events-api/CodingEventsAPI/Postman_AADB2C-CodingEventsAPI-Collection.json)

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/2upload-file.png
   :alt:

- select import

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/3select-import.png
   :alt:

- 3 dots on collection click edit

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/4edit-collection.png
   :alt:

- select the authorization tab

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/5select-authorization-tab.png
   :alt:

- click get new access token button
- a window will pop up
- for auth URL

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/6fill-out-form.png
   :alt:

- token name: access token
- grant type: choose implicit
- callback URL: https://www.postman.com/oauth2/callback
  - warning DO NOT SELECT AUTHORIZE USING BROWSER
- auth URL: click your meta data endpoint (AADB2C portal)

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/7metadata-authorization-endpoint.png
   :alt:

- client id: registered postman app CLIENT ID
- scope: api_user_impersonation scope you copied earlier
- state: leave blank
- client authentication: default but confirm send as basic auth header
- click request token a pop up will prompt you to login

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/8postman-adb2c-form-signin.png
   :alt:

- remind default password

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/9postman-access-token-success.png
   :alt:

- click use token

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/postman/10postman-auth-tab-complete.png
   :alt:

- click the update button

- switch back to client auth aadb2c

.. comment:: END OF POSTMAN GROUP

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/5application-completed-registration-form.png
   :alt:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/5-3copy-client-id.png
   :alt:

- leave defaults except for name & redirect URI
- name: Postman
- redirect URI: https://www.postman.com/oauth2/callback
- click the authentication settings and then click implicit flow

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/5-5postman-implicit-flow.png
   :alt:

- sends you back to the new application dashboard
- select API permissions

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/6api-permissions.png
   :alt:

- click add a permission

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/7add-permission.png
   :alt:

- opens a sidebar select my apis tab and select the codingeventsapi app

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/8my-apis.png
   :alt:

- select the user_impersonation permission

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/9select-user-impersonation-permission.png
   :alt:

- click add permission

- grant admin consent for ADB2C

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/10grant-admin-consent.png
   :alt:

- select yes

- after you select yes you will see:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/11admin-grant-success.png
   :alt:

- click the breadcrumb link (takes you to app registrations)
- select user flows

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/12select-user-flows.png
   :alt:

- select your flow

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/13select-susi-flow.png
   :alt:

- click run user flow

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/14run-user-flow.png
   :alt:

- in the sidebar click access tokens, click resource, choose codingeventsAPI, scopes are already selected, 

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/15user-flow-final.png
   :alt:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/16copy-user-flow-endpoint.png
   :alt:

- double check your application


.. TODO: auth URL, clientID, scope (in postman)

- 
=======
==========================================
