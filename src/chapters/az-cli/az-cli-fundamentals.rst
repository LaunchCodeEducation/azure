.. _az-cli-fundamentals:

================================
Azure CLI Practical Fundamentals
================================

The Azure CLI has been developed as an `open source <https://github.com/Azure/azure-cli>`_ cross-platform tool. Like the ``dotnet CLI`` it works the same whether you are executing it on Windows, Linux, or OSX through either BASH or PowerShell. While it does not have the graphical help menus of the web GUI it does have a well organized pattern that makes "headless" navigation more intuitive than you may expect.

Just as with the GUI web portal the CLI will translate your command into an HTTP request that is sent to the Azure REST API. By default the responses received from the API will be printed as formatted JSON. Every command will have an output "shape" relative to the action that was taken and will either be a JSON object or a JSON list of objects.

Installation
============

The installation of the Azure CLI is straightforward now that you have learned how to use a package manager. Follow the instructions below that match the OS and CLI shell of your machine.

Windows/PowerShell
------------------

To install on Windows using PowerShell use the chocolatey package manager:

.. sourcecode:: powershell

    > choco install az-cli -y

Linux/BASH
----------

To install on Linux machines you should refer to the commands of the respective package manager for its distribution. On Ubuntu you can use the ``apt`` package manager:

.. sourcecode:: bash

    $ apt install az-cli -y

The Pattern
===========

The ``az CLI`` is organized into 4 components that build on each other:

#. **Groups**: top-level services and resources
#. **Sub-Groups**: services, properties or features common to a parent **Group**
#. **Commands**: commands specific to managing the **Group** or **Sub-Group**
#. **Arguments**: required and optional arguments specific to the **Command** to customize its behavior

Every command you issue will be made up of some combination of these components. As an example let's apply these labels to the command for creating a VM that we saw earlier:

.. sourcecode:: bash

    # Group: vm
    # Sub-Group: none
    # Command: create
    # Arguments: configuration options
    $ az vm create <configuration options>

The general form of any command you enter will look like this:

.. sourcecode:: bash

    # <required argument>
    # [optional argument] 
    $ az <group> [sub-group] <command> [command arguments]

Notice that the pattern is rather intuitive reading from left to right as "target", "action", "customization". Or using the official terminology: 

    ``az [the program]`` + 

    ``resource or service target [Group/Sub-Group]`` + 

    ``action to take on the target [Command]`` + 

    ``customizing options for the action [Arguments]``

Getting Help
============

Another core aspect of the ``az CLI`` pattern is the use of a global ``help`` argument. Despite being a text-based interface it can be surprisingly informative and detailed. The ``help`` argument is attached to the end of any Group, Sub-Group, Command or combination among them. The help output will vary according to which components it is requested on but will often include examples of common use commands which can serve as a guide.

To use the ``help`` argument simply append ``--help`` or its shorthand ``-h`` to the end of any CLI command.

.. tip::

    You can think of this structure as saying "help me understand whatever is listed to the left of the ``help`` argument"

Let's see some generic examples of how the argument is used:

.. sourcecode:: bash

    # --help or -h may be used interchangeably

    # help with the tool itself (list available Groups and global Commands/Arguments)
    $ az --help

    # help on a Group (list Sub-Groups and Commands)
    $ az <group> --help

    # help on a Sub-Group (list Commands)
    $ az <group> <sub-group> --help

    # help on a Group Command (list Command Arguments)
    $ az <group> <command> --help

    # help on a Sub-Group Command (list Command Arguments)
    $ az <group> <sub-group> <command> --help

Notice how in each of these the pattern remains consistent in use. This makes it easy to build your understanding of the tool one layer at a time by requesting help outputs through each Group, Sub-Group and Command. 

As a concrete example let's consider how to request help about the ``vm`` Group:

.. sourcecode:: bash

    $ az vm --help
    # or shorthand
    $ az vm -h

While the CLI may feel foreign initially you can use the ``help`` argument at any time to guide you. It is in your best interest to practice digging through the Groups, Sub-Groups and Commands using the ``help`` argument to familiarize yourself.

Groups
======

Groups are the main resources and services that the ``az CLI`` exposes control over. Some examples we will be using include:

#. ``vm``: Virtual Machine management
#. ``keyvault``: KeyVault management
#. ``group``: Resource Group management

.. note:: 

    For the purpose of explaining the organizational pattern we use the terms **Group**, **Sub-Group** and **Commands** to mirror the terminology used in the help output and official documentation. In practice when we refer to "creating a group" with ``az group`` we will always mean **resource group**.

You can see all of the Groups and global Commands available in the ``az CLI`` by requesting help about ``az`` itself:

.. sourcecode:: bash

    $ az --help

