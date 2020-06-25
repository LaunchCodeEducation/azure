==============================================
Walkthrough: Local & Remote Secrets Management
==============================================

In our walkthrough today we will be working with a sample application to learn about secrets management. We will use the ``dotnet user-secrets`` to manage the secrets on our local machine. When we deploy the application we will be using Azure Key vault as a remote secrets manager. 

Explore Concepts
================

Get the Source Code
-------------------

To begin this walkthrough we will each need to fork the project on GitHub. We are each going to have to set up our own unique Key vault that must be configured in our application settings. First fork `this repository <https://github.com/LaunchCodeEducation/dotnet-user-secrets-az-keyvault>`_ to your own GitHub account.

After you fork this project clone your new repository to your local machine. Be sure to replace ``<YOURUSERNAME>`` with your own GitHub username.

.. sourcecode:: bash

   git clone https://github.com/<YOURUSERNAME>/dotnet-user-secrets-az-keyvault

Local: How it Works
-------------------

We already know what secrets are and that they are managed by secrets managers, but how do they work?

Locally, in our development environment, we will be using ``dotnet user-secrets`` as our secrets manager.

Dotnet User-Secrets (Local Secrets)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Our local secrets manager is ``dotnet user-secrets``. As you can see from by the command this is a tool built into the ``dotnet CLI``.

Using the ``dotnet user-secrets`` command we can create a secrets store. Each secrets store is unique to a .NET project. A secrets store is a directory on your local machine that the user-secrets manager creates to store your secrets. The secrets store directory is located separate from your project directory which means there is no chance it will be committed to git. Once a secrets store has been initialized in a project you can add and manage secrets using the ``dotnet user-secrets`` tool. Secrets are saved as key-value pairs within the secrets store.

There are two commands we will be using:

- ``init``: intializes a new secrets store for the project
- ``set``:  creates, or updates, a secret within the secrets store

To work with a secrets store you should first navigate to the project directory.

.. sourcecode:: bash
   :caption: Initialize a secrets store

   cd dotnet-user-secrets-az-keyvault
   dotnet user-secrets init --id walkthrough-secrets
   dotnet user-secrets set Name <yourname>

Once you have intialized your project's secrets store you can create a new secret with ``set``. The ``set`` command takes two arguments the first is the key, and the second argument is the value. For our project we will need a secret with a key of ``Name`` and a value of your first name.

.. sourcecode:: bash

   # make sure to do this within your project directory
   dotnet user-secrets set Name <yourname>

Application User-Secrets Integration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may be wondering how our application will know where to find the secrets store? We must provide our application with the id of our secrets store for it to be recognized. When we used ``dotnet user-secrets init`` the id we provided was registered in our ``api-user-secrets.csproj`` file automatically. 

.. sourcecode:: csharp
   :caption: api-user-secrets.csproj
   :lineno-start: 1
   :emphasize-lines: 6

   <?xml version="1.0" encoding="utf-8"?>
   <Project Sdk="Microsoft.NET.Sdk.Web">
   <PropertyGroup>
      <TargetFramework>netcoreapp3.1</TargetFramework>
      <RootNamespace>api_user_secrets</RootNamespace>
      <UserSecretsId>walkthrough-secrets</UserSecretsId>
   </PropertyGroup>
   <ItemGroup>
      <PackageReference Include="Microsoft.Azure.KeyVault" Version="3.0.5" />
      <PackageReference Include="Microsoft.Extensions.Configuration.AzureKeyVault" Version="3.1.2" />
   </ItemGroup>
   </Project>

It is this entry in the ``.csproj`` file that is responsible for integrating our application and our local secrets manager. 

Accessing the Secrets Store
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now that our application can access the secrets store how can our code access specific secrets? Let's take a look at our ``Startup.cs`` file to find out.

