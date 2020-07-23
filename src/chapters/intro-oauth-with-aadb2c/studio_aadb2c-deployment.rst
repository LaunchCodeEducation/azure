============================================
Studio: Deploy Coding Events API with AADB2C
============================================

.. challenging the students to take the things from the previous walkthrough and use in their code for this studio deployment

Testing Locally
===============

Checklist
---------

Gotchas
-------

Limited Guidance
----------------

Update Code
^^^^^^^^^^^

.. THIS IS THEIR ACTUAL TASK!!

Remote Deployment
=================

Checklist
---------

Gotchas
-------

Limited Guidance
----------------

Provision Resources
^^^^^^^^^^^^^^^^^^^

.. provided script?

Prepare VM
^^^^^^^^^^

.. provided script?

Deliver Deploy
^^^^^^^^^^^^^^

.. provided script?

Deliverable
===========





.. :: original notes when we took pictures

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

   - client id: registered postman app CLIENT ID
   - scope: api_user_impersonation scope you copied earlier
   - state: leave blank
   - client authentication: default but confirm send as basic auth header
   - click request token a pop up will prompt you to login

   .. comment:: END OF POSTMAN GROUP



      :alt:

   - double check your application


   .. TODO: auth URL, clientID, scope (in postman)

   .. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/16copy-user-flow-endpoint.png