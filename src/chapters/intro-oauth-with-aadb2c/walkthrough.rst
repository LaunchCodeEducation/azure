=====================================
Walkthrough: Setup Azure ADB2C Tenant
=====================================

.. the provider is still someone else (MS, Google, Twitter, etc)

.. started these notes before remembering we had these notes

- navigate to the AADB2C blade
- 2 choices create a new tenant, or link to an existing tenant (so you have to create one first)
- create a new tenant directory (which creates a new directory for that tenant)
- define the name of the tenant and base config (switches for ?implicit flow? and what not)
- switch back to your directory
- from your directory repeat the process, but link your subscription to the new tenant you just created
- then switch back to AADB2C directory
- in the directory you search of Azure ADB2C
- register the API application (this is where you set the ID for the app, and where you do the ?implicit flow switch?)
- choose a provider
   - choose the email provider






.. ::

   original notes pat took when we did this the second time

      ## AD B2C
   - create resource
      - AD b2c -> new tenant
         - name: <name>-ms-camp
         - domain: <name>mscamp
   - manage b2c
   - add application
      - name: code-events
      - include web app: yes  
      - allow implicit: no
      - reply URL (enter two):
         - https://localhost:5001/oauth/success (for local dev)
         - !! return later with deployment callback uri !!
      - takes a minute to show the new app (no refresh button)
   - DONT FORGET TO LINK TO SUBSCRIPTION
      - TODO: fresh instructions
   - properties
      - application (client id) id: 06eb34fd-455b-4084-92c3-07d5389e6c15
   - application > keys
      - generate key (client secret) -> copy the key
         - x-TUFqf30gPfOdtPmT7(^ap0
   - ?api access > scopes?
   - top bar (azure ad b2c tab)
      - things to show 
         - identity providers
               - show where to add other providers (email default)
         - company branding (customizing auth view)
         - users -> activity
         - users -> user settings -> users can register apps??
               - TODO: confirm if this should be off
         - user attributes -> add
   - user flows -> create user flow (recommended tab)
   - repeat for each of the flows (signup/signin, editing, reset)
      - ?? all or just some of these?
   - options
      - name: code_events_signup_signin (or flow type, snakecase)
      - email
      - MFA: disabled (but explain what it is?)
      - show more 
         - city, display name (username), email, state
               - collect/return all except email (explain why)