.. sourcecode:: csharp
   :caption: Startup.cs
   :lineno-start: 1
   :emphasize-lines: 18,30

   using System;
   using System.Collections.Generic;
   using System.Linq;
   using System.Threading.Tasks;
   using Microsoft.AspNetCore.Builder;
   using Microsoft.AspNetCore.Hosting;
   using Microsoft.AspNetCore.HttpsPolicy;
   using Microsoft.AspNetCore.Mvc;
   using Microsoft.Extensions.Configuration;
   using Microsoft.Extensions.DependencyInjection;
   using Microsoft.Extensions.Hosting;
   using Microsoft.Extensions.Logging;

   namespace api_user_secrets
   {
      public class Startup
      {
         public static string secret;
         public Startup(IConfiguration configuration)
         {
               Configuration = configuration;
         }

         public IConfiguration Configuration { get; }

         // This method gets called by the runtime. Use this method to add services to the container.
         public void ConfigureServices(IServiceCollection services)
         {
               //accessing the Environment variables that .NET has loaded for us in Configuration
               secret = Configuration["Name"];
               services.AddSingleton<IConfiguration>(Configuration);
               services.AddControllers();
         }

         // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
         public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
         {
               if (env.IsDevelopment())
               {
                  app.UseDeveloperExceptionPage();
               }

               app.UseHttpsRedirection();

               app.UseRouting();

               app.UseAuthorization();

               app.UseEndpoints(endpoints =>
               {
                  endpoints.MapControllers();
               });
         }
      }
   }

On line 18 we are declaring a new public static variable. Public means it's available to classes outside of the Startup class. Static means an object doesn't have to be instantiated to access this property. So this ``Startup.secret`` variable will be available to any of our files.

When a secrets store is registered in a project its secrets will be automatically loaded into the ``Configuration`` object. We can access a specific secret by its key. Line 30 assigns the value of the secret ``Name`` to the static field ``Startup.secret``.

This static field allows any of the other files in our project to access the secret's value.

Using the Secret
^^^^^^^^^^^^^^^^

Where are we actually using our secret? Check out our lone controller file ``SecretController.cs``.

.. sourcecode:: csharp
   :caption: SecretController.cs
   :lineno-start: 1
   :emphasize-lines: 25

   using System;
   using System.Collections.Generic;
   using System.Linq;
   using System.Threading.Tasks;
   using Microsoft.AspNetCore.Mvc;
   using Microsoft.Extensions.Logging;

   namespace api_user_secrets.Controllers
   {
      [ApiController]
      [Route("[controller]")]
      public class SecretController : ControllerBase
      {
         
         private readonly ILogger<SecretController> _logger;

         public SecretController(ILogger<SecretController> logger)
         {
               _logger = logger;
         }

         [HttpGet]
         public IEnumerable<string> Get()
         {
               return new string[] { Startup.secret };
         }
      }
   }

In our controller file there is one route for HTTP GET request ``/secret``. This handler returns the value of the secret stored in the ``Startup.secret`` static field.

In this case our secret isn't very sensitive. However, this process is representative of how you can use secrets in a project. Typically your name wouldn't be considered senesitive data, but many things are sensitive like a database connection string that includes a username and password.


Remote: How it Works
--------------------

It would be a pain to configure dotnet user-secrets for every VM that may run our project, luckily MS provides us with a different way to manage user secrets in a way that is much more scalable. Enter Azure Key vault. 

Azure Key vault is a secrets manager with the same responsiblities as dotnet user-secrets, however since it lives in the cloud it can be accessed by any application that has internet access. So instead of configuring each VM to use their own local secrets manager, why don't we setup one global secrets manager that any VM that has authorization can access? That's what we will do with Azure Key vault! 

Before we can do this we need to configure our application to know when to use a local secrets manager, and when to use a remote secrets manager.

Application Environments
^^^^^^^^^^^^^^^^^^^^^^^^

We have run into a dilemma. We want to use our local secrets manager when we are coding our project, but want to use our remote secrets manager when we deploy our application. We will need to introduce some logic into our application that will allow it to use our local secrets manager when it detects a development environment, and allow it to use a remote secrets manager when it detects a production environment.

