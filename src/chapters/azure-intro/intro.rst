=====================
Introduction to Azure
=====================

Cloud Services Provider
=======================

Azure will be the Cloud Services Provider we use in this class.

A Cloud Services Provider gives access to servers hosted in data centers. **Data Centers** are very large buildings that contain server racks full of computers. These computers are massively powerful machines that are connected together and available for rent on the internet. After you setup an account on Azure you can rent part of one of these servers in the form of various services like a Virtual Machine, which is an OS that works similarly to your local machine. From this machine you would be able to install the ``dotnet`` CLI, and copy over your build artifacts and then run your project.

Cloud Service Providers give you the ability to rent computing power as you need. So you don't need to buy your own equipment, set it up, and maintain it. You leave all of that work to the Cloud Services Provider. You just pay them for the amount of power, and time to rent their services.

In this class we will work with a couple of different Azure Services, but the main one will focus on is the Virtual Machine.

In a nutshell a **Cloud Services Provider** provides various computing services hosted in a data center that can be rented and configured at the user's discretion and are accessed via the internet. Since these machines are stored in a data center they are always on, highly available, accessible via the internet, and highly customizable. 

Azure Account
=============

After creating a Microsoft Azure Account you will have access to many tools including:
    - Virtual Machine
    - Key Vault
    - Azure Active Directory
    - Various SQL Services
    - Resource Groups

**Virtual Machine** is a highly configurable computer with an Operating System like ``ubuntu`` which is one of the various Linux operating systems. Anything you could do on this computer (like run an application) can be done on the VM.

**Key Vault** is an accessible service that stores information. Unlike SQL the Key Vault isn't intended to store business data, but instead sensitive, or configuration data. Data our application may need that we don't want to store on our server, or as a part of our source code. An example would be a database connection string. Our application needs access to the database connection string, but we don't want to store this information on our VM, or in our source code. So we can safely store it in Key Vault, and access it from our application when we need the data.

**Azure Active Directory** is a powerful tool that allows us to authenticate users using one of several different auth flows. You will learn about OAuth implicit flow later in this book, but there are many different flows you can use with Azure Active Directory. Azure Active Directory allows us to authenticate users and access some information about their identity from our application. This gives us the ability to use one loin flow for many different applications, and it allows us to focus more on the features of the application instead of handling authentication.

Azure offers Various SQL Services. Using Relational Databases is an important aspect in most applications. After all most applications are only as good as the underlying data they have. Azure gives the ability to create various Databases of different types and have them be available to VMs, other Azure services, or even publicly.

**Azure Resource Groups** are organizational tools to help you manage the various Azure Resources you create. Every resource you create must be associated to a resource group. You can create as many resource groups as you need. A general convention would be to create a resource group for each new project, and then to put every resource you need from Azure into the same Resource Group so you can easily find all the resources used, or needed by one project. For simple projects you may only have a couple of resources in each resource group. But for much larger projects you may have dozens, or even more resources in one resource group.