==================
Secrets Management
==================

Modern web applications rely on access to one or more data sources. Most applications will need to make a request to at least one database to manage business data. To do this the application needs credentials to access the database, these can be written as a database connection string:

Consider the following fictionalized database connection string used to connect a .NET web application to a MySQL database:

``server=172.28.162.111;port=3306;database=car_db;user=car_user;password=7p*RTY5g8i#WB@F8``.

This string contains:

- the IP address of the database server
- the port of the database server 
- a database name 
- a username and password that has access to the database

That's all the information anyone needs to gain access to your database server! 

A database connection string is a type of **Secret**, a privileged piece of information that our application needs to operate. 

Secrets can be used as the key to protect access to **Sensitive Data**.

.. admonition:: Note

	Sensitive data includes proprietary knowledge or Personal Identifying Information (PII). This sensitive data is usually secured within a data backing service. The data backing service credentials (database connection string) are guarded to ensure only individuals with authorization can access this sensitive data.

Examples of PII:

- first & last name
- email address
- residential address
- phone number
- zip code
- SSN

Examples of Proprietary data:

- user habits, behaviors, and trends
- information about internal products or processes
- results of internal research
- patented or copyrighted materials

.. admonition:: Note

	A secret is a subset of sensitive data. Proprietary knowledge and PII may be part of the underlying data an application uses, but they are not *necessary* for an application to function.

Secrets
=======

**Secret** data is information that is required by an application to function, but is kept separate from the source code of the application. In other words a **secret** is information that is never made publicly available.

Examples of secrets:

- databases connection strings
- API keys
- usernames
- passwords
- VM IP addresses

Handling Sensitive Data
-----------------------

There are a few things we must do to ensure our sensitive data is not exposed to the public. 

- sensitive data stays out of VCS
- application secrets are stored externally and loaded at runtime
- infrastructure must be configured to grant least privileged access
- All PII and proprietary data is securely housed and requires authorization

.. admonition:: Warning

	This and the next two articles will talk about various strategies and tooling to keep sensitive data protected, however they are not exhaustive.

VCS
^^^

To ensure we don't accidentally expose sensitive data we must be careful with the files we track using ``git``. If we have a file that contains sensitive data we need to make sure the file is never added to staging and isn't committed to a ``git`` repository. If sensitive data is tracked, committed and pushed to a remote repository other people can view it. 

Manually determining which file has sensitive data and making sure it isn't added to the local ``git`` repository would be a pain. Fortunately for us ``git`` has a built in feature that allows us to easily track the files we don't want to include in our ``git`` repository. 

This feature is managed by the aptly name ``.gitignore`` file. Files, and directories added to the ``.gitignore`` file will simply be skipped over when ``git`` checks your files and directories for changes.

Let's make a new temporary directory, initialize it as a local ``git`` repository and run the ``git status`` command.

.. sourcecode:: none
   :caption: Windows/PowerShell
   
   > New-Item -ItemType "directory" -Name temp_directory
   > Set-Location ./temp_directory/
   > New-Item -ItemType "file" -Name new-file.txt -Value "hello world"
   > git init
   > git status

   On branch master

   No commits yet

   Untracked files:
   (use "git add <file>..." to include in what will be committed)
      new-file.txt

   nothing added to commit but untracked files present (use "git add" to track)

As we expect when creating a new directory, file, and local git repository when we run the command ``git status`` the output shows us the *untracked files*. In this case our untracked file is ``new-file.txt``.

Let's try adding a ``.gitignore`` file with the entry of ``new-file.txt`` and run the ``git status`` command again.

.. sourcecode:: none
   :caption: Windows/PowerShell

   > Set-Location ./temp_directory/
   > New-Item -ItemType "file" -Name .gitignore -Value "new-file.txt"
   > git status

	On branch master

	No commits yet

	Untracked files:
	(use "git add <file>..." to include in what will be committed)
		.gitignore

	nothing added to commit but untracked files present (use "git add" to track)

Our local ``git`` repository has detected a different change. It no long detects ``new-file.txt``. . In this case ``git`` simply skipped over ``new-file.txt`` when scanning our project directory as dictated by the ``.gitignore`` file. 

Our local ``git`` repository has detected that a new file is currently untracked: ``.gitignore``. We do want to stage, and commit this file because we can use it as a source of determining which files are not being tracked by ``git``.

.. sourcecode:: none
   :caption: Windows/PowerShell

   > git add .gitignore
   > git commit -m "added .gitignore to protect sensitive data"

.. admonition:: Tip

	When writing code you should always consider the data that is exposed in your source code. A best practice is to add a file (or a directory of files) to ``.gitignore`` that you know will contain sensitive data. By adding it before creating the file you can ensure secrets won't ever have a chance to be committed. If you determine a file does have sensitive data in it you should add it to the ``.gitignore`` file right away.

We have only scratched the surface of ``.gitignore``. It is also used to ignore derived code like build artifacts, can ignore entire directories, understands wildcard syntax, and more. These aspects go beyond the scope of this course. However, you can `learn more here <https://git-scm.com/docs/gitignore>`_.

External Configuration
^^^^^^^^^^^^^^^^^^^^^^

A best practice for handling secrets is to use ``external configuration`` files. In the same vein as keeping sensitive data out of our source code, ``external configuration`` goes a step further by keeping our configuration files outside of our project files.

You have already encountered *internal* project configuration files. In the ``CodingEventsAPI`` we have been deploying throughout this class has an ``appsettings.json`` file which contains various configuration properties.  However, when dealing with ``secrets`` we want to distance this data even further. As a reminder ``secrets`` are data required for applications to function, but the secrets need to be kept external to our project.

