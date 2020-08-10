===========================================================
1. TAs ONLY: Discussion: Components of a Functioning System
===========================================================

This is the first group step of the walkthrough. You should allot 20-30 minutes (instructor discretion). **This step takes place before the student setup steps of the walkthrough**.

.. admonition:: Warning

   **Do not allow students to do the setup before this discussion**. This is a thought exercise **before beginning troubleshooting** for students to have an understanding of the entire system to prepare them for troubleshooting it.

.. admonition:: Note

   This should be a group discussion. Encourage points that aren't listed below if the students go in that direction. 

   There isn't an exact script for this section. At the halfway mark if the group hasn't covered the topics listed below move the discussion in that direction.
   
   If the students are stuck you can give them breadcrumbs in the following pattern going through each level:

   #. Use the top level bullet as a prompt to start a dialogue around that component
   #. Follow each sub-list down so everything is covered

Deployment Components
=====================

Let's consider the components in each layer of our system.

Network Level
-------------

...Network related issues are always based around routing behavior and access rules. As an introductory course we have only explored access rules in the form of our network security groups. To that end consider the three components of an access rule

- NSG rules for controlling access at the network level
- what rules do you expect?
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)

Service Level
-------------

- KeyVault
  - what configuration is expected?
    - a secret: database connection string
    - an access policy for our VM
- AADB2C
  - what configuration is expected?
    - tenant dir
    - protected API (user_impersonation scope)
    - Postman client application
    - SUSI flow

Hosting Environment Level
-------------------------

- VM external configuration
  - what configuration is expected?
    - size
    - status
    - image (defines available tools)
    - system assigned identity for KV access
- VM internal configuration
  - what configuration is expected?
    - runtime dependencies (dotnet, mysql, nginx)
    - self-signed SSL cert
  - what services are expected?
    - embedded MySQL
    - NGINX web server (reverse proxy)
    - API service
- MySQL db server
  - user and database for the API
- NGINX
  - RP configuration
  - using SSL cert

Application Level
-----------------

- appsettings.json (external configuration)
- source code
  - could have issues but we will assume it is working as expected