Let's take a look at the ``Program.cs`` file.

.. sourcecode:: csharp
   :caption: Program.cs
   :lineno-start: 1
   :emphasize-lines: 22

   using Microsoft.AspNetCore.Hosting;
   using Microsoft.Extensions.Configuration;
   using Microsoft.Extensions.Hosting;
   using Microsoft.Azure.KeyVault;
   using Microsoft.Azure.Services.AppAuthentication;
   using Microsoft.Extensions.Configuration.AzureKeyVault;

   namespace api_user_secrets
   {
      public class Program
      {
         public static void Main(string[] args)
         {
               CreateHostBuilder(args).Build().Run();
         }

         public static IHostBuilder CreateHostBuilder(string[] args) {
         return Host.CreateDefaultBuilder(args)
         .ConfigureAppConfiguration(
            (context, config) => {
               // if not in Production environment (dotnet run) don't setup KeyVault and use the default Secret Storage managed through dotnet user-secrets
               if (!context.HostingEnvironment.IsProduction()) return;
               
               // if in Production environment (dotnet publish) setup KeyVault -- pull the KeyVault name from appsettings.json

               var builtConfig = config.Build();

               var azureServiceTokenProvider = new AzureServiceTokenProvider();
               var keyVaultClient = new KeyVaultClient(
               new KeyVaultClient.AuthenticationCallback(
                  azureServiceTokenProvider.KeyVaultTokenCallback
               )
               );

               config.AddAzureKeyVault(
               $"https://{builtConfig["KeyVaultName"]}.vault.azure.net/",
               keyVaultClient,
               new DefaultKeyVaultSecretManager()
               );
            }
         )
         .ConfigureWebHostDefaults(webBuilder => { webBuilder.UseStartup<Startup>(); });
         }
      }
   }

Line 22 is a conditional statement. There are some comments explaining the different logical paths, but essentially the first path is that for a development environment that does nothing special and uses the default enabled ``dotnet user-secrets``. The second path that is for a production environment has some code that connects to an Azure Key vault and overrides ``DefaultKeyVaultSecretManager()`` to use the remote secrets manager.

That still leads to the question: How does our application know which Key vault to use?

Application Key vault Integration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may have noticed in the ``Program.cs`` file it is trying to access ``KeyVaultName`` from the ``builtConfig`` on line 36. This references the ``appsettings.json`` file. Let's take a look at this file.

.. sourcecode:: csharp
   :caption: appsettings.json
   :lineno-start: 1
   :emphasize-lines: 10

   {
   "Logging": {
      "LogLevel": {
         "Default": "Information",
         "Microsoft": "Warning",
         "Microsoft.Hosting.Lifetime": "Information"
      }
   },
   "AllowedHosts": "*",
   "KeyVaultName": ""
   }

You will notice there is an empty key-value pair with the key ``KeyVaultName``. After we setup an Azure Key vault we will have to provide it's name as the value to this pair.

Bringing it Together
--------------------

Before we make any changes to our code let's go ahead and run our project locally to see how it works.

Change into the directory you just cloned ``/dotnet-user-secrets-az-keyvault``. Then run

.. sourcecode:: bash

   dotnet run

.. image:: /_static/images/secrets-and-backing/dotnet-run-local.png

Then navigate to `<https://localhost:5001/secret>`_.

You should see a line that says ``null``. This is what we expect for now because we haven't yet configured one of our secrets managers, we will do so in the following sections.

.. image:: /_static/images/secrets-and-backing/no-user-secrets.png

Development Environment Secret Manager
======================================

The CLI tool ``dotnet user-secrets`` will be the secrets manager we use in our development environment. It is convient to work with because it can be managed easily from the CLI, and is loaded automatically into .NET projects.

In order to change our webpage so that it no longer says ``null`` we will need to enter a user secret for this project.

