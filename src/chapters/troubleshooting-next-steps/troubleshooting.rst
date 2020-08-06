===============================
Introduction to Troubleshooting
===============================

...troubleshooting is something best learned through experience...
...some tips based on what you have learned so far...
...not exhaustive but only from what you know right now (fundamentals - rest grows on it)...

- troubleshooting depending on where in the SDLC
  - ops responsibilities (our focus)
  - dev responsibilities 

What You Have Seen
==================

Throughout this course you may have encountered any of the following while trying to deploy:

user receives a connection refused when attempting to access the swagger documentation in browser
    - the VM is being blocked at the network level
        - missing NSG rule for the specific port
        - misconfigured NSG rule

user receives a connection timeout when attempting to access the swagger documentation in browser
    - the web server is NOT running
        - service nginx status

user receives a bad gateway when accessing the swagger documentation in browser
    - the web server is running
    - the application is NOT running
        - service coding-events-api status
        - did it try to start and crashed?
            - check the logs
            - was it because it cannot connect to:
                - DB
                - KV
                - internal error

deployed API cannot access database
    - database is not currently running
    - database connection string is not correct
    - database does not have a user and database the DB connection string needs

deployed API cannot access KV secrets
    - KV does not exist
    - no secrets in KV
    - incorrect secret in KV
    - VM does not have the correct authorization for KV
    - application ``appsettings.json`` does not point to the correct KV

user receives incorrect behavior when working with API
    - inconsistent behavior is usually a dev issue, but we should be able to identify where it is being caused in the code
        - example: user sends a DELETE request and it returns a success No Content response
            - however, user can still access the resource that was supposedly deleted
            - this means the controller logic for that method/endpoint is incorrect
            - look at the code, is it going to the database and deleting?
            - is it waiting for the response of the DB deletion before sending back a response? (maybe the DB sent back that it could not be deleted, but the API already sent back the response) 

Until this point we have been pretty defenseless when an issue comes up. Frustratingly we would have to scrap our entire deployment so far, and start over. A better solution would be to troubleshoot our issues as they come up. The deployment issues we are about to explore are common across web API deployments.

Network Level
-------------

- NSG
- NOTE: future network related pieces

Service Level
-------------

- configuration
- access / authorization

Host Level
----------

- our db is embedded but typically would be in service level

Application Level
-----------------

- appsettings

How to Troubleshoot
===================

.. build mental modal state of the system
.. sometimes fixing one thing can open an underlying issue
.. peeling back layers of the onion
.. RCA [thwink...?]

Take Inventory
--------------

- form a mental model of the state of the system
- holistic inventory of components to understand what could go wrong
- keep inventory of every individual change you make no matter how trivial
  - each one changes the state of the system and could be a valuable clue

Identify the Issue
------------------

- DO NOT CHANGE ANYTHING
  - keep 
- response behavior
  - timeout
  - connection refused
  - 5XX
  - 4XX

Communicate the Issue
---------------------

Isolate & Resolve the Issue
---------------------------

- even if you cant resolve just going through the previous steps can go a long way in helping towards the resolution
  - pass off to a more senior member who will praise you for your effort
    - you are saving their expert time from doing preliminary steps

Troubleshooting Tools
=====================

.. DEPENDENT ON THE ENVIRONMENT (local/prod and OS/services)

Debugging Requests
------------------

  - browser dev Tools
  - curl
  - Invoke-RestMethod / Invoke-WebRequest
  - postman

Remote Management
-----------------

  - SSH
  - RDP
  - az CLI
  - accessing logs
    - journalctl

Source Code Debugging
---------------------

- debugger

Troubleshooting Levels
======================

.. WHAT CAN CAUSE EACH OF THESE
.. HOW CAN EACH BE IDENTIFIED

Network Level
-------------

- NSG
- NOTE: future network related pieces

Service Level
-------------

- configuration
- access / authorization

Hosting Environment Level
-------------------------

- sizing
- 
- NOTE: our db is embedded but typically would be in service level

Application Level
-----------------

- 
- causes
  - external configuration
  - internal bugs
    - unexpected 4XX and 5XX