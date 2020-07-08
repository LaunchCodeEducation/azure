=======================================
Introduction to Infrastructure and IaaS
=======================================

.. ::

   tie in intro -- in the previous chapter we deployed an application to our local machine, this was not a good solution for these reasons (list from previous article)

   hypothetically let's talk about deploying that same application to a machine in the cloud -- the cloud will give us the ability to (list previous article).

   the cloud is powerful and provides us with more than just an always on computer it gives us on demand (computing power, data storage, and networking)

Cloud Services Provider (CSP)
=============================

A Cloud Services Provider (CSP) gives access to servers hosted in data centers. **Data Centers** are very large buildings that contain server racks full of computers. These computers are massively powerful machines that are connected together and available for rent on the internet. 

After you setup an account with a CSP you can rent parts of these servers. The CSP manages the underlying infrastructure of the servers allowing you rent computation, data storage, and networking as you need it.

Cloud Service Providers give you the ability to rent and pay for computing power as you use it. You don't need to buy your own equipment, set it up, and maintain it these responsibilities fall on the CSP. You just pay them for the computation, data storage, and networking necessary to host your applications.

In a nutshell a **Cloud Services Provider** (CSP) provides various computing services hosted in a data center that can be rented at the user's discretion and are accessed via the internet. Since these machines are stored in a data center they are always on, highly available, very customizable and accessible via the internet. 

Infrastructure
==============

.. ::

   .. note:: to end intro infrastructure is a very deep concept, but for the purposes of this article is to give you an understanding of the terms you will encounter throughout this course.

Infrastructure as a Service (IaaS)
==================================

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