In your terminal navigate to the project directory ``/dotnet-user-secrets-az-keyvault``. 

From this location run

.. sourcecode:: bash

   dotnet user-secrets --help

You will notice it is the User Secrets Manager. This will allow us to create and manage secrets per project in our development environment.

Let's create our first secret from the terminal in the project directory enter ``dotnet user-secrets set name yourname``. 

.. sourcecode:: bash

   dotnet user-secrets set name yourname

This creates a new user secret for your project with the key value pair of "name=yourname". This can now be accessed by our locally running web app. Rerun your project with ``dotnet run``.

.. image:: /_static/images/secrets-and-backing/yourname-user-secret.png

Our app is now accessing our user secret and it is being displayed in our running webapp!

However, we are going to change ``yourname`` to your actual name. We can achieve this by overwriting the old user secret. 

.. sourcecode:: bash

   dotnet user-secrets set name <yourname>
   
.. image:: /_static/images/secrets-and-backing/paul-user-secret.png

Using dotnet user-secrets is a way to keep sensitive data safe from your application, and keep yourself from accidently committing your secrets to Version Control (like git).

``dotnet user-secrets`` is typically only used in a development environment for a production environment like when we are deploying our applications we would use a different tool, specifically the Azure Key vault. The remainder of this walkthrough will show you how to work with Azure Key vault.

Create Resource Group
=====================

Before we can configure a Key vault we will need to provision a new Resource Group.

You should use the following pattern for your Resource Group Name: ``yourname-rg-secrets``.

Following are images that will remind you how to create a Resource Group. Refer to previous walkthroughs if you need additional help.

.. image:: /_static/images/secrets-and-backing/provision-rg1.png

.. image:: /_static/images/secrets-and-backing/provision-rg2.png

.. image:: /_static/images/secrets-and-backing/provision-rg3.png

After creating your Resource Group move on to the next step.

Provision VM
============

We will need a VM to deploy our application. So let's create a new one now.

You are probably starting to get the hang of provisioning VMs. Refer to the following pictures for help, if you are still confused checkout the walkthroughs from previous days.

.. image:: /_static/images/secrets-and-backing/provision-vm1.png

.. image:: /_static/images/secrets-and-backing/provision-vm2.png

Make sure to select the correct image, change the Authentication Type to Password, and create a username ``student`` and password ``LaunchCode-@zure1``.

.. image:: /_static/images/secrets-and-backing/provision-vm3.png

As one additional step to previous VM provisioning we will need to change the ``System assigned managed identity`` to ``On``. You will find this option in the ``Management`` section of the VM creation wizard.

.. image:: /_static/images/secrets-and-backing/provision-vm-system-identity.png

Allowing ``System assigned managed identity`` allows the VM to search for other Azure resources like the Key vault we will be setting up soon!

.. image:: /_static/images/secrets-and-backing/provision-vm4.png

.. warning::

   If you didn't change the Authentication Type to Password, and create a User name ``student`` you will run into issues later when trying to perform RunCommands. If you didn't change ``System assigned managed identity`` from ``Off`` to ``On`` you will have issues when your VM attempts to access the Key vault.

After provisioning your VM move on to the next step.

Create Key Vault
================

We have the source code of our project on our VM, it is configured to work with an Azure Key vault, however before we deploy our application we need to create our Key vault and put a secret into the Key vault.

Search for the Key vault blade.

.. image:: /_static/images/secrets-and-backing/keyvault-search.png

Looking at the main page we will want to add a new Key vault. Click the add button.

.. image:: /_static/images/secrets-and-backing/keyvault-add.png

This will take you to the Key vault creation wizard.

.. note::

   Key vault names must be globally unique. This means you may have to try a few different Key vault names to get it to work. However, your source code must match the Key vault name you choose. So take note of your Key vault name as we will be referencing it later.

Fill out the form with your resource group name ``yourname-rg-secrets`` and your Key vault name we recommend using a pattern like ``yourname-kv-secrets``, but you may need to make some changes to your Key vault name since all Key vault names are globally unique.

