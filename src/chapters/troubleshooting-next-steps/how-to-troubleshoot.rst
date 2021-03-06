===================
How to Troubleshoot
===================

As a reminder, troubleshooting is the process of:

#. Realizing an issue exists
#. Identifying the issue through duplication (how and under what conditions it happens)
#. Researching the potential causes of the issue
#. Isolate the root cause of the issue by systematically eliminating the potential causes
#. Researching a fix for the root cause of the issue
#. Fixing the root cause of the issue
#. Checking that the fix resolves the issue
#. Communicating about the issue with others

This process can seem daunting because it involves *researching information you don't already know*. To effectively research things you don't understand you must be able to *ask the correct questions*.

.. admonition:: Note

   The best way to learn troubleshooting is to practice the skill. However, you don't have to go into your practice completely blind. 
   
   This section will present you with ideas, tips, and tricks for assisting with the troubleshooting process.

In this section we will discuss:

- Common issues across web deployments and common HTTP status codes to look out for
- Researching strategies
- Creating a Coding Events API deployment mental model
- Creating questions from the mental model
- Creating a Coding Events API deployment troubleshooting checklist from our questions and mental model
- How to effectively communicate an issue and the troubleshooting process
- Troubleshooting tools we may use to troubleshoot the Coding Events API in our walkthrough

.. build a mental model of the system to come up with potential causes of issues
.. build a troubleshooting checklist to assist in discovering potential causes of issues
.. research error messages and strange behavior to further learn about potential causes of issues
.. research solutions to potential causes of issues
.. isolate the root cause of the issue by eliminating potential causes
.. communicate issue with others
.. know your tools lot's of different tools can be used for troubleshooting in the next walkthrough we will show you how to use:

