=====================================
Operations Troubleshooting Case Study
=====================================

Operation issues are issues that don't involve the source code of the deployed application. However, you may end up with issues related to external configuration files like ``appsettings.json``.

This could be issues relating to:

- Virtual Machine
- Key Vault
- AADB2C
- MySQL
- NGINX
- application software dependencies (dotnet)
- the VM operating system (file permission issue)
- the network connecting the various resources (a network security group rule)

.. admonition:: Note

   The following group walkthrough will require you to perform these troubleshooting steps together to fix a broken deployment. The following is one example of something that *could be* wrong.

Case Study: Connection Timeout
==============================

Realize Issue
-------------

The troubleshooting process is kicked off by an issue brought to our attention. In this case someone sends us a screenshot of their browser encountering a ``Connection Timeout`` when attempting to access the public address of the hosted Coding Events API:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-browser.png

.. ::

   Getting a connection timeout in the browser could mean many things:

   - the URL may have been incorrect
   - the VM is currently down
   - the VM lacks a Network Security Group rule for the given port

   All three of these things can be easily checked by looking at the initial request and examining the Azure Portal. You can even view the VM Network Security Group rules from the AZ CLI.

Identify Issue through Duplication
----------------------------------

Our first step is to identify this issue by reproducing it on our system. This will rule out the possibility of end user error. 

First up let's reproduce the issue in the exact way the end user did with a request from the browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-browser.png

Looks like we are getting the same issue. Let's reproduce this error with PowerShell using ``Invoke-RestMethod`` from our terminal:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-powershell.png

Since this is a learning environment let's reproduce the issue again this time from Bash using curl:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-bash.png

We can definitively state that a ``Connection Timeout`` is happening when users attempt to access the Coding Events API on port 443 from the browser, ``Invoke-RestMethod`` and ``curl``.

Research Potential Causes
-------------------------

The next step is to research the potential causes of the issue. Typically you would rely on your experience and research skills to come up with a list of potential causes, but to save time we have provided them for you:

- the URL may have been incorrect
- the VM is currently down
- the VM lacks a Network Security Group rule for the given port

Isolate Root Cause
------------------

The next step is to isolate the `root cause <http://www.thwink.org/sustain/glossary/LawsOfRootCauseAnalysis.htm>`_ of the issue by systematically eliminating potential causes until we have found the root cause, or have exhausted our known options.

In this case we would need to check that the initial request was going to the correct URL, that the VM is currently running, and that the VM has the appropriate NSG inbound security rule for port 443. At this point in time in the class you should know how to do these things through the Azure Web Portal or the AZ CLI.

Just to continue the example let's say the root cause was that ``the VM lacks a NSG rule for port 443``, and we discovered this by looking at all three of the potential issues and the only one that was incorrect were the NSG rules.

Research Root Cause Fixes
-------------------------

Our next step would be to research a solution to the issue, but because of our experience we can *skip researching* as we already know how to fix it. In this case, we simply need to create a new NSG inbound rule for port 443.

Implement Root Cause Fix
------------------------

After creating the inbound port rule our final step is to reproduce the steps to ensure our issue has been resolved.

Check that Fix Resolves Issue
-----------------------------

Browser:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-resolved-browser.png

Our screen advanced and now we are getting the message about accepting the risk associated with a self-signed certificate. That's what we expect. Let's checkout PowerShell and Bash:

PowerShell:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-resolved-powershell.png

Bash:

.. image:: /_static/images/troubleshooting-next-steps/article/connection-timeout-resolved-bash.png

Uh oh. 

We are getting a new error. 

The good news is we resolved our first issue by creating a port 443 NSG inbound rule. Our fix resolved the issue, we are no longer experiencing a ``Connection Timeout`` error. We have solved this error and need to move on to the next one which according to our web requests is a ``502 Bad Gateway``.

.. admonition:: Note

   An issue is not always solved with one change. In some instances a combination of steps are necessary to solve one issue.
  
   In this case solving one issue revealed a new issue. Revealing a new issue is great progress in troubleshooting assuming you have checked that your fix resolved the initial issue, which we have done.

The final step is being able to communicate this issue and its resolution with others:

Communicate Issue with Others
-----------------------------

   The Coding Events API located at ``https://40.114.86.145/`` was not responding to HTTP requests in the browser, ``Invoke-RestMethod`` or ``curl``. Users were experiencing a ``Connection Timeout`` error.
   
   We researched potential causes for this issue and determined that the Virtual Machine did not have a NSG inbound rule allowing traffic through port 443. We opened this port to all public traffic and the issue was fixed.
   
   The ``Connection Timeout`` errors have not been experienced across ``Invoke-RestMethod``, ``curl`` or the browser after making the change.

