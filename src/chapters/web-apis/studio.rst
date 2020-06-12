===================
Studio: Host an API
===================

For our studio today we will be deploying a RESTful API.

In our walkthrough we deployed a bare-bones, hello world, .NET MVC app. MVC is a design pattern in which the front end, and the back end are contained within the same code base. MVS has it's pros and cons, but for the remainder of our Operations trainings we will be deploying RESTful APIs.

RESTful APIs are pure back end applications, they don't come with a front end. This typically means the RESTful API is deployed on it's own infrastructure and then can be consumed by any number of front ends that are hosted on their own infrastructure. This separation has pros and cons you may have more infrastucture, and ops work to manage, but both projects live in isolation and can be developed independently of one another.

We won't be developing the RESTful API from scratch since we are focusing on the operations work, but you should look over the repo of the `coding-events-api <https://github.com/LaunchCodeEducation/coding-events-api>`_. 

Create Resource Group
=====================

Starting out we will need to create a new resource group for this project. This was done in the walkthrough so we won't explain it again.

Use the pattern ``your-name-lc-rg-rest-api`` when naming your resource group.

Spin up VM
==========

Just like the walkthrough you will need create an ubuntu VM.

Make sure your machine matches the following requirements:
  - Resource group: ``your-name-lc-rg-rest-api``
  - Virtual Machine Name: ``your-name-lc-vm-rest-api``
  - Region: East US
  - Image: Ubuntu Server 18.04 LTS
  - Size: Standard_B2s - 2 vcpu, 4 GiB memory ($$$)
  - Authentication type: Password
  - username: student
  - password: ``LaunchCode-@zure1``
  - confirm password: ``LaunchCode-@zure1``

Configure VM
============

After your VM spins up you will need to add the .NET sdk. Checkout the walkthrough for a reminder on how we did this using the VM Run Command.

The source code for our project is stored on GitHub, so we also need git. However, git comes pre-installed onto Ubuntu for us.

You can check that git is installed and availble to you in Run Command by running ``git --version`` in the VM Run Command. After running this command you should see a specific git version.

.. image:: /_static/images/web-apis/studio-run-command-1.png

If git isn't installed simply delete this VM and create a new one making sure you selected the correct image.

Clone Source Code
=================

Our VM is essentially identical to the VM we used in the walkthrough. It has the same hardware, it has the same Operating system, and it has the same tools.

However, we are going to be using git to retrieve our source code. Whereas in the walkthrough we generated our source code with the dotnet CLI. We still want our source code in the same place the ``/home/student`` directory.

So for our Run Command we will need to change to the ``/home/student`` directory, and then clone the git repository that contains our source code `https://github.com/LaunchCodeEducation/coding-events-api <https://github.com/LaunchCodeEducation/coding-events-api>`_.

We can check that it installed the source code properly by looking into the ``coding-events-api`` directory that will be created for us with the ``git clone`` command.

.. sourcecode:: bash

   cd /home/student
   git clone https://github.com/LaunchCodeEducation/coding-events-api
   ls /home/student/coding-events-api

.. image:: /_static/images/web-apis/studio-run-command-2.png

Looking into the directory we can see we have some source code. I don't see a .csproj file though, and that's what we normally run. However, I see another directory ``/home/student/coding-events-api/CodingEventsAPI`` maybe this has our .csproj file?

.. sourcecode::

  ls /home/student/coding-events-api/CodingEventsAPI

.. image:: /_static/images/web-apis/studio-run-command-3.png

In this folder I can see a .csproj file.

Publish Source Code
===================

Connect to Source Code
======================