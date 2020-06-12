.. _iis:

=================================
Introduction to Web Servers & IIS
=================================

Components of Web Hosting
=========================

When learning about hosting content on the web you will come across the terms **Server**, **Web Server**, **Web Application Server**, and **Web Application Framework** and will likely be confused on what role each of them play. While these terms are sometimes mistakenly used interchangeably it is important to distinguish them to form a strong mental model. Understanding and properly communicating the details of a web hosting system are critical aspects of being able to design it and to troubleshoot and solve any problems that arise.

Before we get into defining each of these, consider the following diagram that shows how the components of a web hosting system relate to each other:

.. todo:: replace placeholder diagram, add ASF connector between Web Server and Application Server

.. image:: /_static/images/ws/server-boxes.jpg
  :alt: Server, Web Server and Application Server relationship diagram

Server
------

A **Server**, or **host machine**, is the broadest and most ambiguous of these terms. In the context of operations it refers to the physical, or virtualized, hardware itself -- like a Windows Server or Linux machine. Think of this as the outermost box of the system, it holds each of the other components within it. Servers **do not necessarily have anything to do with the web**, they are just powerful machines whose roles are defined by the software they run. 

When discussing web-related roles a Server is responsible for handling network requests of various protocols and passing the packets off to the appropriate service for handling them. In our context the packets are passed off to a Web Server service designed for managing raw HTTP traffic.

Web Server
----------

The **Web Server** is responsible for handling the low-level HTTP logic needed to process requests and send off responses. They are usually written in similarly low-level languages like C or C++ to maximize their performance in handling thousands of requests at a time. Web Servers **do not contain business logic code** and are only modified using configuration files written in XML or other structured language formats.

Web Servers can be used to serve **static content** (content that does not change programmatically) like HTML, CSS, JavaScript, images and other files located on the Server. When serving **dynamic content** a Web Server acts as the middle man between the Server machine and the Application Server that generates the dynamic content.

Web Servers handle things like:

- serving static content
- load balancing and rate limiting
- TLS termination for secure (HTTPS) connections
- decompression and compression of requests and responses

Web Application Server
----------------------

A **Web Application Server** is defined by the source code that developers work on. In the context of development it is sometimes referred to as an app server, web app, or, aiding in the confusion, just a server. App Servers are written in C#/ASP.NET, NodeJS/Express, PHP/Laravel or any other number of language and **Web Application Framework** combinations. Application Servers are made up of code that defines **business logic for working with data and processing requests**. They are **not responsible** for dealing with the underlying HTTP logic. Instead, they deal with Request and Response objects within the code that are managed by the Web Application Framework.

Application Servers handle things like:

- authorization logic
- rendering HTML templates
- connecting to and interacting with database servers

Web Application Framework
-------------------------

Web Application Frameworks, like ASP.NET, **have connectors for transforming** raw HTTP requests received from a Web Server into Request objects that can be processed by the Application Server's business logic code. When they are done processing the request they send out a Response object through another connector to transform it into a raw HTTP response for the Web Server to work with.

.. todo:: replace placeholder diagram

.. image:: /_static/images/ws/framework-connector.jpg
  :alt: Web Application Framework connector between Web Server and Application Server

Kestrel Web Server
==================

All ASP.NET Application Servers come packaged with a *lightweight* Web Server called Kestrel. When you run your Application Server on your local machine it is Kestrel that manages the underlying HTTP logic. This is done transparently for you to only have to work with Request and Response objects themselves. However, being a lightweight Web Server, Kestrel has limited capabilities. 

Because it has been designed as a simple Web Server it is not recommended to use Kestrel by itself, as referenced in its `Microsoft documentation <https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-3.1>`_. When deploying to Linux, Kestrel can be used behind a more robust Web Server like Nginx in a `reverse proxy arrangement <https://www.cloudflare.com/learning/cdn/glossary/reverse-proxy/>`_. However, when you have the luxury of working with a Windows Server machine the IIS Web Server is hands-down the best choice for the job. 

IIS Web Server
==============

The Internet Information Service (IIS) is a **Web Server** made for exclusive use by host machines running the Windows Server OS. IIS can be added to any Server that assumes the Web Server Role. The IIS Management Console makes it easy to serve static content and dynamic content generated by ASP.NET Application Servers. It is deeply customizable offering dozens of Role Services for supporting additional behaviors like authentication, caching, logging and more.

IIS Management Console
----------------------

The IIS Management Console is an application for monitoring and configuring the **Sites** that IIS serves. It can be installed on the host Server directly or used to manage IIS remotely from another machine.

.. image:: /_static/images/ws/iis-manager-dashboard.png
  :alt: IIS Manager dashboard view

Sites
^^^^^

Each **Site** served by IIS corresponds to a directory that contains either static content or the artifact files of a published ASP.NET Web App. A Site is managed by an **Application Pool** which is configured according to what content is being served. 

Sites are bounded by their content directory and listening port. IIS is capable of serving any number of Sites. But, like all server process running on a machine, each Site must have a unique port.

Application Pools
^^^^^^^^^^^^^^^^^

Application Pools are individual ``w3wp`` Web Server processes that run within the host machine. They are used to define and manage the runtime behavior of ``w3wp`` process that serves the Sites assigned to them. Each Application Pool can be customized to control features including resource access, request rate limiting and CPU utilization caps. 

While we will be using IIS to serve a single Site there are cases where multiple Sites of content need to be managed in one Web Server. When considering these multi-Site scenarios the ability for Application Pools to be compartmentalized from each other is invaluable. 

Each Application Pool can be customized to run with a specific security and resource utilization profile. This feature allows for Sites to be operated independently and prevent one crash or malicious attack from impacting other Sites or the Server as a whole. 

Static Sites
^^^^^^^^^^^^

Serving static content is as easy as telling IIS what directory the content is held in and what port to listen and serve from. IIS comes pre-configured with a Default Site made up of static HTML and CSS files available on port 80 and managed by a default Application Pool.  

ASP.NET Web Application Sites
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Serving ASP.NET Web Applications requires a bit more effort. However, it is still leagues ahead of alternative Web Servers when it comes to ease of configuration. Out of the box IIS relies on the .NET runtime and an additional dependency called the ``dotnet hosting bundle`` for serving Web Apps. 

Rather than running a Web Application Server directly, the IIS Web Server is responsible for executing and forwarding traffic for you. The Site's directory holds the executable artifacts produced from publishing the Web App with ``dotnet publish``. An Application Pool is then customized for serving dynamic content which manages the life cycle and behavior of how the Web App is served. 

Next Step
=========

In this article we covered the technical differences and responsibilities of Servers, Web Servers, Web Application Servers and Web Application Frameworks. You should feel comfortable describing the differences between each of these components and have a mental model of how they interact with each other. With this newfound knowledge you are ready to spin up your first Windows Server to host an ASP.NET Web App in the IIS Web Server!