Sub-Groups
==========

Within each of these Groups will be Sub-Groups that let you manage related features or properties of the Group resource. For example under the Group ``vm`` you would find the related Sub-Group ``identity`` which refers to the VM identity configuration. Similarly under ``keyvault`` you would find the Sub-Group ``secret`` for managing KeyVault secrets.

You can use the ``help`` command on a specific Group to view the Sub-Groups related to it:

.. sourcecode:: bash
    :caption: general form

    $ az <group> --help

Try entering the following commands to see the Sub-Groups related to the ``vm`` and ``keyvault`` Groups:

.. sourcecode:: bash
    :caption: vm and keyvault examples

    $ az vm -h
    $ az keyvault -h

Commands
========

Commands are declaratively named actions that you can take on a Group or Sub-Group. They will typically include CRUD commands along with others that fit the context. The common CRUD commands you will see include:

- **C** - ``create``: create the resource
- **R** - ``show``: view an individual resource object
- **R** - ``list``: view a list of resource objects
- **U** - ``set``: update a property of a resource
- **D** - ``delete``: delete the resource

Just as before you can view the Commands associated with a Group or Sub-Group by using the ``help`` argument. Within the context of a Group or Sub-Group you may also see commands that are specific to that resource. Some of these commands are shortcuts for common tasks.

For example looking at the Commands related to the ``vm`` Group you will see many additional commands beyond the common CRUD ones. Here are a few examples from the rather lengthy list:

.. sourcecode:: bash
    :caption: trimmed output of the many VM related commands

    $ az vm --help

    # commands specific to interacting with a VM resource
    open-port              : Opens a VM to inbound traffic on specified ports.
    perform-maintenance    : The operation to perform maintenance on a virtual machine.

    # shorthand convenience commands
    list-ip-addresses      : List IP addresses associated with a VM.
    list-sizes             : List available sizes for VMs.

Notice how many of these aren't available at all in the GUI! As a reminder Sub-Groups will also have their own Commands list which can be accessed the same way using the ``help`` argument.

Arguments
=========

Like most CLI tools commands also accept a series of Arguments, sometimes referred to as "flags" or "options". Think of these as modifiers for a given Command. They are used to give additional context or configure settings for performing a Command a specific way. The ``help`` argument is itself an example of one of these that happens to apply *globally* and not just for one Command.

Just as Commands can be context-dependent on the Group or Sub-Group they are called on so too are the related Arguments. The ``help`` argument can be used on a Command to see the arguments associated with it. When reviewing the list of arguments take note of which arguments are **required** and which are **optional**. 

.. note::

    Typically only a handful are actually required to define or will have sensible default values set for you if you leave them out.

For example to see the arguments associated with creating (``create``) a VM (``vm``) you can issue:

.. sourcecode:: bash

    $ az vm create -h

Note that these arguments can be exhaustive especially compared to what is available on the web portal. Don't be overwhelmed by them. They are organized for easily finding which are relevant to your use case. 

.. todo:: seems out of scope to cover this, maybe best to just throw in as an example in the walkthroughs?

.. Query Filtering
.. ---------------

.. As mentioned previously all commands issued from the ``az CLI`` are sent as requests to the Azure REST API with response bodies displayed as JSON output. These response bodies can range from simple objects to lists with dozens of complex objects of data. Working with large complex response bodies can be a tedious and time consuming process.

.. Fortunately the ``az CLI`` includes a global argument called ``--query`` that can be applied to any command. It lets you transform the response body and hone in on just the data you need. The syntax used to define the transformation is a simple query language for JSON called JMESPath. We will not explore this syntax in great depth as it is beyond the scope of our learning goals. However, `the JMESPath documentation <https://jmespath.org/>`_ is well organized and has input boxes you can use to practice. 

.. What we will cover are the fundamentals which we will routinely use in our interactions with the ``az CLI``. The first step to using the ``--query`` option is to determine the shape of the data you are working with, which will be dependent on the command you issue. Fortunately there are only two types to consider as all of the commands will either output a single JSON object or a list containing multiple objects. 

.. .. tip::

..     While you can look through the documentation to determine the output shape to expect you can typically know based on the Command itself. Commands like ``list`` and those that interact with multiple resources or properties will output a list (even if there is only one element in that list). However, Commands that interact with a single resource or property directly will naturally output a single object.

Next Step
=========

Now that you understand the pattern for navigating and using the ``az CLI`` it's time to put it to use! In the :ref:`walkthrough_az-cli` article you will get a chance to provision resources without using the web portal GUI. This is your first step towards the eventual goal of learning how to automate these tasks. As you go through the walkthrough think about how you can combine your knowledge of scripting to compose the individual ``az CLI`` commands.