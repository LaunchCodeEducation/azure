===============================
Introduction to Troubleshooting
===============================

Troubleshooting is one of the most important skills to the Operations professional. 

.. You will come to find **troubleshooting is in large part research**. There are many ways an issue can be brought to your attention, but they will usually only be able to tell you what odd behavior occurred and some of the conditions that led to the error. The next steps are left up to you.

Troubleshooting is the process of:

#. realizing an issue exists
#. identifying the issue through duplication (how and under what conditions it happens)
#. researching the potential causes of the issue
#. isolate the root cause of the issue by systematically eliminating the potential causes
#. researching a fix for the root cause of the issue
#. fixing the root cause of the issue
#. checking that the fix resolves the issue
#. communicating about the issue with others

As you can see from this list **research is a foundational aspect of troubleshooting**. After an issue has been discovered it is usually up to the Operations team to identify the issue, research the issue, and ultimately fix the issue. 

Troubleshooting skills are improved through experience. At the start of your career you won't have much knowledge of what can go wrong, and how to fix a broken deployment. However, as you continue to research and fix issues your troubleshooting skills will grow with your knowledge of potential issues.

In this article we will discuss issues you may have already experienced through this class and how we could use the steps above to resolve the issue.

The following article will focus on **how** to troubleshoot by introducing tools, discussing how to research and developing a troubleshooting script of questions.

.. admonition:: note

   This chapter is in no way exhaustive, as you continue throughout your career you will learn about new techniques, tools, and solutions to issues.

Although development troubleshooting will be mentioned this class will primarily focus on Operations troubleshooting.

To start let's build some troubleshooting knowledge by examining some issues we may have seen already when deploying the Coding Events API and apply the troubleshooting steps to resolve the issue.

What You May Have Experienced Already
=====================================

Throughout the Azure portion of this class we have focused on operations and we will explore more operations issues. However, identifying, communicating, and resolving development issues is often a responsibility of the DevOps professional.

We will look at some of the common operations and development issues.

.. admonition:: Note

   The issues throughout this article will be framed as issues in the Coding Events API. Many of the issues discussed may be similar, or identical, to issues seen across many different deployments.

Example Operation Issues
========================

Operation issues are issues that don't involve the source code of the deployed application. This could be issues relating to:

- Virtual Machine
- Key Vault
- AADB2C
- MySQL
- NGINX
- application software dependencies (dotnet)
- the VM operating system (file permission issue)
- the network connecting the various resources (a network security group rule)
- application external configurations (``appsettings.json`` or a Key Vault secret)

The first example will walk you through all of the troubleshooting steps to illustrate the process. The remaining examples will simply discuss or show the issue and talk about the potential root causes.

.. admonition:: Note

   The following group walkthrough will require you to perform the troubleshooting steps together. If you pay attention to the potential root causes, you may figure out how to solve some of the issues will a relatively small amount of research.

Connection Timeout
------------------

Realize Issue
^^^^^^^^^^^^^

The troubleshooting process is kicked off by an issue brought to our attention. In this case someone sends us a screenshot of their browser encountering a ``Connection Timeout`` when attempting to access our API in the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-browser.png

.. ::

   Getting a connection timeout in the browser could mean many things:

   - the URL may have been incorrect
   - the VM is currently down
   - the VM lacks a Network Security Group rule for the given port

   All three of these things can be easily checked by looking at the initial request and examining the Azure Portal. You can even view the VM Network Security Group rules from the AZ CLI.

Identify Issue through Duplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Our first step is to identify this issue by reproducing it on our system. This will rule out the possibility of end user error. 

First up let's reproduce the issue in the exact way the end user did with a request from the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-browser.png

Looks like we are getting the same issue. Let's reproduce this error with PowerShell using ``Invoke-RestMethod`` from our terminal:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-powershell.png

Since this is a learning environment let's reproduce the issue again this time from Bash using curl:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-bash.png

We can definitively state that a ``Connection Timeout`` is happening when users attempt to access the Coding Events API on port 443 from the browser, Invoke-RestMethod and curl!

Research Potential Causes
^^^^^^^^^^^^^^^^^^^^^^^^^

The next step is to research the potential causes of the issue. Typically you would rely on your experience and research skills to come up with a list of potential causes, but to save time we have provided them for you:

- the URL may have been incorrect
- the VM is currently down
- the VM lacks a Network Security Group rule for the given port

Isolate Root Cause
^^^^^^^^^^^^^^^^^^

The next step is to isolate the `root cause <http://www.thwink.org/sustain/glossary/LawsOfRootCauseAnalysis.htm>`_ of the issue by systematically eliminating potential causes until we have found the root cause, or have exhausted our known options.

In this case we would need to check that the initial request was going to the correct URL, that the VM is currently running, and that the VM has the appropriate NSG inbound security rule for port 443. At this point in time in the class you should know how to do these things through the Azure Web Portal or the AZ CLI.

Just to continue the example let's say the root cause was that ``the VM lacks a NSG rule for port 443``, and we discovered this by looking at all three of the potential issues and the only one that was incorrect were the NSG rules.

Research Root Cause Fixes
^^^^^^^^^^^^^^^^^^^^^^^^^

