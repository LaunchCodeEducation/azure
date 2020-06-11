==============================================
Studio: CLI Deployment to Windows Server & IIS
==============================================

In today's studio you will practice deploying the Coding Events API to a Windows Server VM. You will be using the ``az CLI`` and the new Windows Server that you learned about. Keep the end goal in mind and apply the knowledge you gained from the Linux API and Windows Server sample app deployments to solve the challenges you are presented with.

This studio will be more hands-off than you are used to. This is an opportunity to step out of your comfort zone and take ownership of your abilities. Applied learning "off the tracks" is the best way to solidify your understanding. Stay calm and if you are in doubt feel free to refer to previous lessons and guides to help find your way. Good luck!

Planning & Tools
================

Windows and Linux have many fundamental differences between them that stem from their contrasting kernel designs. But in the context of a host machine for Web Apps the choice of OS is largely arbitrary. The tools and techniques may differ but they both share OS-agnostic requirements that are dictated by the application itself. We refer to these requirements as the application's **hosting environment** needs.

Let's consider the general requirements that our API has on its hosting environment:

#. **.NET SDK**: the SDK is *currently* needed to ``publish`` our API's artifact
#. **.NET runtime**: the runtime (included in the SDK) is needed to execute, or ``run``, the artifact
#. **delivery**: ``git`` is *currently* used as our tool for delivering (cloning) the source code to the VM
#. **database**: our API relies on an embedded (in the same machine) database server (MySQL) as a backing service
#. **web server**: we need an external Web Server (like IIS) to serve our application more efficiently and securely than the built-in Kestrel Web Server
#. **https**: our API must be served over a secure connection to use ADB2C, it needs an SSL certificate and a way of performing TLS termination using that certificate

Packages
--------

Many of these requirements can be satisfied by using a package manager. On Windows Server we use the chocolatey, or ``choco``, package manager. Refer to previous lessons if you need a refresher on how to install chocolatey.

The packages we need to install with ``choco`` have the following names:

- ``dotnetcore-sdk``: installs the latest SDK and the ``dotnet CLI``
- ``mysql``: installs the latest MySQL database server and its companion tool the ``mysql CLI``
- ``git``: installs the latest Git version control system
- ``dotnetcore-windowshosting``: the IIS hosting bundle for .NET core Web Apps

Recall that the general form of using ``choco`` is:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # single package
   > choco install <package name> -y

   # multiple packages can be listed space-separated
   > choco install <package name> <package name> ... -y

.. admonition:: note

   When installing MySQL you may see a lot of red colored output. Despite red typically meaning "something has gone horribly wrong" there is nothing to be concerned about. Let it finish installing then, like the ``dotnet CLI`` installation, close and reopen PowerShell to start using the ``mysql CLI``!

Web Server
----------

Since this deployment uses a Windows Server VM we are able to use the native IIS Web Server. Refer to the previous walkthrough article for the details of how to install and configure it to serve a .NET Web App. In this deployment we will have to perform one additional step -- provisioning an SSL certificate and configuring IIS to use that certificate to serve over ``https``.

TLS Termination
---------------

Fortunately IIS makes it easy to provision a self-signed certificate using the IIS Manager. 

.. admonition:: tip

   In a production deployment you would use an SSL certificate signed by an established Certificate Authority (CA). For our purposes the self-signed certificate is a suitable replacement for the scope of our learning.

In the IIS manager 

MySQL Setup
-----------

The MySQL database Server will start up on its own after installation through ``choco``. However, you will need to configure the CodingEvents database within the MySQL Server for your API to connect to and use. In the Linux deployment this was handled automatically through the setup scripts we ran. This time you will need to use the ``mysql CLI`` to set up the database, user and permissions.

The ``mysql CLI`` will open a connection to the database server and start a MySQL shell session. This shell, like the BASH or PowerShell command-line shells, is a REPL where you can enter commands and have outputs printed to you. However, unlike the scripting shells, the MySQL shell naturally only accepts MySQL syntax!

You can open the MySQL shell by issuing the following command from the PowerShell terminal in the VM:

.. sourcecode:: powershell
   :caption: Windows/PowerShell, connect as the root user to set up the database

   > mysql -u root

Once inside the MySQL shell you can enter the following commands to set up the database and user. Then enter ``exit`` to quit the shell and return to PowerShell:

.. sourcecode:: mysql
   :caption: MySQL shell, each command should be entered individually

   >> CREATE DATABASE coding_events;
   >> CREATE USER 'coding_events'@'localhost' IDENTIFIED BY 'launchcode';
   >> GRANT ALL PRIVILEGES ON coding_events.* TO 'coding_events'@'localhost';
   >> FLUSH PRIVILEGES;
   >> exit

Now confirm everything was set up correctly by connecting to the database with the new user. You will be prompted to enter the password (``launchcode``). If it connects properly you are all set and can enter ``exit`` in the MySQL shell that was opened to return to PowerShell:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > mysql -u coding_events -D coding_events -p


Requirements Checklist
======================

The following is a checklist of tasks you will need to complete. Note that it is neither exhaustively detailed **nor necessarily in a specific order**. Use this as a guide to ensure you complete all of the requirements of your deployment:

- provision a Windows Server VM
- install and configure IIS to serve the API over ``https``
- provision and configure a KeyVault with the database connection string secret
- configure the hosting environment for the API
- 

Gotchas
-------

Along the way there are a few "gotchas" that you should keep in mind:

- The ``appsettings.json`` ``Server.Origin`` field needs to be updated with your VM's public IP address. You can update and push this change before deploying or you can use ``notepad`` tool to open and edit the file from within the Server after cloning the source code into it.
- The ``dotnetcore-windowshosting`` package must be installed **after** installing IIS
- You must allow VM traffic through the correct ``https`` port (hint - it's not over port 80 like the walkthrough)