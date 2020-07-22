======================================================
Studio: Deploy CodingEventsAPI to Windows Server & IIS
======================================================

In today's studio you will practice deploying the Coding Events API to a Windows Server VM. You will be using the ``az CLI`` and the new Windows Server tools that you learned about.

This studio will be more hands-off than you are used to. This is an opportunity to step out of your comfort zone and take ownership of your abilities. Applied learning "off the tracks" is the best way to solidify your understanding and build confidence. 

While it will be challenging, do your best to complete the tasks on your own by referring to your notes and previous lessons. If you are completely stuck then reach out to a TA or your instructor for help.

We will provide some high-level planning and guidance for new steps you haven't seen before. Otherwise, you are on your own to complete the mission. Good luck!

Checklist
=========

This studio will be considered complete when your Coding Events API is accessible over ``https`` at the public IP address of the VM and all of the features are functioning properly. The following is a checklist of tasks you will need to complete. 

Note that this list is neither exhaustively detailed nor necessarily in a specific order:

- provision a Windows Server VM
- provision and configure a KeyVault with the database connection string secret
- install and configure IIS to host .NET Web App Sites
- configure the hosting environment for the API
- deliver and publish the API (``4-member-roles`` branch)
- configure IIS to serve the API over ``https``

Gotchas
-------

Along the way there are a few "gotchas" that you should keep in mind:

