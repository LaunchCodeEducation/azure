.. _intro_az-cli:

================================================
Why should we use a CLI instead of a web portal?
================================================

Up to this point we have been using the Azure Web Portal to provision and manage our Azure resources. Using the terminology we have learned we would refer to this site as a graphical user interface, or GUI. Graphical User Interfaces can be convenient and intuitive to use but have different use cases than their text-based counterpart -- the CLI.

GUIs are great to look at and arguably offer a more intuitive experience *to a human*. But when it comes to programmatic management CLIs shine in the following key areas:

- access to features
- workflow efficiency
- automation capability

While the purpose of this lesson is to inspire your understanding and appreciation for CLIs they *are not always the best choice*. Sometimes GUIs offer an abstraction over more tedious work that can make them worth using. Like most things in the development world you should not blindly adhere to a single approach. What is most important is **to select the right tool for the job** that empowers your workflow.

The Azure Brain
===============

The Azure Web Portal, with its intuitive layout and interactive menus, is actually just a "skin" that is backed by a comprehensive "brain" of a REST API. Any actions you take on the web portal to manage your Azure resources are ultimately fulfilled by HTTP requests sent `to this REST API <https://docs.microsoft.com/en-us/rest/api/azure/>`_. What are the benefits of developing a REST API that is distinct from the online GUI front end?

Recall a web API operates **independent of any user interface(s) that consume it**. By separating their data management [API] from their presentation [UI] they are able to support flexibility and **multiple types of interfaces** against a single consistent service. In the case of Azure that single REST API supports both the GUI web portal *and* the ``az CLI``.

.. todo:: diagram showing Azure -> REST API ->/-> Web Portal / CLI

At this point you understand the design decision of decoupling their API from their UIs, but the question still remains -- why should we bother using a CLI?

Access to Features
==================

A GUI inherently requires additional development work to produce the layouts, buttons, and other components needed for a user to interact with it. Their graphical nature will always be more complex to develop and maintain than a text-based, CLI, counterpart.

Whenever a new resource, service or capability is supported internally by Azure it takes time for both GUI and CLI to have the feature added for use. The process looks something like:

#. internal development of new feature
#. implement support in the Azure REST API
#. implement support in the CLI
#. implement support in the GUI (if at all)

Because of the complexity of developing GUIs you can expect that access to new features will be released to the CLI before, if ever, the web interface is updated.

Now consider the more granular management tasks that you may need to perform on your resources. It stands to reason that priority in GUI development will always be given to the *most common* needs before spending time developing the graphics to support more niche areas. Again, because of their simplicity, CLIs will have more more comprehensive features added to them that may never even reach the GUI.

There are two key takeaways here about a system, of which Azure is but one example, which supports both a GUI and CLI:

- **the CLI will receive the latest additions and updates before the GUI**
- **the CLI will have more granular management capabilities that aren't present on the GUI** 

Workflow Efficiency
===================

When it comes to humans interacting with computers there is little doubt that GUIs are more intuitive to work with. But as a technical user your top priority is in choosing an interface that helps you get the job done quickly. On the whole CLIs are the speedier choice for power users because they enable you to issue the exact commands you need and bypass visual distractions. 

CLIs trade ease of exploration, beneficial to newcomers, for brevity and precise control. Whereas GUIs excel in visually guiding you, CLI tools leave it to you to be the guide. They require you to be direct with what you need done but by doing so allow you to complete your tasks more efficiently. 

As an example, let's consider the process of provisioning a new VM from both the web GUI and the ``az CLI``.

Using the web portal you would need to:

#. open your browser
#. navigate to the azure portal and log in
#. search for the VM resource
#. load the "create VM" wizard
#. work through several menus to configure the VM
#. confirm and provision

Using the CLI you would need to open your terminal and enter a single command:

.. sourcecode:: bash

    $ az vm create <configuration options>

On the one hand the GUI is helpful in providing visual cues and menus to guide you through the process. On the other hand the CLI allows you to skip directly to issuing the exact instructions for the work you need done. This is just one example that highlights the conciseness with regard to *manual* steps. But the real power of CLI tools comes in their automation capabilities.

Automation Showdown
===================

While the CLI is faster to work with we only looked through the lens of manually interacting with the two interfaces. Eventually the goal of any ops specialist is to automate their work! Automation is as much about saving valuable work time as it is about **ensuring consistent behavior**. 

.. tip::

    Computers excel at performing tasks exactly the same way every time. Whatever they are commanded to do they will do without fail or fatigue. Humans on the other hand are prone to introducing errors. For large complex systems the less human interaction involved the less likely that errors will occur. For this reason automation is a core tenant of modern development.

Let's revisit the example from earlier. But this time consider the task of provisioning 1000 VMs. Any human-based solution would require repeating steps 4-6 from above 1000 times. You can imagine that at some point the human would grow tired and as a result make a mistake in one or more of the configuration options. While humans don't have a "loop" ability our scripting languages certainly do!

Here is a basic example in PowerShell invoking the ``az CLI``:

.. sourcecode:: none
    :caption: powershell example

    for($VmCount=0; $VmCount -lt 1000; ++$VmCount) {
        az vm create <configuration options>
    }


Some of you might say, "Couldn't we write a browser script to automate navigating the web portal?" While this is possible it is significantly more complex than a 2-line loop. Worse yet is that GUIs, especially web-based ones, are more prone to updates and redesigns than CLIs. Which means if UI updates occur your script will likely break!

This is just one of thousands of automation examples you will come across in your career. We will explore semi-automatic and fully-automatic automation approaches in the coming sections. For now you can take away an appreciation for the CLI, as foreign as it may seem initially, as it will soon become one of your closest allies. 

Next Step
=========

At this point you understand the strengths of CLI tools like the ``az CLI`` and are ready to see how it can be used. In the next article we will explore how its commands are organized and used to manage your Azure resources.