.. image:: /_static/images/secrets-and-backing/keyvault-form.png

After completing the form click create.

.. image:: /_static/images/secrets-and-backing/keyvault-create.png

Grant VM Access to Key Vault
============================

An important step is to grant our VM access to our Key vault. Even though our application will be configured to access the Key vault. By default the Key Vault blocks everything from accessing it's contents except for things that have been explictly granted.

Since we already have a Key vault, and a VM we can grant our VM access to our Key vault.

We will do this from the Key vault so navigate back to the home page for Key vaults and select the Key vault you created for this project.

.. image:: /_static/images/secrets-and-backing/grant-access1.png

From here you will need to select ``Access Policies`` under the Settings header.

.. image:: /_static/images/secrets-and-backing/grant-access2.png

From here we will need to click ``Add Access Policy`` to grant our VM permission to access this Key vault.

.. image:: /_static/images/secrets-and-backing/grant-access3.png

This pulls up a new form which we will fill out by selecting the template ``Secret Management`` which will auto fill out the next boxes. Then we will need to click on ``None Selected`` next to ``Service Principal``.

.. image:: /_static/images/secrets-and-backing/grant-access4.png

When you click ``None Selected`` next to ``Service Principal`` a window will pop out letting you enter the Service Principal you want to grant access to this Key vault. We will be entering the name of our VM into the search box and it should find it for you.

.. image:: /_static/images/secrets-and-backing/grant-access5.png

After the search box found the VM I simply selected it and then clicked the ``Select`` button and it added it to the form for me.

.. image:: /_static/images/secrets-and-backing/grant-access6.png

Now to complete the creation of this Access Policy I just need to hit the ``Add`` button. Which takes us back to the Access Policy screen and we can see the new Policy that was created for our VM.

.. image:: /_static/images/secrets-and-backing/grant-access7.png

And that's it! We have granted our VM access to the secrets contained within our Key vault. Next we will add a secret.

Add Secret to Key Vault
=======================

Now that we have a Key vault we will need to add our secret to this Key vault. Our application is expecting a key value pair of ``Name=yourname``.

To add secrets to our Key vault we need to first select our newly create Key vault, and navigate to the ``Secrets`` section under Settings.

.. image:: /_static/images/secrets-and-backing/keyvault-secrets.png

Then click the ``Generate/Import`` button.

.. image:: /_static/images/secrets-and-backing/keyvault-generate-import.png

Then fill out the form manually with your Key value pair. 

Key: ``Name``
Value: ``yourname``

.. image:: /_static/images/secrets-and-backing/keyvault-form-filled-out.png

Click the ``Create`` button to add this secret to your Key vault. Which will take us back to the Key vault main page and we will see our new secret's Key:

.. image:: /_static/images/secrets-and-backing/keyvault-secret-final.png

Update Code to Access Key Vault
===============================

Earlier we forked, and cloned the project repistory and looked at three crucial files.

We now need to edit one of those files now that we have a Key vault name.

Open ``appsettings.json`` with your editor of choice (Visual Studio, Visual Studio Code, etc).

You will see a key-value pair with the key being ``KeyVaultName`` for the value enter the Key vault name you created in this walkthrough.

.. sourcecode:: csharp
   :caption: appsettings.json
   :lineno-start: 1
   :emphasize-lines: 10

   {
   "Logging": {
      "LogLevel": {
         "Default": "Information",
         "Microsoft": "Warning",
         "Microsoft.Hosting.Lifetime": "Information"
      }
   },
   "AllowedHosts": "*",
   "KeyVaultName": "paul-kv-secrets"
   }

Now that we have made changes to this file, make sure to save your changes and then push these changes up to your repo. We will be pulling this repository from our VM, and we need it to have the change we just made so it can access our Key vault!

Install Dependencies to VM
==========================

