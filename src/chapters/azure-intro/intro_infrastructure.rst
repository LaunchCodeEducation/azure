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

The CSP owns all the physical hardware and customers rent it, as a service, paying the CSP for their work. To provide access the CSP provides various tools for interfacing with their hardware. 

Most CSPs provide both a web UI, and a CLI tool that will allow customers to provision (create), configure, and manage the infrastructure necessary to deploy applications in a cloud environment.

These tools will allow customers to quickly and easily setup the infrastructure without ever touching the hardware for a relatively inexpensive fee.

The services provided by a CSP fall into three categories: disk storage, computation and networking. 

.. admonition:: note

   We will talk about these services in an abstract manner, but an article in the future will mention specific examples in Azure.

Disk Storage
============

Almost all cloud services are reliant on hard disk storage. Imagine all the stuff that must be stored in order to run an application in the cloud:

- build artifacts
- programming language runtimes
- code dependencies
- OS
- database records

All of these things must be stored on a disk accessible to any cloud services that need them. 

Examples
--------

Disk storage is a service provided by CSPs that comes in various forms:

- server mountable hard drives
- database mountable hard drives
- stand alone file systems

These services can be provisioned and attached to other services, but the actual disk storage is external from the service that uses it.

Scaling
-------

Due to the externalized nature of disk storage they can be scaled without affecting the service they are attached to.

   **Scaling** is the process of managing resources based on demand.

Scaling for a database server would be starting with disk storage that provides 20GBs of space to a DB that currently has 12GBs of data. However, as the database space keeps being used up a new hard disk can be provisioned to add additional space. In the same vein if database records are deleted and the current level of hard disk space is too much, disk storage can be turned off, also known as scaling down.

.. admonition::

   An added benefit for databases that have externalized disk storage is redundancy. Multiple copies of the data can be provisioned across as many disk storage services you are willing to pay for. This additional cost provides protection from data loss.

Computation
===========

Certain cloud services require **computation** which is a combination of central processing units and random access memory.

A deployed application will need a CPU and RAM in order to catch user requests, determine what to do with the request, and respond to the user. Similarly a database needs CPU and RAM in order to access records, add records, update records and delete records. Anything you can think of as *running* needs computation services.

One of the most common services provided by a CSP is a virtualized computer (commonly referred to as a server). 

This server would have:

- a Central Processing Unit (CPU)
- Random Access Memory (RAM)
- a *mountable* hard drive
- an OS 

Although the server would exist in a data center it would be very similar to your own laptop. When interfacing with this remote server you would be able to download, install and run applications. This is an ideal service for deploying a web application.

This service would be categorized as **computation** because the primary need being fulfilled by the server is the CPU and RAM a running application needs to function.

Examples
--------

Again there are multiple CSP services that provide computation:

- virtualized application servers
- database servers
- lambdas

Scaling
-------

Due to the external nature of these services they can be scaled.

If an application server is struggling to handle the traffic of any number of users a new application server can be spun up to help share the load.

Networking
==========

**Networking** services are the CSP services that facilitate and control communication across other computation and disk storage services.

All the physical components of our infrastructure are housed in a data center and all the servers in the data center are networked together. However, we don't want our infrastructure to be accessed by some other party's infrastructure as this could cause all sorts of issues. CSPs provide additional virtualized networks that allow you to create, and manage networks to suit the needs of your deployment.

.. admonition:: note

   This class barely scratches the surface of networking. All of our deployments will have the most basic of networking concerns to allow us to focus more on computation and disk storage.

Examples
--------

- Network Security Groups (NSG) to open ports on application servers so users can access them via a browser
- Virtual Private Networks (VPN) which allow you to control the access one service has with another
- Virtual Private Clouds (VPC) manages large numbers of services

Scaling
-------

Scaling also applies to networking. In the instance of a complex deployment that has lots of different disk storage, and computation services it is usually beneficial to create sub-networks inside the VPN that hosts all the services.

Conclusion
==========

As a reminder infrastructure has a broad definition. Using CSPs we are more concerned with the abstract concepts of computation, disk storage, and networking instead of the physical components. When we refer to the infrastructure to deploy an application we are referring to the various CSP services we interact with to make the deployment possible.

In the next article we will explore the Azure services that go with the abstract concepts learned throughout this article.
