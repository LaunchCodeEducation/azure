=======================================
Introduction to Infrastructure and IaaS
=======================================

In the previous chapter we went through the steps to deploy the CodingEventsAPI to our local machines and discussed how we could instead deploy to a cloud host which would solve the problems of networking, discovery, and availability. 

Continuing with the concept of cloud hosting instead of local hosting this chapter will cover Cloud Service Providers, Infrastructure, Infrastructure as a Service, and an introduction to Azure services predominantly Azure Virtual Machines.

Cloud Services Provider
=======================

A Cloud Services Provider (CSP) gives access to servers hosted in data centers. **Data Centers** are very large buildings that contain server racks full of computers. These computers are massively powerful machines that are connected together and available for rent on the internet. 

After you setup an account with a CSP you can rent parts of these servers. The CSP manages the underlying *infrastructure* of the servers allowing you rent computation, data storage, and networking as you need it.

CSPs give you the ability to rent and pay for computing power as you use it. You don't need to buy your own equipment, set it up, and maintain it these responsibilities fall on the CSP. You just pay them for the computation, data storage, and networking necessary to host your applications.

In a nutshell a **Cloud Services Provider** (CSP) provides various computing services hosted in a data center that can be rented and are accessed via the internet. Since these servers are stored in a data center they are always on, highly available, very customizable and accessible via the internet.

.. admonition:: note

   The CSP is responsible for maintaining the servers and will guarantee a certain level of service uptime. This guarantee of uptime will give you confidence that your deployed applications will always be reachable by your end-users. This guaranteed uptime is also known as **high availability**. Most CSPs like `Azure offer ways to increase the availability <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/manage-availability#use-availability-zones-to-protect-from-datacenter-level-failures>`_ even further.

One of the main benefits of a CSP is the diminishment of your responsibilities. You are not responsible for purchasing, configuring, maintaining, replacing, upgrading, or the utilities of the actual physical servers. These responsibilities are handled by the CSP leaving you to focus on the deployment of your applications. These responsibilities are factored into the cost of renting services from a CSP. This is a trade off, you could choose to not use a CSP and handle all those responsibilities yourself (infrastructure *on-premises*) or you can rent these services from a CSP.

Since CSPs have multiple data centers filled with tons of servers they can negotiate lower rates for physical machines, maintenance/upgrading/utilities fees and can usually offer you rental fees at a very reasonable rate.

Infrastructure
==============

.. ::

   .. note:: to end intro infrastructure is a very deep concept, but for the purposes of this article is to give you an understanding of the terms you will encounter throughout this course.

Infrastructure as a Service
===========================

Computation
===========

Data Storage
============

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
