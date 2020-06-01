======================
Azure Virtual Machines
======================

The first Azure Service we will be working with in this class is Azure Virtual Machines.

Virtual Machine
===============

A Virtual Machine is a highly customizable virtual computer with an accessible Operating System.

From Microsoft: A **virtual machine** is a computer file, typically called an image, that behaves like an actual computer. It's virtual in the fact that's it's an operating system on an already existing operating system that is configured to behave like a standalone computer.

You can create and access a virtual machine in a couple of different ways from the Azure Web Dashboard, or using the Azure-CLI we will use both tools to start virtual machines, but today we will focus solely on the Web Dashboard.

You can provision a Virtual Machine from the Azure Dashboard by accessing the Virtual machines blade.

.. image:: /_static/images/azure-intro-virtual-machines/virtual-machine-blade.png

This blade will show you all of the currently provisioned Virtual Machines, and give you various options for creating new Virtual Machines, or editing/deleting currently existing VMs.

.. image:: /_static/images/azure-intro-virtual-machines/virtual-machine-blade-overview.png

You can create a new Virtual Machine by clicking the ``Add`` button which takes you to the Create VM screen:

.. image:: /_static/images/azure-intro-virtual-machines/virtual-machine-create-basics.png

This screen contains a few tabs worth of options that allow you to configure the hardware, and image of this Virtual Machine. You also set which subscription, and resource group this VM will be associated with.

After you finish the form to create your VM Azure takes a couple of minutes, but will provide you with a public IP address for the machine, and you will be able to connect to it to configure the machine to run whatever application you may have.

In your activities today we will take you through the steps to create your first VM and deploy an application to the VM!

Virtual Machine Benefits
========================

We have already mentioned some of the main benefits of using a Virtual Machine (high availability, accessible via the internet, can be discovered easily with domain names), but they have even more advantages that we mentioned earlier.

VM benefits:
    - on-demand
    - parity
    - highly configurable hardware
    - highly configurable software
    - scalable

On Demand
---------

Using the Azure Dashboard, or the Azure CLI you can create a VM anytime, anywhere, and you can configure it to meet your demands.

Configurable
------------

Azure gives us lots of different options for our VMs. We can fine tune the hardware that is available by dictating exactly how much RAM, how powerful the CPU is, and how much disk storage the VM has access to.

Outside of hardware configuration we can choose the image, or Operating System, of our VM. We can choose various Linux, Windows, or MacOS Operating Systems. Most of these options can be further configured by choosing the major and minor versions of the images.

After choosing our hardware, and image, we can then install any additional software to our VM. We can install mysql-cli, git, dotnet, nginx, etc.

We can configure all aspects of our VM: hardware, image, and software.

Parity
------

Since the Virtual Machine can be configured to use many different images, and you can install whatever technical stack you want you can achieve a higher level of parity.

**Parity** is equivalence between the development environment and production environment. In some instances you may develop and use a slightly different tech stack than the server. Since we can control our server we control the tech stack, and therefore can use the same tech stack for development and production.

Scalable
--------

Due to the configurable nature of VMs we can vertically scale individual VMs. If we spin up a VM to only have 2GB of RAM, but our project grows in scope we can re-configure our VM to allocate more RAM and increase available RAM from 2GB to 8GB, or even more if necessary.

Changing the size of an individual VM is considered Vertical Scaling.

Outside of Vertical Scaling we can horizontally scale with Azure. Horizontal Scaling is creating multiple VMs in which traffic can be shared across. So if an application has lots of simultaneous users multiple copies of the VM can be setup and a Load Balancer can direct traffic to the various VMs. 