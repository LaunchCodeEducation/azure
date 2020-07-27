=====================
Introduction to Azure
=====================

Azure will be the cloud services provider we use in this class.

We will work with a couple of different Azure Services, but the main focus will be the virtual machine.

Azure Account
=============

After creating a Microsoft Azure account you will have access to many tools including:

- Virtual machine
- Key Vault
- Azure Active Directory
- Various SQL services
- Resource groups

.. index:: ! virtual machine

A **virtual machine** is a highly configurable computer with an operating system such as Ubuntu, which is one of the various Linux operating systems. Anything you could do on your computer (like running an application) can be done on the VM.

.. index:: Key Vault

**Key Vault** is an accessible service that stores information. Unlike SQL, Key Vault isn't intended to store business data. Rather, it is used to store sensitive or configuration data. This can be data our application may need but that we don't want to store on our server, or as a part of our source code. An example is a database connection string. Our application needs access to the database connection string, but we don't want to store this information on our VM, or in our source code. We can safely store it in Key Vault, and access it from our application when we need the data.

.. index:: ! Azure Active Directory

**Azure Active Directory** is a powerful tool that allows us to authenticate users using one of several different auth flows. You will learn about OAuth implicit flow later in this book, but there are many different flows you can use with Azure Active Directory. Azure Active Directory allows us to authenticate users and access information about their identity from our application. This gives us the ability to use one main flow for many different applications, and it allows us to focus more on the features of the application instead of handling authentication.

.. index:: SQL services

Azure offers Various SQL Services. Using relational databases is an important aspect in most applications. After all, most applications are only as good as the underlying data they have. Azure provides the ability to create databases of different types and make them available to VMs, other Azure services, or even the public Internet.

.. index:: ! resource groups

**Azure resource groups** are organizational tools to help you manage the various Azure resources you create. Every resource you create must be associated to a resource group. You can create as many resource groups as you need. A general convention is to create a resource group for each new project, and then to put every resource you need from Azure into the same resource group so you can easily find all the resources used by one project. For simple projects, you may only have a couple of resources in each resource group. But for much larger projects you may have dozens, or even more, resources in one resource group.