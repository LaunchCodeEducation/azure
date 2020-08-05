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

- our db is embedded but typically would be in service level

Application Level
-----------------

- appsettings

How to Troubleshoot
===================

Take Inventory
--------------

- holistic inventory of components to understand what could go wrong

Identify the Issue
------------------

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