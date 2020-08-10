===============================
Introduction to Troubleshooting
===============================

Troubleshooting is one of the most important skills to the Operations professional. You will come to find troubleshooting is in large part research. An issue may be first brought to your attention by a ticket, or report from QA or an end user, but they will usually only be able to tell you what odd behavior occurred and some of the conditions that led to the error. The next steps are left up to you.

As a part of your investigation into the issue you may need to answer lots of different questions like:

- what is the issue?
- when does the issue occur?
- where, within the tech stack, does the issue occur?
- is it actually an issue, or simply end user error?
- is the issue reproducible?
- what are the exact conditions that cause the issue to occur?
- is it an issue with the underlying source code of the application?
- is it an issue with the infrastructure or system that supports the application?
- what do common error messages mean?
- how to determine what an obscure error message means?
- has a similar issue occurred in the past?
- who on your team can help you with the issue?

This is just a small sample of some of the questions you may need to answer to diagnose and resolve an issue. At first glance, this may seem overwhelming, however you have lots of tools to assist your investigation, you can adopt a methodology for solving issues, as you gain experience you will gather additional knowledge to assist in your investigation, and you are not alone! You will find that teammates are exceptionally advantageous when troubleshooting. 

They can provide you with new insight, knowledge of new tools, or can act as a sounding board to bounce ideas off of. In addition to your team the internet is filled with people that have may experienced similar, or identical issues to the one you are currently encountering.

In this article we will discuss issues you may have already experienced through this class, talk about a methodology to assist you in researching issues, and talk about some of the basic tools you can use while troubleshooting.

.. admonition:: note

   This article is in way exhaustive, as you continue throughout your career you will learn about new techniques, tools, and solutions to issues.

This article, and the following exercise, will primarily focus on Operations troubleshooting.

.. :: 

   ...troubleshooting is something best learned through experience...
   ...some tips based on what you have learned so far...
   ...not exhaustive but only from what you know right now (fundamentals - rest grows on it)...

   - troubleshooting depending on where in the SDLC
      - ops responsibilities (our focus)
      - dev responsibilities 

.. list-table:: Common HTTP status codes in API design
   :widths: 30 40 40
   :header-rows: 1

   * - Error Message
     - Description
     - 
   * - Connection Refused
     - The server received the request, but refuses to handle it
     - 
   * - Connection Timeout
     - The server did not respond to the client request within a specific time period
     - 
   * - 502 Bad Gateway
     - A server received an incorrect response from another server
     - 
   * - 401 Unauthorized
     - The request did not include credentials indicating a user needs to **authenticate**
     - 
   * - 403 Forbidden
     - The request included credentials, but the authenticated user does not have the proper level of **authorization**
     - 
   * - 500 Internal Server Error
     - The request was received, however the server encountered an issue it doesn't know how to resolve
     - 

What You May Have Experienced Already
=====================================

Throughout the Azure portion of this class we have focused on operations and not at all on development. However, identifying, communicating, and resolving development issues is often a responsibility of the DevOps professional.

We will look at some of the common operations and development issues.

.. admonition:: Note

   The issues throughout this article will be framed as issues in the Coding Events API as that's the application we have been working with throughout this class.

Operation Issues
----------------

Operation issues are issues that don't involve the source code of the deployed application. This could be issues relating to:

- Virtual Machine
- Key Vault
- AADB2C
- MySQL
- NGINX
- application software dependencies like dotnet
- VM operating system like a file permission issue
- the network connecting the various resources like a network security group rule
- application external configurations like ``appsettings.json`` or a Key Vault secret

Connection Timeout
^^^^^^^^^^^^^^^^^^

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-browser.png

Getting a connection timeout in the browser could mean many things:

- the URL may have been incorrect
- the VM is currently down
- the VM lacks a Network Security Group rule for the given port

That's a long list of things to check. Luckily checking the URL and Network Security Group rules of the VM can be done easily from the Azure Portal or the AZ CLI. To check if NGINX or an internal firewall is the issue we will need access to the Virtual Machine via SSH.

Let's try to SSH into the VM:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-ssh.png

Getting an SSH connection timeout here is a good indicator that the VM is not currently running.

After starting the VM, if we still get a Connection Timeout we would be able to further investigate the issue. 

.. admonition:: Note

   An issue is not always solved with one change. In some instances a combination of steps are necessary to solve one issue.
  
   Solving one issue may reveal a new issue. Revealing a new issue is great progress in troubleshooting!

Connection Refused
^^^^^^^^^^^^^^^^^^

From the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-browser.png

From PowerShell:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-terminal.png