``External configuration`` is the process of keeping configuration data outside of the source code of a project and loading the configuration values into the project at runtime. This keeps the ``secrets`` separate from the project completely. 

Using ``external configuration`` files has two major benefits: 

#. secrets are kept separate and safe from both the code, and running application
#. an application running across different environments can be configured in different ways (like easily swapping a local and production database connection string)

.. admonition:: Note

	Separating the configurations from the rest of the source code has even more benefits, but these are the two ways in which we will explore ``external configurations`` throughout this course.

We will discuss application environments in the next article, but before then let's discuss how we can manage secrets in .NET and Azure.

Secrets Management
------------------

There are many different applications that handle secrets management and although they all have slightly different implementations they are loosely based on the same basic principles. Generally speaking we refer to these services as **Secrets Managers**.

- a ``secrets store`` is a directory or location that houses secrets
- secrets are contained in a text file
- secrets are stored as strings consisting of key-value pairs
- a secret's key refers to the name of the secret
- a secret's value refers to the contents of the secret (a string or a more complex object of data like JSON)

Our project has run in two different environments: locally on our personal machines, and remotely via Azure. For local development environments we will use the ``dotnet user-secrets`` tool to manage our secrets. In remote environments we will use Azure Key vault.

Secrets Managers
================

dotnet user-secrets
-------------------

``dotnet user-secrets`` is an added module of the ``dotnet`` CLI. Like all ``dotnet`` commands you can use the ``--help`` option to learn more.

When using ``dotnet user-secrets`` dotnet creates a ``secrets store`` directory on your machine. When you *initialize* a ``secrets store`` in your project your project configuration file (``.csproj``) will automatically updated with its ID.

We can see this in action by creating a new temporary .NET project and printing out the .csproj file:

.. sourcecode:: none
   :caption: Windows/PowerShell

   > dotnet new console -n example-dotnet-user-secret
   > Set-Location ./example-dotnet-user-secret/
   > Get-Content ./example-dotnet-user-secret.csproj

   <Project Sdk="Microsoft.NET.Sdk">

   <PropertyGroup>
      <OutputType>Exe</OutputType>
      <TargetFramework>netcoreapp3.1</TargetFramework>
      <RootNamespace>example_dotnet_user_secret</RootNamespace>
   </PropertyGroup>

   </Project>

This is the ``.csproj`` file for a standard dotnet project. Let's initialize a new secret store for this project using ``dotnet user-secrets init``.

.. sourcecode:: none
   :caption: Windows/PowerShell

   > Set-Location ./example-dotnet-user-secret/
   > dotnet user-secrets init --id example-secret-store-id

   Set UserSecretsId to 'example-secret-store-id' for MSBuild project
   '/home/<username>/example-dotnet-user-secret/example-dotnet-user-secret.csproj'.

This command did two things for us, it created a new secret store and amended the ``.csproj`` file to let our project know the ID of the secret store.

We can view the changed ``.csproj`` file with:

.. sourcecode:: none
   :caption: Windows/PowerShell
   :emphasize-lines: 10
	
   > Set-Location ./example-dotnet-user-secret/
   > Get-Content ./example-dotnet-user-secret.csproj

   <?xml version="1.0" encoding="utf-8"?>
   <Project Sdk="Microsoft.NET.Sdk">
   <PropertyGroup>
      <OutputType>Exe</OutputType>
      <TargetFramework>netcoreapp3.1</TargetFramework>
      <RootNamespace>example_dotnet_user_secret</RootNamespace>
      <UserSecretsId>example-secret-store-id</UserSecretsId>
   </PropertyGroup>
   </Project>

Now that our .NET project has an associated secret store we can add as many secrets as we want. They will be stored externally from our project source and loaded at runtime.

Let's add a new secret:

.. sourcecode:: none
   :caption: Windows/PowerShell

   > Set-Location ./example-dotnet-user-secret
   > dotnet user-secrets set secret_name secret_value

   Successfully saved secret_name = secret_value to the secret store.

Setting our first secret associated with this project and secret store will have created a new ``secrets.json`` file. It will look something like this:

.. sourcecode:: javascript

   {
      "secret_name": "secret_value"
   }
   
You can safely discard this application. In the following walkthrough we will get hands-on practice with both local ``user-secrets`` and the Azure Key vault.

Azure Key vault
---------------

In our remote production environment we will be using Azure Key vault to manage our secrets. The Azure Key vault is a **remote secrets manager** that behaves like ``user-secrets`` but is managed externally from your machine.

The following are the general steps of setting up a Key vault. In the following walkthrough we will cover these steps in greater detail.

Starting in the Azure portal you will need to search for the Key vault blade.

.. image:: /_static/images/secrets-and-backing/keyvault-search.png

Then from the home page you will need to click ``Add``.

.. image:: /_static/images/secrets-and-backing/keyvault-add.png

Then fill out the following form to create the Key vault.

.. image:: /_static/images/secrets-and-backing/keyvault-form.png

Which creates a new Key vault with the specified parameters selecting this Key vault you can add new secrets.

.. image:: /_static/images/secrets-and-backing/keyvault-secrets.png

Then by clicking ``Add`` again you fill out the form to create a new secret.

.. image:: /_static/images/secrets-and-backing/keyvault-form-filled-out.png

Which finally creates the secret.

.. image:: /_static/images/secrets-and-backing/keyvault-secret-final.png
