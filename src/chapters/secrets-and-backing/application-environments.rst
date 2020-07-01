========================
Application Environments
========================

Consider the application we have been deploying through out our Operations training: the CodingEventsAPI. We have used different strategies for running this application. On our local machines we run the application with ``dotnet run``. When we deploy the application to a VM we first run ``dotnet publish`` to create build artifacts and then deploy them.

Our CodingEventsAPI *behaves* the same when being run vs being deployed however, there are two distinct environments our application is run in. The first is our development environment when using ``dotnet run`` this environment exists on our local machine. The second environment is our production environment when using ``dotnet publish`` and hosting the application on a VM.

Think about how very different your local machine is from a VM. You may be using a Windows OS for your development environment, but our production environment is a Linux based OS. Your development environment exists in only a few places your machine and any of your collaborators machines, the production environment may exist across multiple VMs across multiple servers across multiple data centers. These different environments have different software, different OS kernels, different shells, different hardware, different network configurations, etc.

In this article we will explore different application environments and how to manage them.

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

Parity & Portability
====================

Parity
------

*Keep development, staging, and production as similar as possible* -- straight from 12 factor

- defined tech stack between Dev & Ops
- ensure behavior of code across environments
- decrease time to deploy
- decrease time to re-create environments
- decrease time to tool a new worker

Portability
-----------

*the ability to move an application between environments*

- inverse correlation time to move and portability
- increasing parity usually increases portability

- tools exist to assist with portability but go beyond the scope of this class
    - ops automated pipeline tools
    - virtualization tooling like Docker 
