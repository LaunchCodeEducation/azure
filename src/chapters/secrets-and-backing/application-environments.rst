========================
Application Environments
========================

Consider the application we have been deploying through out our Operations training: the CodingEventsAPI. We have used different strategies for running this application in different environments. 

When running our application while we are developing it we use ``dotnet run``. When running our application on a VM we first build the project with ``dotnet publish`` and then run the executable build artifact.

Our CodingEventsAPI *behaves* the same when being run on our local machine vs being deployed on a remote machine. However, there are two distinct environments our application is run in on our local development machine, and in an Azure Virtual Machine.

Let's consider some of the differences between our local machine and our VM:

- OS: local is Windows personal; remote is Ubuntu server
- Hardware: local has a physical hard drive, ram, CPU; remote is a virtualized slice of a much more powerful machine
- Peripherals: local may have a mouse, keyboard, monitor; remote never has a mouse, keyboard, or monitor
- Software: local has lots of different software you use with your personal machine; remote only has the software necessary to run deploy the application
- Shell: local has PowerShell; remote has BASH
- Networking: local machine is configured to work with your home or work LAN; remote is configured to be accessible via the internet and must allow traffic over various ports

There are a lot of differences between these two environments!

Read further to learn about different application environments and their general purposes.

Standard Application Environments
---------------------------------

Every project has it's own requirements and may utilize different application environments. However, most modern web development projects adopt their environments from the basic pattern:

``Local -> Development -> Production``

Local
^^^^^

The ``local application environment`` is one we are already familiar with, your local development machine! This is the environment in which development work happens. 

In this environment you may be working on a feature branch in which you are the only contributor. As you work on your code you run your application on your local machine to make sure your code behaves the way it should, this usually includes running tests (which is outside the scope of this course). When you finish your work, after testing, you push your work to your remote git repository and make a *Pull Request* to notify your team that your work is complete and ready for review.

When you think about the ``local application environment`` consider that each contributor to the project has their own unique ``local application environment``. Your local machine is probably very different than your teammates local machine. Even if you have the exact same hardware you probably have different software. 

Luckily, you only have to worry about your own local machine, because the next environment combines all of your teams collective work.

Development
^^^^^^^^^^^

The ``development application environment`` is the environment in which all of the work from individual ``local application environments`` are combined together. This is a crucial environment that usually runs a huge suite of automated tests. This environment is responsible for verifying that each contribution from a local environment passes its tests, and that the merged code doesn't affect any existing code.

Ideally this branch is completely automated. After a Pull Request is merged into the development branch software automatically pulls down the entire development branch, runs all tests, and notifies the team of the results. If something a test fails, indicating something is broken, it can be addressed immediately to keep the broken segment from ever being deployed to a live environment.

We will not be using a ``development application environment`` in this class, but it is an important environment you will experience throughout your career.

Production
^^^^^^^^^^

After all the testing

- every computer in which your application runs is a different application environment

- local
    - your personal machine
    - unique to each developer on the team
    - all development work takes place in local environments
    - automated unit tests run here
- Development
    - collaboration branch of all contributors code
    - where stuff gets merged
    - automated integration tests run here
- Testing
    - the Quality Assurance 
    - internal bug reporting and patches
- Staging
    - live site beta
    - simulation of the production (live) environment
    - product/feature demos live on this branch
    - one last env to visually check products/features before going live
- Production
    - live usable application

- environment flow
    - isn't moved between environments until it has successfully made it through each preceding environment
    - decreases the likelihood of breaking production

Parity
======

*Keep development, staging, and production as similar as possible* -- straight from 12 factor

- defined tech stack between Dev & Ops
- ensure behavior of code across environments
- decrease time to deploy
- decrease time to re-create environments
- decrease time to tool a new worker