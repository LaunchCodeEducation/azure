==================================
Walkthrough: Running Code Anywhere
==================================

So far you have been writing and running your code on your **local machine**. This works well for development but in order to *host your application* on the internet you will need to run it on a **remote machine**. 

Recall that when we **publish** our application we are creating build artifacts that we can use to run our application. Once we have published the application we gain the benefit of portability. We can take those build artifacts and run it on any other machine that has the .NET runtime.

In today's studio we're going to practice the steps needed to run code on a different machine than where it was written. Each of you will partner with another student to practice cloning, publishing, executing, and connecting to each other's applications.

The Dev Side
============

The application we will work with is a project we will be building up throughout the week as we introduce new topics. It is a basic REST web API with a SQLite database and a single resource -- ``CodingEvents``. The API has endpoints for CRUD operations to manage ``CodingEvents``. In other words it exposes endpoints for Creating, Reading (the collection or a single resource), and Deleting ``CodingEvents``. 

Because web APIs are inherently *headless* (meaning they do not have a front-end like an MVC app) the project includes a tool called Swagger UI. This is a simple web page that documents the API and allows you to explore the endpoints with a built-in tool for executing requests.

We will cover web APIs, REST, and Swagger in greater detail tomorrow. So feel free to look over the code but don't worry if it looks foreign to you! Today the goal is just to practice publishing, executing, and connecting across machines.

Fork the Repo
-------------

We will begin by forking the API repo onto our own accounts. This will allow us to make and push changes we make throughout the week. 

First go to `Coding Events API Repo <https://github.com/launchcodeeducation/coding-events-api>`_. 

At the top right corner select the **Fork** option:

.. image:: /_static/images/studio-1/fork-repo.png

Once you have forked the repo you will be sent to the forked version under your GitHub account: 

.. image:: /_static/images/studio-1/forked-repo.png

Clone the Forked Repo
---------------------

Copy the remote address using the green **Clone or download** button:

.. image:: /_static/images/studio-1/clone.png

Next clone the repo on your local machine. Make sure to clone the repo into a location you will remember. 

The example below clones it into the ``~/coding-projects/azure/coding-events-api`` file path. If you already have a preferred location feel free to edit the command for that file path instead:

.. sourcecode:: bash
   :caption: set the cloned directory path wherever you'd like to clone the project

   $ git clone https://github.com/<your username>/coding-events-api.git ~/coding-projects/azure/coding-events-api


There are a number of branches that will correspond with the studios for each day. Today we will be working with the first one that has the basic version of the API.

Checkout the ``1-sqlite`` branch:

.. sourcecode:: bash

   $ git checkout 1-sqlite

The Ops Side
============

Before we get to running our own VM on Azure we need to get comfortable with the basics. Remember that virtual machines don't have a graphical interface like your IDE. There won't be a shiny green play button in the cloud to run your application. In fact, there won't even be a mouse pointer!

We will simulate what it's like to run our application in the cloud by going through similar steps locally from the command line. First on your own machine and then by swapping with your partner to publish and run each other's code.

.. todo:: linux subsystem and dotnet / az CLI installations page

.. note::

   Before continuing make sure you have the tools you need. If you do not have the linux subsystem set up with the dotnet CLI tool refer to the ref::`cli-setup` page.

Publish the API
---------------

There are multiple ways to publish your project and even more to customize how it is packaged. In this course we will focus on the `self-contained <https://docs.microsoft.com/en-us/dotnet/core/deploying/#publish-self-contained>`_ strategy with options to build a single executable project file. Rather than using our IDE we will use the ``dotnet`` CLI tool to get comfortable working from the command line.

First navigate to your cloned repo (solution) directory. In the cloning example above the path to that directory was ``~/coding-projects/azure/coding-events-api``:

.. sourcecode:: bash

   $ cd ~/coding-projects/azure/coding-events-api

From within the solution directory run the following command to publish your first Release:

.. sourcecode:: bash
   :caption: make sure to run this from the root (solution) directory

   $ dotnet publish -c Release

This will publish to ``CodingEventsAPI/bin/Release/netcoreapp3.1/linux-x64/publish/``

Notice that it automatically published as a self-contained, single (executable) file, built to execute on the ``linux-x64`` runtime. These defaults were set in the ``CodingEventsAPI/CodingEventsAPI.csproj`` configuration file by the following attributes:

.. sourcecode:: xml
   :caption: CodingEventsAPI/CodingEventsAPI.csproj

   <?xml version="1.0" encoding="utf-8"?>
   <Project Sdk="Microsoft.NET.Sdk.Web">
      <PropertyGroup>
         <SelfContained>true</SelfContained>
         <PublishSingleFile>true</PublishSingleFile>
         <RuntimeIdentifier>linux-x64</RuntimeIdentifier>

These defaults are the equivalent of running the publish command with the following options:

.. sourcecode:: bash
   :caption: make sure to run this from the root (solution) directory

   $ dotnet publish -c Release -r linux-x64 -p:PublishSingleFile=true 


.. tip::

   If you change the ``-r`` option to a different `RID value <https://docs.microsoft.com/en-us/dotnet/core/rid-catalog>`_ you can build for other runtimes as needed while still using the defaults for the other options.

Execute the API
---------------

Within the ``CodingEventsAPI/bin/Release/netcoreapp3.1/linux-x64/publish/`` directory is the single executable file ``CodingEventsAPI``. All you need to do to run it is execute that file. 

.. sourcecode:: bash

   $ ./CodingEventsAPI/bin/Release/netcoreapp3.1/linux-x64/publish/CodingEventsAPI

Now you can navigate to `https://localhost:5001 <https://localhost:5001>`_ and view the Swagger API documentation!