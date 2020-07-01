=========================================================
Walkthrough: Consuming the Coding Events API With Postman
=========================================================

The UI of a browser is designed to make *simple* ``GET`` requests for URLs entered into its address bar. This design works great for browsing sites but falls short when working with headless APIs. 

Anything beyond a ``GET`` request is handled behind the scenes such as when you ``POST`` a form or through AJAX requests with JavaScript. But before you develop the client-side logic for making background requests you need a way to interact with the API server directly and understand how it works.

When exploring and testing a Web API it is invaluable to have an interactive environment that allows you to fine-tune requests. For example, you may need to configure the HTTP method, headers or body of the request -- all of which the browser does not provide a UI for.

Instead of the browser we can use tools made specifically for interacting with APIs. One of the most popular API tools in the industry is **Postman**. It is a cross-platform tool that puts you in full control of configuring and executing API requests. 

In this walkthrough we will work with Postman to explore how APIs can be consumed.

Setup
=====

Installing Postman
------------------

Installing Postman is easy thanks to its cross-platform nature. You can download the installer on `their downloads page <https://www.postman.com/downloads/>`_. We will show instructions for setting up on Windows but because Postman is cross-platform the other instructions in this walkthrough will apply regardless of your platform.

Select the ``Windows x64`` installer download then run the installer:

.. image:: /_static/images/postman/download-installer.png
   :alt: Download Windows x64 Postman installer

After installation Postman should open automatically. Making an account can be useful but if you do not want to create one you can select the **skip** link in grey at the bottom of the splash screen:

.. image:: /_static/images/postman/account.png
   :alt: Postman splash screen for new account

.. admonition:: tip

   Once installed you can right-click the Postman icon and pin it to your taskbar for easy access in the future:

   .. image:: /_static/images/postman/pin-taskbar.png
      :alt: Pin Postman application to taskbar on Windows

You can leave the Launchpad view open for now. We will explore Postman after setting up our API server.

.. image:: /_static/images/postman/launchpad-view.png
   :alt: Postman Launchpad view

Clone the Coding Events API Source Code
---------------------------------------

Throughout this course we will be using a modified version of the MVC Coding Events application you created. The `Coding Events API <https://github.com/LaunchCodeEducation/coding-events-api/tree/1-sqlite>`_ is designed following the OpenAPI REST specification. Although they are implemented differently you will find that most of the features from the MVC application have been supported through endpoints in the API.

.. admonition:: note

   Our focus in this course is on operations and as such we will not be going into the development of the API. However, feel free to explore the source code if you are curious about the similarities and differences between the .NET MVC and API implementations.

Let's begin by cloning the repo onto our machine:

.. admonition:: note

   If you just opened your PowerShell Terminal then it will default to a CWD of your ``HOME`` directory, ``C:\Users\<username>``. 
   
   If you want to clone the repo somewhere else make sure to change to that directory first.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > git clone https://github.com/launchcodeeducation/coding-events-api

For today's studio we will start with the first branch of the API codebase, ``1-sqlite``. This branch has an API with a single (``CodingEvent``) resource and a built-in SQLite database. 

Let's change into the repo and switch to this branch:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # cd is an alias (like a nick-name) for the Set-Location cmdlet in PowerShell
   > cd coding-events-api

   # check out the 1-sqlite branch
   > git checkout 1-sqlite

You can leave this PowerShell Terminal window open:

.. image:: /_static/images/postman/powershell-in-repo-dir.png
   :alt: PowerShell in coding-events-api repo directory on 1-sqlite branch

We will return to it after exploring Postman.

Postman UI
==========

Request Collections
-------------------

Requests
--------

Configuring Postman Requests
============================

Setting the Path
----------------

Setting the Method
------------------

Setting the Headers
-------------------

Setting the Request Body
------------------------

Coding Events API
=================

CodingEvent Resource
--------------------

Endpoints
---------

GET Coding Events
^^^^^^^^^^^^^^^^^

GET Single Coding Event
^^^^^^^^^^^^^^^^^^^^^^^

Create a Coding Event
^^^^^^^^^^^^^^^^^^^^^

Delete a Coding Event
^^^^^^^^^^^^^^^^^^^^^

Making Requests to the Coding Events API
========================================

Start the API Server
--------------------

Create a Coding Event
---------------------

Get the Coding Events Collection
--------------------------------

Get a Single Coding Event Entity
--------------------------------

Delete a Coding Event
---------------------