Our next step would be to research a solution to the issue, in this case we simply need to create a new NSG inbound rule for port 443.

Implement Root Cause Fix
^^^^^^^^^^^^^^^^^^^^^^^^

After fixing the issue our final step is to reproduce the steps to ensure our issue has been resolved!

Check that Fix Resolves Issue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-resolved-browser.png

Our screen advanced and now we are getting the message about accepting the risk associated with a self-signed certificate. That's what we expect! Let's checkout PowerShell and Bash:

PowerShell:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-resolved-powershell.png

Bash:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-resolved-bash.png

Uh oh! 

We are getting a new error. 

The good news is we resolved our connection timeout issue by opening port 443 NSG inbound rule. Our fix resolved the issue, we are no longer experiencing a ``Connection Timeout`` error. We have solved this error and need to move on to the next one which according to our web requests is a ``502 Bad Gateway``.

.. admonition:: Note

   An issue is not always solved with one change. In some instances a combination of steps are necessary to solve one issue.
  
   In this case solving one issue revealed a new issue. Revealing a new issue is great progress in troubleshooting assuming you have checked that your fix resolved the initial issue, which we have done!

The final step is being able to communicate this issue with others:

Communicate Issue with Others
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Coding Events API located at ``https://40.114.86.145/`` was not responding to HTTP requests in the browser, ``Invoke-RestMethod`` or ``curl``. Users were experiencing a ``Connection Timeout`` error. We researched potential causes for this issue and determined that the Virtual Machine did not have a NSG inbound rule for port 443. We opened this port to all traffic and the issue was fixed. ``Connection Timeout`` errors have not been experienced across ``Invoke-RestMethod``, ``curl`` or the browser after making the change.

Connection Refused
------------------

Realize Issue
^^^^^^^^^^^^^

A user reports from the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-browser.png

Identify Issue through Duplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We replicate the issue from PowerShell:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-terminal.png

We replicate the issue from Bash:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-curl.png

Research Potential Causes
^^^^^^^^^^^^^^^^^^^^^^^^^

We research potential causes:

- the VM internal firewall is blocking access to the given port
- no applications are listening on the port the request was made to (port 443: NGINX)

Isolate Root Cause
^^^^^^^^^^^^^^^^^^

We isolate the root cause of the issue by eliminating potential causes. It is determined that the VM does not have a running application that is listening on port 443.

Research Root Cause Fixes
^^^^^^^^^^^^^^^^^^^^^^^^^

We research fixes for the problem and determine a tool called ``service`` that allows you to check the status of services and allow you to start services. 

Implement Root Cause Fix
^^^^^^^^^^^^^^^^^^^^^^^^

We implement the fix for the issue by starting NGINX using the ``service`` tool.

Check that Fix Resolves Issue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We check that NGINX is successfully running this time using the ``service`` tool. Then we verify that our fix resolved the problem by accessing the application in the browser, from PowerShell and Bash.

Communicate Issue with Others
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users were reporting a connection refused when making HTTP requests to the Coding Events API. The issue was confirmed by using the browser, Invoke-RestMethod and curl. It was determined that the NGINX web server was not running. We started the NGINX web server and the issue was resolved. We verified the issue was resolved by using a web browser, Invoke-RestMethod and curl.

Bad Gateway
-----------

Realize Issue
^^^^^^^^^^^^^

From the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-browser.png

Identify Issue through Duplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From PowerShell:

.. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-powershell.png

From Bash:

.. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-curl.png

Research Potential Causes
^^^^^^^^^^^^^^^^^^^^^^^^^

Research the error code to determine potential causes:

A bad gateway is an issue between *servers*. In the case of our Coding Events API we have two web servers NGINX which proxies requests to the Coding Events API server.

Research potential causes:

- the ``coding-events-api`` service was never started
- the VM was restarted and the ``coding-events-api`` is not configured to start itself on a reboot
- an error in the Coding Events API source code has kept the application from starting
- the Coding Events API may require access to another cloud resource (like Key Vault), but lacks the authorization, or name of the resource

Isolate Root Cause
^^^^^^^^^^^^^^^^^^

Isolate the root cause by systematically checking the potential causes to determine the VM was restarted and the ``coding-events-api`` was not configured to restart itself after a VM reboot.

Research Root Cause Fixes
^^^^^^^^^^^^^^^^^^^^^^^^^

To fix the issue we will need to start the coding-events-api which we can do with the ``service`` tool we previously learned about, however to keep this issue from happening in the future we need to figure out how to make the coding-events-api restart itself if the VM reboots. Our research resulted in `systemctl enable <https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units>`_ which gives us the ability to start a service on reboot, and it will attempt to restart itself any time it goes down!

Implement Root Cause Fix
^^^^^^^^^^^^^^^^^^^^^^^^

We implement the fix by using ``systemctl enable`` and ``service`` to start the service.

Check that Fix Resolves Issue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We check that the coding-events-api is running by using ``service`` again and by making a request to the API in the browser, from PowerShell and from Bash!