From Bash:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-curl.png

If our connection was refused we know the VM is up and running because it responded to our request immediately. But again there could be multiple reasons for a refused connection:

- the VM internal firewall is blocking access to the given port
- no applications are listening on the port the request was made to (port 443: NGINX)

Both of these issues we will need to diagnose by looking into the VM. We can use SSH to look at both the internal firewall rules, and to determine if an application is running and listening to requests on port 443.

Bad Gateway
^^^^^^^^^^^

From the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-browser.png

From PowerShell:

.. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-powershell.png

From Bash:

.. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-curl.png

A bad gateway is an issue between *servers* in the case of our Coding Events API we have two web servers NGINX which proxies requests to the Coding Events API server.

NGINX is the entry point so receiving a Bad Gateway indicates that the Coding Events API is not currently running. You probably noticed that all three of the images above explicitly stated which server responded: ``NGINX``. We know NGINX is running and accepting requests on port 443! So it must be our Coding Events API that is causing the issue.

There could be any number of reasons the Coding Events API is not running:

- the ``coding-events-api`` service was never started
- the VM was restarted and the ``coding-events-api`` is not configured to start itself on a reboot
- an error in the Coding Events API source code has kept the application from starting
- the Coding Events API may require access to another cloud resource (like Key Vault), but lacks the authorization, or name of the resource

We can investigate the issue by doing a few things:

#. determine if the API is running: check the status of the ``coding-events-api`` service it should be active
#. make an internal web request from the VM to the Coding Events API: ``curl https://localhost:5001``
#. check the logs of the API: ``journalctl -u coding-events-api``

Development Issues
------------------

Development issues relate to the sourcecode of a deployed application. Ideally these issues are discovered before reaching the live production environment by automated tests, or Quality Assurance testers. However, sometimes these issues are discovered by end users who usually report that the application is not behaving correctly. The deployment isn't necessarily broken, however the application is not behaving the way it is intended to.

Internal Server Error
^^^^^^^^^^^^^^^^^^^^^

In some cases a Quality Assurance professional, or end user may see an HTTP response status code of 500, indicating an internal server error. This error informs us that the server encountered something it didn't know how to handle. 500 Internal Server Error issues are almost **always** the result of a runtime error within the source code of the application.

An example of this would be a user sends a GET request for a specific coding event. However, the controller method handler has code that instructs it to get a collection of coding events and attempts to serialize a collection into a single response body. This could create a runtime error as the serializer throws and error stating a collection cannot be serialized into a single coding event. Instead of breaking completely and sending no response to the user the Coding Events API is unable to determine what to do and returns a 500 Internal Server Error indicating the server encountered an error.

.. admonition:: Note

   The Coding Events API does not behave this way! This was simply an example of how a 500 Internal Server Error could occur.

API Bug
^^^^^^^

An API bug is almost **always** the result of a logic error within the source code of the application.

An example of this would be an owner of a Coding Event sending a DELETE request to their event. This should DELETE the event from the Database completely and no users should be able to access the now deleted event. However, if the DELETE control method handler had a logic error in which the delete was never sent to the database, but a 204 No Content *was* returned the user would be able to access the event they attempted to delete. This is incorrect behavior.

.. admonition:: Note

   The Coding Events API does not behave this way! This was an example to illustrate a logic error in a deployed application.

For both of these errors we would be forced to look into the source code of the API. Luckily, the Coding Events API is RESTful so we should have a basic understanding of where and how the request should be handled.

.. admonition:: Note

   Although you may not be required to solve development issues if you are working as an Operations professional you are required to understand the circumstances that cause a development issue to occur. This allows you to isolate a given issue into something you can solve as an Ops professional, or gives you the information you need to share with the Development team so they can patch the error in the upcoming version.

Categorize Issues
=================

A highly beneficial tool, especially when starting out, with troubleshooting is having a mental model of the deployment. What are the individual components and how might they fail? How do these components fit together, and can we categorize them?

Being able to categorize an issue will allow us to isolate the issue and only need to look at a few specific things to find the root cause of the issue.

Let's briefly define the different levels we could encounter an issue in our Coding Events API:

Network Level
-------------

The networking of our system. The Coding Events API doesn't contain much networking and only consists of the Network Security Group rules.

However for more complex deployment you may also consider:

- Subnets
- CIDR blocks
- Internet gateways
- Public vs private access
- Virtual Private Cloud
- Virtual Networks

Service Level
-------------

Our Coding Events API only works with two services:

- Key Vault (database connection string & has granted access to our VM)
- AADB2C

