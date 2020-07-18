

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


.. image:: /_static/images/intro-oauth-with-aadb2c/studio_aadb2c-deployment/.png
   :alt: 

