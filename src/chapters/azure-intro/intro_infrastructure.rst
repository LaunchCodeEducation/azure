=======================================
Introduction to Infrastructure and IaaS
=======================================

In the previous chapter we went through the steps to deploy the CodingEventsAPI to our local machines and discussed how we could instead deploy to a cloud host which would solve the problems of networking, discovery, and availability. 

Continuing with the concept of cloud hosting this chapter will cover Cloud Service Providers, Infrastructure, Infrastructure as a Service, and an introduction to Azure services predominantly Azure Virtual Machines.

Cloud Services Provider
=======================

   A Cloud Services Provider (CSP) rents access to servers hosted in data centers. 

**Data Centers** are very large buildings that contain server racks full of computers. These computers are massively powerful machines that are connected together and available for rent on the internet. 

After you setup an account with a CSP you can rent parts of these servers. The CSP manages the underlying *infrastructure* of the servers allowing you rent computation, data storage, and networking as you need it.

Since these servers are stored in a data center they are always on, highly available, very customizable and accessible via the internet.

.. admonition:: note

   The CSP is responsible for maintaining the servers and will guarantee a certain level of service uptime. This guarantee of uptime will give you confidence that your deployed applications will always be reachable by your end-users. This guaranteed uptime is also known as **high availability**. Most CSPs like `Azure offer ways to increase the availability <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability#use-availability-zones-to-protect-from-datacenter-level-failures>`_ even further.

One of the main benefits of a CSP is the diminishment of your responsibilities. When renting services from a CSP you are not responsible for any aspects of the physical server including:

- purchasing
- configuring
- maintaining
- replacing
- upgrading
- utilities

These responsibilities are handled by the CSP allowing you to focus on the deployment and deployment of your applications. These responsibilities are factored into the cost of renting services from a CSP. This is a trade off, you could choose to not use a CSP and handle all those responsibilities yourself (infrastructure *on-premises*) or you can rent these services from a CSP.

Since CSPs have multiple data centers filled with tons of servers they can negotiate lower rates for physical machines, maintenance/upgrading/utilities fees and can usually offer you rental fees at a very reasonable rate.

Infrastructure
==============

   Infrastructure is a broad term that refers to the all of the hardware and software used to deploy your code.

.. too deep? should it just instead say Infrastructure is the physical

.. list-table:: Infrastructure Examples
   :widths: 15 15
   :header-rows: 1

   * - Hardware
     - Software
   * - servers
     - OS
   * - CPU
     - firewalls
   * - RAM
     - git
   * - disk storage
     - network security groups
   * - power cords
     - language interpreter
   * - network cables
     - web servers
   * - routers
     - CLI tools

One of the major benefits of using a CSP is the physical components are handled by the CSP. So throughout this class when we refer to infrastructure we are referring to the services rented from the CSP and the software we must manage to use those services.

.. admonition:: tip

   As we talk about Infrastructure throughout this course remember that all of the CSP services are backed by physical hardware in a data center.

Infrastructure as a Service
---------------------------

   CSPs provide Infrastructure as a Service (IaaS) in which they offer access to their hardware through a digital interface.

The CSP owns all the physical hardware and we rent it, as a service, paying them for their work. To provide access the CSP provides various tools for interfacing with their hardware. 

We will work with both a web UI, and a CLI tool that will allow us to provision (create), configure, and manage the infrastructure necessary to deploy our projects in a cloud environment.

These tools will allow us to quickly and easily setup the infrastructure without ever touching the hardware for a relatively inexpensive fee.

The services provided by a CSP fall into three categories: disk storage, computation and networking.

Disk Storage
============

Almost all cloud services are reliant on hard disk storage. Imagine all the stuff that must be stored in order to run an application in the cloud:

- build artifacts
- programming language runtimes
- code dependencies
- OS
- database records

All of these things must be stored on a disk accessible to any cloud services that need them. Disk storage is a service provided by CSPs that comes in various forms:

- stand alone file systems
- server mountable hard drives
- databases

These services can be provisioned and attached to other services.

.. ::

   Consider the previous example of a server. Beyond CPU, RAM and an OS the server has a hard drive. After all a computer wouldn't not be very useful if it didn't have some form of permanent storage. The build artifacts, the dependencies, the software all have to live somewhere and the hard drive is the answer.

   In Cloud Computing we consider disk storage to be separate from computation

.. ::

   this needs to be a note if the point is made at all

   Outside of computation, and it's RAM, a virtual server will require a hard drive to store the OS, dependencies, and build artifacts. When thinking about Infrastructure it's a best practice to keep the aspects separated from each other. 

Computation
===========

One of the most common services provided by a CSP is a virtualized computer (commonly referred to as a server). 

This server would have:

- a Central Processing Unit (CPU)
- Random Access Memory (RAM)
- a *mountable* hard drive
- an OS 

Although the server would exist in a data center it would be very similar to your own laptop. When interfacing with this remote server you would be able to download, install and run applications. This is an ideal service for deploying a web application.

This service would be categorized as **computation** because the primary need being fulfilled by the server is the CPU and RAM a running application needs to function.

Networking
==========


.. ::

   IaaS -- top levels
      - servers (computing)
         - example (the physical Server, a virtual machine (slice of a Server), containers (slice of a virtual machine))
         - provisioning
         - scaling
         - note: these terms depend on the context of the infrastructure
      - databases (data storage)
         - example (disks (memory for virtual machines), databases (disk attached for database), file storage (disk))
         - when provisioning our storage we are thinking about the needs of the applications (how much disk space do we need, what type of disk storage do we need)
         - when scaling our storage
      - networking (networking) -- everything in the CSP is networked to the internet so networking provisioning is creating your own private network for your infrastructure. You decide how that network operates both internally and externally via SG
         - example: security (the network between infrastructure (storage and compute), SGs, sub-networks)
         - when provisioning our networking what we are thinking about is how do we connect the other pieces of infrastructure, also how can we secure these connections
         - scaling: how to we connect these sub-networks of a broader system (in a more complex deployment with lots of different infrastructure some things need to connect to other infrastructure but not everything which is when you would consider sub-network)
      - the entire system is made up of pieces of infrastructure (the sum of all the pieces)