Not only must these services exist, and be accessible to the deployed application they must be configured properly as well. In the case of our API our Key Vault must have a secret, and most grant the VM ``get`` access to the secret. Our AADB2C must be configured to issue identity tokens and access tokens. Our AADB2C tenant must have exposed the registered Coding Events API and appropriate scopes must be granted for the registered front end application, Postman.

Host Level
----------

Our Coding Events API has a lot of things going on at the Host level inside the VM we must have:

- properly installed API dependencies (dotnet, mysql, nginx, systemd, unit file)
- source code delivery mechanism (git)
- source code build mechanism (dotnet publish)
- appropriate folder and file structure
- NGINX
- MySQL
- properly configured ``appsettings.json``

.. admonition:: Note

   In this class we have been working with a VM embedded database. In many real-world deployments this database would be a service that is external to the VM. For our deployment we consider any database issues to be at the Host level.

How to Troubleshoot
===================

.. build mental modal state of the system

Troubleshooting is the combination of asking questions and researching answers. Really the only way to troubleshoot is to have a mental model of the deployment and have an understanding of how the components are supposed to work. You can usually find the solution to any deployment issue by following a script and checking every aspect of the deployment.

Troubleshooting is the combination of asking questions and researching answers. When you are first starting it might be easiset for you to check each individual aspect of the deployment. And with a simple deployment like our Coding Events API this wouldn't be difficult. You would need to simply understand all the components of the deployment and then just check their configurations one by one until you found the issue. This can be an effective way to troubleshoot a deployment, but it is very time consuming.

A better approach is to have a mental model of the deployment and then asking questions that *lead you* to the **root cause** of the issue. 

.. admonition:: Note

   It is this question and answer approach that makes experience extremely valuable when troubleshooting. If you have seen the exact problem before and found a solution it will be easier for you to resolve that issue again.

For example if you see a ``Connection Timeout`` issue you have a good understanding of what caused this. The section above listed these things as the possible cause of a Connection Timeout:

- the URL may have been incorrect
- the VM is currently down
- the VM lacks a Network Security Group rule for the given port

Understanding these are the potential causes comes from understanding the components of the deployment, research and experience. After you know these are the potential root causes you would pick one and check it out. For example if you know from experience that you usually forget to create NSG access rules it would be a good idea to check that out first.

If you check all three of these things and the issue persists you have the opportunity to learn something new! You need to continue working on your understanding of the mental model and research additional reasons a ``Connection Timeout`` may occur.

.. admonition:: Note

   Research looks a little different for everyone as we all learn in slightly different ways. 
   
   Some of you may prefer searching the internet for Stack Overflow posts, forums, documentation, technical examples and more as the main part of your research. Some of you may prefer talking to coworkers to gain a better understanding of the mental model or to gain insight on what might be causing the issue. Usually it comes down to a combination of both to find the root cause of an issue.

Troubleshooting Script
----------------------

After building a mental model of the deployment it is beneficial to build a troubleshooting script of questions to ask when diagnosing issues. An example script is provided below:

Is this an issue?
^^^^^^^^^^^^^^^^^

- is this something I can reproduce?
- was it user error?

What is the issue?
^^^^^^^^^^^^^^^^^^

- is it something I have seen before?
- is there an error message I can use as a starting point?

What is the category of this issue?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Which level is it affecting?
- Operations or Development?

.. admonition:: Note

   If you don't know the category research it by talking with teammates, or searching the internet for individual's that have had similar experiences.

You can then create a script of possible solutions based on the questions you answered above:

Networking issues
^^^^^^^^^^^^^^^^^

- Do I have the proper NSG rules?
- Are all of my services on the same network?

Service Issues
^^^^^^^^^^^^^^

- Are my services up and running?
- Have my services been configured correctly?
- Do my services have the proper level of authorization to access each other?

Host Issues
^^^^^^^^^^^

- Are the proper dependencies fully installed? are they at the proper version (updated)?
- Are my internal services running (web server, API, MySQL)?
- Are my internal services configured properly?
- Are there any errors in the logs of the API (``journalctl -u coding-events-api``)?

Final Thoughts
^^^^^^^^^^^^^^

Remember that resolving one issue can bring a new issue to the service. Seeing a change in error message or behavior in the deployment is a great hint towards fixing the deployment!

The most effective way to build your skills in troubleshooting is by practicing troubleshooting. Each time you solve a new issue you will learn a new solution and you will increase your ability to research issues. A very benefical thing to do is to build your own troubleshooting script. The questions above give a good introduction for a troubleshooting script, as you continue to learn more about Operations continue adding to the script with your new experiences.

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