.. :: 

   Example
   -------

   In the ``Connection Timeout`` section above you were presented with three potential causes of the ``Connection Timeout`` issue within the Coding Events API.

   Let's review them again:

   - the URL may have been incorrect
   - the VM is currently down
   - the VM lacks a Network Security Group rule for the given port

   When we make a request from the browser to the Coding Events API (https://<coding-events-api-public-ip>) if a ``Connection Timeout`` issue is noticed we would need to answer three simple questions to find the root cause of our issue:

   - did we type the URL correctly?
   - is the VM running?
   - does the VM have an inbound Network Security Group rule for port 443 that allows all traffic?

   If the answer to any of these questions is *no* we have found a potential solution to the issue. 

   To resolve this issue we will need to fix the question, or questions, that we responded *no* to. After ensuring that all three of these things are correct we make a new request to Coding Events API to see if the issue was resolved.

   .. admonition:: Note

      When you are starting out it is a good idea to try each question we responded *no* to by itself and re-try the request. This will help you isolate the issue, so upon solving the issue you know definitively what caused the issue.

   Understanding these potential causes comes from understanding the components of the deployment, research and experience. When you are starting with troubleshooting you don't have much experience so you will have to lean on your research skills to figure out the potential causes to a problem.

   .. admonition:: Note

      Research looks a little different for everyone as we all learn in different ways:
      
      - searching the internet
      - talking with coworkers
      - trial and error
      - drawing components and integrations
      
      Usually it comes down to a combination of research forms to find the root cause of an issue.

Identify Common Issues
======================

Identifying an issue can be the most difficult part of troubleshooting. As your knowledge of potential causes grows, it will become easier to identify issues. Until that point in time, you will have to utilize your research skills to determine potential causes.

For now, knowing what some of the most *common* issues encountered are, and being able to *ask and answer questions about your deployment* will be your two biggest tools for identifying an issue and its potential causes.

.. admonition:: Warning

   When you are still in the process of identifying an issue it is crucial to *not make any changes*! 
   
   Every change you make needs to be accounted for, because you may need to undo the change to put the system back in its original state. Changes are necessary to resolve the issue, but while you are still identifying and researching you want the system to exist in its initial state.

Let's take a look at some of the most common issues seen in web deployments (this list is not exhaustive):

.. list-table:: Common Issues
   :widths: 30 40 40
   :header-rows: 1

   * - Error Message
     - Description
     - Common cause
   * - Connection Refused
     - The server received the request, but refuses to handle it
     - no application listening on the given port
   * - Connection Timeout
     - The server did not respond to the client request within a specific time period
     - missing NSG inbound rule
   * - HTTP Status Code: 502 Bad Gateway
     - A server received an incorrect response from another server
     - web server is running, but the application is not
   * - HTTP Status Code: 401 Unauthorized
     - The request did not include credentials indicating a user needs to *authenticate*
     - credentials were not included
   * - HTTP Status Code: 403 Forbidden
     - The request included credentials, but the authenticated user does not have the proper level of *authorization*
     - credentials are not correct, or have not been configured properly
   * - HTTP Status Code: 500 Internal Server Error
     - The request was received, however the server encountered an issue it doesn't know how to resolve
     - runtime error in the source code

As you may have noticed, may of the most common issues are `HTTP status codes <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>`_. These status codes are a standard across HTTP, so learning the various categories and individual status codes will be *invaluable* when troubleshooting a web deployment.

Researching
===========

Researching is a vital part of the troubleshooting process, especially when you are not aware of many potential causes of issues.

Being able to clearly state the issue is a powerful tool when researching potential causes. Not only will it be beneficial to communicate with your fellow teammates and superiors as a part of your research, but knowing how to phrase your question to a search engine to optimize the results can save a lot of time.

For theses reasons, it is beneficial to be able to state the issue in plain english. This helps in both communicating with people, and optimizing search engine results.

Tools for Identifying and Reproducing Issues
--------------------------------------------

Before you can even begin researching an issue it must first be brought to your attention. 

You may discover an issue on your own through your day-to-day activities, but it is more likely an issue will be submitted by QA or an end user through some form of ticketing software. The ticketing software will usually provide you with a brief description of what the issue was, and the conditions in which the issue was exposed. In some instances, you may need to reach out to the QA team or end user to gather more information about the issue.

.. admonition:: Note

   Ticketing software goes outside the scope of this class. However, you should learn how the ticketing system your team uses works, as it is the most reliable method for initially discovering an issue.

After realizing an issue exists, the next step is for you to reproduce the issue in your own environment. To gain a better understanding than what the end user or QA provided you with, you will want to keep an eye out for HTTP status codes and logs.

The HTTP status codes aren't always recognizable in the browser, but provide you with tremendous insight on potential causes. You will want to check the logs of the application, which will have a record of any runtime errors that the web server encountered.

.. admonition:: Note

   We will access the logs of the Coding Event API by using the Bash tool: ``journalctl``. However, in most real-world deployments the logs will usually be externalized. In the example in this chapter we will be looking at internal logs.

Search Engine Skills
--------------------

One of the easiest and first-line steps of researching should be to search for an error message using a search engine like Bing or Google. You will be presented with the experiences of thousands of developers before you that have witnessed the same, or a similar issue. Often you can find the exact potential cause of the issue with very little effort by reading the experiences people have had on StackOverFlow or other tech forums. 

With a more unique issue you may not find any results referencing your exact issue. However, you should be able to find documentation, or source code that caused the issue. By reading through the documentation or source code you can usually find potential causes of the more rare issue.

.. admonition:: Note

   Learning basic search engine operators and syntax can greatly optimize your ability to find relevant information. Advanced usage of search engines is outside the scope of this class, but you can learn some basics about refining Google search requests from `this article <https://support.google.com/websearch/answer/2466433?hl=en>`_.

Talking with Teammates
----------------------

Outside of search engines, talking with your teammates can be a fantastic way to learn about new potential causes. Many of your teammates will have more experience in troubleshooting, and you may be able to use their knowledge of potential causes to bolster your own knowledge.

In addition to learning from your teammates, simply talking through the issue with someone else serves as `rubber duck debugging <https://en.wikipedia.org/wiki/Rubber_duck_debugging>`_. Often, just the act of explaining everything out loud will bring a potential cause to the top of your mind!

Create a Visual Representation of the System
--------------------------------------------

To further your insight into potential causes of issues, take some time to sketch out the entire deployment. Doing so will force you to think about all of the components and their interactions. Visualizing the system, as opposed to simply talking about it, forces you to examine the system from a new perspective.

.. admonition:: Note

   This visualization is similar to creating a mental model of the system. However the act of drawing the system by hand will engage different areas of your brain, which may spur the creativity necessary for you to identify a new potential cause.

Trial and Error
---------------

As a final suggestion for researching, you can use trial and error. Trial and error is the processing of making an educated guess of the root cause of an issue and making a small change related to that guess.

Trial and error can be tricky, because every change made to the state must be recorded. If you aren't certain that your guess is correct, you should record the change that you made. If your guess is incorrect, you may need to revert the change to reset the deployment to its initial state.

Trial and error is a valid research strategy when the above methods don't provide you with the information you need to resolve the issue. However, trial and error should be approached with care unless you are in a controlled environment, such as an education environment (this class), or a personal environment.

.. admonition:: Warning

   You should only resort to trial and error when working with a live environment or data set as a last resort.

Create a Mental Model of the System
===================================

Troubleshooting follows a very specific pattern, as mentioned at the start of this section and in the previous section. 

The pattern is relatively easy to follow once you have come up with a *list of potential causes*. You will learn many of the potential causes throughout your career, but when you are first starting it is difficult to know many potential causes.

A highly beneficial tool for determining potential causes is having a strong mental model of the deployment. If you can recognize the individual components, and are aware of how the components can fail or be misconfigured, you are well on your way to performing a root cause analysis.

To help determine a list of potential causes, consider the related components and categorize issues based on the related components. This will help you come up with a troubleshooting checklist of potential issues to check.

To assist you in the task of categorizing issues, we have created various levels. The levels are completely arbitrary, and differ between deployments. 

Use these categories as a tool to help you determine potential causes and develop a troubleshooting checklist.

Network Level
-------------

The networking of our system. The Coding Events API doesn't contain much networking and only consists of the Network Security Group rules.

However for more complex deployment you may also consider:

- Subnets
- CIDR blocks
- Internet gateways
- Public vs private access
- Virtual Private Cloud

Service Level
-------------

Our Coding Events API only works with two services:

- Key Vault (database connection string & has granted access to our VM)
- AADB2C

Not only must these services exist and be accessible to the deployed application, they must be configured properly as well. In the case of our API, our Key Vault must have a secret, and must grant the VM ``get`` access to the secret. Our AADB2C must be configured to issue identity tokens and access tokens. Our AADB2C tenant must have exposed the registered Coding Events API, and appropriate scopes must be granted for the registered front end application, Postman.

For a more complex deployment you may also consider:

- External database server
- External API that an application depends on
- External search engine service

Host Level
----------

Our Coding Events API has a lot of things going on at the Host level inside the VM. We must have:

- Properly installed API dependencies (dotnet, mysql, nginx, systemd, unit file)
- Source code delivery mechanism (git)
- Source code build mechanism (dotnet publish)
- Appropriate folder and file structure
- NGINX
- MySQL
- properly configured ``appsettings.json``

.. admonition:: Note

   In this class we have been working with a VM-embedded database. In many real-world deployments this database would be a service that is external to the VM. For our deployment, we consider any database issues to be at the Host level.

General Troubleshooting Questions
=================================

Using the mental model of this deployment, we can start coming up with questions to guide our research into the issue:

Is This an Issue?
-----------------

- Was it user error?
- Is this something I can reproduce?

What is the Issue?
------------------

- Is this issues something I have seen before?
- Is there an error message I can use as a starting point for my research?
- How would I summarize this issue to others?
- Can I state this issue in plain English?
- How would I enter this issue to a search engine?

What is the Category of This Issue?
-----------------------------------

- Which level is this issue affecting (network, service, host)?
- Could this issue span multiple levels?
- Is this an operations or development issue?

.. admonition:: Note

   If you don't know the category, research the issue by talking with teammates, or searching the internet for other people's experiences that have had similar problems.

You can then create a troubleshooting checklist of possible solutions based on the questions you answered above.

Troubleshooting Checklist
=========================

Using our general troubleshooting questions and our Coding Events API mental model, we have started a troubleshooting checklist for this specific deployment. (Note it is not complete, and you will be expanding on this in the upcoming walkthrough and throughout the rest of your career):

Networking issues
-----------------

- Do I have the proper NSG rules?
- Are all of my services on the same network?

Service Issues
--------------

- Are my external services up and running?
- Have my services been configured correctly?
- Do my services have the proper level of authorization to access each other?

Host Issues
-----------

- Are the proper dependencies fully installed?
- Are my internal services running?
- Are my internal services configured properly?
- Are there any errors in the logs of the API?
- Does the application use any configuration files?
- Are the configuration files configured properly?

Troubleshooting Checklist Final Thoughts
----------------------------------------

Using a troubleshooting checklist in combination with the steps of troubleshooting can provide you with the information necessary to solve a problem.

Remember that resolving one issue can bring a new issue to the surface. Seeing a change in error message or behavior in the deployment is a great hint towards fixing the broken deployment!

The most effective way to build your skills in troubleshooting is by practicing troubleshooting. Each time you solve a new issue you will learn a new solution and you will increase your ability to research issues. 

A very beneficial thing to do is to build *your own troubleshooting checklist*. The questions above provide a good starter checklist. As you continue to learn more about operations, continue adding to the checklist with your new experiences.

Communicate the Issue
=====================

Communicating the issue is as simple as defining each part of the troubleshooting process you have worked through so far:

- State how the problem was identified
- State how the problem was proven through reproduction
- State the potential causes that were discovered
- State the solution to the problem
- State how the solution was verified or any steps taken to pass the issue to someone else

You will find communicating is not only a powerful tool for reporting to superiors, but is a beneficial tool when building a mental model of the system, and when researching potential causes by talking to coworkers.

Troubleshooting Tools
=====================

The tools you will use for troubleshooting vary. Sometimes you are locked in to a set of troubleshooting tools based on the tech stack of your deployment. For example, if you are using Windows Server and have a personal Windows operating system, the troubleshooting tools will be slightly different than if you were deploying to an Ubuntu server and have a personal MacOS. 

.. admonition:: Note

   In some instances, you will use multiple sets of troubleshooting tools. 
   
   Consider the Coding Events API deployed to an Ubuntu Virtual Machine. If you need to access a tool internal to the VM you are locked in to the tools that are usable with Ubuntu. However, your personal computer may have access to a completely different set of tools.

Tool preference will also vary across teams and individuals. You may have a personal preference for one tool, but choose to work with a different tool to match the preference of your team. You will experience new tools as you advance throughout your career. Learning the preferred tools is one of the first tasks you should accomplish when joining a new team.

In the upcoming walkthrough we will introduce a variety of tools that can be used throughout the troubleshooting process of the Coding Events API. Part of being a successful troubleshooter is the ability to learn and effectively use new troubleshooting tools. Feel free to share any other tools that would be helpful with your fellow teammates.