After spinning up your VM inside a new Resource Group we will need to install the dependencies of our project namely dotnet.

Remeber to run these bash commands you will need to go to your VM, and under Operations select RunCommand, and then select RunShellScript to access the RunCommand console.

.. note::

   Remember that using the RunCommand will take some time so after you hit ``Run`` give it a few minutes. This first RunCommand will take the longest as it's downloading and installing the dotnet CLI.

.. sourcecode:: bash

   wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
   sudo dpkg -i packages-microsoft-prod.deb
   sudo apt-get update; \
     sudo apt-get install -y apt-transport-https && \
     sudo apt-get update && \
     sudo apt-get install -y dotnet-sdk-3.1
   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   dotnet --version

You will know it installed correctly if you see the version number of the dotnet installation like the following picture the version is hilighted and is ``3.1.301``.

.. image:: /_static/images/secrets-and-backing/install-dotnet.png

If you are struggling to figure out which line from STDOUT is the version number you can simply run the following commands and it should be the only thing in the output section.

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   dotnet --version

After you have successfully installed dotnet move on to the next step.

Get Source Code
===============

The project we want to deploy is the same repository that we forked earlier. You need to deploy the project on your repository since it contains the source code that references your unique Key vault. Once you have the URL for that repository you will need to replace the URL in the following source code block with the URL to your repository.

Clone it to your Virtual Machine with the following bash commands in the RunCommand section of the Azure Portal making sure to replace ``<YOURUSERNAME>`` with your actual GitHub repo URL:

.. note::

   If you forked the repository your GitHub URL will look something like this ``https://github.com/<YOURUSERNAME>/dotnet-user-secrets-az-keyvault``. Double check that you reference the URL correctly or it won't work in the Azure RunCommand.

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student
   git clone https://github.com/<YOURUSERNAME>/dotnet-user-secrets-az-keyvault
   ls /home/student

.. note::

   If you run into any issues double check that your GitHub URL is correct!

You should see a new folder named ``dotnet-user-secrets-az-keyvault`` which will contain the code for our project.

.. image:: /_static/images/secrets-and-backing/vm-clone.png

Once you see ``dotnet-user-secrets-az-keyvault`` in the STDOUT section of your run command move on.

VM Security Groups
==================

Before we deploy our application let's open our NSGs.

From the VM select ``Networking`` under the Settings section.

.. image:: /_static/images/secrets-and-backing/vm-nsg1.png

Add new inbound and outbound rules for port 80.

.. image:: /_static/images/secrets-and-backing/vm-nsg2.png

.. image:: /_static/images/secrets-and-backing/vm-nsg3.png

Publish
=======

Finally to use the Key vault instead of user-secrets you will need to publish your project so that it is in a production environment which will trigger our app to use Key vault instead of user-secrets.

We will need to publish and run our project.

To publish we will need to be in the root directory of our project, and run the ``dotnet publish`` command.

.. note::

   Remember that the RunCommand commands are being run as the root user and therefore doesn't have a home directory so we have to add some environment variables when touching various tools like the dotnet CLI.

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student/dotnet-user-secrets-az-keyvault
   dotnet publish -c Release -r linux-x64 -p:PublishSingleFile=true

.. image:: /_static/images/secrets-and-backing/dotnet-publish.png

Deploy
======

.. sourcecode:: bash

   export DOTNET_CLI_HOME=/home/student
   export HOME=/home/student
   cd /home/student/dotnet-user-secrets-az-keyvault
   ASPNETCORE_URLS="http://*:80" ./bin/Release/netcoreapp3.1/linux-x64/publish/api-user-secrets

This publish step will look like it's stuck if it's successful becuase the process attached itself to the running application. Just like the picture below.

.. image:: /_static/images/secrets-and-backing/dotnet-deploy.png

However, if it looks hung, and you've opened your NSG for this VM you can access the running app by going to ``http://<YOURVMIP>/secret``.

.. image:: /_static/images/secrets-and-backing/final-app.png