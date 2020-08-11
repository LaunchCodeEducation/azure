===================================
Troubleshooting Instructor Solution
===================================

Overview of Issues
==================

#. **connection timeout**: VM is not running
#. **connection timeout**: NSG inbound rule for port 443 is missing
#. **connection refused**: NGINX service is down
#. **502 bad gateway**: MySQL service is down
#. **502 bad gateway**: ``appsettings.json`` doesn't contain the correct KV name
#. **502 bad gateway**: VM not granted access to KV

Overview of Troubleshooting Diagnosis
=====================================

- **connection timeout**: networking issue (VM is down or NSG rule missing/misconfigured)
- **connection refused**: port is not in use (service is down)
- **502 bad gateway**: the web server can't access the upstream API (API is crashed / not running)

Instructor & TA Articles
========================

Articles for setting up and facilitating the walkthrough with students. Each article and section within them are labeled according to Instructors, TAs or both. You should review all of them related to your role.

.. toctree::
  :maxdepth: 3
  
  overview
  0-setup-steps
  1-group-discussion
  2-solution-steps
  resetting