Communicate Issue with Others
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users were reporting a ``502 Bad Gateway``. Reports were confirmed in browser and by using ``Invoke-RestMethod`` and ``curl``. It was determined that the ``coding-events-api`` was not running after a recent VM reboot. The API was started with the ``service`` tool and the service was *enabled* so it will automatically start the next time the VM reboots.

Example Development Issues
==========================

Development issues relate to the source code of a deployed application. *Ideally* these issues are discovered before reaching the live production environment by automated tests and Quality Assurance testers. However, sometimes these issues are discovered by end users who usually report that the application is not behaving correctly. 

The deployment isn't necessarily broken, however the application is not behaving properly.

500 Internal Server Error
-------------------------

Realize Issue
^^^^^^^^^^^^^

A user sends a report that they received an HTTP response of ``500 Internal Server Error`` when sending a GET request for a specific coding event.

A ``500 Internal Server Error`` is almost **always** the result of a runtime error within the source code of the application.

Identify Issue through Duplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We first reproduce the issue by requesting the specific coding event, and then we continue attempting to reproduce the issue with other specific coding events. We are trying to determine if it is something special about this one coding event, or if it is a behavior seen across all coding events. In this case it's just this specific coding event that is experiencing this issue.

Research Potential Causes
^^^^^^^^^^^^^^^^^^^^^^^^^

In researching potential causes across the internet and talking to some of the developers on the team we come up with one potential reason:

- this coding event may have a special character that is not serializing to or from the database correctly

Isolate Root Cause
^^^^^^^^^^^^^^^^^^

It's a short list, but at least we can check something. 

We fire up MySQL and make a request for the specific coding events record. We notice this coding event has some special characters in it ``â€``. We put in a breakpoint to pause the application before it pulls the data out of the database and step through. Alas as our API tries to serialize the special characters the ORM throws an error and our API returns a ``500 Internal Server Error``.

Research Root Cause Fixes
^^^^^^^^^^^^^^^^^^^^^^^^^

Next we research solving this error and find a couple of solutions:

- change the underlying data in MySQL
- implement a third party library that assists in special character serialization
- write our own database special character serialization library

It is never a good idea to change the underlying data that is owned by end users so the first option is out! The remaining two options have obvious pros and cons. It would be faster to implement the third party library, however we would need to research the library to make sure it doesn't contain insecure code and that it won't break any of our existing functionality. Writing our own library would give us full control and the ability to make it as secure as we need, but would take development time.

.. admonition:: Note

   The decision between implementing a third party library and writing an in house solution is one that is typically made by management and senior level engineers. This is a situation in which effectively communicating the issue is extremely important!

Implement Root Cause Fix
^^^^^^^^^^^^^^^^^^^^^^^^

Being a junior dev we decide *this issue needs to be elevated to our superior* as we don't feel comfortable reviewing the security of a third party library. 

We explain the issue, the solutions we found, and pass the information to our senior who thanks us for not only finding the issue, but with researching potential fixes. The senior engineers will research the third party library and management will decide on the proper course of action!

Communicate Issue with Others
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An HTTP ``500 Internal Server Error`` was encountered when a database record contained various special characters. Upon debugging the application it was discovered that the current ORM serialization libraries were incapable of working with various special characters. The issue was elevated to senior developers who are determining on how to resolve the issue.

.. admonition:: Note

   The Coding Events API does not behave this way! This was simply an example of how a 500 Internal Server Error could occur and how you may resolve, or in this case, identify, isolate, research, and pass it to a more senior developer.

API Bug
-------

Realize Issue
^^^^^^^^^^^^^

A user reports a bug in the API. It isn't throwing any errors, but the application is not behaving correctly. When the user deletes a coding event they are the owner of they can still view and edit the coding event.

An API bug is almost **always** the result of a logic error within the source code of the application.

Identify Issue through Duplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We first reproduce the issue with a copy of the exact event in which we also behave the incorrect DELETE error. We also notice that any coding event we create cannot be deleted despite a proper DELETE request coming through.

Research & Isolate Root Cause
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We research the issue, luckily this is easy because we know how a RESTful API works and feel confident looking at the source code. Upon looking at the source code we can see the line that sends the resource deletion to the ORM is commented out and skips straight to sending back a ``204 No Content``! Our research indicates:

- fixing the source code error may resolve the issue


Implement Root Cause Fix
^^^^^^^^^^^^^^^^^^^^^^^^

We build the project locally on our machine and make the change. It seems to work, however since this is not a project we are a developer for we will just communicate this issue and resolution to the dev team responsible for this project. After all the dev team may have their reasons for that specific line we edited.

Luckily we are very capable of explaining the issue, our research, and our proposed solution to the problem. After communicating it to them the dev team will be responsible for making the change and running it through the automated tests to make sure the change doesn't result in any unexpected behaviors.

Communicate Issue with Others
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users reported that after deleting an event the event was still accessible. We reproduced the issue and found that the reported behavior was consistent across all events. Upon investigating the issue it was determined that the RESTful API event DELETE method was not implemented correctly. The dev team needs to re-examine this method to determine why the RESTful API is not deleting resources correctly.

.. admonition:: Note

   The Coding Events API does not behave this way! This was an example to illustrate a logic error in a deployed application.