.. admonition:: Note

   This article illustrates the entire troubleshooting process for a hypothetical operations issue in the Coding Events API deployment. 
   
   The next article will discuss two hypothetical case studies that explore potential development issues. The objective is the same, to gain a **strong understanding of the troubleshooting process**.

.. Connection Refused
.. ==================

.. Realize Issue
.. -------------

.. A user reports from the browser:

.. .. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-browser.png

.. Identify Issue through Duplication
.. ----------------------------------

.. We replicate the issue from PowerShell:

.. .. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-terminal.png

.. We replicate the issue from Bash:

.. .. image:: /_static/images/troubleshooting-next-steps/article/connection-refused-curl.png

.. Research Potential Causes
.. -------------------------

.. We research potential causes:

.. - the VM internal firewall is blocking access to the given port
.. - no processes are listening on the port the request was made to (port 443: NGINX)

.. Isolate Root Cause
.. ------------------

.. We isolate the root cause of the issue by eliminating potential causes. It is determined that the VM does not have a running application that is listening on port 443.

.. Research Root Cause Fixes
.. -------------------------

.. We research fixes for the problem and learn about a tool called ``service`` available on Ubuntu machines. The documentation shows how it can be used to check the status of and start or stop services. 

.. Implement Root Cause Fix
.. ------------------------

.. We implement the fix for the issue by starting NGINX using the ``service`` tool.

.. Check that Fix Resolves Issue
.. -----------------------------

.. We check that NGINX is successfully running this time using the ``service`` tool. Then we verify that our fix resolved the problem by accessing the application in the browser, from PowerShell and Bash.

.. Communicate Issue with Others
.. -----------------------------

..    Users were reporting a ``connection refused`` error when making HTTP requests to the Coding Events API. The issue was confirmed across three different clients using the browser, ``Invoke-RestMethod`` and ``curl``.
   
..    It was determined that the NGINX web server was not running. We started the NGINX web server and the issue was resolved.
   
..    We verified the issue was resolved by using a web browser, ``Invoke-RestMethod`` and ``curl``.

.. Bad Gateway
.. ===========

.. Realize Issue
.. -------------

.. From the browser:

.. .. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-browser.png

.. Identify Issue through Duplication
.. ----------------------------------

.. From PowerShell:

.. .. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-powershell.png

.. From Bash:

.. .. image:: /_static/images/troubleshooting-next-steps/article/bad-gateway-curl.png

.. Research Potential Causes
.. -------------------------

.. Research the error code to determine potential causes:

.. A bad gateway is an issue between *servers*. In the case of our deployment we have two web servers that could be related -- NGINX and the Coding Events API.

.. Research potential causes:

.. - the ``coding-events-api`` service was never started
.. - the VM was restarted and the ``coding-events-api`` is not configured to start itself on a reboot
.. - an error in the Coding Events API source code has kept the application from starting
.. - the Coding Events API may require access to another cloud resource (like Key Vault), but lacks the authorization, or name of the resource

.. Isolate Root Cause
.. ------------------

.. Isolate the root cause by systematically checking the potential causes to determine the VM was restarted and the ``coding-events-api`` was not configured to restart itself after a VM reboot.

.. Research Root Cause Fixes
.. -------------------------

.. To fix the issue we will need to start the coding-events-api which we can do with the ``service`` tool we previously learned about. However, to keep this issue from happening in the future we need to figure out how to make the coding-events-api restart itself if the VM reboots. Our research resulted in finding a tool called ``systemctl`` which gives us the ability to start a service on reboot.

.. Implement Root Cause Fix
.. ------------------------

.. We implement the fix by using ``systemctl`` to make the service start during machine startup and ``service`` to start the service immediately.

.. Check that Fix Resolves Issue
.. -----------------------------

.. We check that the coding-events-api is running by using ``service`` again and by making a request to the API in the browser, from PowerShell and from Bash.

.. Communicate Issue with Others
.. -----------------------------

..    Users were reporting a ``502 Bad Gateway`` error. Reports were confirmed in browser and by using ``Invoke-RestMethod`` and ``curl``. 
   
..    It was determined that the ``coding-events-api`` was not running after a recent VM reboot. The API was started with the ``service`` tool and the service was *enabled* so it will automatically start the next time the VM reboots.