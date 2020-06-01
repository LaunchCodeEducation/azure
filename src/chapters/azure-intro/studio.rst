.. todo:: confirm all "remember/recall/implicit" references are covered in the lecture/reading material

===================================
Studio: Running on a Remote Machine
===================================

After executing on your local machine it's time to practice running on a "remote" machine. You and your partner will take turns as either the "**remote server machine**" or the "**development machine**".

- **development machine**: responsible for editing the API, pushing the changes, and sharing the repo address with your partner (**remote server machine**)
- **remote server machine**: responsible for cloning, publishing, and executing the updated API from your partner (**development machine**) 

The Development Machine
-----------------------

As the **development machine** you are simulating where the source code is developed (your local machine).

Open the ``CodingEventsAPI/Startup.cs`` file. then edit the code so your partner can tell it's *your* Coding Events API.

.. warning::

   If you do not see the code on this line you are likely on the wrong branch. Make sure you are working on the ``1-sqlite`` branch before continuing.

You will see a configuration for Swagger on ``line 25``:

.. sourcecode:: csharp
   :lineno-start: 25
   :emphasize-lines: 7,8
   :caption: CodingEventsAPI/CodingEventsAPI.csproj

   services.AddSwaggerGen(
      options => {
         options.SwaggerDoc(
            "v1",
            new OpenApiInfo {
               Version = "v1",
               Title = "Coding Events API",
               Description = "REST API for managing Coding Events"
            }
         );
      }
   );

Change the ``Title`` of the UI to include your name. You can also customize the ``Description`` if you would like. Then commit and push your changes:

.. sourcecode:: bash
   :caption: run from the root (solution) directory

   $ git add .
   $ git commit -m "made it my own!"
   $ git push

The Remote Server Machine
-------------------------

As the **remote server machine** you are simulating a virtual machine where application will be hosted.

Clone your partner's repo. This time clone it into a different directory by prefixing the directory name with your partner's name. Using the example path from before ``~/coding-projects/azure/coding-events-api``:

.. sourcecode:: bash
   :caption: set the cloned directory path wherever you'd like to clone the project

   $ git clone https://github.com/<partner username>/coding-events-api ~/coding-projects/azure/<partner name>-coding-events-api

Navigate to your partner's cloned repo directory from the command line. Once in the directory run the publish command to package the API into its executable. After publishing execute the published executable just as you did earlier.

As the final step open the Swagger documentation page `https://localhost:5001 <https://localhost:5001>`_ in your browser.

.. admonition:: Question

   If your partner navigates to the same page on *their* laptop (**development machine**) do you think they will be able to see the page? Discuss your answer with each other then test it out.

Now switch roles with your partner and go through the steps again.  

Reflect
-------

While this exercise was only a simulation the steps involved will be the same when you host your API in an Azure VM. Development takes place on a local **development machine**. Hosting takes place in the cloud after publishing and executing. 

Keep this in mind if you feel lost or overwhelmed when working on your studio tomorrow. Hosting an API in the cloud is no different than publishing and executing on a **remote server machine**. Whether that remote machine is your partner sitting next to your or virtualized in a publicly networked machine is immaterial.

.. admonition:: Fun Fact

   The modern development process to host an application through developing, publishing, and executing takes place on three different machines! Development takes place locally but a cloud-hosted **CI Pipeline** handles publishing (and other automated tasks). The execution itself takes place on a separate cloud-hosted machine like an Azure VM. 

Connecting Over a Network
=========================

Earlier you discussed what would happen if you tried to access the documentation page running on your partner's machine. You weren't able to because ``localhost`` is just that -- a **local** **host** name -- mapped to the machine's **internal IP address** ``127.0.0.1``. Recall that this address is only accessible from within the machine that is executing the application.

In order to access the page you need the **network IP address** of the machine and the **server process port**. Remember that every machine on a network is assigned a unique IP address. And every server process running on a machine has a port it listens on.

On the internet[work] every machine connected to it has its own IP address that uniquely identifies it across the entire network called the **public IP address**. But on the WiFi (WAN) network your laptop (machine) is connected to it has been assigned an *internal* IP address that uniquely identifies it called its **private IP address**.

In this section we will take our first step towards connecting to a machine hosted on a network. Before diving into the vast seas of the open internet we will practice within the smaller pond of the WiFi network.

Instructor
----------

Your instructor will now play the **remote server machine** by publishing and executing the API. Then they will identify their machine's **private IP address** on the WAN and distribute it to the class.

Student
-------

Navigate to your instructor's machine IP address in your browser. Don't forget that you **have to include the port** in order to view their hosted documentation. 

.. admonition:: Question

   Why did you have to include the port? Why don't you typically need to include it when accessing sites on the internet?

Reflect
-------

Earlier you learned how hosting on a **remote server machine** is functionally the same whether it takes place on a partner's laptop or a VM in the cloud. Connecting to machines that are hosted on a network is equally analogous from a small WAN like the WiFI to the open internet itself. 

Remember that everything that happens in the cloud, as mysterious and elusive as it may seem, is just a virtualized representation of what happens in the physical world. It often feels like magic, and it arguably is, but it follows the same logical principles that it was designed to simulate.

Bonus
=====

If you want to try connecting to your partner's machine over the WAN you can use one of the following commands to identify each other's network IP addresses and share them with each other. Don't forget to start the server first!

.. warning::

   As a security best practice do not leave server processes listening on exposed ports running unattended while connected to a public network. We will learn about how to use firewalls and Azure networking rules to protect our VM later in the course.

Select the command for your OS:

.. sourcecode:: bash
   :caption: Linux with Bash or ZSH

   $ hostname -I

.. sourcecode:: bash
   :caption: OSX with Bash or ZSH

   # the inet address is your machine's IP
   $ ifconfig en0

.. sourcecode:: powershell
   :caption: Windows with PowerShell

   # the IPv4 entry is your machine's IP
   $ ipconfig
