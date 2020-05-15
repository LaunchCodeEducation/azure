===================================================
Deploying & Connecting to a Machine on the same LAN
===================================================

As an additional example, you will deploy your web app to your local machine that is connected to a LAN and then access the swagger front end using your phone, or another device you have connected to your LAN.

To complete this studio you will need your development machine, and a separate device that has access to a web browser and both your local machine and the separate device must be conncected to the same LAN.

This studio will be very similar to the previous studio, but instead of relying on an instructor you will be playing both parts yourself. You will need to go through the development, and remote server instructions again, and then finally you will need to connect to the deployed application by using another device on your network.

The Development Machine
-----------------------

As the **development machine** you are simulating where the source code is developed (your local machine).

Open the ``CodingEventsAPI/Startup.cs`` file. again edit the code in some way so when you connect from the other device you will see the changes.

.. warning::

   If you do not see the code on this line you are likely on the wrong branch. Make sure you are working on the ``1-sqlite`` branch before continuing.

You will see a configuration for Swagger on ``line 25``:

.. sourcecode:: csharp
   :lineno-start: 25
   :emphasis-lines: 31,32
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

Your development machine will also act as the remote server. After completing the steps in the previous section go ahead and deploy the application.

As the final step open the Swagger documentation page `https://localhost:5001`_ in your browser from the local development machine. You should see the Swagger documentation you saw earlier.

Now to connect to the API from another device. To do this you will need to know the private IP address of your development machine. There are multiple ways of doing this the easieast is to run ``ifconfig`` from a powershell (Windows) or bash (OSX/Linux) terminal or to run ``ipconfig`` from the command prompt (Windows).

Depending on how your computer is connected to your LAN the information you need will be under different sections, but you are looking for your ``inet address`` following are 2 screenshots that show what you are looking for using ``ifconfig`` from bash, and powershell.

.. image:: /_static/images/studio-2/powershell-ifconfig.png

.. image:: /_static/images/studio-2/bash-ifconfig.png

In the images above the ``inet address`` we are looking for is ``192.168.1.9`` they are found under the ``wlp0s20f3`` section which is the header for the wireless access card on my computer. If the section starts with a ``w`` it indicates a wireless connection. If the section starts with a ``e`` it indicates a wired connected over ethernet.

You will need to find the private IP address of your development/deployment machine.

After you have it you will need to pull up your other device with a web browser, your phone will work fine. Navigate to your private IP address on port 5001 and you should see the Swagger documentation.

Reflect
-------

This example is just another illustration of what's going on with the internet. The internet, after all, is just a collection of inter-connected networks and in concept the internet behaves similarly as your LAN. One device makes a request to another device and a specific port, and the deployment machine responds to the request with a payload of information.