- The ``appsettings.json`` entry for ``Server.Origin`` needs to be updated with your new VM's public IP address. You can update and push this change before delivery or you can use the ``notepad`` tool to open and edit the file from within the Server afterwards.
- The ``dotnetcore-windowshosting`` bundle must be installed **after** installing IIS
- You must allow VM traffic through the correct ``https`` port (hint -- it's not over port 80 like the previous walkthrough)

Planning
========

Windows and Linux have many fundamental differences between them that stem from their contrasting kernel designs. But in the context of a host machine for Web Apps the choice of OS is largely arbitrary. The tools and techniques may differ but they both share OS-agnostic requirements that are dictated by the application itself. We refer to these requirements as the application's **hosting environment** needs.

Let's consider the general requirements that our API has on its hosting environment:

#. **runtime**: the .NET SDK (and included runtime) is *currently* needed to ``publish`` and execute our API's artifact
#. **delivery**: ``git`` is *currently* used as our tool for delivering (cloning) the source code to the VM
#. **MySQL database**: our API relies on an embedded (in the same machine) MySQL database server as a backing service
#. **web server**: we need an external Web Server (like IIS) to serve our application more efficiently and securely than the built-in Kestrel Web Server
#. **https**: our API must be served over a secure connection to use ADB2C, it needs an SSL certificate and a way of performing TLS termination using that certificate

Limited Guidance
================

The following sections will guide you on specifics and steps you may not have seen yet. Before starting the studio take a moment to read them over and come up with a plan for when and how you will use them.

Packages
--------

Many of these requirements can be satisfied by using a package manager. On Windows Server we use the chocolatey, or ``choco``, package manager. Refer to previous lessons if you need a refresher on how to install chocolatey.

The packages you need to install with ``choco`` have the following names:

- ``dotnetcore-sdk``: the latest SDK and the ``dotnet CLI``
- ``mysql``: the latest MySQL database server and its companion tool the ``mysql CLI``
- ``git``: the latest Git version control system
- ``dotnetcore-windowshosting``: the latest IIS hosting bundle for serving .NET core Web Apps

Recall that the general form of using ``choco`` is:

.. sourcecode:: none
   :caption: Windows/PowerShell

   > choco install <package name> -y

.. admonition:: Note

   When installing MySQL you may see a lot of red colored output. Despite red typically meaning "something has gone horribly wrong" there is nothing to be concerned about. Let it finish installing then, like the ``dotnet CLI`` installation, close and reopen PowerShell to start using it.

MySQL Setup
-----------

The MySQL database Server will start up on its own after installation through ``choco``. However, you will need to configure the Coding Events database within the MySQL Server for your API to connect to and use. In the Linux deployment this was handled automatically through the setup scripts we ran. This time you will need to use the ``mysql CLI`` to set up the database, user and permissions.

The ``mysql CLI`` will open a connection to the database server and start a MySQL shell session. This shell, like the Bash or PowerShell command-line shells, is a REPL where you can enter commands and have outputs printed to you. However, unlike the scripting shells, the MySQL shell naturally only accepts MySQL syntax!

You can open the MySQL shell by issuing the following command from the PowerShell terminal in the VM:

.. sourcecode:: none
   :caption: Windows/PowerShell, connect as the root user to set up the database

   > mysql -u root

Once inside the MySQL shell you can enter the following commands to set up the database and user. Then use the ``exit`` command to quit the MySQL shell and return to the PowerShell shell:

.. sourcecode:: mysql
   :caption: MySQL shell, each command should be entered individually

   >> CREATE DATABASE coding_events;
   >> CREATE USER 'coding_events'@'localhost' IDENTIFIED BY 'launchcode';
   >> GRANT ALL PRIVILEGES ON coding_events.* TO 'coding_events'@'localhost';
   >> FLUSH PRIVILEGES;
   >> exit

Now confirm everything was set up correctly by connecting to the database with the new user. You will be prompted to enter the password (``launchcode``):

.. sourcecode:: none
   :caption: Windows/PowerShell

   > mysql -u coding_events -D coding_events -p

If it connects properly you are all set and can use ``exit`` in the MySQL shell that was opened to return to PowerShell.

Configuring HTTPS with IIS
--------------------------

Since this deployment uses a Windows Server VM we are able to use the native IIS Web Server. Refer to the previous walkthrough article for the details of how to install and configure it to serve a .NET Web App. 

In this deployment we will have to perform one additional step -- provisioning an SSL certificate and configuring IIS to use that certificate to serve over ``https``. Fortunately IIS makes it easy to provision and use a self-signed certificate using the IIS Manager.

.. admonition:: Tip

   In a production deployment you would use an SSL certificate signed by an established Certificate Authority (CA). The topic of `Public Key Infrastructure (PKI) <https://www.ssh.com/pki/>`_, which SSL certificates belong to, is beyond the scope of this class. For our purposes the self-signed certificate is a suitable alternative. 

Provision a self-signed certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the IIS manager select the VM from the Connections panel on the left then switch to the Features View (at the bottom of the window). From the Features View select Server Certificates:

.. image:: /_static/images/ws/iis-manager-server-certs.png
   :alt: IIS Manager VM Features View server certificates selection

On the right side select the option to create a new **self-signed certificate**:

.. image:: /_static/images/ws/iis-manager-self-signed-cert.png
   :alt: IIS Manager create self-signed certificate option

In the dialog box set the following options for the name and store the certificate will be held in:

.. image:: /_static/images/ws/iis-manager-create-self-signed-cert.png
   :alt: IIS Manager self-signed certificate creation wizard

This will create the self-signed certificate and store it for use in web hosting. Now you just need to assign the certificate to your Site. 

Configure the Site to be served securely
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When you configure the port binding of the Site there is an option to set the server certificate to be used. Note that this option is only available for a binding to ``https`` (port 443). Just as before you can right click the Site and select the edit bindings option then add an additional binding for ``https``.

In the binding dialog select ``https`` and the certificate you provisioned in the previous steps:

.. image:: /_static/images/ws/iis-manager-site-https-binding.png
   :alt: IIS Manager Site binding to https

After setting the binding we want to enforce the use of SSL by forbidding any insecure requests. In the Site Features View select SSL settings then require SSL and apply (in the top right corner):

.. image:: /_static/images/ws/iis-manager-site-ssl-settings.png
   :alt: IIS Manager Server Features View SSL settings

.. image:: /_static/images/ws/iis-manager-site-require-ssl.png
   :alt: IIS Manager require SSL setting

Finally you can enable HTTP Strict Transport Security (HSTS) which will notify browsers to prevent access over ``http``. We will also select the option for automatically upgrading from ``http`` to ``https`` to support this configuration. In the Site Features View the right side panel has an option for configuring HSTS. Open this dialog to enable it:

.. image:: /_static/images/ws/iis-manager-configure-hsts.png
   :alt: IIS Manager configure HSTS

.. image:: /_static/images/ws/iis-manager-hsts-dialog.png
   :alt: IIS Manager HSTS configuration dialog

Connecting over HTTPS
^^^^^^^^^^^^^^^^^^^^^

The first time you connect to the Site from a browser within the Server or locally from your machine you will be presented with a warning. Because the Server is using an untrusted (self-signed) certificate you need to explicitly accept its use:

From IE within the Server:

.. image:: /_static/images/ws/untrusted-certificate-ie.png
   :alt: Untrusted certificate warning in IE

From your local machine's browser (Firefox):

.. image:: /_static/images/ws/untrusted-certificate-firefox.png
   :alt: Untrusted certificate warning in Firefox

After accepting the certificate your Site will be served over ``https``!