=======================================
Introduction to Infrastructure and IaaS
=======================================

In the previous chapter we went through the steps to simulate a deployment of the CodingEventsAPI to our local machines. We discussed how we could deploy to a cloud host which would solve the problems of networking, discovery, and availability. 

Continuing with the concept of cloud hosting this chapter will cover an introduction to Microsoft Azure services predominantly Virtual Machines, as well as:

- Cloud Service Providers (CSP)
- Infrastructure
- Infrastructure as a Service (IaaS)

Cloud Services Provider
=======================

   A `Cloud Services Provider <https://azure.microsoft.com/en-us/overview/what-is-a-cloud-provider/>`_ (CSP) leases access to infrastructure services hosted in data centers. 

**Data Centers** are very large buildings that contain **physical infrastructure** including computers, storage disks and networking equipment. This industrial scale hardware in a single data center operates on an unfathomable scale. There are hundreds of data centers!

.. admonition:: fun-fact

   A single computer, called a server, can have hundreds of cores and the hard drives are chained together to create an effectively limitless amount of storage.

After you setup an account with a CSP you can rent parts of these servers. The process of subdividing a server, storage and networking equipment is known as **virtualization**. These virtual slices of the physical hardware are the services that a CSP allows you to rent.

Since these servers are stored in a data center they are always on, highly available, very customizable and accessible via the internet.

.. admonition:: note

   The CSP is responsible for operating the physical hardware and will guarantee a high level of service uptime known as **high availability**. This guarantee of uptime will give you confidence that your deployed applications will be reachable by your end-users when they need access. 
   
   Most CSPs like `Microsoft Azure offer ways to increase the availability <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability#use-availability-zones-to-protect-from-datacenter-level-failures>`_ even further.

One of the main benefits of a CSP is the diminishment of your responsibilities. When renting services from a CSP you are not responsible for any aspects of the physical hardware including:

- purchasing
- configuring
- maintaining
- replacing
- upgrading

These responsibilities are handled by the CSP allowing you to focus on the development and deployment of your applications. These responsibilities are factored into the cost of renting services from a CSP. This is a trade off, you could choose to not use a CSP and handle all those responsibilities yourself (infrastructure *on-premises*) or you can rent these services from a CSP.

Using a CSP you have immediate access to effectively limitless computing, storage, and worldwide networking. CSPs operate on a scale of hundreds of data centers and  virtualize to the precise scale of your demand and budget.

Infrastructure
==============

Infrastructure is a broad term that refers to the all of the hardware and software used to deploy your code.

   Throughout this class when we refer to infrastructure we are referring to the **virtualized services** rented from the CSP.

Infrastructure as a Service
---------------------------

   Infrastructure as a Service (IaaS) is when a CSP rents access to their virtualized services through a digital interface.

The CSP owns all the physical hardware and customers rent virtual pieces of it **as a service**. To provide access the CSP provides various tools for interfacing with their infrastructure. 

Most CSPs provide both a web UI, and a CLI tool that will allow customers to **provision** (create), configure, and manage the infrastructure necessary to deploy applications in a cloud environment.

The services provided by a CSP fall into three categories: 

- disk storage 
- computation 
- networking 

.. admonition:: note

   We will talk about these services in an abstract manner, but this chapter will contain specific examples in Microsoft Azure.

Disk Storage
============

Almost all cloud services are reliant on hard disk storage. Imagine all the data that must be stored in order to run an application in the cloud. In addition to the data you are familiar with storing (databases) disks are also used to store software data such as:

- build artifacts
- programming language runtimes
- code dependencies
- OS

Everything stored on your local machine to run an application must also be stored to host your application in a cloud environment.

Examples
--------

Disk storage is a service provided by CSPs that come in various forms:

- hard drives mounted to virtual machines
- hard drives mounted to database server
- hosted file systems (directly accessible images and documents)

These services can be provisioned and attached to other services, but the actual disk storage is external from the service that uses it.

Scaling
-------

Due to the externalized nature of disk storage they can be scaled with minimal, if any, impact on the service they are attached to.

   **Scaling** is the process of managing (increasing or decreasing) resources based on demand.

Consider your laptop if you run out of storage space you can mount an additional drive. By mounting we mean adding an external drive, this could be a flash drive or a full external hard drive. Our virtual services operate the same way, we can expand the size of the disk storage by mounting additional drives.

.. admonition:: note

   An added benefit for cloud services that have externalized disk storage is redundancy. Multiple copies of the data can be provisioned across as many disk storage services you are willing to pay for. This additional cost provides protection from data loss.

Computation
===========

Computation is anything you consider to be *running* on a machine. For example on your local physical machine you use CPU and RAM to run applications. In the cloud you can provision virtual machines to perform the same tasks. These virtual machines have access to virtual CPU and RAM. You can provision any amount of CPU cores and RAM across any number of virtual machines.

Like purchasing a laptop provisioning a virtual machine would include:

- selecting the number of CPU cores
- the amount of RAM
- the amount of disk storage
- an OS

Scaling
-------

Due to the external nature of these services they can be scaled.

In the context of computing in the cloud scaling refers to:

- vertical: increasing or decreasing the power of CPU cores and RAM of a *single machine*
- horizontal: increasing or decreasing the number of virtual machines with the *same amount of CPU and RAM*

Networking
==========

**Networking** services facilitate communication across the other services.

CSPs allow you to provision private networks to compartmentalize your services. This allows each customer's infrastructure to operate in isolation from others.  Within these private networks you can provision security services that allow you to control the parts of your infrastructure that are accessible from the internet.

Scaling
-------

Scaling networking involves subdividing or expanding a network.

- Bridging to other networks
- Encapsulating pieces of the infrastructure within a **sub-network**

In the next article we will explore the Microsoft Azure services that go with the abstract concepts learned throughout this article.

- compute: `Azure Virtual Machine <https://azure.microsoft.com/en-us/services/virtual-machines/>`_
- storage: `Azure SQL Databases <https://azure.microsoft.com/en-us/services/sql-database/>`_ & `Azure Blob Storage <https://azure.microsoft.com/en-us/services/storage/blobs/>`_
- network: `Azure Virtual Network <https://azure.microsoft.com/en-us/services/virtual-network/>`_

As an introductory class we will only explore Azure Machines.